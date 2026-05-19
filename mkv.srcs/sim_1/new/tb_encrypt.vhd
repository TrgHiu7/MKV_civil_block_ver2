library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_encrypt is
end tb_encrypt;

architecture Behavioral of tb_encrypt is

    -- Component Declaration
    component encrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            key_master  : in  std_logic_vector(255 downto 0);
            plaintext   : in  std_logic_vector(127 downto 0);
            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            key_post    : in  std_logic_vector(127 downto 0);
            done        : out std_logic;
            ciphertext  : out std_logic_vector(127 downto 0)
        );
    end component;

    -- Signals
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal start       : std_logic := '0';

    signal key_master  : std_logic_vector(255 downto 0);
    signal plaintext   : std_logic_vector(127 downto 0);

    signal keyk0       : std_logic_vector(127 downto 0) := (others => '0');
    signal keyk1       : std_logic_vector(127 downto 0) := (others => '0');
    signal key_post    : std_logic_vector(127 downto 0) := (others => '0');

    signal done        : std_logic;
    signal ciphertext  : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instantiate DUT
    DUT : encrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        key_master  => key_master,
        plaintext   => plaintext,
        keyk0       => keyk0,
        keyk1       => keyk1,
        key_post    => key_post,
        done        => done,
        ciphertext  => ciphertext
    );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD/2;

            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin

        -- Reset
        rst <= '1';
        wait for 20 ns;

        rst <= '0';
        wait for 20 ns;

        -- Input test vector
        plaintext <= x"112233445566778899AABBCCDDEEFF00";

        key_master <=
            x"0102030405060708090A0B0C0D0E0F11" &
            x"12131415161718191A1B1C1D1E1F2223";

        -- Start pulse
        start <= '1';
        wait for CLK_PERIOD;

        start <= '0';

        -- Wait until encryption done
        wait until done = '1';

        -- Display result
        report "Encryption Finished";

        wait;

    end process;

end Behavioral;