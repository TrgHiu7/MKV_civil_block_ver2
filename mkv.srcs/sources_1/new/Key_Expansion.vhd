----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2026 08:27:22 AM
-- Design Name: 
-- Module Name: Key_Expansion - Behavioral
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
----------------------------------------------------------------------------------
-- Key Expansion
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Key_Expansion is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;
        
--        plain_text  : in  std_logic_vector(127 downto 0);
        key_master  : in  std_logic_vector(255 downto 0);
        
--        donek0      : out std_logic;
--        donek1      : out std_logic;
        done        : out std_logic;
        keyk0_out   : out std_logic_vector(127 downto 0);
        keyk1_out   : out std_logic_vector(127 downto 0)
    );
end Key_Expansion;

architecture Behavioral of Key_Expansion is

    component Gen_Key
        Port(
            data_in    : in  std_logic_vector(127 downto 0);
            data_out   : out std_logic_vector(127 downto 0)
        );
    end component;
    
    function const_func(k, r : integer) return std_logic_vector is
        variable p_last : std_logic_vector(127 downto 0);
        variable p      : std_logic_vector(7 downto 0);
    begin
        if k = 0 then
            p := std_logic_vector(to_unsigned(2*r + 2, 8));
        elsif k = 1 then
            p := std_logic_vector(to_unsigned(2*r + 1, 8));
        end if;
        p_last := (119 downto 0 => '0') & p;
        return p_last;
    end function;
    
    type state_type is (IDLE, MAIN_PROCESS, UPDATE_KEY, NEXT_ROUND, FINISH);
    signal state, next_state : state_type;

--    signal donek0      : std_logic;
--    signal donek1      : std_logic;

    signal round_cnt_reg, round_cnt_next : integer range 0 to 9 := 0;

    signal k0_reg, k0_next : std_logic_vector(127 downto 0);
    signal k1_reg, k1_next : std_logic_vector(127 downto 0);

    signal i_data0, o_data0, i_data1, o_data1 : std_logic_vector(127 downto 0);

begin
    GKEY0: Gen_Key port map (data_in => i_data0, data_out => o_data0);
    GKEY1: Gen_Key port map (data_in => i_data1, data_out => o_data1);
    process(clk, rst)
    begin
        if rst = '1' then
            state <= IDLE;
            round_cnt_reg <= 0;
            k0_reg        <= (others => '0');
            k1_reg        <= (others => '0');
--            key_out     <= (others => '0');
            keyk0_out   <= (others => '0');
            keyk1_out   <= (others => '0');
--            donek0      <= '0';
--            donek1      <= '0';
            done        <= '0';
        elsif rising_edge(clk) then
            state <= next_state;
            round_cnt_reg <= round_cnt_next;
            k0_reg        <= k0_next;
            k1_reg        <= k1_next;
            
--            if donek1 = '1' then
--                donek1 <= '0';
--                keyk1_out <= k0_next;
--            end if;
            if state = IDLE then
                if start = '0' then
                    keyk0_out <= key_master(255 downto 128);
                    keyk1_out <= (others => '0');
                end if;
            elsif state = UPDATE_KEY  then
--                donek0 <= '0';
                keyk0_out <= k1_next;
                keyk1_out <= k0_next;
            end if;
        end if;
    end process;
    
    process(state, round_cnt_reg, k0_reg, k1_reg, o_data0, o_data1, start, key_master)
    begin
        next_state <= state;
        round_cnt_next <= round_cnt_reg;
        k0_next        <= k0_reg;
        k1_next        <= k1_reg;
        i_data0        <= (others => '0');
        i_data1        <= (others => '0');
        done           <= '0';
        case state is
            when IDLE =>
                round_cnt_next <= 0;
                if start = '1' then
                    round_cnt_next <= 1;
                    k0_next <= key_master(255 downto 128);
                    k1_next <= key_master(127 downto 0);
                    --vao buoc subcells thu 1 thi donek0 = 0
                    next_state <= MAIN_PROCESS;
                end if;
            when MAIN_PROCESS =>
                if round_cnt_reg = 1 then
                    i_data0 <= k0_reg xor const_func(1, round_cnt_reg - 1);
                    i_data1 <= k1_reg xor const_func(0, round_cnt_reg - 1);
                else
                    i_data0 <= k0_reg xor const_func(0, round_cnt_reg - 1);
                    i_data1 <= k1_reg xor const_func(1, round_cnt_reg - 1);
                end if;
                next_state <= UPDATE_KEY;
            when UPDATE_KEY =>
                k0_next    <= o_data1;
                k1_next    <= o_data1 xor o_data0;
--                donek1 <= '1';
--                donek0 <= '1';
                next_state <= NEXT_ROUND;
            when NEXT_ROUND =>
                if round_cnt_reg = 9 then
                    next_state <= FINISH;
                else
                    round_cnt_next <= round_cnt_reg + 1;
                    next_state <= MAIN_PROCESS;
                end if;
            when FINISH =>
                done <= '1';
                if start = '0' then
                    next_state <= IDLE;
                end if;
            when others => next_state <= IDLE;
        end case;
    end process;
end Behavioral;
