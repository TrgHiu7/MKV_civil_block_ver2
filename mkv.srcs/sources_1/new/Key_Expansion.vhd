----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2026 08:27:22 AM
-- Design Name: 
-- Module Name: Key_Expansion - Behavioral
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

entity Key_Expansion is
  Port (key_master  :   in  std_logic_vector(255 downto 0);
        key_out    :   out std_logic_vector(127 downto 0)
        );
end Key_Expansion;

architecture Behavioral of Key_Expansion is
    function const_func(k, i : integer) return std_logic_vector is
        variable p_last     : std_logic_vector(127 downto 0);
        variable p          : std_logic_vector(7 downto 0);
    begin
        if      k = 0 then --0 left, 1 right
                    p := std_logic_vector(to_unsigned(2*i + 2, 8));
        elsif   k = 1 then
                    p := std_logic_vector(to_unsigned(2*i + 1, 8));
        end if;
        p_last := (119 downto 0 => '0') & p;
        return p_last;
    end function;
begin


end Behavioral;
