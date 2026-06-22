library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decrypt is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;
        keylen      : in  std_logic_vector(1 downto 0);   -- 00=128, 01=192, 10=256

        ciphertext  : in  std_logic_vector(127 downto 0);

        keyk0       : in  std_logic_vector(127 downto 0);
        keyk1       : in  std_logic_vector(127 downto 0);
        key_post    : in  std_logic_vector(127 downto 0);

        next_round  : out std_logic;
        done        : out std_logic;
        plaintext   : out std_logic_vector(127 downto 0)
    );
end decrypt;

architecture Behavioral of decrypt is

    component INV_N_ROUND
        Port (
            data_in   : in  std_logic_vector(127 downto 0);
            keyk0     : in  std_logic_vector(127 downto 0);
            keyk1     : in  std_logic_vector(127 downto 0);
            data_out  : out std_logic_vector(127 downto 0)
        );
    end component;

    type state_type is (IDLE, LOAD, ROUND, NEXT_KEY, FINISH);

    signal state      : state_type := IDLE;
    signal sel_reg    : unsigned(3 downto 0) := (others => '0');

    signal data_reg   : std_logic_vector(127 downto 0);
    signal round_out  : std_logic_vector(127 downto 0);

    -- So vong cuoi cung (sel index): 128->6, 192->7, 256->8
    function last_sel_f(kl : std_logic_vector(1 downto 0)) return unsigned is
    begin
        case kl is
            when "00"   => return to_unsigned(6, 4);
            when "01"   => return to_unsigned(7, 4);
            when others => return to_unsigned(8, 4);
        end case;
    end function;
    signal last_sel   : unsigned(3 downto 0) := to_unsigned(8, 4);

begin

    ROUND_CORE : INV_N_ROUND
    port map(
        data_in  => data_reg,
        keyk0    => keyk0,
        keyk1    => keyk1,
        data_out => round_out
    );

    process(clk, rst)
    begin
        if rst='1' then
            state       <= IDLE;
            sel_reg     <= (others=>'0');
            data_reg    <= (others=>'0');
            plaintext   <= (others=>'0');
            done        <= '0';
            next_round  <= '0';

        elsif rising_edge(clk) then

            done <= '0';

            case state is

                when IDLE =>
                    sel_reg <= (others=>'0');

                    if start='1' then
                        last_sel <= last_sel_f(keylen);
                        state <= LOAD;
                    end if;

                when LOAD =>
                    -- Undo final whitening
                    data_reg <= ciphertext xor key_post;
                    state <= ROUND;

                when ROUND =>
                    next_round <= '1';
                    state <= NEXT_KEY;

                when NEXT_KEY =>
                    next_round <= '0';
                    data_reg <= round_out;

                    if sel_reg = last_sel then
                        plaintext <= round_out;
                        done <= '1';
                        state <= FINISH;
                    else
                        sel_reg <= sel_reg + 1;
                        state <= ROUND;
                    end if;

                when FINISH =>
                    if start='0' then
                        state <= IDLE;
                    end if;

            end case;

        end if;
    end process;

end Behavioral;