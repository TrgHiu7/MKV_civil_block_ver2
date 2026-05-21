library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_encrypt is
end tb_encrypt;

architecture Behavioral of tb_encrypt is

    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    component encrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            key_master  : in  std_logic_vector(255 downto 0);
            plaintext   : in  std_logic_vector(127 downto 0);

            done        : out std_logic;
            ciphertext  : out std_logic_vector(127 downto 0)
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
    DUT : encrypt
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

        ----------------------------------------------------------------
        -- INITIAL VALUES
        ----------------------------------------------------------------
        plaintext <= x"112233445566778899AABBCCDDEEFF00";

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

        ----------------------------------------------------------------
        -- PRINT RESULT
        ----------------------------------------------------------------
        report "====================================";
        report "ENCRYPTION DONE";
        report "Ciphertext generated.";
        report "====================================";

        wait;

    end process;

end Behavioral;