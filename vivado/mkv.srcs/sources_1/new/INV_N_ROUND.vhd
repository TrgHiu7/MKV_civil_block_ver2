----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2026 10:21:50 PM
-- Design Name: 
-- Module Name: INV_N_ROUND - Behavioral
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

entity INV_N_ROUND is
    Port (
        data_in   :   in std_logic_vector(127 downto 0);
        keyk0       :   in std_logic_vector(127 downto 0);
        keyk1       :   in std_logic_vector(127 downto 0);
        data_out    :   out std_logic_vector(127 downto 0)
         );
end INV_N_ROUND;

architecture Behavioral of INV_N_ROUND is
    component inv_SubCells_128
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;
    component invMixWords
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
    Sub1 : XWords               port map(data_in  => data_in, data_out => s1);
    Mix1 : inv_SubCells_128     port map(data_in  => s1, data_out => s2);
    s3 <= s2 xor keyk1;
    Sub2 : invMixWords          port map(data_in  => s3, data_out => s4);
    Mix2 : inv_SubCells_128     port map(data_in  => s4, data_out => s5);
    data_out    <=  s5 xor keyk0;    
end Behavioral;