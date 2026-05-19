----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/20/2026 12:38:29 AM
-- Design Name: 
-- Module Name: N_ROUND - Behavioral
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

entity N_ROUND is
    Port (
        data_in   :   in std_logic_vector(127 downto 0);
        keyk0       :   in std_logic_vector(127 downto 0);
        keyk1       :   in std_logic_vector(127 downto 0);
        data_out    :   out std_logic_vector(127 downto 0)
         );
end N_ROUND;

architecture Behavioral of N_ROUND is
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
    
    component XWords
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;
    
    signal s1, s2, s3, s4, s5 : std_logic_vector(127 downto 0);
begin
    s1 <= data_in xor keyk0;
    Sub1 : SubCells_128 port map(data_in  => s1, data_out => s2);
    Mix1 : MixWords     port map(data_in  => s2, data_out => s3);
    s4    <=  s3 xor keyk1;
    Sub2 : SubCells_128 port map(data_in  => s4, data_out => s5);
    Mix2 : MixWords     port map(data_in  => s5, data_out => data_out);
end Behavioral;

