----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2026 11:44:57 PM
-- Design Name: 
-- Module Name: Sub_Mix - Behavioral
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

entity Sub_Mix is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out  : out std_logic_vector(127 downto 0)
    );
end Sub_Mix;

architecture Behavioral of Sub_Mix is
    component SubCells_128
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;

    component MixWords
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;
    
    signal s1 : std_logic_vector(127 downto 0);
begin
    Sub1 : SubCells_128
    port map(
        data_in  => data_in,
        data_out => s1
    );

    Mix1 : MixWords
    port map(
        data_in  => s1,
        data_out => data_out
    );
end Behavioral;
