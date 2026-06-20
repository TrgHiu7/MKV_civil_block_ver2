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
        
        keylen      : in  std_logic_vector(1 downto 0);   -- 00=128, 01=192, 10=256
        key_master  : in  std_logic_vector(255 downto 0);
        
        keyk0_out   : out std_logic_vector(127 downto 0);
        keyk1_out   : out std_logic_vector(127 downto 0);
        key_post    : out std_logic_vector(127 downto 0);
        
        key_index   : out std_logic_vector(3 downto 0);
        valid       : out std_logic;
		done        : out std_logic
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

    -- Hang so vong cua MKV (theo code C: Const_0/Const_1, 16 byte).
    -- k=1 : nhanh trai (block1) dung Const_0, counter = 2r+1
    -- k=0 : nhanh phai (block2) dung Const_1, counter = 2r+2
    -- counter chi XOR vao byte thap nhat (giong CL[15]^=2i+1, CR[15]^=2i+2).
    constant C0_CONST : std_logic_vector(127 downto 0) := x"9302ee911a2ad98cad13e7948ad8b3b2";
    constant C1_CONST : std_logic_vector(127 downto 0) := x"d4da00f33f11fd8822166bb9cd187c55";

    function const_func(k, r : integer) return std_logic_vector is
        variable base : std_logic_vector(127 downto 0);
        variable cnt  : std_logic_vector(7 downto 0);
    begin
        if k = 1 then
            base := C0_CONST;
            cnt  := std_logic_vector(to_unsigned(2*r + 1, 8));
        else
            base := C1_CONST;
            cnt  := std_logic_vector(to_unsigned(2*r + 2, 8));
        end if;
        base(7 downto 0) := base(7 downto 0) xor cnt;
        return base;
    end function;

    type state_type is (IDLE, INIT_K0, WAIT_K0, SAVE_K0, INIT_K1, WAIT_K1, SAVE_K1, UPDATE_K, NEXT_ROUND, FINISH);
    signal state	: state_type := IDLE;
	
    signal round	: unsigned(3 downto 0) := (others => '0');
    signal last_round : unsigned(3 downto 0) := "1001";   -- 7/8/9 tuy keylen
	
    signal k0_reg : std_logic_vector(127 downto 0) := (others => '0');
    signal k1_reg : std_logic_vector(127 downto 0) := (others => '0');
	
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
            k0_reg <= (others => '0');
            k1_reg <= (others => '0');			
			i_data_reg<= (others => '0');
            o_data_reg0 <= (others => '0');
            o_data_reg1 <= (others => '0');   
            keyk0_out <= (others => '0');
            keyk1_out <= (others => '0');
            key_post  <= (others => '0');
            key_index <= (others => '0');
            valid     <= '0';      
        elsif rising_edge(clk) then
			valid        <= '0';
			done		 <= '0';	
			case state is
				when IDLE =>
					if start = '1' then
						round 	<= "0001";
						k0_reg 	<= key_master(255 downto 128);
						-- Khoi tao Block2 (k1) theo do dai khoa (giong setInitialKeyState128 trong code C)
						case keylen is
							when "00" =>   -- 128: k1 = K[0:15] xor 0xFF..FF; 7 vong
								k1_reg     <= key_master(255 downto 128) xor (127 downto 0 => '1');
								last_round <= "0111";
							when "01" =>   -- 192: k1 = K[16:23] || (K[8:15] xor 0xFF..); 8 vong
								k1_reg     <= key_master(127 downto 64) &
								              (key_master(191 downto 128) xor (63 downto 0 => '1'));
								last_round <= "1000";
							when others => -- 256 (10): k1 = K[16:31]; 9 vong
								k1_reg     <= key_master(127 downto 0);
								last_round <= "1001";
						end case;
						state <= INIT_K0;
					end if;
				when INIT_K0 =>
					-- k0_reg da = master_hi tai round 1 (nap o IDLE), nen dung
					-- const_func cho moi round (counter 2r+1, hang so Const_0).
					i_data_reg <= k0_reg xor const_func(1, to_integer(round)-1);
					state <= WAIT_K0;
				when WAIT_K0 =>                    
                    state <= SAVE_K0;
				when SAVE_K0 =>					
                    o_data_reg0 	<= o_data;
					state <= INIT_K1;
				when INIT_K1 =>
					-- k1_reg da = master_lo tai round 1 (nap o IDLE), nen dung
					-- const_func cho moi round (counter 2r+2, hang so Const_1).
					i_data_reg <= k1_reg xor const_func(0, to_integer(round)-1);
					state <= WAIT_K1;
				when WAIT_K1 =>	
					state <= SAVE_K1;	
				when SAVE_K1 =>					
					o_data_reg1 	<= o_data;
					state <= UPDATE_K;             
				when UPDATE_K =>
                    key_index <= std_logic_vector(round - 1);                
                    if round = "0001" then
                        keyk0_out <= key_master(255 downto 128);
                    else
                        keyk0_out <= k1_reg;
                    end if;                
                    keyk1_out <= o_data_reg1;                
                    if round = last_round then
                        key_post <= o_data_reg1 xor o_data_reg0;
                    end if;                
                    valid <= '1';                
                    state <= NEXT_ROUND;
				when NEXT_ROUND =>
				    k0_reg <= o_data_reg1;
                    k1_reg <= o_data_reg1 xor o_data_reg0;                
                    if round = last_round then
                        done <= '1';
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