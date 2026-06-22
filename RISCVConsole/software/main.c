#include "main.h"
#include "encoding.h"
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdatomic.h>
#include "libfdt/libfdt.h"
#include "uart/uart.h"
#include <kprintf/kprintf.h>
#include <stdio.h>
#include <platform.h>
#include <plic/plic_driver.h>

volatile unsigned long dtb_target;

void no_interrupt_handler (void) {};
function_ptr_t g_ext_interrupt_handlers[32];
function_ptr_t g_time_interrupt_handler = no_interrupt_handler;
plic_instance_t g_plic;

#define RTC_FREQ 1000000

void boot_fail(long code, int trap)
{
  kputs("BOOT FAILED\r\nCODE: ");
  uart_put_hex((void*)uart_reg, code);
  kputs("\r\nTRAP: ");
  uart_put_hex((void*)uart_reg, trap);
  while(1);
}

void handle_m_ext_interrupt(){
  int int_num  = PLIC_claim_interrupt(&g_plic);
  if ((int_num >=1 ) && (int_num < 32)) {
    g_ext_interrupt_handlers[int_num]();
  }
  else {
    boot_fail((long) read_csr(mcause), 1);
  }
  PLIC_complete_interrupt(&g_plic, int_num);
}

void handle_m_time_interrupt() {
  clear_csr(mie, MIP_MTIP);
  volatile unsigned long *mtime    = (unsigned long*)(CLINT_CTRL_ADDR + CLINT_MTIME);
  volatile unsigned long *mtimecmp = (unsigned long*)(CLINT_CTRL_ADDR + CLINT_MTIMECMP);
  unsigned long now = *mtime;
  unsigned long then = now + RTC_FREQ;
  *mtimecmp = then;
  g_time_interrupt_handler();
  set_csr(mie, MIP_MTIP);
}

uintptr_t handle_trap(uintptr_t mcause, uintptr_t epc)
{
  if ((mcause & MCAUSE_INT) && ((mcause & MCAUSE_CAUSE) == IRQ_M_EXT)) {
    handle_m_ext_interrupt();
  } else if ((mcause & MCAUSE_INT) && ((mcause & MCAUSE_CAUSE) == IRQ_M_TIMER)){
    handle_m_time_interrupt();
  }
  else {
    boot_fail((long) read_csr(mcause), 1);
  }
  return epc;
}

void remove_from_dtb(void* dtb_target, const char* path) {
  int nodeoffset;
  int err;
  do{
    nodeoffset = fdt_path_offset((void*)dtb_target, path);
    if(nodeoffset >= 0) {
      kputs("\r\nINFO: Removing ");
      kputs(path);
      err = fdt_del_node((void*)dtb_target, nodeoffset);
      if (err < 0) {
        kputs("\r\nWARNING: Cannot remove a subnode ");
        kputs(path);
      }
    }
  } while (nodeoffset >= 0) ;
}

static int fdt_translate_address(void *fdt, uint64_t reg, int parent, unsigned long *addr)
{
  int i, rlen;
  int cell_addr, cell_size;
  const fdt32_t *ranges;
  uint64_t offset = 0, caddr = 0, paddr = 0, rsize = 0;

  cell_addr = fdt_address_cells(fdt, parent);
  if (cell_addr < 1) return -FDT_ERR_NOTFOUND;
  cell_size = fdt_size_cells(fdt, parent);
  if (cell_size < 0) return -FDT_ERR_NOTFOUND;

  ranges = fdt_getprop(fdt, parent, "ranges", &rlen);
  if (ranges && rlen > 0) {
    for (i = 0; i < cell_addr; i++)
      caddr = (caddr << 32) | fdt32_to_cpu(*ranges++);
    for (i = 0; i < cell_addr; i++)
      paddr = (paddr << 32) | fdt32_to_cpu(*ranges++);
    for (i = 0; i < cell_size; i++)
      rsize = (rsize << 32) | fdt32_to_cpu(*ranges++);
    if (reg < caddr || caddr >= (reg + rsize )) {
      return -FDT_ERR_NOTFOUND;
    }
    offset = reg - caddr;
    *addr = paddr + offset;
  } else {
    *addr = reg;
  }
  return 0;
}

int fdt_get_node_addr_size(void *fdt, int node, unsigned long *addr, unsigned long *size)
{
  int parent, len, i, rc;
  int cell_addr, cell_size;
  const fdt32_t *prop_addr, *prop_size;
  uint64_t temp = 0;

  parent = fdt_parent_offset(fdt, node);
  if (parent < 0) return parent;
  cell_addr = fdt_address_cells(fdt, parent);
  if (cell_addr < 1) return -FDT_ERR_NOTFOUND;
  cell_size = fdt_size_cells(fdt, parent);
  if (cell_size < 0) return -FDT_ERR_NOTFOUND;

  prop_addr = fdt_getprop(fdt, node, "reg", &len);
  if (!prop_addr) return -FDT_ERR_NOTFOUND;
  prop_size = prop_addr + cell_addr;

  if (addr) {
    for (i = 0; i < cell_addr; i++)
      temp = (temp << 32) | fdt32_to_cpu(*prop_addr++);
    do {
      if (parent < 0) break;
      rc  = fdt_translate_address(fdt, temp, parent, addr);
      if (rc) break;
      parent = fdt_parent_offset(fdt, parent);
      temp = *addr;
    } while (1);
  }
  temp = 0;

  if (size) {
    for (i = 0; i < cell_size; i++)
      temp = (temp << 32) | fdt32_to_cpu(*prop_size++);
    *size = temp;
  }
  return 0;
}

int fdt_parse_hart_id(void *fdt, int cpu_offset, uint32_t *hartid)
{
  int len;
  const void *prop;
  const fdt32_t *val;

  if (!fdt || cpu_offset < 0) return -FDT_ERR_NOTFOUND;
  prop = fdt_getprop(fdt, cpu_offset, "device_type", &len);
  if (!prop || !len) return -FDT_ERR_NOTFOUND;
  if (strncmp (prop, "cpu", strlen ("cpu"))) return -FDT_ERR_NOTFOUND;

  val = fdt_getprop(fdt, cpu_offset, "reg", &len);
  if (!val || len < sizeof(fdt32_t)) return -FDT_ERR_NOTFOUND;
  if (len > sizeof(fdt32_t)) val++;
  if (hartid) *hartid = fdt32_to_cpu(*val);
  return 0;
}

