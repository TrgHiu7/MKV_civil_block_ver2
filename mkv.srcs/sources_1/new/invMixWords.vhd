----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: invMixWords
-- Module Name: invMixWords - Behavioral
-- Project Name: mkv
-- Target Devices: arty100
-- Tool Versions: 2022.2
-- Description: Bi?n ??i invMixWords là bi?n ??i ngh?ch ??o c?a bi?n ??i MixWords, thao tác trên Tr?ng thái, thay m?i tr?ng thái con này b?ng tr?ng thái con khác.
--              Phép bi?n ??i này có th? bi?u di?n d??i d?ng phép nhân ma tr?n, ? ??y m?i byte ???c coi nh? m?t ph?n t? c?a tr??ng h?u h?n  ?ã l?a ch?n.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity invMixWords is
  Port( data_in:    in  std_logic_vector(127 downto 0);
        data_out:   out std_logic_vector(127 downto 0)
      );
end invMixWords;

architecture Behavioral of invMixWords is
    function gf_mul(a,b : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable p      : std_logic_vector(7 downto 0) := x"00";
        variable temp_a : std_logic_vector(7 downto 0) := a;
    begin
        for i in 0 to 7 loop
            if b(i) = '1' then p := p xor temp_a;
            end if;
            if temp_a(7) = '1' then
                temp_a := (temp_a(6 downto 0) & '0') xor x"1B";
            else
                temp_a := (temp_a(6 downto 0) & '0');
            end if;
        end loop;
        return p;
    end function;
    component invSubCells is
        Port (
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    gen_columns: for i in 0 to 3 generate
        signal x0, x1, x2, x3 : std_logic_vector(7 downto 0);
        signal s0, s1, s2, s3 : std_logic_vector(7 downto 0);
        constant offset : integer := i * 32;
    begin
        -- Tach cac byte tu data_in
        x0 <= data_in(offset + 31 downto offset + 24);
        x1 <= data_in(offset + 23 downto offset + 16);
        x2 <= data_in(offset + 15 downto offset + 8);
        x3 <= data_in(offset + 7  downto offset + 0);
        -- Moi byte trong cot se di qua mot hop S-box rieng biet
        invSbox0: invSubCells port map(data_in => x0, data_out => s0);
        invSbox1: invSubCells port map(data_in => x1, data_out => s1);
        invSbox2: invSubCells port map(data_in => x2, data_out => s2);
        invSbox3: invSubCells port map(data_in => x3, data_out => s3);
        -- Thuc hien nhan ma tran voi cac byte DA THAY THE (s0, s1, s2, s3)
        process(s0, s1, s2, s3)
            variable y0, y1, y2, y3 : std_logic_vector(7 downto 0);
        begin
            -- Hàng 0: [01 02 01 03]
            y0 := s0 xor gf_mul(s1, x"02") xor s2 xor gf_mul(s3, x"03");   
            -- Hàng 1: [03 07 01 04]
            y1 := gf_mul(s0, x"03") xor gf_mul(s1, x"07") xor s2 xor gf_mul(s3, x"04");
            -- Hàng 2: [04 0B 03 0D]
            y2 := gf_mul(s0, x"04") xor gf_mul(s1, x"0B") xor gf_mul(s2, x"03") xor gf_mul(s3, x"0D");
            -- Hàng 3: [0D 1E 06 14]
            y3 := gf_mul(s0, x"0D") xor gf_mul(s1, x"1E") xor gf_mul(s2, x"06") xor gf_mul(s3, x"14");
            
            data_out(offset + 31 downto offset + 24) <= y0;
            data_out(offset + 23 downto offset + 16) <= y1;
            data_out(offset + 15 downto offset + 8)  <= y2;
            data_out(offset + 7  downto offset + 0)  <= y3;
        end process;
    end generate;
end Behavioral;
