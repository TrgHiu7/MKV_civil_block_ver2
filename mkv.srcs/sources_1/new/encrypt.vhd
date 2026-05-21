--------------------------------------------------------------------------------------
------ Company: 
------ Engineer: 
------ 
------ Create Date: 05/19/2026 11:32:25 PM
------ Design Name: 
------ Module Name: encrypt - Behavioral
------ Project Name: 
------ Target Devices: 
------ Tool Versions: 
------ Description: 
------ 
------ Dependencies: 
------ 
------ Revision:
------ Revision 0.01 - File Created
------ Additional Comments:
------ 
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity encrypt is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;

        key_master  : in  std_logic_vector(255 downto 0);
        plaintext   : in  std_logic_vector(127 downto 0);

        done        : out std_logic;
        ciphertext  : out std_logic_vector(127 downto 0)
    );
end encrypt;

architecture Behavioral of encrypt is
    component Key_Expansion
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            key_master  : in  std_logic_vector(255 downto 0);

            done        : out std_logic;
            keyk0_out   : out std_logic_vector(127 downto 0);
            keyk1_out   : out std_logic_vector(127 downto 0);
            key_post    : out std_logic_vector(127 downto 0)
        );
    end component;
    component N_ROUND
        Port (
            data_in     : in  std_logic_vector(127 downto 0);
            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            data_out    : out std_logic_vector(127 downto 0)
        );
    end component;
    type state_type is (IDLE, INIT, ROUND, CHECK, FINISH);
    signal state_reg, state_next : state_type;

    signal round_reg, round_next : integer range 0 to 10 := 0;

    signal key_valid : std_logic;

    signal o_keyk0   : std_logic_vector(127 downto 0);
    signal o_keyk1   : std_logic_vector(127 downto 0);
    signal o_keypost : std_logic_vector(127 downto 0);

    signal i_data_next, i_data_reg : std_logic_vector(127 downto 0);
    signal o_data : std_logic_vector(127 downto 0);

    signal cipher_reg, cipher_next : std_logic_vector(127 downto 0);

    signal done_reg, done_next : std_logic;
begin
    KEYGEN : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start,
        key_master  => key_master,

        done        => key_valid,
        keyk0_out   => o_keyk0,
        keyk1_out   => o_keyk1,
        key_post    => o_keypost
    );
    ROUND_CORE : N_ROUND
    port map(
        data_in    => i_data_reg,
        keyk0      => o_keyk0,
        keyk1      => o_keyk1,
        data_out   => o_data
    );

    process(clk, rst)
    begin
        if rst = '1' then
            state_reg       <= IDLE;
            round_reg       <= 0;
            i_data_reg      <= (others => '0');
            cipher_reg      <= (others => '0');
            done_reg        <= '0';
        elsif rising_edge(clk) then
            state_reg       <= state_next;
            round_reg       <= round_next;
            i_data_reg      <= i_data_next;
            cipher_reg      <= cipher_next;
            done_reg        <= done_next;
        end if;
    end process;
    
    process(state_reg, round_reg, start, key_valid,
            plaintext, i_data_reg, o_data, o_keypost, cipher_reg)
    begin
        state_next      <= state_reg;
        round_next      <= round_reg;
        i_data_next     <= i_data_reg;
        cipher_next     <= cipher_reg;
        done_next       <= '0';
        case state_reg is            
            when IDLE =>
                if start = '1' then
                    state_next <= INIT;
                end if;
            when INIT =>
                if key_valid = '1' then
                    i_data_next  <= plaintext;
                    state_next  <= ROUND;
                end if;
            when ROUND =>
                if key_valid = '1' then
                    if round_reg = 8 then
                        round_next <= round_reg + 1;                        
                    else
                        i_data_next <= o_data;
                        round_next <= round_reg + 1;                        
                    end if;
                    state_next <= CHECK;
                end if;
            when CHECK =>
                if round_reg = 9 then
                    cipher_next <= o_data xor o_keypost;
                    done_next   <= '1';
                    state_next <= FINISH;
                else
                    state_next <= ROUND;
                end if;       
            when FINISH =>
                if start = '0' then
                    state_next  <= IDLE;
                    done_next   <= '0';
                    round_next  <= 0;
                end if;
        end case;
    end process;
    ciphertext <= cipher_reg;
    done <= done_reg;
end Behavioral;