int fdt_parse_max_hart_id(void *fdt, uint32_t *max_hartid)
{
  uint32_t hartid;
  int err, cpu_offset, cpus_offset;

  if (!fdt) return -FDT_ERR_NOTFOUND;
  if (!max_hartid) return 0;
  *max_hartid = 0;

  cpus_offset = fdt_path_offset(fdt, "/cpus");
  if (cpus_offset < 0) return cpus_offset;

  fdt_for_each_subnode(cpu_offset, fdt, cpus_offset) {
    err = fdt_parse_hart_id(fdt, cpu_offset, &hartid);
    if (err) continue;
    if (hartid > *max_hartid) *max_hartid = hartid;
  }
  return 0;
}

int fdt_find_or_add_subnode(void *fdt, int parentoffset, const char *name)
{
  int offset;
  offset = fdt_subnode_offset(fdt, parentoffset, name);
  if (offset == -FDT_ERR_NOTFOUND)
    offset = fdt_add_subnode(fdt, parentoffset, name);
  if (offset < 0) {
    uart_puts((void*)uart_reg, fdt_strerror(offset));
    uart_puts((void*)uart_reg, "\r\n");
  }
  return offset;
}

int timescale_freq = 0;

unsigned long uart_reg = 0;
int tlclk_freq;
unsigned long plic_reg;
int plic_max_priority;
int plic_ndevs;
//---------SOFTWARE----------------
void print_block(const char *label, uint8_t block[16])
{
    kputs(label);
    kputs(" : ");
    for(int i=0; i<16; i++)
    {
        uart_put_hex("%02X ", block[i]); // in hex 2 chữ số
    }
    kputs("\r\n");
}
static uint64_t get_cycle_count()
{
#ifdef __riscv_xlen
#if __riscv_xlen == 32
    uint32_t hi, lo, hi2;

    do {
        hi  = read_csr(mcycleh);
        lo  = read_csr(mcycle);
        hi2 = read_csr(mcycleh);
    } while (hi != hi2);

    return (((uint64_t)hi) << 32) | lo;
#else
    return read_csr(mcycle);
#endif
#else
    return read_csr(mcycle);
#endif
}
static void print128(
    uint32_t w3,
    uint32_t w2,
    uint32_t w1,
    uint32_t w0)
{
    uart_put_hex((void*)uart_reg, w3); kputs(" ");
    uart_put_hex((void*)uart_reg, w2); kputs(" ");
    uart_put_hex((void*)uart_reg, w1); kputs(" ");
    uart_put_hex((void*)uart_reg, w0);
}
void print128_grouped(uint8_t *data)
{
    uint32_t w3 = (data[0] << 24) | (data[1] << 16) | (data[2] << 8) | data[3];
    uint32_t w2 = (data[4] << 24) | (data[5] << 16) | (data[6] << 8) | data[7];
    uint32_t w1 = (data[8] << 24) | (data[9] << 16) | (data[10] << 8) | data[11];
    uint32_t w0 = (data[12] << 24) | (data[13] << 16) | (data[14] << 8) | data[15];
    uart_put_hex((void*)uart_reg, w3); kputs(" ");
    uart_put_hex((void*)uart_reg, w2); kputs(" ");
    uart_put_hex((void*)uart_reg, w1); kputs(" ");
    uart_put_hex((void*)uart_reg, w0);
    kputs("\r\n");
}
static const uint8_t SBOX[256] =
{
    0x01,0x11,0x91,0xE1,0xD1,0xB1,0x71,0x61,0xF1,0x21,0xC1,0x51,0xA1,0x41,0x31,0x81,
    0x00,0x10,0xE3,0x92,0xB5,0xD4,0x77,0x66,0x89,0x38,0xAB,0x4A,0xCD,0x5C,0x2F,0xFE,
    0x08,0x5F,0x3E,0xB0,0x1C,0xC2,0x83,0xDD,0xE8,0xF6,0x47,0x79,0x95,0x2B,0xAA,0x64,
    0x0F,0x48,0xD0,0x29,0xA3,0x1A,0xF2,0xBB,0x65,0xCC,0xE4,0x3D,0x57,0x7E,0x86,0x9F,
    0x0C,0x2A,0xF4,0x1F,0x5B,0x90,0xEE,0xC5,0x36,0x6D,0x73,0x88,0xBC,0xA7,0x49,0xD2,
    0x0A,0x3C,0x18,0x85,0xE0,0x4D,0x99,0xA4,0xB3,0x5E,0xDA,0xC7,0x72,0xFF,0x6B,0x26,
    0x06,0x76,0xCF,0xA8,0x4E,0x59,0x60,0x17,0xDC,0x9B,0x32,0xF5,0x23,0x84,0xED,0xBA,
    0x07,0x67,0x2D,0x3B,0xFA,0x8C,0x16,0x70,0x54,0xA2,0x98,0xBE,0xEF,0xD9,0xC3,0x45,
    0x0E,0xA9,0x62,0x5A,0x27,0xBF,0x34,0x9C,0xFD,0xD5,0x8E,0xE6,0x1B,0x43,0x78,0xC0,
    0x03,0xB2,0x87,0xC4,0x9D,0x6E,0x4B,0xF8,0x7A,0xE9,0x2C,0xAF,0xD6,0x15,0x50,0x33,
    0x0D,0xFB,0x56,0xEC,0x3F,0x75,0xB8,0x42,0x1E,0x24,0xC9,0x93,0x80,0x6A,0xD7,0xAD,
    0x04,0xE5,0xB9,0x7D,0x82,0xA6,0xCA,0x2E,0x97,0x13,0x6F,0xDB,0x44,0x30,0xFC,0x58,
    0x0B,0x8D,0x9A,0x46,0x74,0x28,0xDF,0x53,0xCB,0xB7,0xF0,0x6C,0xAE,0xE2,0x35,0x19,
    0x05,0x94,0x7B,0xDE,0xC6,0xF3,0xAC,0x39,0x4F,0x8A,0x55,0x20,0x68,0xBD,0x12,0xE7,
    0x02,0xD3,0xA5,0xF7,0x69,0xEB,0x5D,0x8F,0x22,0x40,0xB6,0x14,0x3A,0xC8,0x9E,0x7C,
    0x09,0xCE,0x4C,0x63,0xD8,0x37,0x25,0xEA,0xA0,0x7F,0x1D,0x52,0xF9,0x96,0xB4,0x8B
};
static const uint8_t INV_SBOX[256] =
{
    0x10,0x00,0xE0,0x90,0xB0,0xD0,0x60,0x70,0x20,0xF0,0x50,0xC0,0x40,0xA0,0x80,0x30,
    0x11,0x01,0xDE,0xB9,0xEB,0x9D,0x76,0x67,0x52,0xCF,0x35,0x8C,0x24,0xFA,0xA8,0x43,
    0xDB,0x09,0xE8,0x6C,0xA9,0xF6,0x5F,0x84,0xC5,0x33,0x41,0x2D,0x9A,0x72,0xB7,0x1E,
    0xBD,0x0E,0x6A,0x9F,0x86,0xCE,0x48,0xF5,0x19,0xD7,0xEC,0x73,0x51,0x3B,0x22,0xA4,
    0xE9,0x0D,0xA7,0x8D,0xBC,0x7F,0xC3,0x2A,0x31,0x4E,0x1B,0x96,0xF2,0x55,0x64,0xD8,
    0x9E,0x0B,0xFB,0xC7,0x78,0xDA,0xA2,0x3C,0xBF,0x65,0x83,0x44,0x1D,0xE6,0x59,0x21,
    0x66,0x07,0x82,0xF3,0x2F,0x38,0x17,0x71,0xDC,0xE4,0xAD,0x5E,0xCB,0x49,0x95,0xBA,
    0x77,0x06,0x5C,0x4A,0xC4,0xA5,0x61,0x16,0x8E,0x2B,0x98,0xD2,0xEF,0xB3,0x3D,0xF9,
    0xAC,0x0F,0xB4,0x26,0x6D,0x53,0x3E,0x92,0x4B,0x18,0xD9,0xFF,0x75,0xC1,0x8A,0xE7,
    0x45,0x02,0x13,0xAB,0xD1,0x2C,0xFD,0xB8,0x7A,0x56,0xC2,0x69,0x87,0x94,0xEE,0x3F,
    0xF8,0x0C,0x79,0x34,0x57,0xE2,0xB5,0x4D,0x63,0x81,0x2E,0x1A,0xD6,0xAF,0xCC,0x9B,
    0x23,0x05,0x91,0x58,0xFE,0x14,0xEA,0xC9,0xA6,0xB2,0x6F,0x37,0x4C,0xDD,0x7B,0x85,
    0x8F,0x0A,0x25,0x7E,0x93,0x47,0xD4,0x5B,0xED,0xAA,0xB6,0xC8,0x39,0x1C,0xF1,0x62,
    0x32,0x04,0x4F,0xE1,0x15,0x89,0x9C,0xAE,0xF4,0x7D,0x5A,0xBB,0x68,0x27,0xD3,0xC6,
    0x54,0x03,0xCD,0x12,0x3A,0xB1,0x8B,0xDF,0x28,0x99,0xF7,0xE5,0xA3,0x6E,0x46,0x7C,
    0xCA,0x08,0x36,0xD5,0x42,0x6B,0x29,0xE3,0x97,0xFC,0x74,0xA1,0xBE,0x88,0x1F,0x5D
};
void SubCells(uint8_t state[16])
{
    for(int i=0;i<16;i++)
        state[i] = SBOX[state[i]];
}
void InvSubCells(uint8_t state[16])
{
    for(int i=0;i<16;i++)
        state[i] = INV_SBOX[state[i]];
}
uint8_t xtime(uint8_t a)
{
    uint8_t r;
    if(a & 0x80)
        r = (a << 1) ^ 0x2B;
    else
        r = (a << 1);
    return r;
}
void MixWords(uint8_t data[16])
{
    uint8_t b[4]; // Lưu 4 byte của cột hiện tại
    uint8_t x[4]; // 4 byte sau khi đã xoay
    uint8_t y[4]; // Kết quả tạm
    
    for(int i = 0; i < 4; i++) // Vòng lặp theo từng cột (word)
    {
        // 1. Trích xuất 4 byte của cột i
        for(int j = 0; j < 4; j++) b[j] = data[4*i + j];        
        // 2. Thực hiện xoay cột (Cyclic shift)
        // x(j) = b((j + i) mod 4)
        for(int j = 0; j < 4; j++) {
            x[j] = b[(j + i) % 4];
        }        
        // 3. Tính toán MixWords trên x0, x1, x2, x3
        y[0] = x[0] ^ x[2] ^ x[3] ^ xtime(x[1] ^ x[3]);
        y[1] = x[1] ^ x[3] ^ y[0] ^ xtime(x[2] ^ y[0]);
        y[2] = x[2] ^ y[0] ^ y[1] ^ xtime(x[3] ^ y[1]);
        y[3] = x[3] ^ y[1] ^ y[2] ^ xtime(y[0] ^ y[2]);        
        // 4. Gán lại vào data
        for(int j = 0; j < 4; j++) data[4*i + j] = y[j];
    }
}
void InvMixWords(uint8_t data[16])
{
    uint8_t b[4]; // Input của cột i
    uint8_t yv[4]; // Kết quả sau khi nhân ma trận nghịch đảo
    uint8_t y[4];  // Kết quả cuối cùng sau khi xoay    
    for(int i = 0; i < 4; i++) // Vòng lặp theo từng cột (word)
    {
        // 1. Trích xuất 4 byte của cột i
        for(int j = 0; j < 4; j++) b[j] = data[4*i + j];        
        // 2. Nhân ma trận nghịch đảo (InvMatrix)
        uint8_t x0 = b[0], x1 = b[1], x2 = b[2], x3 = b[3];
        yv[3] = x1 ^ x2 ^ x3 ^ xtime(x0 ^ x2);
        yv[2] = x0 ^ x1 ^ x2 ^ xtime(x1 ^ yv[3]);
        yv[1] = x0 ^ x2 ^ x3 ^ xtime(x2 ^ yv[2]);
        yv[0] = x3 ^ xtime(x0 ^ x1 ^ x2 ^ yv[1]);        
        // 3. Thực hiện xoay phải output theo k=i
        // out(j) = yv((j - i) mod 4)
        // Trong C, (j-i) mod 4 có thể âm, nên dùng: ((j - i) % 4 + 4) % 4
        for(int j = 0; j < 4; j++) {
            y[j] = yv[((j - i) % 4 + 4) % 4];
        }        
        // 4. Gán lại vào data
        for(int j = 0; j < 4; j++) data[4*i + j] = y[j];
    }
}
void XWords(uint8_t state[16])
{
    uint8_t x0[4];
    uint8_t x1[4];
    uint8_t x2[4];
    uint8_t x3[4];
    uint8_t y0[4];
    uint8_t y1[4];
    uint8_t y2[4];
    uint8_t y3[4];
    for(int i=0;i<4;i++)
    {
        x0[i] = state[i];
        x1[i] = state[i+4];
        x2[i] = state[i+8];
        x3[i] = state[i+12];
    }
    for(int i=0;i<4;i++)
    {
        y0[i] = x1[i] ^ x2[i] ^ x3[i];
        y1[i] = x0[i] ^ x2[i] ^ x3[i];
        y2[i] = x0[i] ^ x1[i] ^ x3[i];
        y3[i] = x0[i] ^ x1[i] ^ x2[i];
    }
    for(int i=0;i<4;i++)
    {
        state[i]    = y0[i];
        state[i+4]  = y1[i];
        state[i+8]  = y2[i];
        state[i+12] = y3[i];
    }
}
void COPY128(uint8_t dst[16], uint8_t src[16])
{
    for(int i=0;i<16;i++)
    {
        dst[i] = src[i];
    }
}
void XOR128(uint8_t A[16], uint8_t B[16])
{
    for(int i=0;i<16;i++)
    {
        A[i] ^= B[i];
    }
}
/* DEBUG
void print_state(uint8_t state[16], const char* step) {
    kputs(step); kputs(": ");
    for(int i=0; i<16; i++) {
        uart_put_hex_1b((void*)uart_reg, state[i]); kputs(" ");
    }
    kputs("\r\n");
}
void Gen_Key(uint8_t state[16]) {
    SubCells(state); print_state(state, "SubCells 1");
    MixWords(state); print_state(state, "MixWords 1");
    SubCells(state); print_state(state, "SubCells 2");
    XWords(state);   print_state(state, "XWords 1");
    SubCells(state); print_state(state, "SubCells 3");
    MixWords(state); print_state(state, "MixWords 2");
    SubCells(state); print_state(state, "SubCells 4");
    XWords(state);   print_state(state, "XWords 2");
}
*/
void Gen_Key(uint8_t state[16]) {
    SubCells(state); 
    MixWords(state);
    SubCells(state); 
    XWords(state);  
    SubCells(state); 
    MixWords(state); 
    SubCells(state); 
    XWords(state);  
}
static const uint8_t C0_CONST[16] =
{
    0x93,0x02,0xee,0x91,
    0x1a,0x2a,0xd9,0x8c,
    0xad,0x13,0xe7,0x94,
    0x8a,0xd8,0xb3,0xb2
};

