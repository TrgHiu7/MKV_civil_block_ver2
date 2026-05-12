----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 05/12/2026 02:48:18 PM
-- Design Name: invSubCells
-- Module Name: invSubCells - Behavioral
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

entity invSubCells is
    Port (
        data_in  : in  std_logic_vector(7 downto 0); 
        data_out : out std_logic_vector(7 downto 0)
    );
end invSubCells;
architecture Behavioral of invSubCells is
    type sbox_array is array (0 to 255) of std_logic_vector(7 downto 0);
    constant inv_sbox_mkv : sbox_array := (
        x"10", x"00", x"E0", x"90", x"B0", x"D0", x"60", x"70", x"20", x"F0", x"50", x"C0", x"40", x"A0", x"80", x"30",
        x"11", x"01", x"DE", x"B9", x"EB", x"9D", x"76", x"67", x"52", x"CF", x"35", x"8C", x"24", x"FA", x"A8", x"43",
        x"DB", x"09", x"E8", x"6C", x"A9", x"F6", x"5F", x"84", x"C5", x"33", x"41", x"2D", x"9A", x"72", x"B7", x"1E",
        x"BD", x"0E", x"6A", x"9F", x"86", x"CE", x"48", x"F5", x"19", x"D7", x"EC", x"73", x"51", x"3B", x"22", x"A4",
        x"E9", x"0D", x"A7", x"8D", x"BC", x"7F", x"C3", x"2A", x"31", x"4E", x"1B", x"96", x"F2", x"55", x"64", x"D8",
        x"9E", x"0B", x"FB", x"C7", x"78", x"DA", x"A2", x"3C", x"BF", x"65", x"83", x"44", x"1D", x"E6", x"59", x"21",
        x"66", x"07", x"82", x"F3", x"2F", x"38", x"17", x"71", x"DC", x"E4", x"AD", x"5E", x"CB", x"49", x"95", x"BA",
        x"77", x"06", x"5C", x"4A", x"C4", x"A5", x"61", x"16", x"8E", x"2B", x"98", x"D2", x"EF", x"B3", x"3D", x"F9",
        x"AC", x"0F", x"B4", x"26", x"6D", x"53", x"3E", x"92", x"4B", x"18", x"D9", x"FF", x"75", x"C1", x"8A", x"E7",
        x"45", x"02", x"13", x"AB", x"D1", x"2C", x"FD", x"B8", x"7A", x"56", x"C2", x"69", x"87", x"94", x"EE", x"3F",
        x"F8", x"0C", x"79", x"34", x"57", x"E2", x"B5", x"4D", x"63", x"81", x"2E", x"1A", x"D6", x"AF", x"CC", x"9B",
        x"23", x"05", x"91", x"58", x"FE", x"14", x"EA", x"C9", x"A6", x"B2", x"6F", x"37", x"4C", x"30", x"7B", x"85",
        x"8F", x"0A", x"25", x"7E", x"93", x"47", x"D4", x"5B", x"ED", x"AA", x"B6", x"C8", x"39", x"1C", x"F1", x"62",
        x"32", x"04", x"4F", x"E1", x"15", x"89", x"9C", x"AE", x"F4", x"7D", x"5A", x"BB", x"68", x"27", x"D3", x"C6",
        x"54", x"03", x"CD", x"12", x"3A", x"B1", x"8B", x"DF", x"28", x"99", x"F7", x"E5", x"A3", x"6E", x"46", x"7C",
        x"CA", x"08", x"36", x"D5", x"42", x"6B", x"29", x"E3", x"97", x"FC", x"74", x"A1", x"BE", x"88", x"1F", x"5D"
    );
begin
    data_out <= inv_sbox_mkv(to_integer(unsigned(data_in)));
end Behavioral;
