----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2026 11:07:07 AM
-- Design Name: 
-- Module Name: Gen_Key - Behavioral
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

entity Gen_Key is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out  : out std_logic_vector(127 downto 0)
    );
end Gen_Key;

architecture Behavioral of Gen_Key is

    ----------------------------------------------------------------
    -- COMPONENTS
    ----------------------------------------------------------------

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

    ----------------------------------------------------------------
    -- INTERNAL SIGNALS
    ----------------------------------------------------------------

    signal s1, s2, s3, s4 : std_logic_vector(127 downto 0);

    signal m1, m2         : std_logic_vector(127 downto 0);

    signal x1             : std_logic_vector(127 downto 0);

begin
    Sub1 : SubCells_128
    port map(
        data_in  => data_in,
        data_out => s1
    );

    Mix1 : MixWords
    port map(
        data_in  => s1,
        data_out => m1
    );

    Sub2 : SubCells_128
    port map(
        data_in  => m1,
        data_out => s2
    );

    XW1 : XWords
    port map(
        data_in  => s2,
        data_out => x1
    );

    Sub3 : SubCells_128
    port map(
        data_in  => x1,
        data_out => s3
    );

    Mix2 : MixWords
    port map(
        data_in  => s3,
        data_out => m2
    );

    Sub4 : SubCells_128
    port map(
        data_in  => m2,
        data_out => s4
    );

    XW2 : XWords
    port map(
        data_in  => s4,
        data_out => data_out
    );

end Behavioral;