static const uint8_t C1_CONST[16] =
{
    0xd4,0xda,0x00,0xf3,
    0x3f,0x11,0xfd,0x88,
    0x22,0x16,0x6b,0xb9,
    0xcd,0x18,0x7c,0x55
};
uint8_t round_key_k0[9][16];
uint8_t round_key_k1[9][16];
uint8_t key_post[16];
uint8_t done = 0;
uint64_t Key_Expansion(uint8_t key_master[32], uint8_t keylen, uint8_t start) {
    uint64_t start_cycle = 0;
    uint64_t end_cycle = 0;

    start_cycle = get_cycle_count();

    uint8_t k0_reg[16];
    uint8_t k1_reg[16];
    uint8_t o_data_reg0[16];
    uint8_t o_data_reg1[16];
    uint8_t temp[16];

    kputs("KEY MASTER: \r\n");
    print128_grouped(&key_master[0]);
    print128_grouped(&key_master[16]);

    if (start == 0) {
        kputs("Waiting for START signal ...\r\n");
    } else {
        // Tương đương IDLE State
        COPY128(k0_reg, &key_master[0]);

        int last_round;
        switch (keylen) {
            case 0:
                COPY128(k1_reg, &key_master[0]);
                for (int i = 0; i < 16; i++) k1_reg[i] ^= 0xFF;
                last_round = 7;
                break;
            case 1:
                memcpy(k1_reg, &key_master[16], 8);
                for (int i = 0; i < 8; i++) k1_reg[8 + i] = key_master[8 + i] ^ 0xFF;
                last_round = 8;
                break;
            default:
                COPY128(k1_reg, &key_master[16]);
                last_round = 9;
                break;
        }

        for (int round = 1; round <= last_round; round++) {
            /* Tương đương INIT_K0 -> WAIT_K0 -> SAVE_K0 */
            COPY128(temp, k0_reg);
            XOR128(temp, (uint8_t *)C0_CONST);
            temp[15] ^= (2 * round - 1);
            Gen_Key(temp);
            COPY128(o_data_reg0, temp);

            /* Tương đương INIT_K1 -> WAIT_K1 -> SAVE_K1 */
            COPY128(temp, k1_reg);
            XOR128(temp, (uint8_t *)C1_CONST);
            temp[15] ^= (2 * round);
            Gen_Key(temp);
            COPY128(o_data_reg1, temp);

            /* Tương đương UPDATE_K - Xuất Round Keys */
            if (round == 1) {
                COPY128(round_key_k0[round - 1], &key_master[0]);
            } else {
                COPY128(round_key_k0[round - 1], k1_reg);
            }

            COPY128(round_key_k1[round - 1], o_data_reg1);

            if (round == last_round) {
                COPY128(key_post, o_data_reg1);
                XOR128(key_post, o_data_reg0);
            }

            /* Tương đương NEXT_ROUND */
            COPY128(k0_reg, o_data_reg1);
            COPY128(k1_reg, o_data_reg1);
            XOR128(k1_reg, o_data_reg0);
        }

        done = 1;
        end_cycle = get_cycle_count();

        // Logging kết quả
        kputs("\r\n=========== ROUND KEYS ===========\r\n");
        for (int i = 0; i < last_round; i++) {
            kputs("----------------------------------\r\n");
            kputs("ROUND ");
            uart_put_dec((void *)uart_reg, i + 1);
            kputs("\r\n");
            kputs("RK0: "); print128_grouped(round_key_k0[i]);
            kputs("RK1: "); print128_grouped(round_key_k1[i]);
            if (i == last_round - 1) {
                kputs("\r\nKEY_POST: "); print128_grouped(key_post);
            }
        }

        kputs("\r\n========== KEY EXPANSION ==========\r\n");
        kputs("STATUS : DONE\r\n");
        kputs("LATENCY: ");
        uart_put_dec((void *)uart_reg, (end_cycle - start_cycle));
        kputs(" cycles\r\n-------END KEY EXPANSION-------\r\n");
    }

    return (end_cycle - start_cycle);
}
uint8_t ciphertext[16];
uint64_t ENC_CORE(
    uint8_t plaintext[16],
    uint8_t master_key[32],
    uint8_t keylen
)
{
    uint64_t start_cycle = get_cycle_count();
    uint64_t end_cycle;
    uint8_t state[16];
    COPY128(state, plaintext);
    if(done == 1)
    {
        int last_round;
        switch(keylen)
        {
            case 0: last_round = 7; break;   // MKV-128
            case 1: last_round = 8; break;   // MKV-192
            default: last_round = 9; break;  // MKV-256
        }
        for(int i=0;i<last_round;i++)
        {
            XOR128(state, round_key_k0[i]);
            SubCells(state);
            MixWords(state);
            XOR128(state, round_key_k1[i]);
            SubCells(state);
            XWords(state);
        }
        XOR128(state, key_post);
        COPY128(ciphertext, state);
        end_cycle = get_cycle_count();
        kputs("\r\n========== ENCRYPT ==========");
        kputs("\r\nDATA IN (PLAIN TEXT): ");
        print128_grouped(plaintext);
        kputs("\r\nDATA OUT (CIPHER TEXT): ");
        print128_grouped(ciphertext);
        kputs("\r\nLATENCY: ");
        uart_put_dec((void*)uart_reg, end_cycle-start_cycle);
        kputs(" cycles\r\n");
        kputs("-------END ENCRYPT-------\r\n");
    }
    else
    {
        end_cycle = get_cycle_count();
        kputs("\r\nWaiting for KEY EXPANSION...\r\n");
    }
    return end_cycle-start_cycle;
}
uint64_t DEC_CORE(
    uint8_t ciphertext_in[16],
    uint8_t master_key[32],
    uint8_t keylen
)
{
    uint64_t start_cycle = get_cycle_count();
    uint64_t end_cycle;
    uint8_t state[16];
    COPY128(state, ciphertext_in);
    if(done == 1)
    {
        int last_round;
        switch(keylen)
        {
            case 0: last_round = 6; break;
            case 1: last_round = 7; break;
            default: last_round = 8; break;
        }
        XOR128(state, key_post);
        for(int i=last_round;i>=0;i--)
        {
            XWords(state);
            InvSubCells(state);
            XOR128(state, round_key_k1[i]);
            InvMixWords(state);
            InvSubCells(state);
            XOR128(state, round_key_k0[i]);
        }
        end_cycle = get_cycle_count();
        kputs("\r\n========== DECRYPT ==========");
        kputs("\r\nDATA IN (CIPHER TEXT): ");
        print128_grouped(ciphertext_in);
        kputs("\r\nDATA OUT (PLAIN TEXT): ");
        print128_grouped(state);
        kputs("\r\nLATENCY: ");
        uart_put_dec((void*)uart_reg, end_cycle-start_cycle);
        kputs(" cycles\r\n");
        kputs("-------END DECRYPT-------\r\n");
    }
    else
    {
        end_cycle = get_cycle_count();
        kputs("\r\nWaiting for KEY EXPANSION...\r\n");
    }
    return end_cycle-start_cycle;
}
//---------HARDWARE----------------x
#define i_rst      0x00
#define i_keyinit  0x04
#define i_start    0x08
#define i_selcrypt 0x0C
#define i_keylen   0x10
#define o_keydone  0x14
#define o_done     0x18
#define data_in    0x20
#define key_in     0x30
#define data_out   0x50
unsigned long mkv_reg;
void mkv_reset() {
  _REG32(mkv_reg, i_rst) = 0x01;
  for(volatile int i=0; i<100; i++);
  _REG32(mkv_reg, i_rst) = 0x00;
  for(volatile int i=0; i<1000; i++);
  _REG32(mkv_reg, i_rst) = 0x01;
  for(volatile int i=0; i<100; i++);
  _REG32(mkv_reg, i_rst) = 0x00;
  for(volatile int i=0; i<1000; i++);
}
static uint64_t run_key(uint32_t keylen, uint32_t d0, uint32_t d1, uint32_t d2, uint32_t d3,
                                         uint32_t d4, uint32_t d5, uint32_t d6, uint32_t d7)
{
    uint64_t start_cycle, end_cycle;
    mkv_reset();
    
    // Nạp Key Master vào phần cứng
    _REG32(mkv_reg, key_in + 0x00) = d0; _REG32(mkv_reg, key_in + 0x04) = d1;
    _REG32(mkv_reg, key_in + 0x08) = d2; _REG32(mkv_reg, key_in + 0x0C) = d3;
    _REG32(mkv_reg, key_in + 0x10) = d4; _REG32(mkv_reg, key_in + 0x14) = d5;
    _REG32(mkv_reg, key_in + 0x18) = d6; _REG32(mkv_reg, key_in + 0x1C) = d7;
    
    // Chon Key (128/292/256)
    _REG32(mkv_reg, i_keylen) = keylen; 

    // Kích hoạt Key Init + Start Latency
    start_cycle = get_cycle_count();
    _REG32(mkv_reg, i_keyinit) = 0x01; 
    for(volatile int i=0; i<5; i++);
    _REG32(mkv_reg, i_keyinit) = 0x00; 

    // Chờ Done_Key = 1 + End Latency
    while (((_REG32(mkv_reg, o_keydone)) & 0x01) == 0);
    end_cycle = get_cycle_count();
    
    kputs(" Key Expansion hoàn thành.\r\n");
    return end_cycle - start_cycle;
}
static uint64_t run_crypt(uint32_t sel_crypt, uint32_t d0, uint32_t d1, uint32_t d2, uint32_t d3,
                                               uint32_t *o0, uint32_t *o1, uint32_t *o2, uint32_t *o3)
{
    uint64_t start_cycle, end_cycle;

    kputs(sel_crypt ? "\r\nQuá trình Giải mã...\r\n" : "\r\nQuá trình Mã hóa...\r\n");

    // Nạp data in
    _REG32(mkv_reg, data_in + 0x00) = d0; _REG32(mkv_reg, data_in + 0x04) = d1;
    _REG32(mkv_reg, data_in + 0x08) = d2; _REG32(mkv_reg, data_in + 0x0C) = d3;
    
    // Nạp Sel Crypt
    _REG32(mkv_reg, i_selcrypt) = sel_crypt;
    
    // kiểm tra xem done_key = 1 -> Kích hoạt Start Crypt + Start Latency
    //while (((_REG32(mkv_reg, o_keydone)) & 0x01) == 0);
    
    _REG32(mkv_reg, i_start) = 0x01; 
    _REG32(mkv_reg, i_start) = 0x00;
    start_cycle = get_cycle_count();
    kputs("Bắt đầu...\r\n");
    // Chờ Done = 1 + End Latency
    while (((_REG32(mkv_reg, o_done)) & 0x01) == 0);
    end_cycle = get_cycle_count();
    *o0 = _REG32(mkv_reg, data_out + 0x00);
    *o1 = _REG32(mkv_reg, data_out + 0x04);
    *o2 = _REG32(mkv_reg, data_out + 0x08);
    *o3 = _REG32(mkv_reg, data_out + 0x0C);

    kputs("Hoàn thành. Kết quả đã đọc.");
    return (end_cycle - start_cycle);
}

