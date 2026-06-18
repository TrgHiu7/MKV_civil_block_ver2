--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity tb_Key_Expansion is

--end tb_Key_Expansion;

--architecture behavior of tb_Key_Expansion is

--    component Key_Expansion
--    Port (
--        clk         : in  std_logic;
--        rst         : in  std_logic;
--        start       : in  std_logic;
--        key_master  : in  std_logic_vector(255 downto 0);
--        sel         : in std_logic_vector(3 downto 0);
--        done        : out std_logic;
--        keyk0_out   : out std_logic_vector(127 downto 0);
--        keyk1_out   : out std_logic_vector(127 downto 0);
--        key_post    : out std_logic_vector(127 downto 0)
--    );
--    end component;

--    signal clk        : std_logic := '0';
--    signal rst        : std_logic := '0';
--    signal start      : std_logic := '0';
--    signal key_master : std_logic_vector(255 downto 0) := (others => '0');

--    signal done       : std_logic;
--    signal keyk0_out  : std_logic_vector(127 downto 0);
--    signal keyk1_out  : std_logic_vector(127 downto 0);
--    signal key_post  : std_logic_vector(127 downto 0);
--    constant clk_period : time := 10 ns;
--    signal sel : std_logic_vector(3 downto 0);
--begin

--    uut: Key_Expansion PORT MAP (
--        clk        => clk,
--        rst        => rst,
--        start      => start,
--        key_master => key_master,
--        done       => done,
--        sel => sel,
--        keyk0_out  => keyk0_out,
--        keyk1_out  => keyk1_out,
--        key_post   => key_post
--    );

--    clk_process :process
--    begin
--        clk <= '0';
--        wait for clk_period/2;
--        clk <= '1';
--        wait for clk_period/2;
--    end process;

--    stim_proc: process
--    begin
--        rst <= '1';
--        start <= '0';
--        key_master <= (others => '0');
--        wait for 20 ns;

--        rst <= '0';
--        wait for 20 ns;

----        key_master <= x"0102030405060708090A0B0C0D0E0F1112131415161718191A1B1C1D1E1F2223";
--        key_master <= x"000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F";
--        wait for 10 ns;
--        start <= '1';
        
--        wait for clk_period * 2;
        
--        wait until done = '1';
        
--        start <= '0';
        
--        wait for 50 ns;

--        wait;
--    end process;

--end behavior;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Key_Expansion is
end tb_Key_Expansion;

architecture Behavioral of tb_Key_Expansion is

    component Key_Expansion
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;

            key_master  : in  std_logic_vector(255 downto 0);

            keyk0_out   : out std_logic_vector(127 downto 0);
            keyk1_out   : out std_logic_vector(127 downto 0);
            key_post    : out std_logic_vector(127 downto 0);

            key_index   : out std_logic_vector(3 downto 0);
            valid       : out std_logic;
            done        : out std_logic
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal start       : std_logic := '0';

    signal key_master  : std_logic_vector(255 downto 0);

    signal keyk0_out   : std_logic_vector(127 downto 0);
    signal keyk1_out   : std_logic_vector(127 downto 0);
    signal key_post    : std_logic_vector(127 downto 0);

    signal key_index   : std_logic_vector(3 downto 0);
    signal valid       : std_logic;
    signal done        : std_logic;

begin

    DUT : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        key_master  => key_master,

        keyk0_out   => keyk0_out,
        keyk1_out   => keyk1_out,
        key_post    => key_post,

        key_index   => key_index,
        valid       => valid,
        done        => done
    );

    ------------------------------------------------
    -- Clock
    ------------------------------------------------

    clk <= not clk after 5 ns;

    ------------------------------------------------
    -- Stimulus
    ------------------------------------------------

    process
    begin

--        key_master <=
--        x"000102030405060708090A0B0C0D0E0F" &
--        x"101112131415161718191A1B1C1D1E1F";
        key_master <=
                x"0102030405060708090a0b0c0d0e0f11" &
                x"12131415161718191a1b1c1d1e1f2223";
        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;
        start <= '1';

        wait for 10 ns;
        start <= '0';

        wait until done = '1';

        report "===================================";
        report "KEY EXPANSION FINISHED";
        report "===================================";

        wait for 50 ns;

        assert false
        report "SIMULATION END"
        severity failure;

    end process;

    ------------------------------------------------
    -- Monitor
    ------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            if valid = '1' then

                report "--------------------------------";

                report "ROUND = "
                & integer'image(
                    to_integer(unsigned(key_index))
                );

                report "KEY GENERATED";

            end if;

            if done = '1' then

                report "POST KEY GENERATED";

            end if;

        end if;
    end process;

end Behavioral;
