------------------------------------------------------------------------------------
---- Company: 
---- Engineer: 
---- 
---- Create Date: 05/15/2026 08:27:22 AM
---- Design Name: 
---- Module Name: Key_Expansion - Behavioral
---- Project Name: 
---- Target Devices: 
---- Tool Versions: 
---- Description: 
---- 
---- Dependencies: 
---- 
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
---- 
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Key_Expansion is
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
        else
            p := (others => '0');
        end if;
        p_last := (119 downto 0 => '0') & p;
        return p_last;
    end function;
    
    type state_type is (IDLE, MAIN_PROCESS, UPDATE_KEY, NEXT_ROUND, FINISH);
    signal state_reg, state_next : state_type;

    signal round_reg, round_next : integer range 0 to 9 := 0;

    signal k0_reg, k0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal k1_reg, k1_next : std_logic_vector(127 downto 0) := (others => '0');

    signal keyk0_reg, keyk0_next, xor_key_reg : std_logic_vector(127 downto 0) := (others => '0');
    signal keyk1_reg, keyk1_next, xor_key_next : std_logic_vector(127 downto 0) := (others => '0');
    signal done_reg   : std_logic := '0';

    signal i_data0, o_data0, i_data1, o_data1 : std_logic_vector(127 downto 0);

begin
    GKEY0: Gen_Key port map (data_in => i_data0, data_out => o_data0);
    GKEY1: Gen_Key port map (data_in => i_data1, data_out => o_data1);

    i_data0 <= (k0_reg xor const_func(1, 0))           when ((state_reg = MAIN_PROCESS or state_reg = UPDATE_KEY) and round_reg = 1) else
               (k0_reg xor const_func(1, round_reg - 1)) when (state_reg = MAIN_PROCESS or state_reg = UPDATE_KEY) else
               (others => '0');               
    i_data1 <= (k1_reg xor const_func(0, 0))           when ((state_reg = MAIN_PROCESS or state_reg = UPDATE_KEY) and round_reg = 1) else
               (k1_reg xor const_func(0, round_reg - 1)) when (state_reg = MAIN_PROCESS or state_reg = UPDATE_KEY) else
               (others => '0');

    done        <= done_reg;
    keyk0_out   <= keyk0_reg;
    keyk1_out   <= keyk1_reg;
    key_post    <= xor_key_reg;
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg     <= IDLE;
            round_reg     <= 0;
            k0_reg        <= (others => '0');
            k1_reg        <= (others => '0');
            keyk0_reg     <= (others => '0');
            keyk1_reg     <= (others => '0');
            xor_key_reg   <= (others => '0');
        elsif rising_edge(clk) then
            state_reg     <= state_next;
            round_reg     <= round_next;
            k0_reg        <= k0_next;
            k1_reg        <= k1_next;
            keyk0_reg     <= keyk0_next;
            keyk1_reg     <= keyk1_next;
            xor_key_reg   <= xor_key_next;
        end if;
    end process;

    process(state_reg, start, key_master, round_reg, k0_reg, k1_reg,
            o_data0, o_data1, keyk0_reg, keyk1_reg, xor_key_reg)
    begin
        state_next     <= state_reg;
        round_next     <= round_reg;
        k0_next        <= k0_reg;
        k1_next        <= k1_reg;
        keyk0_next     <= keyk0_reg;
        keyk1_next     <= keyk1_reg;
        xor_key_next   <= xor_key_reg;
        done_reg       <=  '0';
        case state_reg is
            when IDLE =>
                if start = '1' then
                    round_next <= 1;
                    k0_next <= key_master(255 downto 128);
                    k1_next <= key_master(127 downto 0);
                    state_next <= MAIN_PROCESS;
                end if;                
            when MAIN_PROCESS =>
                xor_key_next    <= o_data1 xor o_data0;
                if round_reg = 1 then
                    keyk0_next <= key_master(255 downto 128);                   
                else
                    keyk0_next <= xor_key_reg;
                end if;
                keyk1_next  <= o_data1;
                done_reg    <= '1';
                state_next  <= UPDATE_KEY;                
            when UPDATE_KEY =>
                k1_next     <= xor_key_reg;
                k0_next     <= o_data1;
                state_next  <= NEXT_ROUND;
            when NEXT_ROUND =>
                if round_reg = 9 then
                    state_next <= FINISH;
                else
                    round_next <= round_reg + 1;
                    state_next <= MAIN_PROCESS;
                end if;
            when FINISH =>
                done_reg  <= '1';
                key_post  <= xor_key_reg;
                if start = '0' then
                    state_next <= IDLE;
                end if;
        end case;
    end process;
end Behavioral;