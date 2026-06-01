------------------------------------------------------------------------------------------
---------- Company: 
---------- Engineer: 
---------- 
---------- Create Date: 05/15/2026 08:27:22 AM
---------- Design Name: 
---------- Module Name: Key_Expansion - Behavioral
---------- Project Name: 
---------- Target Devices: 
---------- Tool Versions: 
---------- Description: 
---------- 
---------- Dependencies: 
---------- 
---------- Revision:
---------- Revision 0.01 - File Created
---------- Additional Comments:
---------- 
------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Key_Expansion is
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;
        key_master  : in  std_logic_vector(255 downto 0);
        
        keyk0_out   : out std_logic_vector(127 downto 0);
        keyk1_out   : out std_logic_vector(127 downto 0);
        key_post     : out std_logic_vector(127 downto 0);
		done           : out std_logic
    );
end Key_Expansion;

architecture Behavioral of Key_Expansion is
    component Gen_Key
        Port(
            clk        : in  std_logic;
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

    type state_type is (IDLE, INIT_K0, WAIT_K0, SAVE_K0, INIT_K1, WAIT_K1, SAVE_K1, KEY_OUT, UPDATE_K, NEXT_ROUND, FINISH);
    signal state	: state_type := IDLE;
	
    signal round	: unsigned(3 downto 0) := (others => '0');
	
    signal k0_reg : std_logic_vector(127 downto 0) := (others => '0');
    signal k1_reg : std_logic_vector(127 downto 0) := (others => '0');
	
    signal keyk0_reg	: std_logic_vector(127 downto 0) := (others => '0');
    signal keyk1_reg	: std_logic_vector(127 downto 0) := (others => '0');
	
    signal i_data_reg	: std_logic_vector(127 downto 0) := (others => '0'); 
    signal o_data_reg0, o_data_reg1, o_data	:    std_logic_vector(127 downto 0) := (others => '0');
begin
    GKEY : Gen_Key port map(clk => clk, data_in  => i_data_reg, data_out => o_data);
    process(clk, rst)
    begin
        if rst = '1' then
            state			<= IDLE;
            round		<= (others => '0');
			done			<= '0';
			
			keyk0_out	<= (others => '0');
			keyk1_out	<= (others => '0');
			key_post	<= (others => '0');
			
            k0_reg <= (others => '0');
            k1_reg <= (others => '0');			
            keyk0_reg <= (others => '0');
            keyk1_reg <= (others => '0');
			i_data_reg<= (others => '0');
            o_data_reg0 <= (others => '0');
            o_data_reg1 <= (others => '0');            
        elsif rising_edge(clk) then
			done			<= '0';
			keyk0_out <= keyk0_reg;
            keyk1_out <= keyk1_reg;
			case state is
				when IDLE =>
					if start = '1' then
						round 	<= "0001";
						k0_reg 	<= key_master(255 downto 128);
						k1_reg 	<= key_master(127 downto 0);
						state <= INIT_K0;
					end if;
				when INIT_K0 =>
					if round = "0001" then
						i_data_reg <= key_master(255 downto 128) xor std_logic_vector(to_unsigned(1, 128));
					else
						i_data_reg <= k0_reg xor const_func(1, to_integer(round)-1);
					end if;					
					state <= WAIT_K0;
				when WAIT_K0 =>                    
                    state <= SAVE_K0;
				when SAVE_K0 =>					
                    o_data_reg0 	<= o_data;
					state <= INIT_K1;
				when INIT_K1 =>
					if round = "0001" then
						i_data_reg <= key_master(127 downto 0) xor std_logic_vector(to_unsigned(2, 128));
					else
						i_data_reg <= k1_reg xor const_func(0, to_integer(round)-1);
					end if;										
					state <= WAIT_K1;
				when WAIT_K1 =>	
					state <= SAVE_K1;	
				when SAVE_K1 =>					
					o_data_reg1 	<= o_data;
					state <= KEY_OUT;
				when KEY_OUT =>
					if round = "0001" then
						keyk0_reg <= key_master(255 downto 128);
					else
						keyk0_reg <= k1_reg;
					end if;
					if round = "1001" then					   
						key_post  <= o_data_reg1 xor o_data_reg0;
				    end if;
					done	<= '1';
					keyk1_reg <= o_data_reg1;					
					state <= UPDATE_K;                
				when UPDATE_K => 
				                 
                        state <= NEXT_ROUND;
				when NEXT_ROUND =>
				    k0_reg <= o_data_reg1;
                    k1_reg <= o_data_reg1 xor o_data_reg0;                    
					if round = "1001" then					   
						state <= FINISH;					
					else
						round <= round + 1;
						state <= INIT_K0;
					end if;
				when FINISH =>                    
					if start = '0' then
						state <= IDLE;
					end if;
			end case;
        end if;
    end process;
end Behavioral;