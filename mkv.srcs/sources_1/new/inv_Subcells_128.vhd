----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2026 02:19:30 AM
-- Design Name: 
-- Module Name: inv_Subcells_128 - Behavioral
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
entity inv_Subcells_128 is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end inv_Subcells_128;
architecture Behavioral of inv_Subcells_128 is
    component invSubCells
        Port (
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    gen_sbox : for i in 0 to 15 generate
    begin
        SBOX_INST : invSubCells
        port map(
            data_in  => data_in(i*8+7 downto i*8),
            data_out => data_out(i*8+7 downto i*8)
        );
    end generate;
end Behavioral;
