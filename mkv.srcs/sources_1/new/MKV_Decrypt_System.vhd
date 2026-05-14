library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MKV_Decrypt_System is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        start      : in  std_logic;
        ciphertext : in  std_logic_vector(127 downto 0);
        key_master : in  std_logic_vector(127 downto 0);
        plaintext  : out std_logic_vector(127 downto 0);
        done       : out std_logic
    );
end MKV_Decrypt_System;

architecture Behavioral of MKV_Decrypt_System is

    -- Khai báo các module con ?ã có
    component Key_Init is
        Port ( K_master : in std_logic_vector(127 downto 0); K_int : out std_logic_vector(255 downto 0) );
    end component;

    component XWords is
        Port ( data_in : in std_logic_vector(127 downto 0); data_out : out std_logic_vector(127 downto 0) );
    end component;

    component invMixWords is
        Port ( data_in : in std_logic_vector(127 downto 0); data_out : out std_logic_vector(127 downto 0) );
    end component;

    -- Tín hi?u ?i?u khi?n FSM
    type state_type is (IDLE, PRE_WHITENING, ROUND_OP, POST_WHITENING, FINISH);
    signal current_state : state_type;
    signal round_count   : integer range 0 to 7 := 0;

    -- Tín hi?u d? li?u
    signal reg_X       : std_logic_vector(127 downto 0);
    signal K_int_full  : std_logic_vector(255 downto 0);
    signal K_post      : std_logic_vector(127 downto 0);
    signal Ki_0, Ki_1  : std_logic_vector(127 downto 0);
    
    -- Tín hi?u k?t n?i module
    signal xwords_out  : std_logic_vector(127 downto 0);
    signal invmix_out  : std_logic_vector(127 downto 0);
begin
    -- 1. Kh?i t?o khóa trong K_int t? Key_master (128-bit mode)
    -- Gi? s? K_master ??a vào 256-bit v?i 128-bit cao là key th?t
    
    Key_Block: Key_Init 
        port map (
            K_master => key_master, 
            K_int    => K_int_full
        );

    -- Khóa làm tr?ng K_post và các thành ph?n khóa vòng
    K_post <= key_master;
    Ki_0   <= K_int_full(255 downto 128);
    Ki_1   <= K_int_full(127 downto 0);

    -- 2. Khai báo các kh?i bi?n ??i
    XW_Block: XWords port map (data_in => reg_X, data_out => xwords_out);
    IM_Block: invMixWords port map (data_in => reg_X, data_out => invmix_out);

    -- 3. B? ?i?u khi?n FSM th?c hi?n gi?i mã
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            done <= '0';
            round_count <= 0;
        elsif rising_edge(clk) then
            case current_state is
                
                when IDLE =>
                    done <= '0';
                    if start = '1' then
                        reg_X <= ciphertext;
                        current_state <= PRE_WHITENING;
                    end if;

                when PRE_WHITENING =>
                    -- B??c (2): X = X xor K_post
                    reg_X <= reg_X xor K_post;
                    round_count <= 0;
                    current_state <= ROUND_OP;

                when ROUND_OP =>
                    -- Th?c hi?n chu?i bi?n ??i vòng l?p (3.1 -> 3.6)
                    -- L?u ý: ?? t?i ?u, ta có th? chia nh? ROUND_OP thành các sub-state
                    -- ? ?ây tôi g?p l?i ?? b?n th?y lu?ng logic chính:
                    
                    -- B??c 3.1: XWords
                    -- B??c 3.4: invMixWords (Trong module invMixWords c?a b?n ?ã có invSubCells)
                    -- B??c 3.6: XOR Ki_0
                    
                    reg_X <= invmix_out xor Ki_0; -- ?ây là ví d? k?t h?p các b??c
                    
                    if round_count = 6 then -- R = 7 vòng (0 ??n 6)
                        current_state <= POST_WHITENING;
                    else
                        round_count <= round_count + 1;
                    end if;

                when POST_WHITENING =>
                    -- B??c cu?i cùng: P = X xor K_post
                    plaintext <= reg_X xor K_post;
                    current_state <= FINISH;

                when FINISH =>
                    done <= '1';
                    if start = '0' then
                        current_state <= IDLE;
                    end if;

                when others =>
                    current_state <= IDLE;
            end case;
        end if;
    end process;

end Behavioral;