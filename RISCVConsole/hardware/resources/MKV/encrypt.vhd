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
    type state_type is (IDLE, INIT, ROUND_CORE, CHECK, FINISH);
    signal state : state_type := IDLE;

    signal round	: unsigned(3 downto 0) := (others => '0');

    signal key_valid : std_logic;

    signal o_keyk0   : std_logic_vector(127 downto 0);
    signal o_keyk1   : std_logic_vector(127 downto 0);
    signal o_keypost : std_logic_vector(127 downto 0);

    signal i_data_reg : std_logic_vector(127 downto 0);
    signal o_data : std_logic_vector(127 downto 0);

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
    ROUND_C : N_ROUND
    port map(
        data_in    => i_data_reg,
        keyk0      => o_keyk0,
        keyk1      => o_keyk1,
        data_out   => o_data
    );

    process(clk, rst)
    begin
        if rst = '1' then
            state       <= IDLE;
            round       <= (others => '0');
            i_data_reg  <= (others => '0');
            ciphertext  <= (others => '0');
            done        <= '0';
        elsif rising_edge(clk) then
            done       <= '0';
            case state is            
                when IDLE =>
                    round <= (others => '0');
                    if start = '1' then
                        state <= INIT;
                    end if;
                when INIT =>
                    if key_valid = '1' then
                        i_data_reg  <= plaintext;
                        round <= (others => '0');
                        state  <= ROUND_CORE;
                    end if;
                when ROUND_CORE =>
                    if key_valid = '1' then
                        if round = "1000" then                       
                        else
                            i_data_reg <= o_data;                       
                        end if;
                        round <= round + 1;
                        state <= CHECK;
                    end if;
                when CHECK =>
                    if round = "1000" then
                        ciphertext <= o_data xor o_keypost;
                        done   <= '1';
                        state <= FINISH;
                    else                        
                        state <= ROUND_CORE;
                    end if;       
                when FINISH =>
                    if start = '0' then
                        state  <= IDLE;
                    end if;
            end case;
        end if;
    end process;    
end Behavioral;