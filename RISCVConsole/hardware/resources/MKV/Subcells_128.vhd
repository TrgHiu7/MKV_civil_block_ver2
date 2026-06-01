----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2026 11:03:01 AM
-- Design Name: 
-- Module Name: Subcells_128 - Behavioral
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
entity SubCells_128 is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end SubCells_128;
architecture Behavioral of SubCells_128 is
    component SubCells
        Port (
            data_in  : in  std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;
begin
    gen_sbox : for i in 0 to 15 generate
    begin
        SBOX_INST : SubCells
        port map(
            data_in  => data_in(i*8+7 downto i*8),
            data_out => data_out(i*8+7 downto i*8)
        );
    end generate;
end Behavioral;
