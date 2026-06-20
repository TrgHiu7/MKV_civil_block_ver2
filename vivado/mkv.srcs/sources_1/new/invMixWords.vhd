----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: invMixWords
-- Module Name: invMixWords - Behavioral
-- Project Name: mkv
-- Target Devices: arty100
-- Tool Versions: 2022.2
-- Description:
--     ma tran M4x4 chuan MKV-128:
---    encrypt
--     [01 02 01 03]
--     [03 07 01 04]
--     [04 0B 03 0C]
--     [0C 1E 06 14]        
--     decrypt
--     [14 06 18 0B]
--     [0B 02 0D 05]
--     [05 01 07 02]
--     [02 01 03 01] 
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
    function xtime(
        a : std_logic_vector(7 downto 0)
    ) return std_logic_vector is
        variable temp : std_logic_vector(7 downto 0);
    begin    
        if a(7) = '1' then
            temp := (a(6 downto 0) & '0') xor x"2B";
        else
            temp := (a(6 downto 0) & '0');
        end if;    
        return temp;
    end function;
begin
    -- MKV chuan: nghich dao cua MixWords. Ap ma tran iM roi XOAY PHAI output
    -- theo k=i (tuong duong matrmultcol2(X, iM, k=i) trong code C).
    gen_cols: for i in 0 to 3 generate
        concurrency_block: block
            type byte_arr is array(0 to 3) of std_logic_vector(7 downto 0);
            signal x0, x1, x2, x3 : std_logic_vector(7 downto 0);
            signal yv : byte_arr;   -- ket qua iM truoc khi xoay
        begin
            x0 <= data_in(127 - 32*i downto 120 - 32*i);
            x1 <= data_in(119 - 32*i downto 112 - 32*i);
            x2 <= data_in(111 - 32*i downto 104 - 32*i);
            x3 <= data_in(103 - 32*i downto 96 - 32*i);

            --     decrypt
            --     [14 06 18 0B]
            --     [0B 02 0D 05]
            --     [05 01 07 02]
            --     [02 01 03 01]
            yv(3) <= x1 xor x2 xor x3 xor xtime(x0 xor x2);
            yv(2) <= x0 xor x1 xor x2 xor xtime(x1 xor yv(3));
            yv(1) <= x0 xor x2 xor x3 xor xtime(x2 xor yv(2));
            yv(0) <= x3 xor xtime(x0 xor x1 xor x2 xor yv(1));

            -- Xoay phai output theo k=i: out(j) = yv((j - i) mod 4)
            data_out(127 - 32*i downto 120 - 32*i) <= yv((0 - i) mod 4);
            data_out(119 - 32*i downto 112 - 32*i) <= yv((1 - i) mod 4);
            data_out(111 - 32*i downto 104 - 32*i) <= yv((2 - i) mod 4);
            data_out(103 - 32*i downto 96 - 32*i)  <= yv((3 - i) mod 4);
        end block;
    end generate gen_cols;
end Behavioral;
