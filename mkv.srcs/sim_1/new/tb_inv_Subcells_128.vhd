library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_inv_Subcells_128 is
end tb_inv_Subcells_128;

architecture Behavioral of tb_inv_Subcells_128 is

    component inv_Subcells_128
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;

    signal data_in  : std_logic_vector(127 downto 0);
    signal data_out : std_logic_vector(127 downto 0);

begin

    DUT : inv_Subcells_128
    port map(
        data_in  => data_in,
        data_out => data_out
    );

    stim_proc : process
    begin

        ----------------------------------------------------------------
        -- TEST VECTOR
        ----------------------------------------------------------------
        data_in <= x"1191E1D1B17161F121C151A141318100";

        wait for 20 ns;

        ----------------------------------------------------------------
        -- EXPECTED:
        -- 11 -> 01
        -- 91 -> 02
        -- E1 -> 03
        -- D1 -> 04
        -- B1 -> 05
        -- 71 -> 06
        -- 61 -> 07
        -- F1 -> 08
        -- 21 -> 09
        -- C1 -> 0A
        -- 51 -> 0B
        -- A1 -> 0C
        -- 31 -> 0D
        -- 81 -> 0E
        -- 00 -> 10
        -- 00 -> 10
        ----------------------------------------------------------------

        assert data_out = x"0102030405060708090A0B0C0D0E1010"
        report "TEST FAILED"
        severity failure;

        report "TEST PASSED"
        severity note;

        wait;

    end process;

end Behavioral;