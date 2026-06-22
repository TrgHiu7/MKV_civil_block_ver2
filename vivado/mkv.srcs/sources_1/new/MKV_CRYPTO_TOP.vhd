----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/15/2026 01:10:58 PM
-- Design Name: 
-- Module Name: MKV_CRYPTO_TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MKV_CRYPTO_TOP is
    Port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        
        start           : in  std_logic;                        --start latency / reset latency
        key_master      : in  std_logic_vector(255 downto 0);
        keylen          : in  std_logic_vector(1 downto 0);      --00=128, 01=192, 10=256
        key_init        : in  std_logic;
        key_expand_done : out std_logic;                        --done key -> latency key, start enc/dec
        
        sel_crypt       : in  std_logic;                        --0: enc      1:dec
        data_in         : in  std_logic_vector(127 downto 0);
        
        done            : out std_logic;                        --end latency
        data_out        : out std_logic_vector(127 downto 0)
    );
end MKV_CRYPTO_TOP;

architecture Behavioral of MKV_CRYPTO_TOP is
    component Key_Expansion
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            
            keylen      : in  std_logic_vector(1 downto 0);
            key_master  : in  std_logic_vector(255 downto 0);
            
            keyk0_out   : out std_logic_vector(127 downto 0);
            keyk1_out   : out std_logic_vector(127 downto 0);
            key_post    : out std_logic_vector(127 downto 0);
            
            key_index   : out std_logic_vector(3 downto 0);
            valid       : out std_logic;
            done        : out std_logic
        );
    end component;
    
    component encrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            keylen      : in  std_logic_vector(1 downto 0);
            plaintext   : in  std_logic_vector(127 downto 0);
    
            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            key_post    : in  std_logic_vector(127 downto 0);
            
            next_round  : out std_logic;    
            done        : out std_logic;
            ciphertext  : out std_logic_vector(127 downto 0)
        );
    end component;
    
    component decrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            keylen      : in  std_logic_vector(1 downto 0);
    
            ciphertext  : in  std_logic_vector(127 downto 0);
    
            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            key_post    : in  std_logic_vector(127 downto 0);
    
            next_round  : out std_logic;
            done        : out std_logic;
            plaintext   : out std_logic_vector(127 downto 0)
        );
    end component;
    
    signal start_enc, start_dec, enc_done, dec_done  : std_logic := '0';
    
    type key_array is array(0 to 8) of std_logic_vector(127 downto 0);    
    signal mem_keyk0 : key_array;
    signal mem_keyk1 : key_array;
    signal mem_keypost : std_logic_vector(127 downto 0);
    
    signal key_index   : std_logic_vector(3 downto 0);
    signal valid_key   : std_logic;
    
    signal keyk0_out   : std_logic_vector(127 downto 0);
    signal keyk1_out   : std_logic_vector(127 downto 0);
    signal key_post    : std_logic_vector(127 downto 0);
    
    signal key_ready : std_logic;
    signal enc_round : std_logic_vector(3 downto 0);
    signal done_key : std_logic;
    signal keyk0_mem   : std_logic_vector(127 downto 0);
    signal keyk1_mem   : std_logic_vector(127 downto 0);
    signal key_post_mem, data_out_reg, dec_data: std_logic_vector(127 downto 0);
    
    type state_type is (IDLE, WAIT_KEY, LOAD, UPDATE, FINISH);
    signal state : state_type := IDLE;
        
    signal dec_key_ready : std_logic;
    signal i : std_logic_vector(3 downto 0) := "0000";

    signal sel_crypt_reg: std_logic;    
    signal key_expand_done_reg : std_logic := '0';
    signal start_key           : std_logic := '0';
    signal key_init_d          : std_logic := '0';  
    -- Chi so khoa vong cao nhat (R-1): 128->6, 192->7, 256->8
    signal last_idx            : unsigned(3 downto 0);
    signal start_d             : std_logic := '0';
    signal crypto_done_reg : std_logic := '0';
