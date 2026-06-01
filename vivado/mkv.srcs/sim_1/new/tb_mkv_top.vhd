library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mkv_top is
end tb_mkv_top;

architecture Behavioral of tb_mkv_top is

    --------------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------------

    component mkv_top
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;

            i_valid     : in  std_logic;
            i_ready     : out std_logic;

            i_mode      : in  std_logic;

            o_valid     : in  std_logic;
            o_ready     : out std_logic;

            key_master  : in  std_logic_vector(255 downto 0);
            data_in     : in  std_logic_vector(127 downto 0);

            data_out    : out std_logic_vector(127 downto 0)
        );
    end component;

    --------------------------------------------------------------------------
    -- SIGNALS
    --------------------------------------------------------------------------

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';

    signal i_valid      : std_logic := '0';
    signal i_ready      : std_logic;

    signal i_mode       : std_logic := '0';

    signal o_valid      : std_logic := '0';
    signal o_ready      : std_logic;

    signal key_master   : std_logic_vector(255 downto 0) := (others => '0');
    signal data_in      : std_logic_vector(127 downto 0) := (others => '0');

    signal data_out     : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------------

    clk <= not clk after CLK_PERIOD/2;

    --------------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------------

    DUT : mkv_top
    port map(
        clk         => clk,
        rst         => rst,

        i_valid     => i_valid,
        i_ready     => i_ready,

        i_mode      => i_mode,

        o_valid     => o_valid,
        o_ready     => o_ready,

        key_master  => key_master,
        data_in     => data_in,

        data_out    => data_out
    );

    --------------------------------------------------------------------------
    -- TEST
    --------------------------------------------------------------------------

    process
    begin

        ----------------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------------

        rst <= '1';
        wait for 30 ns;

        rst <= '0';
        wait for 20 ns;

        ----------------------------------------------------------------------
        -- TEST 1 : ENCRYPT
        ----------------------------------------------------------------------

        report "TEST 1 : ENCRYPT";

        key_master <= x"0102030405060708090A0B0C0D0E0F11" &
                      x"12131415161718191A1B1C1D1E1F2223";

        data_in <= x"112233445566778899AABBCCDDEEFF00";

        i_mode <= '0';

        wait for 20 ns;

        assert i_ready = '0'
        report "ERROR: i_ready should be 0 after input loaded"
        severity error;

        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';

        wait until o_ready = '1';
        wait for 90 ns;
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';

        wait for 20 ns;
        ----------------------------------------------------------------------
        -- TEST z : ENCRYPT
        ----------------------------------------------------------------------

        report "TEST z : ENCRYPT";

        key_master <= x"1E1F22231A1B1C1D1617181912131415" &
                      x"0D0E0F11090A0B0C0506070801020304";

        data_in <= x"DDEEFF0099AABBCC5566778811223344";

        i_mode <= '1';

        wait for 20 ns;

        assert i_ready = '0'
        report "ERROR: i_ready should be 0 after input loaded"
        severity error;

        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';

        wait until o_ready = '1';
        wait for 90 ns;
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';

        wait for 20 ns;
        ----------------------------------------------------------------------
        -- TEST 2 : DECRYPT
        ----------------------------------------------------------------------

        report "TEST 2 : DECRYPT";

        key_master <= x"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" &
                      x"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";

        data_in <= x"1234567890ABCDEF1234567890ABCDEF";

        i_mode <= '0';

        wait for 20 ns;

        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';

        wait until o_ready = '1';

        o_valid <= '1';
        wait for 60 ns;
        o_valid <= '0';

        wait for 20 ns;

        ----------------------------------------------------------------------
        -- TEST 3 : HOLD OUTPUT
        ----------------------------------------------------------------------

        report "TEST 3 : HOLD OUTPUT";

        key_master <= (others => '1');
        data_in    <= (others => '1');

        i_mode <= '1';

        wait for 20 ns;

        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';

        wait until o_ready = '1';

        wait for 50 ns;

        assert o_ready = '1'
        report "ERROR: o_ready should stay HIGH"
        severity error;

        o_valid <= '1';
        wait for 70 ns;
        o_valid <= '0';

        wait for 20 ns;

        ----------------------------------------------------------------------
        -- TEST 4 : SYSTEM RETURNS TO IDLE
        ----------------------------------------------------------------------

        report "TEST 4 : RETURN TO IDLE";

        wait for 20 ns;

        assert i_ready = '1'
        report "ERROR: system did not return to IDLE"
        severity error;

        ----------------------------------------------------------------------
        -- END
        ----------------------------------------------------------------------

        report "ALL TESTS PASSED";

        wait;

    end process;

end Behavioral;