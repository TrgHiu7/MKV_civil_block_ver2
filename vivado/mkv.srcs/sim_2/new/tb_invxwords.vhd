library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_invxwords is
end tb_invxwords;

architecture Behavioral of tb_invxwords is

    ----------------------------------------------------------------
    -- UUT Component
    ----------------------------------------------------------------
    component inv_xwords
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;

    ----------------------------------------------------------------
    -- Signals
    ----------------------------------------------------------------
    signal data_in  : std_logic_vector(127 downto 0) := (others => '0');
    signal data_out : std_logic_vector(127 downto 0);

begin

    ----------------------------------------------------------------
    -- Instantiate DUT
    ----------------------------------------------------------------
    uut : inv_xwords
    port map (
        data_in  => data_in,
        data_out => data_out
    );

    ----------------------------------------------------------------
    -- Stimulus Process
    ----------------------------------------------------------------
    stim_proc : process
    begin

        ------------------------------------------------------------
        -- Wait for initialization
        ------------------------------------------------------------
        wait for 20 ns;

        ------------------------------------------------------------
        -- Apply Test Vector
        ------------------------------------------------------------
        data_in <= X"ce2f691d793c904a065c4d0fd93d4e60";

        ------------------------------------------------------------
        -- Wait for combinational propagation
        ------------------------------------------------------------
        wait for 40 ns;

        ------------------------------------------------------------
        -- Print Result
        ------------------------------------------------------------
        report "====================================";
        report "XWords Test";
        report "====================================";

        ------------------------------------------------------------
        -- Finish Simulation
        ------------------------------------------------------------
        wait;

    end process;

end Behavioral;