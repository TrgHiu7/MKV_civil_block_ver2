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
            keylen          : in  std_logic_vector(1 downto 0);
            key_init        : in  std_logic;
            key_expand_done : out std_logic;
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
    signal sel_crypt : std_logic := '0';

    signal key_master : std_logic_vector(255 downto 0) := (others => '0');
    signal keylen     : std_logic_vector(1 downto 0)   := "00";
    signal data_in    : std_logic_vector(127 downto 0) := (others => '0');

    signal done, key_expand_done, key_init : std_logic := '0';
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
        clk             => clk,
        rst             => rst,
        start           => start,
        key_master      => key_master,
        keylen          => keylen,
        key_init        => key_init,
        key_expand_done => key_expand_done,
        sel_crypt       => sel_crypt,
        data_in         => data_in,
        done            => done,
        data_out        => data_out
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

            elsif key_init = '1' and key_meas_en = '0' then
                key_cycle_cnt <= 0;
                key_meas_en   <= '1';

            elsif key_meas_en = '1' then
                key_cycle_cnt <= key_cycle_cnt + 1;

                if key_expand_done = '1' then
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
        variable v_cipher : std_logic_vector(127 downto 0);
    begin
        ------------------------------------------------------------------
        -- RESET
        ------------------------------------------------------------------
        rst <= '1';
        key_init <= '0';
        start <= '0';
        sel_crypt <= '0';
        keylen <= "00";
        data_in <= (others => '0');
        key_master <= (others => '0');

        wait for 30 ns;
        rst <= '0';
        wait for 20 ns;

        ------------------------------------------------------------------
        -- TEST 1 : MKV-128
        ------------------------------------------------------------------
        report "==================================================" severity note;
        report "TEST 1 : keylen = 00 (MKV-128)" severity note;
        report "==================================================" severity note;

        keylen <= "00";
        key_master <= x"000102030405060708090A0B0C0D0E0F" &
            x"00000000000000000000000000000000";
        sel_crypt <= '0';
        data_in   <= x"FFEEDDCCBBAA99887766554433221100";

        wait for 20 ns;

        -- Key expansion
        key_init <= '1';
        wait until rising_edge(clk);
        key_init <= '0';

        wait until key_expand_done = '1';
        report LF &
            "TEST 1 - KEY MASTER  = 0x" & slv_to_hex(key_master) & LF &
            "TEST 1 - KEY LATENCY = " & integer'image(key_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Encrypt
        report "TEST 1 - ENCRYPT" severity note;
        sel_crypt <= '0';
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        v_cipher := data_out;

        report LF &
            "TEST 1 - ENCRYPT OUTPUT  = 0x" & slv_to_hex(v_cipher) & LF &
            "TEST 1 - ENCRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Decrypt
        report "TEST 1 - DECRYPT" severity note;
        sel_crypt <= '1';
        data_in   <= v_cipher;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        report LF &
            "TEST 1 - DECRYPT OUTPUT  = 0x" & slv_to_hex(data_out) & LF &
            "TEST 1 - DECRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 50 ns;

        ------------------------------------------------------------------
        -- TEST 2 : MKV-192
        ------------------------------------------------------------------
        report "==================================================" severity note;
        report "TEST 2 : keylen = 01 (MKV-192)" severity note;
        report "==================================================" severity note;

        keylen <= "01";
        key_master <= x"000102030405060708090A0B0C0D0E0F" &
            x"10111213141516170000000000000000";
        sel_crypt <= '0';
        data_in   <= x"FFEEDDCCBBAA99887766554433221100";

        wait for 20 ns;

        -- Key expansion
        key_init <= '1';
        wait until rising_edge(clk);
        key_init <= '0';

        wait until key_expand_done = '1';
        report LF &
            "TEST 2 - KEY MASTER  = 0x" & slv_to_hex(key_master) & LF &
            "TEST 2 - KEY LATENCY = " & integer'image(key_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Encrypt
        report "TEST 2 - ENCRYPT" severity note;
        sel_crypt <= '0';
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        v_cipher := data_out;

        report LF &
            "TEST 2 - ENCRYPT OUTPUT  = 0x" & slv_to_hex(v_cipher) & LF &
            "TEST 2 - ENCRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Decrypt
        report "TEST 2 - DECRYPT" severity note;
        sel_crypt <= '1';
        data_in   <= v_cipher;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        report LF &
            "TEST 2 - DECRYPT OUTPUT  = 0x" & slv_to_hex(data_out) & LF &
            "TEST 2 - DECRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 50 ns;

        ------------------------------------------------------------------
        -- TEST 3 : MKV-256
        ------------------------------------------------------------------
        report "==================================================" severity note;
        report "TEST 3 : keylen = 10 (MKV-256)" severity note;
        report "==================================================" severity note;

        keylen <= "10";
        key_master <= x"000102030405060708090A0B0C0D0E0F" &
            x"101112131415161718191A1B1C1D1E1F";
        sel_crypt <= '0';
        data_in   <= x"FFEEDDCCBBAA99887766554433221100";

        wait for 20 ns;

        -- Key expansion
        key_init <= '1';
        wait until rising_edge(clk);
        key_init <= '0';

        wait until key_expand_done = '1';
        report LF &
            "TEST 3 - KEY MASTER  = 0x" & slv_to_hex(key_master) & LF &
            "TEST 3 - KEY LATENCY = " & integer'image(key_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Encrypt
        report "TEST 3 - ENCRYPT" severity note;
        sel_crypt <= '0';
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        v_cipher := data_out;

        report LF &
            "TEST 3 - ENCRYPT OUTPUT  = 0x" & slv_to_hex(v_cipher) & LF &
            "TEST 3 - ENCRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 20 ns;

        -- Decrypt
        report "TEST 3 - DECRYPT" severity note;
        sel_crypt <= '1';
        data_in   <= v_cipher;
        start <= '1';
        wait until rising_edge(clk);
        start <= '0';

        wait until done = '1';
        report LF &
            "TEST 3 - DECRYPT OUTPUT  = 0x" & slv_to_hex(data_out) & LF &
            "TEST 3 - DECRYPT LATENCY = " & integer'image(crypt_cycle_cnt) & " cycles"
            severity note;

        wait for 50 ns;

        report "==================================================" severity note;
        report "SIM DONE" severity note;
        report "==================================================" severity note;

        wait;
    end process;

end Behavioral;