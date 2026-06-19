library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_MKV_CRYPTO_TOP is
end tb_MKV_CRYPTO_TOP;

architecture Behavioral of tb_MKV_CRYPTO_TOP is

    component MKV_CRYPTO_TOP
        Port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            start           : in  std_logic;
            key_master      : in  std_logic_vector(255 downto 0);
            done_key_debug  : out std_logic;
            sel_crypt       : in  std_logic;
            data_in         : in  std_logic_vector(127 downto 0);
            done            : out std_logic;
            data_out        : out std_logic_vector(127 downto 0)
        );
    end component;

    ------------------------------------------------------------------
    -- SIGNALS
    ------------------------------------------------------------------
    signal clk, rst : std_logic := '0';
    signal start    : std_logic := '0';
    signal sel_crypt: std_logic := '0';

    signal key_master : std_logic_vector(255 downto 0) := (others=>'0');
    signal data_in    : std_logic_vector(127 downto 0) := (others=>'0');

    signal done, done_key_debug : std_logic;
    signal data_out : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;

    ------------------------------------------------------------------
    -- CYCLE LATENCY COUNTER (KEY)
    ------------------------------------------------------------------
    signal key_cycle_cnt : integer := 0;
    signal key_meas_en   : std_logic := '0';

    ------------------------------------------------------------------
    -- CYCLE LATENCY COUNTER (CRYPTO)
    ------------------------------------------------------------------
    signal crypt_cycle_cnt : integer := 0;
    signal crypt_meas_en   : std_logic := '0';
    
    function slv_to_hex(slv : std_logic_vector) return string is
    variable L : line;
    begin
        hwrite(L, slv);
        return L.all;
    end function;
    
begin

    ------------------------------------------------------------------
    -- DUT
    ------------------------------------------------------------------
    DUT : MKV_CRYPTO_TOP
    port map (
        clk            => clk,
        rst            => rst,
        start          => start,
        key_master     => key_master,
        done_key_debug => done_key_debug,
        sel_crypt      => sel_crypt,
        data_in        => data_in,
        done           => done,
        data_out       => data_out
    );

    ------------------------------------------------------------------
    -- CLOCK
    ------------------------------------------------------------------
    clk <= not clk after CLK_PERIOD/2;

    ------------------------------------------------------------------
    -- KEY LATENCY COUNTER
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                key_cycle_cnt <= 0;
                key_meas_en   <= '0';

            elsif start = '1' and key_meas_en = '0' then
                key_cycle_cnt <= 0;
                key_meas_en   <= '1';

            elsif key_meas_en = '1' then
                key_cycle_cnt <= key_cycle_cnt + 1;

                if done_key_debug = '1' then
                    key_meas_en <= '0';
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- CRYPTO LATENCY COUNTER
    ------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                crypt_cycle_cnt <= 0;
                crypt_meas_en   <= '0';

            elsif start = '1' and crypt_meas_en = '0' then
                crypt_cycle_cnt <= 0;
                crypt_meas_en   <= '1';

            elsif crypt_meas_en = '1' then
                crypt_cycle_cnt <= crypt_cycle_cnt + 1;

                if done = '1' then
                    crypt_meas_en <= '0';
                end if;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------
    -- TEST PROCESS
    ------------------------------------------------------------------
    process
    begin
        ------------------------------------------------------------------
        -- RESET
        ------------------------------------------------------------------
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 20 ns;

        key_master <= x"0102030405060708090A0B0C0D0E0F11" &
                      x"12131415161718191A1B1C1D1E1F2223";

        ------------------------------------------------------------------
        -- KEY + DECRYPT
        ------------------------------------------------------------------
        report "=== KEY EXPANSION + DECRYPT ===";

        sel_crypt <= '1';
        data_in   <= x"8a6f9bbc745bfee7005f04054dd1ff8e";

        wait for 20 ns;

        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done_key_debug = '1';

        report "KEY LATENCY = " & integer'image(key_cycle_cnt) & " cycles";

        wait until done = '1';

        report LF &
            "DECRYPT OUTPUT = 0x" & slv_to_hex(data_out) & LF &
            "DECRYPT LATENCY = " & integer'image(crypt_cycle_cnt-key_cycle_cnt+1) & " cycles"
        severity note;
        
        wait for 50 ns;
        ------------------------------------------------------------------
        -- ENCRYPT
        ------------------------------------------------------------------
        report "=== ENCRYPT ===";
        sel_crypt <= '0';
        data_in   <= data_out;
        wait for 20 ns;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';
        wait until done = '1';
        report LF &
            "ENCRYPT OUTPUT = 0x" & slv_to_hex(data_out) & LF &
            "ENCRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
        severity note;
        
        wait for 50 ns;
        ------------------------------------------------------------------
        -- ENCRYPT
        ------------------------------------------------------------------
        report "=== ENCRYPT ===";
        sel_crypt <= '1';
        data_in   <= x"5472616E2054726F6E67204869657500";
        wait for 20 ns;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';
        wait until done = '1';
        report "ENCRYPT OUTPUT = 0x" & slv_to_hex(data_out);
        report "ENCRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles";
        
        wait for 50 ns;
        ------------------------------------------------------------------
        -- DECRYPT
        ------------------------------------------------------------------
        report "=== DECRYPT ===";
        sel_crypt <= '0';
        data_in   <= data_out;
        wait for 20 ns;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';
        wait until done = '1';
        report LF &
            "DECRYPT OUTPUT = 0x" & slv_to_hex(data_out) & LF &
            "DECRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
        severity note;
        
        report "=== SIM DONE ===";

        wait;
    end process;

end Behavioral;