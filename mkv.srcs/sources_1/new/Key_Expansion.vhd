--------------------------------------------------------------------------------------
------ Company: 
------ Engineer: 
------ 
------ Create Date: 05/15/2026 08:27:22 AM
------ Design Name: 
------ Module Name: Key_Expansion - Behavioral
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

    type state_type is (IDLE, GEN_KEY_K0, WAIT_K0, GEN_KEY_K1, WAIT_K1, UPDATE_KEY, NEXT_ROUND, FINISH);
    signal state_reg, state_next : state_type;

    signal round_reg, round_next : unsigned(3 downto 0) := (others => '0');

    signal k0_reg, k0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal k1_reg, k1_next : std_logic_vector(127 downto 0) := (others => '0');

    signal keyk0_reg, keyk0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal keyk1_reg, keyk1_next : std_logic_vector(127 downto 0) := (others => '0');

    signal xor_key_reg, xor_key_next : std_logic_vector(127 downto 0) := (others => '0');

    signal done_reg : std_logic := '0';

    signal i_data_reg, i_data_next : std_logic_vector(127 downto 0) := (others => '0'); 
    signal o_data  : std_logic_vector(127 downto 0);

    signal o_data_k0_reg, o_data_k0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal o_data_reg, o_data_next :    std_logic_vector(127 downto 0) := (others => '0');
begin
    GKEY : Gen_Key port map(data_in  => i_data_reg, data_out => o_data);

    done      <= done_reg;
    keyk0_out <= keyk0_reg;
    keyk1_out <= keyk1_reg;

    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= IDLE;
            round_reg <= (others => '0');
            k0_reg <= (others => '0');
            k1_reg <= (others => '0');
            keyk0_reg <= (others => '0');
            keyk1_reg <= (others => '0');
            xor_key_reg <= (others => '0');
            o_data_k0_reg <= (others => '0');
            i_data_reg <= (others => '0');
            o_data_reg <= (others => '0');
        elsif rising_edge(clk) then
            state_reg <= state_next;
            round_reg <= round_next;
            k0_reg <= k0_next;
            k1_reg <= k1_next;
            keyk0_reg <= keyk0_next;
            keyk1_reg <= keyk1_next;
            xor_key_reg <= xor_key_next;
            o_data_k0_reg <= o_data_k0_next;
            i_data_reg <= i_data_next;
            o_data_reg <= o_data_next;
        end if;
    end process;

    process(state_reg, start, key_master, round_reg, k0_reg, k1_reg,
            keyk0_reg, keyk1_reg, xor_key_reg, o_data, o_data_k0_reg, o_data_reg)
    begin
        state_next <= state_reg;
        round_next <= round_reg;
        k0_next <= k0_reg;
        k1_next <= k1_reg;
        keyk0_next <= keyk0_reg;
        keyk1_next <= keyk1_reg;
        xor_key_next <= xor_key_reg;
        o_data_k0_next <= o_data_k0_reg;
        done_reg <= '0';
        i_data_next <= i_data_reg;
        o_data_next <= o_data_reg;
        case state_reg is
            when IDLE =>
                if start = '1' then
                    round_next <= "0001";
                    k0_next <= key_master(255 downto 128);
                    k1_next <= key_master(127 downto 0);
                    state_next <= GEN_KEY_K0;
                end if;
            when GEN_KEY_K0 =>
                if round_reg = "0001" then
                    i_data_next <= k0_reg xor const_func(1, 0);
                else
                    i_data_next <= k0_reg xor const_func(1, to_integer(round_reg)-1);
                end if;
                state_next <= WAIT_K0;
            when WAIT_K0 =>
                o_data_next <= o_data;
--                o_data_k0_next <= o_data_reg;
                state_next <= GEN_KEY_K1;
            when GEN_KEY_K1 =>
                o_data_k0_next <= o_data_reg;
                if round_reg = "0001" then
                    i_data_next <= k1_reg xor const_func(0, 0);
                else
                    i_data_next <= k1_reg xor const_func(0, to_integer(round_reg)-1);
                end if;
                state_next <= WAIT_K1;
            when WAIT_K1 =>
                if round_reg = "0001" then
                    keyk0_next <= key_master(255 downto 128);
                else
                    keyk0_next <= xor_key_reg;
                end if;
                o_data_next <= o_data;
                xor_key_next <= o_data_k0_reg xor o_data_reg;
                keyk1_next <= o_data_reg;
                done_reg <= '1';
                state_next <= UPDATE_KEY;
            when UPDATE_KEY =>
                k0_next <= keyk1_reg;
                k1_next <= xor_key_reg;
                state_next <= NEXT_ROUND;
            when NEXT_ROUND =>        
                if round_reg = "1001" then
                    state_next <= FINISH;
                else
                    round_next <= round_reg + 1;
                    state_next <= GEN_KEY_K0;
                end if;
            when FINISH =>
                key_post  <= xor_key_reg;
                done_reg <= '1';
                if start = '0' then
                    state_next <= IDLE;
                end if;
        end case;
    end process;
end Behavioral;