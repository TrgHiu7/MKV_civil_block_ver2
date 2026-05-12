----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: SubCells
-- Module Name: SubCells - Behavioral
-- Project Name: mkv
-- Target Devices: arty100
-- Tool Versions: 2022.2
-- Description: Bi?n ??i SubCells x? lý trên toàn b? tr?ng thái X ? Vl b?ng cách áp d?ng h?p th? 8 bit s vào t?ng byte
-- Chú thích:   Các giá tr? c?a các b?ng này ???c bi?u di?n d??i d?ng th?p l?c phân (hex), trong ?ó giá tr? ??u ra c?a h?p
--              th? là giá tr? ???c xác ??nh t?i v? trí giao nhau gi?a c?t ???c xác ??nh b?i 4-bit tr?ng s? th?p và hàng ???c
--              xác ??nh b?i 4-bit tr?ng s? cao c?a ??u vào. Ví d?, s(0x24) = 0x1C và inv_s(0x82) = 0xB4.
-- Dependencies: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SubCells is
    Port (
        data_in  : in  std_logic_vector(7 downto 0); 
        data_out : out std_logic_vector(7 downto 0)
    );
end SubCells;
architecture Behavioral of SubCells is
    type sbox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant sbox_mkv : sbox_array := (
        x"01", x"11", x"91", x"E1", x"D1", x"B1", x"71", x"61", x"F1", x"21", x"C1", x"51", x"A1", x"41", x"31", x"81",
        x"00", x"10", x"E3", x"92", x"B5", x"D4", x"77", x"66", x"89", x"38", x"AB", x"4A", x"CD", x"5C", x"2F", x"FE",
        x"08", x"5F", x"3E", x"B0", x"1C", x"C2", x"83", x"DD", x"E8", x"F6", x"47", x"79", x"95", x"2B", x"AA", x"64",
        x"0F", x"48", x"D0", x"29", x"A3", x"1A", x"F2", x"BB", x"65", x"CC", x"E4", x"3D", x"57", x"7E", x"86", x"9F",
        x"0C", x"2A", x"F4", x"1F", x"5B", x"90", x"EE", x"C5", x"36", x"6D", x"73", x"88", x"BC", x"A7", x"49", x"D2",
        x"0A", x"3C", x"18", x"85", x"E0", x"4D", x"99", x"A4", x"B3", x"5E", x"DA", x"C7", x"72", x"FF", x"6B", x"26",
        x"06", x"76", x"CF", x"A8", x"4E", x"59", x"60", x"17", x"DC", x"9B", x"32", x"F5", x"23", x"84", x"ED", x"BA",
        x"07", x"67", x"2D", x"3B", x"FA", x"8C", x"16", x"70", x"54", x"A2", x"98", x"BE", x"EF", x"D9", x"C3", x"45",
        x"0E", x"A9", x"62", x"5A", x"27", x"BF", x"34", x"9C", x"FD", x"D5", x"8E", x"E6", x"1B", x"43", x"78", x"C0",
        x"03", x"B2", x"87", x"C4", x"9D", x"6E", x"4B", x"F8", x"7A", x"E9", x"2C", x"AF", x"D6", x"15", x"50", x"33",
        x"0D", x"FB", x"56", x"EC", x"3F", x"75", x"B8", x"42", x"1E", x"24", x"C9", x"93", x"80", x"6A", x"D7", x"AD",
        x"04", x"E5", x"B9", x"7D", x"82", x"A6", x"CA", x"2E", x"97", x"13", x"6F", x"DB", x"44", x"30", x"FC", x"58",
        x"0B", x"8D", x"9A", x"46", x"74", x"28", x"DF", x"53", x"CB", x"B7", x"F0", x"6C", x"AE", x"E2", x"35", x"19",
        x"05", x"94", x"7B", x"DE", x"C6", x"F3", x"AC", x"39", x"4F", x"8A", x"55", x"20", x"68", x"BD", x"12", x"E7",
        x"02", x"D3", x"A5", x"F7", x"69", x"EB", x"5D", x"8F", x"22", x"40", x"B6", x"14", x"3A", x"C8", x"9E", x"7C",
        x"09", x"CE", x"4C", x"63", x"D8", x"37", x"25", x"EA", x"A0", x"7F", x"1D", x"52", x"F9", x"96", x"B4", x"8B"
    );
begin
    data_out <= sbox_mkv(to_integer(unsigned(data_in)));
end Behavioral;
