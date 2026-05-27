----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: XWords
-- Module Name: XWords - Behavioral
-- Project Name: mkv
-- Target Devices: arty100
-- Tool Versions: 2022.2
-- Description: Bi?n ??i này c?p nh?t tr?ng thái ??u vào X = x0 ||x1 || x2 || x3 b?ng cách
--              c?ng XOR các tr?ng thái con v?i nhau ?? nh?n giá tr? cho tr?ng thái ti?p theo Y = y0 || y1 || y2 || y3.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity XWords is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end XWords;
architecture Behavioral of XWords is
    signal x0, x1, x2, x3 : std_logic_vector(31 downto 0);
    signal y0, y1, y2, y3 : std_logic_vector(31 downto 0);
begin
    x0 <= data_in(127 downto 96);
    x1 <= data_in(95 downto 64);
    x2 <= data_in(63 downto 32);
    x3 <= data_in(31 downto 0);

    y0 <= x1 xor x2 xor x3;
    y1 <= x0 xor x2 xor x3;
    y2 <= x0 xor x1 xor x3;
    y3 <= x0 xor x1 xor x2;
    
    data_out <= y0 & y1 & y2 & y3;
end Behavioral;
