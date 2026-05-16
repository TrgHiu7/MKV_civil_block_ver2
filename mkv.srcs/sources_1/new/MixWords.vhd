--------------------------------------------------------------------------------------
------ Company: Hoc vien ky thuat mat ma
------ Engineer: Tran Trong Hieu
------ Create Date: 05/12/2026 02:48:18 PM
------ Design Name: MixWords
------ Module Name: MixWords - Behavioral
------ Project Name: mkv
------ Target Devices: arty100
------ Tool Versions: 2022.2
------ Description: 
------ Dependencies: 
------ Revision:
------ Revision 0.01 - File Created
------ Additional Comments:
--------------------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity MixWords is
--  Port( data_in:    in  std_logic_vector(127 downto 0);
--        data_out:   out std_logic_vector(127 downto 0)
--      );
--end MixWords;

--architecture Behavioral of MixWords is
--    function gf_mul(a, b : std_logic_vector(7 downto 0)) return std_logic_vector is
--        variable p      : std_logic_vector(7 downto 0) := x"00";
--        variable temp_a : std_logic_vector(7 downto 0) := a;
--    begin
--        for i in 0 to 7 loop
--            if b(i) = '1' then 
--                p := p xor temp_a;
--            end if;
--            if temp_a(7) = '1' then
--                temp_a := (temp_a(6 downto 0) & '0') xor x"1B";
--            else
--                temp_a := (temp_a(6 downto 0) & '0');
--            end if;
--        end loop;
--        return p;
--    end function;
    
--    signal s0, s1, s2, s3 : std_logic_vector(31 downto 0);
--    signal y0, y1, y2, y3 : std_logic_vector(31 downto 0);
--begin
--    s0 <= data_in(127 downto 96);
--    s1 <= data_in(95 downto 64);
--    s2 <= data_in(63 downto 32);
--    s3 <= data_in(31 downto 0);

--    process(s0, s1, s2, s3)
--        variable byte_s0, byte_s1, byte_s2, byte_s3 : std_logic_vector(7 downto 0);
--        variable byte_y0, byte_y1, byte_y2, byte_y3 : std_logic_vector(7 downto 0);
--    begin
--        for i in 0 to 3 loop
--            byte_s0 := s0(i*8+7 downto i*8);
--            byte_s1 := s1(i*8+7 downto i*8);
--            byte_s2 := s2(i*8+7 downto i*8);
--            byte_s3 := s3(i*8+7 downto i*8);
--            -- ma tran M4x4 chuan MKV-128:
--            -- [01 02 01 03]
--            -- [03 07 01 04]
--            -- [04 0B 03 0C]
--            -- [0C 1E 06 14]        
-- INV MIX
        --0x14 0x06 0x18 0x0B
        --0x0B 0x02 0x0D 0x05
        --0x05 0x01 0x07 0x02
        --0x02 0x01 0x03 0x01
--            byte_y0 := gf_mul(byte_s0, x"01") xor gf_mul(byte_s1, x"02") xor gf_mul(byte_s2, x"01") xor gf_mul(byte_s3, x"03");            
--            byte_y1 := gf_mul(byte_s0, x"03") xor gf_mul(byte_s1, x"07") xor gf_mul(byte_s2, x"01") xor gf_mul(byte_s3, x"04");            
--            byte_y2 := gf_mul(byte_s0, x"04") xor gf_mul(byte_s1, x"0B") xor gf_mul(byte_s2, x"03") xor gf_mul(byte_s3, x"0D");            
--            byte_y3 := gf_mul(byte_s0, x"0D") xor gf_mul(byte_s1, x"1E") xor gf_mul(byte_s2, x"06") xor gf_mul(byte_s3, x"14");

--            y0(i*8+7 downto i*8) <= byte_y0;
--            y1(i*8+7 downto i*8) <= byte_y1;
--            y2(i*8+7 downto i*8) <= byte_y2;
--            y3(i*8+7 downto i*8) <= byte_y3;
--        end loop;
--    end process;

--    data_out <= y0 & y1 & y2 & y3;

