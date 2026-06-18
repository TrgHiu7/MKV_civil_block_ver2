library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

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
    signal cycle_cnt : integer := 0;
    function slv_to_hex(slv : std_logic_vector) return string is
    variable L : line;
    begin
        hwrite(L, slv);
        return L.all;
    end function;
    signal measure_en : std_logic := '0';

begin
    
    --------------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------------

    clk <= not clk after CLK_PERIOD/2;
    --------------------------------------------------------------------------
    -- CYCLE COUNTER
    --------------------------------------------------------------------------
    
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cycle_cnt  <= 0;
                measure_en <= '0';
    
            elsif i_valid = '1' then
                cycle_cnt  <= 0;
                measure_en <= '1';
    
            elsif measure_en = '1' then
                cycle_cnt <= cycle_cnt + 1;
    
                if o_ready = '1' then
                    measure_en <= '0';
                end if;
            end if;
        end if;
    end process;
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
    variable latency     : integer;
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
        assert false
        report LF &
               "================================" & LF &
               "TEST 1 :" & LF &
               "ENCRYPT" & LF &
               "================================"
        severity note;

        key_master <= x"0102030405060708090A0B0C0D0E0F11" &
                      x"12131415161718191A1B1C1D1E1F2223";
        
        data_in <= x"112233445566778899AABBCCDDEEFF00";
        
        i_mode <= '1';        
        wait for 20 ns;
		
        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';
        wait until o_ready = '1';        
        latency := cycle_cnt;        
        wait for 90 ns;        
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';
        assert false
        report LF &
               "INPUT   : 0x" & slv_to_hex(data_in) & LF &
               "OUTPUT  : 0x" & slv_to_hex(data_out) & LF &
               "LATENCY : " & integer'image(latency) & " cycles"
        severity note;
        wait for 20 ns;
        
        assert false
        report LF &
               "================================" & LF &
               "DECRYPT" & LF &
               "================================"
        severity note;

        
        data_in <= data_out;
        
        i_mode <= '0';        
        wait for 20 ns;
	
        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';
        wait until o_ready = '1';        
        latency := cycle_cnt;        
        wait for 90 ns;        
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';
        assert false
        report LF &
               "INPUT   : 0x" & slv_to_hex(data_in) & LF &
               "OUTPUT  : 0x" & slv_to_hex(data_out) & LF &
               "LATENCY : " & integer'image(latency) & " cycles"
        severity note;
        wait for 20 ns;
        ----------------------------------------------------------------------
        -- TEST z : ENCRYPT
        ----------------------------------------------------------------------

        assert false
        report LF &
               "================================" & LF &
               "TEST 2 :" & LF &
               "ENCRYPT" & LF &
               "================================"
        severity note;
        
        key_master <= x"0102030405060708090A0B0C0D0E0F11" &
                      x"12131415161718191A1B1C1D1E1F2223";
        
        data_in <= x"FEDCBA9876543210FEDCBA9876543210";
        
        i_mode <= '1';        
        wait for 20 ns;
	
        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';
        wait until o_ready = '1';        
        latency := cycle_cnt;        
        wait for 90 ns;        
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';
        
        assert false
        report LF &
               "INPUT   : 0x" & slv_to_hex(data_in) & LF &
               "OUTPUT  : 0x" & slv_to_hex(data_out) & LF &
               "LATENCY : " & integer'image(latency) & " cycles"
        severity note;
        wait for 20 ns;
        
        assert false
        report LF &
               "================================" & LF &
               "DECRYPT" & LF &
               "================================"
        severity note;
        
        data_in <= data_out;
        
        i_mode <= '0';        
        wait for 20 ns;
		

        i_valid <= '1';
        wait until rising_edge(clk);
        i_valid <= '0';
        wait until o_ready = '1';        
        latency := cycle_cnt;        
        wait for 90 ns;        
        o_valid <= '1';
        wait for 90 ns;
        o_valid <= '0';
        
        assert false
        report LF &
               "INPUT   : 0x" & slv_to_hex(data_in) & LF &
               "OUTPUT  : 0x" & slv_to_hex(data_out) & LF &
               "LATENCY : " & integer'image(latency) & " cycles"
        severity note;

        report "ALL TESTS PASSED";

        wait;

    end process;

end Behavioral;