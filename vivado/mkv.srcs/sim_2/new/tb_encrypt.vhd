library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_encrypt is
end tb_encrypt;

architecture Behavioral of tb_encrypt is

    component encrypt
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            plaintext   : in  std_logic_vector(127 downto 0);

            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            key_post    : in  std_logic_vector(127 downto 0);

            next_round  : out std_logic;
            done        : out std_logic;
            ciphertext  : out std_logic_vector(127 downto 0)
        );
    end component;

    signal clk         : std_logic := '0';
    signal rst         : std_logic := '1';
    signal start       : std_logic := '0';

    signal plaintext   : std_logic_vector(127 downto 0);

    signal keyk0       : std_logic_vector(127 downto 0);
    signal keyk1       : std_logic_vector(127 downto 0);
    signal key_post    : std_logic_vector(127 downto 0);

    signal next_round  : std_logic;
    signal done        : std_logic;
    signal ciphertext  : std_logic_vector(127 downto 0);

    -------------------------------------------------
    -- Memory
    -------------------------------------------------

    type key_array is array (0 to 8) of std_logic_vector(127 downto 0);

    signal mem_keyk0 : key_array :=
    (
        x"000102030405060708090A0B0C0D0E0F",
        x"F3C0707DCBAAFBBC9DE592B8665B0DE7",
        x"E25712841F927942AF9C4FDDDBD94165",
        x"305B008D3B49C360C5056E2F540D12E5",
        x"5577EDCD1D0AB9C889616E4D95889727",
        x"837330BAFC57E5872210F142C562E5AD",
        x"E00AF2939E11CF9D3A2B2078402806C7",
        x"62F8FCF91415CA40430633A20DCD03EF",
        x"DE7AE4FB0ED3483F62A0D4D5238E7CC8"
    );

    signal mem_keyk1 : key_array :=
    (
        x"4F3CB2130AC3DB1AE17C31949E349CAA",
        x"D24FD43A8BA6CECDBC6BBC3102814BFD",
        x"EC00550FA80B67D1130069186F55098E",
        x"C47016DC69EE2D9EC837FEF5C04AFD59",
        x"4F2E2119C6525753D2123DA8B4CD9F70",
        x"5BBAC586F16CDE4D0525AFEF0888A0CE",
        x"65B497070D282B7CA3FE217845E757D2",
        x"440F9ABE66624627ECFA9389CB46C2F1",
        x"DDF6D5855A3A575636552C593309038C"
    );

    signal round_cnt : integer range 0 to 8 := 0;

begin

    DUT : encrypt
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        plaintext   => plaintext,
        keyk0       => keyk0,
        keyk1       => keyk1,
        key_post    => key_post,
        next_round  => next_round,
        done        => done,
        ciphertext  => ciphertext
    );

    -------------------------------------------------
    -- Clock
    -------------------------------------------------

    clk <= not clk after 5 ns;

    -------------------------------------------------
    -- Key memory
    -------------------------------------------------

    process(clk)
    begin
        if rising_edge(clk) then

            if rst='1' then
                round_cnt <= 0;

            elsif start='1' then
                round_cnt <= 0;

            elsif next_round='1' then
                if round_cnt < 8 then
                    round_cnt <= round_cnt + 1;
                end if;
            end if;

        end if;
    end process;

    keyk0 <= mem_keyk0(round_cnt);
    keyk1 <= mem_keyk1(round_cnt);

    key_post <= x"9FDF7DF51B9910C72D75D64752DE94DD";

    -------------------------------------------------
    -- Stimulus
    -------------------------------------------------

    process
    begin

        plaintext <= x"00112233445566778899AABBCCDDEEFF";

        wait for 20 ns;
        rst <= '0';

        wait for 20 ns;
        start <= '1';

        wait for 10 ns;
        start <= '0';

        wait until done='1';

        report "===================================";
        report "Encryption Finished";
        report "===================================";

        wait for 100 ns;

        assert false
            report "Simulation End"
            severity failure;
    end process;

end Behavioral;