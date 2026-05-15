library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Key_Expansion is
end tb_Key_Expansion;

architecture Behavioral of tb_Key_Expansion is

    --------------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------------

    component Key_Expansion
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            key_master  : in  std_logic_vector(255 downto 0);
            done        : out std_logic;
            key_out     : out std_logic_vector(127 downto 0)
        );
    end component;

    --------------------------------------------------------------------------
    -- SIGNAL
    --------------------------------------------------------------------------

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal start        : std_logic := '0';

    signal key_master   : std_logic_vector(255 downto 0);

    signal done         : std_logic;
    signal key_out      : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------------

    clk <= not clk after CLK_PERIOD/2;

    --------------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------------

    DUT : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        key_master  => key_master,
        done        => done,
        key_out     => key_out
    );

    --------------------------------------------------------------------------
    -- STIMULUS
    --------------------------------------------------------------------------

    process
    begin

        ----------------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------------

        rst <= '1';

        wait for 20 ns;

        rst <= '0';

        ----------------------------------------------------------------------
        -- INPUT KEY
        ----------------------------------------------------------------------

        key_master <=
        x"0102030405060708090A0B0C0D0E0F1112131415161718191A1B1C1D1E1F2223";

        wait for 20 ns;

        ----------------------------------------------------------------------
        -- START
        ----------------------------------------------------------------------

        start <= '1';

        wait for CLK_PERIOD;

        start <= '0';

        ----------------------------------------------------------------------
        -- WAIT FINISH
        ----------------------------------------------------------------------

        wait until done = '1';

        wait for 100 ns;

        report "KEY EXPANSION DONE";

        wait;

    end process;

end Behavioral;