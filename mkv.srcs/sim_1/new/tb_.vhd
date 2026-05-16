library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_XWords is
end tb_XWords;

architecture Behavioral of tb_XWords is

    ----------------------------------------------------------------
    -- UUT Component
    ----------------------------------------------------------------
    component XWords
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
    uut : XWords
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
        data_in <= X"E9E1C2BD17C7D2F37D12EDB2145A48B1";

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