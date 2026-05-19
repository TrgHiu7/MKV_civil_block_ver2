----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/19/2026 11:32:25 PM
-- Design Name: 
-- Module Name: encrypt - Behavioral
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

entity encrypt is
    Port (
        clk         :   in std_logic;
        rst         :   in std_logic;
        start       :   in std_logic;
        key_master  :   in std_logic_vector(255 downto 0);
        plaintext   :   in std_logic_vector(127 downto 0);
        keyk0       :   in std_logic_vector(127 downto 0);
        keyk1       :   in std_logic_vector(127 downto 0);
        key_post    :   in std_logic_vector(127 downto 0);
        done        :   out std_logic;
        ciphertext  :   out std_logic_vector(127 downto 0)
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
            data_in     :   in std_logic_vector(127 downto 0);
            keyk0       :   in std_logic_vector(127 downto 0);
            keyk1       :   in std_logic_vector(127 downto 0);
            data_out    :   out std_logic_vector(127 downto 0)
             );
    end component;

    
    type state_type is (IDLE, MAIN_PROCESS, UPDATE_KEY, NEXT_ROUND, FINISH);
    signal state_reg, state_next : state_type;
    signal round_cnt_reg, round_cnt_next : integer range 0 to 10 := 0;
    
    signal done_round, done_k   : std_logic := '0';    
    signal o_keyk0, o_keyk1, o_keypost: std_logic_vector(127 downto 0);
    signal i_data, i_keyk0, i_keyk1, o_data, temp_odata: std_logic_vector(127 downto 0);
begin
    K_Expansion :Key_Expansion port map(clk => clk, rst => rst,
                                        start => start, key_master => key_master,
                                        done => done_k, keyk0_out => o_keyk0,
                                        keyk1_out => o_keyk1, key_post => o_keypost);
    ROUND       :N_ROUND       port map(data_in => i_data,
                                        keyk0   => i_keyk0,
                                        keyk1   => i_keyk1,
                                        data_out=> o_data);
                                        
    i_keyk0 <= o_keyk0 when (done_k='1');
    i_keyk1 <= o_keyk1 when (done_k='1');
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg     <= IDLE;
            round_cnt_reg <= 0;
        elsif rising_edge(clk) then
            state_reg     <= state_next;
            round_cnt_reg <= round_cnt_next;
        end if;
    end process;
    
    process(state_reg, start, plaintext, round_cnt_reg, o_data, temp_odata, o_keypost)
    begin
        state_next     <= state_reg;
        round_cnt_next <= round_cnt_reg;
        case state_reg is
            when IDLE =>
                done <= '0';
                if start = '0' then
                    round_cnt_next <= 0;
                elsif start = '1' then
                    round_cnt_next <= 1;
                    if  (done_k = '1')  then
                        done_round <= '0';
                        i_data <= plaintext;
                        state_next  <= MAIN_PROCESS;
                    end if;
                end if;         
            when MAIN_PROCESS =>
                temp_odata <= o_data;
                done_round <= '1';
                if (done_k = '0') then
                    state_next  <= UPDATE_KEY;
                end if;
            when UPDATE_KEY =>
                if (done_k = '1') then
                    i_data <= temp_odata;
                    state_next  <= NEXT_ROUND;
                end if;    
            when NEXT_ROUND =>
                if round_cnt_reg = 10 then
                    state_next <= FINISH;
                else
                    round_cnt_next <= round_cnt_reg + 1;
                    state_next <= MAIN_PROCESS;
                end if;
            when FINISH =>
                ciphertext <= o_keypost xor temp_odata;
                done <= '1';
                if start = '0' then
                    state_next <= IDLE;
                end if;
        end case;
    end process;
end Behavioral;
