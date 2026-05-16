library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_SubCells_128 is
end tb_SubCells_128;

architecture Behavioral of tb_SubCells_128 is

    ----------------------------------------------------------------
    -- DUT Signals
    ----------------------------------------------------------------
    signal data_in  : std_logic_vector(127 downto 0);
    signal data_out : std_logic_vector(127 downto 0);

begin

    ----------------------------------------------------------------
    -- DUT
    ----------------------------------------------------------------
    DUT : entity work.SubCells_128
    port map(
        data_in  => data_in,
        data_out => data_out
    );

    ----------------------------------------------------------------
    -- Stimulus
    ----------------------------------------------------------------
    stim_proc : process
    begin

        ------------------------------------------------------------
        -- Test Vector
        ------------------------------------------------------------
        data_in <= x"0102030405060708090A0B0C0D0E0F10";

        wait for 100 ns;

        ------------------------------------------------------------
        -- Print Result
        ------------------------------------------------------------
        report "========================================";
        report "SubCells_128 Test";
        report "INPUT  = 0102030405060708090A0B0C0D0E0F10";
        report "========================================";

        ------------------------------------------------------------
        -- Finish Simulation
        ------------------------------------------------------------
        assert false
        report "Simulation Finished"
        severity failure;

    end process;

end Behavioral;