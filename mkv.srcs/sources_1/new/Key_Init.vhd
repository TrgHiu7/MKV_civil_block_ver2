----------------------------------------------------------------------------------
-- Company: Hoc vien ky thuat mat ma
-- Engineer: Tran Trong Hieu
-- Create Date: 2026-05-15
-- Design Name: KeyInit
-- Module Name: KeyInit - Behavioral
-- Project Name: mkv (128-bit key mode)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Key_Init is
    Port (
        K_master : in  std_logic_vector(127 downto 0); -- Khoa chinh 128-bit
        K_int    : out std_logic_vector(255 downto 0)  -- Khoa trong 256-bit
    );
end Key_Init;

architecture Behavioral of Key_Init is
begin
    -- Thuc hien phep ghep noi (Concatenation) theo quy tac:
    -- K_int = K_master || NOT(K_master)
    -- Toan tu '&' trong VHDL tuong ung voi ky hieu '||' trong toan hoc
    
    K_int <= K_master & (not K_master);

end Behavioral;