--end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixWords is
    Port(
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end MixWords;

architecture Behavioral of MixWords is

    ----------------------------------------------------------------
    -- GF(2^8) multiplication
    ----------------------------------------------------------------
    function gf_mul(
        a, b : std_logic_vector(7 downto 0)
    ) return std_logic_vector is
        variable p      : std_logic_vector(7 downto 0) := x"00";
        variable temp_a : std_logic_vector(7 downto 0) := a;
    begin
        for i in 0 to 7 loop
            if b(i) = '1' then
                p := p xor temp_a;
            end if;
            if temp_a(7) = '1' then
                temp_a := (temp_a(6 downto 0) & '0') xor x"1B";
            else
                temp_a := (temp_a(6 downto 0) & '0');
            end if;
        end loop;
        return p;
    end function;

    ----------------------------------------------------------------
    -- WORD signals
    ----------------------------------------------------------------
    signal s0, s1, s2, s3 : std_logic_vector(31 downto 0);
    signal y0, y1, y2, y3 : std_logic_vector(31 downto 0);

begin

    ----------------------------------------------------------------
    -- Split input
    ----------------------------------------------------------------
    s0 <= data_in(127 downto 96);
    s1 <= data_in(95 downto 64);
    s2 <= data_in(63 downto 32);
    s3 <= data_in(31 downto 0);

    ----------------------------------------------------------------
    -- Generate byte-wise MixWords
    ----------------------------------------------------------------
    gen_mix : for i in 0 to 3 generate
        signal byte_s0, byte_s1, byte_s2, byte_s3 : std_logic_vector(7 downto 0);
        signal byte_y0, byte_y1, byte_y2, byte_y3 : std_logic_vector(7 downto 0);
    begin

        ----------------------------------------------------------------
        -- Extract bytes
        ----------------------------------------------------------------
        byte_s0 <= s0(i*8+7 downto i*8);
        byte_s1 <= s1(i*8+7 downto i*8);
        byte_s2 <= s2(i*8+7 downto i*8);
        byte_s3 <= s3(i*8+7 downto i*8);

        ----------------------------------------------------------------
        -- PROCESS thực hiện tính toán ma trận MKV-128 chuẩn theo ảnh
        ----------------------------------------------------------------
        process(byte_s0, byte_s1, byte_s2, byte_s3)
        begin
            -- Hàng 1: [0x01  0x02  0x01  0x03]
            byte_y0 <= gf_mul(byte_s0, x"01") xor
                       gf_mul(byte_s1, x"02") xor
                       gf_mul(byte_s2, x"01") xor
                       gf_mul(byte_s3, x"03");

            -- Hàng 2: [0x03  0x07  0x01  0x04]
            byte_y1 <= gf_mul(byte_s0, x"03") xor
                       gf_mul(byte_s1, x"07") xor
                       gf_mul(byte_s2, x"01") xor
                       gf_mul(byte_s3, x"04");

            -- Hàng 3: [0x04  0x0B  0x03  0x0C]
            byte_y2 <= gf_mul(byte_s0, x"04") xor
                       gf_mul(byte_s1, x"0B") xor
                       gf_mul(byte_s2, x"03") xor
                       gf_mul(byte_s3, x"0C");

            -- Hàng 4: [0x0C  0x1E  0x06  0x14]
            byte_y3 <= gf_mul(byte_s0, x"0C") xor
                       gf_mul(byte_s1, x"1E") xor
                       gf_mul(byte_s2, x"06") xor
                       gf_mul(byte_s3, x"14");
        end process;

        ----------------------------------------------------------------
        -- Assign output bytes
        ----------------------------------------------------------------
        y0(i*8+7 downto i*8) <= byte_y0;
        y1(i*8+7 downto i*8) <= byte_y1;
        y2(i*8+7 downto i*8) <= byte_y2;
        y3(i*8+7 downto i*8) <= byte_y3;

    end generate;

    ----------------------------------------------------------------
    -- Merge output
    ----------------------------------------------------------------
    data_out <= y0 & y1 & y2 & y3;

end Behavioral;