begin
    last_idx <= to_unsigned(6,4) when keylen = "00" else
                to_unsigned(7,4) when keylen = "01" else
                to_unsigned(8,4);
    KEYGEN : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start_key,
        keylen      => keylen,
        key_master  => key_master,        
        keyk0_out   => keyk0_out,
        keyk1_out   => keyk1_out,
        key_post    => key_post,
        key_index   => key_index,
        valid       => valid_key,
        done        => done_key
    );    
    ENC_CORE : encrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => start_enc,
        keylen      => keylen,
        plaintext   => data_in,
        keyk0       => keyk0_mem,
        keyk1       => keyk1_mem,
        key_post    => mem_keypost,
        next_round  => key_ready,
        done        => enc_done,
        ciphertext  => data_out_reg
    );    
    DEC_CORE : decrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => start_dec,
        keylen      => keylen,
        ciphertext  => data_in,
        keyk0       => keyk0_mem,
        keyk1       => keyk1_mem,
        key_post    => mem_keypost,
        next_round  => dec_key_ready,
        done        => dec_done,
        plaintext   => dec_data
    );    
    process(clk, rst)
    begin
        if rst = '1' then  
            i           <= "0000";
            start_enc   <= '0';
            start_dec   <= '0';    
            state <= IDLE;
            keyk0_mem <= (others=>'0');
            keyk1_mem <= (others=>'0');
            key_post_mem <= (others=>'0');
            mem_keypost <= (others => '0');   
            sel_crypt_reg <= '0'; 
            key_expand_done_reg <= '0';
            start_key           <= '0';
            key_init_d          <= '0';
            crypto_done_reg <= '0';
            for j in 0 to 8 loop
                mem_keyk0(j) <= (others => '0');
                mem_keyk1(j) <= (others => '0');
            end loop;   
        elsif rising_edge(clk) then
            sel_crypt_reg <= sel_crypt;
            key_init_d <= key_init;
            start_d <= start;
            start_key  <= '0';
            if (start = '1' and start_d = '0') then 
                crypto_done_reg <= '0'; -- Xóa cờ done khi có lệnh start mới
            elsif (enc_done = '1' or dec_done = '1') then
                crypto_done_reg <= '1'; -- Chốt cờ done bằng 1 mãi mãi cho đến khi có lệnh start mới
            end if;
            if (key_init = '1' and key_init_d = '0') then
                key_expand_done_reg <= '0';
                start_key <= '1';
                start_enc <= '0';
                start_dec <= '0';
                state <= IDLE;
                i <= "0000";
            elsif done_key='1' then
                key_expand_done_reg <= '1';
                mem_keypost <= key_post;
            end if;
            if valid_key = '1' then    
                mem_keyk0(to_integer(unsigned(key_index))) <= keyk0_out;
                mem_keyk1(to_integer(unsigned(key_index))) <= keyk1_out;    
            end if;                     
            case state is
                when IDLE =>
                    if start = '1' then
                        state <= WAIT_KEY;
                        i     <= "0000";
                    end if;                    
                when WAIT_KEY =>
                    if key_expand_done_reg = '1' then    
                        if sel_crypt_reg = '1' then
                            start_dec <= '1';
                            start_enc <= '0';
                            keyk0_mem <= mem_keyk0(to_integer(last_idx));
                            keyk1_mem <= mem_keyk1(to_integer(last_idx));
                        else
                            start_dec <= '0';
                            start_enc <= '1';
                            keyk0_mem   <= mem_keyk0(0);
                            keyk1_mem   <= mem_keyk1(0);      
                        end if;                                              
                        state <= LOAD;
                    end if;                    
                when LOAD =>
                    start_enc <= '0';
                    start_dec <= '0';                    
                    if unsigned(i) = last_idx then
                        state <= FINISH;
                    elsif ((sel_crypt_reg='0' and key_ready='1') or
                           (sel_crypt_reg='1' and dec_key_ready='1')) then
                        if sel_crypt_reg='0' then
                            keyk0_mem <= mem_keyk0(to_integer(unsigned(i))+1);
                            keyk1_mem <= mem_keyk1(to_integer(unsigned(i))+1);
                        else
                            keyk0_mem <= mem_keyk0(to_integer(last_idx) - to_integer(unsigned(i))-1);
                            keyk1_mem <= mem_keyk1(to_integer(last_idx) - to_integer(unsigned(i))-1);
                        end if;
                        i <= std_logic_vector(unsigned(i) + 1);
                        state <= UPDATE;
                    end if;                    
                when UPDATE => 
                    state <= LOAD;                    
                when FINISH =>
                    if start = '0' then
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;    
    key_expand_done <= key_expand_done_reg;
    done <= crypto_done_reg;    
    data_out <= data_out_reg when sel_crypt_reg='0' else dec_data;    
end Behavioral;