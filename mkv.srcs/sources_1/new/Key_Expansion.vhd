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
        
        done        : out std_logic;
        key_out     : out std_logic_vector(127 downto 0)
    );
end Key_Expansion;

architecture Behavioral of Key_Expansion is

    ----------------------------------------------------------------------------
    -- COMPONENT
    ----------------------------------------------------------------------------

    component SubCells
        Port(
            data_in    : in  std_logic_vector(7 downto 0);
            data_out   : out std_logic_vector(7 downto 0)
        );
    end component;

    ----------------------------------------------------------------------------
    -- CONST FUNCTION
    ----------------------------------------------------------------------------

    function const_func(k, r : integer) return std_logic_vector is

        variable p_last : std_logic_vector(127 downto 0);
        variable p      : std_logic_vector(7 downto 0);

    begin

        if k = 0 then
            p := std_logic_vector(to_unsigned(2*r + 2, 8));
        else
            p := std_logic_vector(to_unsigned(2*r + 1, 8));
        end if;

        p_last := (119 downto 0 => '0') & p;

        return p_last;

    end function;

    ----------------------------------------------------------------------------
    -- SUBCELLS FUNCTION
    ----------------------------------------------------------------------------

    signal sub_in0  : std_logic_vector(7 downto 0);
    signal sub_out0 : std_logic_vector(7 downto 0);

    function subcells_128(
        din : std_logic_vector(127 downto 0)
    ) return std_logic_vector is

        variable temp : std_logic_vector(127 downto 0);

    begin

        for i in 0 to 15 loop

            case din(i*8+7 downto i*8) is

                when x"00" => temp(i*8+7 downto i*8) := x"01";
                when others => temp(i*8+7 downto i*8) := din(i*8+7 downto i*8);

            end case;

        end loop;

        return temp;

    end function;

    ----------------------------------------------------------------------------
    -- DUMMY MIXWORDS
    ----------------------------------------------------------------------------

    function mixwords_func(
        din : std_logic_vector(127 downto 0)
    ) return std_logic_vector is

    begin

        return din;

    end function;

    ----------------------------------------------------------------------------
    -- DUMMY XWORDS
    ----------------------------------------------------------------------------

    function xwords_func(
        din : std_logic_vector(127 downto 0)
    ) return std_logic_vector is

        variable temp : std_logic_vector(127 downto 0);

    begin

        temp := din(119 downto 0) & din(127 downto 120);

        return temp;

    end function;

    ----------------------------------------------------------------------------
    -- FSM
    ----------------------------------------------------------------------------

    type state_type is (
        IDLE,

        LEFT_PROCESS,
        RIGHT_PROCESS,

        UPDATE_KEY,
        NEXT_ROUND,

        FINISH
    );

    signal state : state_type := IDLE;

    ----------------------------------------------------------------------------
    -- SIGNAL
    ----------------------------------------------------------------------------

    signal round_cnt : integer range 0 to 9 := 0;

    signal k0        : std_logic_vector(127 downto 0);
    signal k1        : std_logic_vector(127 downto 0);

    signal key_temp  : std_logic_vector(127 downto 0);

    signal temp_data : std_logic_vector(127 downto 0);

begin

    ----------------------------------------------------------------------------
    -- FSM
    ----------------------------------------------------------------------------

    process(clk, rst)

        variable v_data : std_logic_vector(127 downto 0);

    begin

        if rst = '1' then

            state       <= IDLE;

            round_cnt   <= 0;

            k0          <= (others => '0');
            k1          <= (others => '0');

            key_temp    <= (others => '0');

            key_out     <= (others => '0');

            done        <= '0';

        elsif rising_edge(clk) then

            case state is

                ----------------------------------------------------------------
                -- IDLE
                ----------------------------------------------------------------

                when IDLE =>

                    done <= '0';

                    if start = '1' then

                        round_cnt <= 1;

                        k0 <= key_master(255 downto 128);
                        k1 <= key_master(127 downto 0);

                        state <= LEFT_PROCESS;

                    end if;

                ----------------------------------------------------------------
                -- LEFT PROCESS
                ----------------------------------------------------------------

                when LEFT_PROCESS =>

                    if round_cnt = 1 then
                        v_data := k0 xor const_func(1, round_cnt - 1);
                    else
                        v_data := k0 xor const_func(0, round_cnt - 1);
                    end if;

                    v_data := subcells_128(v_data);
                    v_data := mixwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := xwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := mixwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := xwords_func(v_data);

                    key_temp <= v_data;

                    state <= RIGHT_PROCESS;

                ----------------------------------------------------------------
                -- RIGHT PROCESS
                ----------------------------------------------------------------

                when RIGHT_PROCESS =>

                    if round_cnt = 1 then
                        v_data := k1 xor const_func(0, round_cnt - 1);
                    else
                        v_data := k1 xor const_func(1, round_cnt - 1);
                    end if;

                    v_data := subcells_128(v_data);
                    v_data := mixwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := xwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := mixwords_func(v_data);

                    v_data := subcells_128(v_data);
                    v_data := xwords_func(v_data);

                    k0 <= v_data;
                    k1 <= v_data xor key_temp;

                    state <= UPDATE_KEY;

                ----------------------------------------------------------------
                -- UPDATE
                ----------------------------------------------------------------

                when UPDATE_KEY =>

                    key_out <= k1;

                    state <= NEXT_ROUND;

                ----------------------------------------------------------------
                -- NEXT ROUND
                ----------------------------------------------------------------

                when NEXT_ROUND =>

                    if round_cnt = 9 then

                        key_out <= k0;

                        done <= '1';

                        state <= FINISH;

                    else

                        round_cnt <= round_cnt + 1;

                        state <= LEFT_PROCESS;

                    end if;

                ----------------------------------------------------------------
                -- FINISH
                ----------------------------------------------------------------

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