#define RUN_KEY_TEST(NAME, KEYLEN, K0,K1,K2,K3,K4,K5,K6,K7)            \
do{                                                                    \
    kputs("\r\n=================================================\r\n");\
    kputs(NAME);                                                       \
    kputs("\r\n=================================================\r\n");\
    kputs("Master Key = ");                                            \
    uart_put_hex((void*)uart_reg,K7); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K6); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K5); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K4); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K3); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K2); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K1); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,K0);                                  \
    key_latency = run_key(KEYLEN,K0,K1,K2,K3,K4,K5,K6,K7);             \
    kputs("Key Expansion Latency : ");                                 \
    uart_put_dec((void*)uart_reg,key_latency);                         \
    kputs(" cycles\r\n");                                              \
                                                                       \
    kputs("\r\nPlaintext = ");                                         \
    uart_put_hex((void*)uart_reg,0x11223344); kputs(" ");              \
    uart_put_hex((void*)uart_reg,0x55667788); kputs(" ");              \
    uart_put_hex((void*)uart_reg,0x99AABBCC); kputs(" ");              \
    uart_put_hex((void*)uart_reg,0xDDEEFF00);                          \
    enc_latency = run_crypt(                                           \
        0,                                                             \
        0x33221100,                                                    \
        0x77665544,                                                    \
        0xBBAA9988,                                                    \
        0xFFEEDDCC,                                                    \
        &c0,&c1,&c2,&c3);                                              \
    kputs("\r\nEncrypt Latency : ");                                   \
    uart_put_dec((void*)uart_reg,enc_latency);                         \
    kputs(" cycles\r\n");                                              \
                                                                       \
    kputs("Ciphertext = ");                                            \
    uart_put_hex((void*)uart_reg,c3); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,c2); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,c1); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,c0);                                  \
                                                                       \
    dec_latency = run_crypt(                                           \
        1,                                                             \
        c0,c1,c2,c3,                                                   \
        &p0,&p1,&p2,&p3);                                              \
                                                                       \
    kputs("\r\nDecrypt Latency : ");                                   \
    uart_put_dec((void*)uart_reg,dec_latency);                         \
    kputs(" cycles\r\n");                                              \
                                                                       \
    kputs("Recovered Plaintext = ");                                   \
    uart_put_hex((void*)uart_reg,p3); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,p2); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,p1); kputs(" ");                      \
    uart_put_hex((void*)uart_reg,p0);                                  \
                                                                       \
    if(p3==0xFFEEDDCC &&                                               \
       p2==0xBBAA9988 &&                                               \
       p1==0x77665544 &&                                               \
       p0==0x33221100)                                                 \
        kputs("\r\nResult : PASS");                                    \
    else                                                               \
        kputs("\r\nResult : FAIL");                                    \
}while(0)
//HART 0 runs main
int main(int id, unsigned long dtb)
{
  // Use the FDT to get some devices
  int nodeoffset;
  int err = 0;
  int len;
    const fdt32_t *val;
  
  // 1. Get the uart reg
  nodeoffset = fdt_path_offset((void*)dtb, "/soc/serial");
  if (nodeoffset < 0) while(1);
  err = fdt_get_node_addr_size((void*)dtb, nodeoffset, &uart_reg, NULL);
  if (err < 0) while(1);
  // NOTE: If want to force UART, uncomment these
  //uart_reg = 0x64000000;
  //tlclk_freq = 20000000;
  _REG32(uart_reg, UART_REG_TXCTRL) = UART_TXEN;
  _REG32(uart_reg, UART_REG_RXCTRL) = UART_RXEN;
  
  // 2. Get tl_clk 
  nodeoffset = fdt_path_offset((void*)dtb, "/soc/subsystem_pbus_clock");
  if (nodeoffset < 0) {
    kputs("\r\nCannot find '/soc/subsystem_pbus_clock'\r\nAborting...");
    while(1);
  }
  val = fdt_getprop((void*)dtb, nodeoffset, "clock-frequency", &len);
  if(!val || len < sizeof(fdt32_t)) {
    kputs("\r\nThere is no clock-frequency in '/soc/subsystem_pbus_clock'\r\nAborting...");
    while(1);
  }
  if (len > sizeof(fdt32_t)) val++;
  tlclk_freq = fdt32_to_cpu(*val);
  _REG32(uart_reg, UART_REG_DIV) = uart_min_clk_divisor(tlclk_freq, 115200);
  
  // 3. Get the mem_size
  nodeoffset = fdt_path_offset((void*)dtb, "/memory");
  if (nodeoffset < 0) {
    kputs("\r\nCannot find '/memory'\r\nAborting...");
    while(1);
  }
  unsigned long mem_base, mem_size;
  err = fdt_get_node_addr_size((void*)dtb, nodeoffset, &mem_base, &mem_size);
  if (err < 0) {
    kputs("\r\nCannot get reg space from '/memory'\r\nAborting...");
    while(1);
  }
  unsigned long ddr_size = (unsigned long)mem_size; // TODO; get this
  unsigned long ddr_end = (unsigned long)mem_base + ddr_size;
  
  // 4. Get the number of cores
  uint32_t num_cores = 0;
  err = fdt_parse_max_hart_id((void*)dtb, &num_cores);
  num_cores++; // Gives maxid. For max cores we need to add 1
  
  // 5. Get the plic parameters
  nodeoffset = fdt_path_offset((void*)dtb, "/soc/interrupt-controller");
  if (nodeoffset < 0) {
    kputs("\r\nCannot find '/soc/interrupt-controller'\r\nAborting...");
    while(1);
  }
  kputs("\r\n");
  err = fdt_get_node_addr_size((void*)dtb, nodeoffset, &plic_reg, NULL);
  if (err < 0) {
    kputs("\r\nCannot get reg space from '/soc/interrupt-controller'\r\nAborting...");
    while(1);
  }
  
  val = fdt_getprop((void*)dtb, nodeoffset, "riscv,ndev", &len);
  if(!val || len < sizeof(fdt32_t)) {
    kputs("\r\nThere is no riscv,ndev in '/soc/interrupt-controller'\r\nAborting...");
    while(1);
  }
  if (len > sizeof(fdt32_t)) val++;
  plic_ndevs = fdt32_to_cpu(*val);
  
  val = fdt_getprop((void*)dtb, nodeoffset, "riscv,max-priority", &len);
  if(!val || len < sizeof(fdt32_t)) {
    kputs("\r\nThere is no riscv,max-priority in '/soc/interrupt-controller'\r\nAborting...");
    while(1);
  }
  if (len > sizeof(fdt32_t)) val++;
  plic_max_priority = fdt32_to_cpu(*val);

  // Disable the machine & timer interrupts until setup is done.
  clear_csr(mstatus, MSTATUS_MIE);
  clear_csr(mie, MIP_MEIP);
  clear_csr(mie, MIP_MTIP);
  
  if(plic_reg != 0) {
    PLIC_init(&g_plic,
              plic_reg,
              plic_ndevs,
              plic_max_priority);
  }
  
  // Display some information
#define DEQ(mon, x) ((cdate[0] == mon[0] && cdate[1] == mon[1] && cdate[2] == mon[2]) ? x : 0)
  const char *cdate = __DATE__;
  int month =
    DEQ("Jan", 1) | DEQ("Feb",  2) | DEQ("Mar",  3) | DEQ("Apr",  4) |
    DEQ("May", 5) | DEQ("Jun",  6) | DEQ("Jul",  7) | DEQ("Aug",  8) |
    DEQ("Sep", 9) | DEQ("Oct", 10) | DEQ("Nov", 11) | DEQ("Dec", 12);

  char date[11] = "YYYY-MM-DD";
  date[0] = cdate[7];
  date[1] = cdate[8];
  date[2] = cdate[9];
  date[3] = cdate[10];
  date[5] = '0' + (month/10);
  date[6] = '0' + (month%10);
  date[8] = cdate[4];
  date[9] = cdate[5];

  // Post the serial number and build info
  extern const char * gitid;

  kputs("\r\nRATONA Demo:       ");
  kputs(date);
  kputs("-");
  kputs(__TIME__);
  kputs("-");
  kputs(gitid);
  kputs("\r\nGot TL_CLK: ");
  uart_put_dec((void*)uart_reg, tlclk_freq);
  kputs("\r\nGot NUM_CORES: ");
  uart_put_dec((void*)uart_reg, num_cores);

  // Copy the DTB
  dtb_target = ddr_end - 0x200000UL; // - 2MB
  err = fdt_open_into((void*)dtb, (void*)dtb_target, 0x100000UL); // - 1MB only for the DTB
  if (err < 0) {
    kputs(fdt_strerror(err));
    kputs("\r\n");
    boot_fail(-err, 4);
  }
  //memcpy((void*)dtb_target, (void*)dtb, fdt_size(dtb));
  
  // Put the choosen if non existent, and put the bootargs
  nodeoffset = fdt_find_or_add_subnode((void*)dtb_target, 0, "chosen");
  if (nodeoffset < 0) boot_fail(-nodeoffset, 2);
    
  const char* str = "console=hvc0 earlycon=sbi";
  err = fdt_setprop((void*)dtb_target, nodeoffset, "bootargs", str, strlen(str) + 1);
  if (err < 0) boot_fail(-err, 3);

  // Get the timebase-frequency for the cpu@0
  nodeoffset = fdt_path_offset((void*)dtb_target, "/cpus/cpu@0");
  if (nodeoffset < 0) {
    kputs("\r\nCannot find '/cpus/cpu@0'\r\nAborting...");
    while(1);
  }
  val = fdt_getprop((void*)dtb_target, nodeoffset, "timebase-frequency", &len);
  if(!val || len < sizeof(fdt32_t)) {
    kputs("\r\nThere is no timebase-frequency in '/cpus/cpu@0'\r\nAborting...");
    while(1);
  }
  if (len > sizeof(fdt32_t)) val++;
  timescale_freq = fdt32_to_cpu(*val);
  kputs("\r\nGot TIMEBASE: ");
  uart_put_dec((void*)uart_reg, timescale_freq);
    
    // Put the timebase-frequency for the cpus
  nodeoffset = fdt_subnode_offset((void*)dtb_target, 0, "cpus");
    if (nodeoffset < 0) {
      kputs("\r\nCannot find 'cpus'\r\nAborting...");
    while(1);
    }
    err = fdt_setprop_u32((void*)dtb_target, nodeoffset, "timebase-frequency", 1000000);
    if (err < 0) {
      kputs("\r\nCannot set 'timebase-frequency' in 'timebase-frequency'\r\nAborting...");
    while(1);
    }

    // Pack the FDT and place the data after it
    fdt_pack((void*)dtb_target);

  // TODO: From this point, insert any code
  kputs("\r\n\n\nWelcome! Hello world!\r\n\n");

  nodeoffset = fdt_node_offset_by_compatible((void*)dtb_target, 0, "console,MKV0");
  
  if (nodeoffset <= 0) {
    kputs("\r\nCannot find a node with compatible 'console,MKV0'\r\nAborting...");
    while(1);
  }
  err = fdt_get_node_addr_size((void*)dtb_target, nodeoffset, &mkv_reg, NULL);
  if (err < 0){
    kputs("\r\nCannot find a node with compatible 'console,MKV0'\r\nAborting...");
    while(1);
  }
  uint32_t c0,c1,c2,c3;
  uint32_t p0,p1,p2,p3;
  kputs("\r\n========= SOFTWARE TEST =========\r\n");
  uint64_t key_latency;
  uint64_t enc_latency;
  uint64_t dec_latency;
  uint8_t plaintext[16] =
  {
      0xFF,0xEE,0xDD,0xCC,
      0xBB,0xAA,0x99,0x88,
      0x77,0x66,0x55,0x44,
      0x33,0x22,0x11,0x00
  };
  /*==========================
   * TEST 1 : KEY_MASTER-128
   *=========================*/
  kputs("\r\n******** TEST 1 : KEY_MASTER-128 ********\r\n");
  uint8_t key128[32] =
  {
      0x00,0x01,0x02,0x03,
      0x04,0x05,0x06,0x07,
      0x08,0x09,0x0A,0x0B,
      0x0C,0x0D,0x0E,0x0F,
      0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0
  };
  done = 0;
  key_latency = Key_Expansion(key128,0,1);
  enc_latency = ENC_CORE(plaintext,key128,0);
  dec_latency = DEC_CORE(ciphertext,key128,0);
  /*==========================
   * TEST 2 : KEY_MASTER-192
   *=========================*/
  kputs("\r\n******** TEST 2 : KEY_MASTER-192 ********\r\n");
  uint8_t key192[32] =
  {
      0x00,0x01,0x02,0x03,
      0x04,0x05,0x06,0x07,
      0x08,0x09,0x0A,0x0B,
      0x0C,0x0D,0x0E,0x0F,
      0x10,0x11,0x12,0x13,
      0x14,0x15,0x16,0x17,
      0,0,0,0,0,0,0,0
  };
  done = 0;
  key_latency = Key_Expansion(key192,1,1);
  enc_latency = ENC_CORE(plaintext,key192,1);
  dec_latency = DEC_CORE(ciphertext,key192,1);
  /*==========================
   * TEST 3 : KEY_MASTER-256
   *=========================*/
  kputs("\r\n******** TEST 3 : KEY_MASTER-256 ********\r\n");
  uint8_t key256[32] =
  {
      0x00,0x01,0x02,0x03,
      0x04,0x05,0x06,0x07,
      0x08,0x09,0x0A,0x0B,
      0x0C,0x0D,0x0E,0x0F,
      0x10,0x11,0x12,0x13,
      0x14,0x15,0x16,0x17,
      0x18,0x19,0x1A,0x1B,
      0x1C,0x1D,0x1E,0x1F
  };
  done = 0;
  key_latency = Key_Expansion(key256,2,1);
  enc_latency = ENC_CORE(plaintext,key256,2);
  dec_latency = DEC_CORE(ciphertext,key256,2);
  kputs("\r\n=========== ALL TESTS DONE ===========\r\n");
  kputs("\r\n==================================================\r\n");
  kputs("           HARDWARE CRYPTO TEST BENCH             \r\n");
  RUN_KEY_TEST(
    "KEY SET 1 (MKV-128)",
    0,
    0x00000000,
    0x00000000,
    0x00000000,
    0x00000000,
    0x0C0D0E0F,
    0x08090A0B,
    0x04050607,
    0x00010203
  );
  RUN_KEY_TEST(
    "KEY SET 2 (MKV-192)",
    1,
    0x00000000,
    0x00000000,
    0x14151617,
    0x10111213,
    0x0C0D0E0F,
    0x08090A0B,
    0x04050607,
    0x00010203
  );
  RUN_KEY_TEST(
    "KEY SET 3 (MKV-256)",
    2,
    0x1C1D1E1F,
    0x18191A1B,
    0x14151617,
    0x10111213,
    0x0C0D0E0F,
    0x08090A0B,
    0x04050607,
    0x00010203
  );
  // If finished, stay in a infinite loop
  while(1);
  //dead code
  return 0;
}
