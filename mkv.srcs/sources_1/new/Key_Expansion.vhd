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
        
        donek0      : out std_logic;
        donek1      : out std_logic;
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
    
    type state_type is (
        IDLE,

        MAIN_PROCESS,

        UPDATE_KEY,
        NEXT_ROUND,

        FINISH
    );

    signal state : state_type := IDLE;

    signal round_cnt : integer range 0 to 9 := 0;

    signal k0        : std_logic_vector(127 downto 0);
    signal k1        : std_logic_vector(127 downto 0);

    signal key_temp  : std_logic_vector(127 downto 0);

    signal temp_data, i_data0, o_data0, i_data1, o_data1 : std_logic_vector(127 downto 0);

begin
    GKEY0: Gen_Key port map (data_in => i_data0, data_out => o_data0);
    GKEY1: Gen_Key port map (data_in => i_data1, data_out => o_data1);
    process(clk, rst)
    begin
        if rst = '1' then
            state       <= IDLE;
            round_cnt   <= 0;
            k0          <= (others => '0');
            k1          <= (others => '0');
            key_temp    <= (others => '0');
--            key_out     <= (others => '0');
            keyk0_out   <= (others => '0');
            keyk1_out   <= (others => '0');
            donek0      <= '0';
            donek1      <= '0';
            done        <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    done <= '0';
                    keyk0_out   <= key_master(255 downto 128);
                    donek0      <= '1';
                    donek1      <= '0';
                    if start = '1' then
                        round_cnt <= 1;
                        k0 <= key_master(255 downto 128);
                        k1 <= key_master(127 downto 0);
                        --vao buoc subcells thu 1 thi donek0 = 0
                        state <= MAIN_PROCESS;
                    end if;
                when MAIN_PROCESS =>
                    donek0      <= '0';
                    donek1      <= '0';
                    if round_cnt = 1 then
                        i_data0 <= k0 xor const_func(1, round_cnt - 1);
                        i_data1 <= k1 xor const_func(0, round_cnt - 1);
                    else
                        i_data0 <= k0 xor const_func(0, round_cnt - 1);
                        i_data1 <= k1 xor const_func(1, round_cnt - 1);
                    end if;
                        key_temp <= o_data0;
                        k0       <= o_data1;
                        k1       <= k0 xor key_temp;

                    state <= UPDATE_KEY;
                when UPDATE_KEY =>
                    keyk1_out <= k0;
                    donek1 <= '1';
                    keyk0_out <= k1;
                    --vao buoc subcells thu 2 thi donek1 = 0
                    donek1 <= '0';
                    donek0 <= '1';
                    state <= NEXT_ROUND;
                when NEXT_ROUND =>
                    if round_cnt = 9 then
                        state <= FINISH;
                    else
                        round_cnt <= round_cnt + 1;
                        state <= MAIN_PROCESS;
                    end if;
                when FINISH =>
                    done <= '1';
                    if start = '0' then
                        state <= IDLE;
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;
end Behavioral;
