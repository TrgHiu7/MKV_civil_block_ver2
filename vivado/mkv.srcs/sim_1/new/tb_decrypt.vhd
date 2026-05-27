----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/25/2026 11:36:13 PM
-- Design Name: 
-- Module Name: tb_decrypt - Behavioral
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

entity tb_decrypt is
end tb_decrypt;

architecture Behavioral of tb_decrypt is

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    component decrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            key_master  : in  std_logic_vector(255 downto 0);
            ciphertext   : in  std_logic_vector(127 downto 0);

            done        : out std_logic;
            plaintext  : out std_logic_vector(127 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal start       : std_logic := '0';

    signal key_master  : std_logic_vector(255 downto 0);
    signal plaintext   : std_logic_vector(127 downto 0);

    signal done        : std_logic;
    signal ciphertext  : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    clk <= not clk after CLK_PERIOD/2;

    --------------------------------------------------------------------
    -- DUT INSTANTIATION
    --------------------------------------------------------------------
    DUT : decrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        key_master  => key_master,
        plaintext   => plaintext,
        done        => done,
        ciphertext  => ciphertext
    );

    --------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------
    stim_proc : process
    begin

        ciphertext <= x"8A6F9BBC745BFEE7005F04054DD1FF8E";

        key_master <=
            x"0102030405060708090A0B0C0D0E0F11" &
            x"12131415161718191A1B1C1D1E1F2223";

        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        rst <= '1';
        start <= '0';

        wait for 30 ns;

        rst <= '0';

        wait for 20 ns;

        ----------------------------------------------------------------
        -- START ENCRYPTION
        ----------------------------------------------------------------
        start <= '1';

        wait for CLK_PERIOD;

        start <= '0';

        ----------------------------------------------------------------
        -- WAIT DONE
        ----------------------------------------------------------------
        wait until done = '1';

        wait for 20 ns;

        wait;

    end process;

end Behavioral;
