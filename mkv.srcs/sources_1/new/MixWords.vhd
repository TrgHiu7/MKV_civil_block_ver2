----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: MixWords
-- Module Name: MixWords - Behavioral
-- Project Name: mkv
-- Target Devices: arty100
-- Tool Versions: 2022.2
-- Description: V?i m?i tr?ng th�i ??u v�o X = x^0 || x^1 || x^2 || x^3, ph�p bi?n ??i MixWords c?p nh?t t?ng  
--              tr?ng th�i con x^i qua m?t bi?n ??i tuy?n t�nh d?a tr�n ma tr?n c� k�ch th??c t � t tr�n tr??ng.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixWords is
  Port( data_in:    in  std_logic_vector(127 downto 0);
        data_out:   out std_logic_vector(127 downto 0)
      );
end MixWords;

architecture Behavioral of MixWords is
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
    component SubCells is
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
        Sbox0: SubCells port map(data_in => x0, data_out => s0);
        Sbox1: SubCells port map(data_in => x1, data_out => s1);
        Sbox2: SubCells port map(data_in => x2, data_out => s2);
        Sbox3: SubCells port map(data_in => x3, data_out => s3);
        -- Thuc hien nhan ma tran voi cac byte DA THAY THE (s0, s1, s2, s3)
        process(s0, s1, s2, s3)
            variable y0, y1, y2, y3 : std_logic_vector(7 downto 0);
        begin
            -- Hang 0: [02 03 01 01]
            y0 := gf_mul(s0, x"02") xor gf_mul(s1, x"03") xor gf_mul(s2, x"01") xor gf_mul(s3, x"01");
            -- Hang 1: [01 02 03 01]
            y1 := gf_mul(s0, x"01") xor gf_mul(s1, x"02") xor gf_mul(s2, x"03") xor gf_mul(s3, x"01");
            -- Hang 2: [01 01 02 03]
            y2 := gf_mul(s0, x"01") xor gf_mul(s1, x"01") xor gf_mul(s2, x"02") xor gf_mul(s3, x"03");
            -- Hang 3: [03 01 01 02]
            y3 := gf_mul(s0, x"03") xor gf_mul(s1, x"01") xor gf_mul(s2, x"01") xor gf_mul(s3, x"02");

            data_out(offset + 31 downto offset + 24) <= y0;
            data_out(offset + 23 downto offset + 16) <= y1;
            data_out(offset + 15 downto offset + 8)  <= y2;
            data_out(offset + 7  downto offset + 0)  <= y3;
        end process;
    end generate;
end Behavioral;
