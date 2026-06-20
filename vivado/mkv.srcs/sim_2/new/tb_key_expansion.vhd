library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_key_expansion is
end tb_key_expansion;

architecture Behavioral of tb_key_expansion is

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    component Key_Expansion
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            keylen      : in  std_logic_vector(1 downto 0);
            key_master  : in  std_logic_vector(255 downto 0);

            keyk0_out   : out std_logic_vector(127 downto 0);
            keyk1_out   : out std_logic_vector(127 downto 0);
            key_post    : out std_logic_vector(127 downto 0);

            key_index   : out std_logic_vector(3 downto 0);
            valid       : out std_logic;
            done        : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal start       : std_logic := '0';

    signal keylen      : std_logic_vector(1 downto 0);
    signal key_master  : std_logic_vector(255 downto 0);

    signal keyk0_out   : std_logic_vector(127 downto 0);
    signal keyk1_out   : std_logic_vector(127 downto 0);
    signal key_post    : std_logic_vector(127 downto 0);

    signal key_index   : std_logic_vector(3 downto 0);
    signal valid       : std_logic;
    signal done        : std_logic;

begin

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    DUT : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        keylen      => keylen,
        key_master  => key_master,
        keyk0_out   => keyk0_out,
        keyk1_out   => keyk1_out,
        key_post    => key_post,
        key_index   => key_index,
        valid       => valid,
        done        => done
    );

    --------------------------------------------------------------------
    -- Clock (100 MHz)
    --------------------------------------------------------------------
    clk <= not clk after 5 ns;

    --------------------------------------------------------------------
    -- Stimulus
    --------------------------------------------------------------------
    process
    begin

        ------------------------------------------------------------
        -- Reset
        ------------------------------------------------------------
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        ------------------------------------------------------------
        -- TEST 1 : MKV-128
        ------------------------------------------------------------
        report "========== TEST 1 : MKV-128 ==========";

        keylen <= "00";

        key_master <=
            x"000102030405060708090A0B0C0D0E0F" &
            x"00000000000000000000000000000000";
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done='1';

        report "TEST1 DONE";

        wait for 100 ns;

        ------------------------------------------------------------
        -- TEST 2 : MKV-192
        ------------------------------------------------------------
        report "========== TEST 2 : MKV-192 ==========";

        keylen <= "01";

        key_master <=
            x"000102030405060708090A0B0C0D0E0F" &
            x"10111213141516170000000000000000";

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done='1';

        report "TEST2 DONE";

        wait for 100 ns;

        ------------------------------------------------------------
        -- TEST 3 : MKV-256
        ------------------------------------------------------------
        report "========== TEST 3 : MKV-256 ==========";

        keylen <= "10";

        key_master <=
            x"000102030405060708090A0B0C0D0E0F" &
            x"101112131415161718191A1B1C1D1E1F";

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done='1';

        report "TEST3 DONE";

        wait;

    end process;

end Behavioral;