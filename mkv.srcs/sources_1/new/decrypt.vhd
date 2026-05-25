----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2026 11:32:25 PM
-- Design Name: 
-- Module Name: decrypt - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decrypt is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;

        key_master  : in  std_logic_vector(255 downto 0);
        ciphertext  : in  std_logic_vector(127 downto 0);

        done        : out std_logic;
        plaintext   : out std_logic_vector(127 downto 0)
    );
end decrypt;

architecture Behavioral of decrypt is
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
    component INV_N_ROUND
        Port (
            data_in     : in  std_logic_vector(127 downto 0);
            keyk0       : in  std_logic_vector(127 downto 0);
            keyk1       : in  std_logic_vector(127 downto 0);
            data_out    : out std_logic_vector(127 downto 0)
        );
    end component;
    type key_array_type is array (0 to 9) of std_logic_vector(127 downto 0);
    signal mem_keyk0    : key_array_type := (others => (others => '0'));
    signal mem_keyk1    : key_array_type := (others => (others => '0'));
    signal mem_keypost  : std_logic_vector(127 downto 0) := (others => '0');
    type state_type is (IDLE, WAIT_KEY, INIT, ROUND_CORE, FINISH);
    signal state : state_type := IDLE;

    signal round	: unsigned(3 downto 0) := (others => '0');

    signal key_valid : std_logic;
    signal start_keygen : std_logic := '0';

    signal o_keyk0   : std_logic_vector(127 downto 0);
    signal o_keyk1   : std_logic_vector(127 downto 0);
    signal o_keypost : std_logic_vector(127 downto 0);
    signal i : unsigned(3 downto 0) := (others => '0');
    signal i_data_reg : std_logic_vector(127 downto 0);
    signal o_data : std_logic_vector(127 downto 0);
    signal i_k0_reg, i_k1_reg : std_logic_vector(127 downto 0);
begin
    KEYGEN : Key_Expansion
    port map(
        clk         => clk,
        rst         => rst,
        start       => start_keygen,
        key_master  => key_master,

        done        => key_valid,
        keyk0_out   => o_keyk0,
        keyk1_out   => o_keyk1,
        key_post    => o_keypost
    );
    INV_ROUND_CORE : INV_N_ROUND
    port map(
        data_in    => i_data_reg,
        keyk0      => i_k0_reg,
        keyk1      => i_k1_reg,
        data_out   => o_data
    );

    process(clk, rst)       
    begin
        if rst = '1' then
            state       <= IDLE;
            round       <= (others => '0');
            start_keygen <= '0';
            done		<= '0';
            plaintext   <= (others => '0');
            i_data_reg  <= (others => '0');
            i_k0_reg    <= (others => '0');
            i_k1_reg    <= (others => '0');
        elsif rising_edge(clk) then
            done		<= '0';
            case state is            
            when IDLE =>
                if start = '1' then
                    round <= "0000";
                    start_keygen <= '1';
                    i            <= (others => '0');
                    state <= WAIT_KEY;
                end if;
            when WAIT_KEY =>
                start_keygen <= '0';
                if key_valid = '1' then
                    mem_keyk0(to_integer(i)) <= o_keyk0;
                    mem_keyk1(to_integer(i)) <= o_keyk1;  
                    if i = 8 then 
                        mem_keypost <= o_keypost;  
                        round <= "0001";                        
                        state <= INIT;
                    else
                        i <= i + 1;
                    end if; 
                end if;
              when INIT =>
                i_data_reg  <= ciphertext xor mem_keypost;
                i_k0_reg    <= mem_keyk0(to_integer(i));
                i_k1_reg    <= mem_keyk1(to_integer(i));
                round <= round + 1;
                state <= ROUND_CORE;
              when ROUND_CORE =>
                if i = 0 then
                    plaintext <= o_data;
                    done <= '1';
                    state <= FINISH;
                else
                    i <= i - 1;
                    round <= round + 1;
                    i_data_reg  <= o_data;
                    i_k0_reg    <= mem_keyk0(to_integer(i-1));
                    i_k1_reg    <= mem_keyk1(to_integer(i-1));
                    state       <= ROUND_CORE;
                end if;
            when FINISH =>
                if start = '0' then
                    state  <= IDLE;
                end if;
        end case;
        end if;
    end process;
end Behavioral;
