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
------------------------------------------------------------------------------------
---- Key Expansion
------------------------------------------------------------------------------------

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity Key_Expansion is
--    Port (
--        clk         : in  std_logic;
--        rst         : in  std_logic;
--        start       : in  std_logic;
--        key_master  : in  std_logic_vector(255 downto 0);
        
--        done        : out std_logic;
--        keyk0_out   : out std_logic_vector(127 downto 0);
--        keyk1_out   : out std_logic_vector(127 downto 0)
--    );
--end Key_Expansion;

--architecture Behavioral of Key_Expansion is
--    component Gen_Key
--        Port(
--            data_in    : in  std_logic_vector(127 downto 0);
--            data_out   : out std_logic_vector(127 downto 0)
--        );
--    end component;
    
--    function const_func(k, r : integer) return std_logic_vector is
--        variable p_last : std_logic_vector(127 downto 0);
--        variable p      : std_logic_vector(7 downto 0);
--    begin
--        if k = 0 then
--            p := std_logic_vector(to_unsigned(2*r + 2, 8));
--        elsif k = 1 then
--            p := std_logic_vector(to_unsigned(2*r + 1, 8));
--        else
--            p := (others => '0');
--        end if;
--        p_last := (119 downto 0 => '0') & p;
--        return p_last;
--    end function;
    
--    type state_type is (IDLE, MAIN_PROCESS, UPDATE_KEY, NEXT_ROUND, FINISH, ERROR);
--    signal state_reg, state_next : state_type;

--    signal round_cnt_reg, round_cnt_next : integer range 0 to 9 := 0;

--    signal k0_reg, k0_next : std_logic_vector(127 downto 0) := (others => '0');
--    signal k1_reg, k1_next : std_logic_vector(127 downto 0) := (others => '0');

--    signal keyk0_reg, keyk0_next : std_logic_vector(127 downto 0) := (others => '0');
--    signal keyk1_reg, keyk1_next : std_logic_vector(127 downto 0) := (others => '0');
--    signal done_reg, done_next   : std_logic := '0';
    
--    signal i_data0, o_data0, i_data1, o_data1 : std_logic_vector(127 downto 0);

--begin   
--    i_data0 <= k0_reg xor const_func(1, 0) when round_cnt_reg = 1 else
--               k0_reg xor const_func(0, round_cnt_reg - 1);
--    i_data1 <= k1_reg xor const_func(0, 0) when round_cnt_reg = 1 else
--               k1_reg xor const_func(1, round_cnt_reg - 1);
               
--    GKEY0: Gen_Key port map (data_in => i_data0, data_out => o_data0);
--    GKEY1: Gen_Key port map (data_in => i_data1, data_out => o_data1);
    
--    done      <= done_reg;
--    keyk0_out <= keyk0_reg;
--    keyk1_out <= keyk1_reg;
    
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            state_reg <= IDLE;
--            round_cnt_reg <= 0;
--            k0_reg        <= (others => '0');
--            k1_reg        <= (others => '0');
--            keyk0_reg     <= (others => '0');
--            keyk1_reg     <= (others => '0');
--            done_reg      <= '0';
--        elsif rising_edge(clk) then
--            state_reg     <= state_next;
--            round_cnt_reg <= round_cnt_next;
--            k0_reg        <= k0_next;
--            k1_reg        <= k1_next;
--            keyk0_reg     <= keyk0_next;
--            keyk1_reg     <= keyk1_next;
--            done_reg      <= done_next;
--        end if;
--    end process;
    
--    process(state_reg)
--    begin
--        state_next     <= state_reg;
--        round_cnt_next <= round_cnt_reg;
--        k0_next        <= k0_reg;
--        k1_next        <= k1_reg;
--        keyk0_next     <= keyk0_reg;
--        keyk1_next     <= keyk1_reg;
--        done_next      <= done_reg;
--        case state_reg is
--            when IDLE =>
--                round_cnt_next <= 0;
--                if start = '0' then
--                    keyk0_next <= key_master(255 downto 128);
--                    keyk1_next <= (others => '0');
--                elsif start = '1' then
--                    round_cnt_next <= 1;
--                    k0_next <= key_master(255 downto 128);
--                    k1_next <= key_master(127 downto 0);
--                    state_next <= MAIN_PROCESS;
--                end if;
                
--            when MAIN_PROCESS =>
--                state_next <= UPDATE_KEY;
                
--            when UPDATE_KEY =>
--                k0_next    <= o_data1;
--                k1_next    <= o_data1 xor o_data0;
--                state_next <= NEXT_ROUND;
                
--            when NEXT_ROUND =>
--                keyk0_next <= k1_reg;
--                keyk1_next <= k0_reg;
--                if round_cnt_reg = 9 then
--                    state_next <= FINISH;
--                else
--                    round_cnt_next <= round_cnt_reg + 1;
--                    state_next <= MAIN_PROCESS;
--                end if;
                
--            when FINISH =>
--                done_next <= '1';
--                if start = '0' then
--                    state_next <= IDLE;
--                end if;
--            when others => state_next <= ERROR;
--        end case;
--    end process;

--end Behavioral;
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
        else
            p := (others => '0'); -- Thêm giá trị mặc định để tránh cảnh báo biên dịch
        end if;
        p_last := (119 downto 0 => '0') & p;
        return p_last;
    end function;
    
    type state_type is (IDLE, MAIN_PROCESS, UPDATE_KEY, NEXT_ROUND, FINISH, ERROR);
    signal state_reg, state_next : state_type;

    signal round_cnt_reg, round_cnt_next : integer range 0 to 9 := 0;

    signal k0_reg, k0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal k1_reg, k1_next : std_logic_vector(127 downto 0) := (others => '0');

    -- Thêm các thanh ghi cho output để giữ trạng thái và tránh Latch
    signal keyk0_reg, keyk0_next : std_logic_vector(127 downto 0) := (others => '0');
    signal keyk1_reg, keyk1_next : std_logic_vector(127 downto 0) := (others => '0');
    signal done_reg, done_next   : std_logic := '0';

    signal i_data0, o_data0, i_data1, o_data1 : std_logic_vector(127 downto 0);

begin
    GKEY0: Gen_Key port map (data_in => i_data0, data_out => o_data0);
    GKEY1: Gen_Key port map (data_in => i_data1, data_out => o_data1);

    -- GÁN LIÊN TỤC (Concurrent Assignment) CHO DATAPATH
    -- Giải quyết triệt để lỗi mất dữ liệu khi chuyển state
    i_data0 <= k0_reg xor const_func(1, 0) when round_cnt_reg = 1 else
               k0_reg xor const_func(0, round_cnt_reg - 1);
               
    i_data1 <= k1_reg xor const_func(0, 0) when round_cnt_reg = 1 else
               k1_reg xor const_func(1, round_cnt_reg - 1);

    -- Gán ngõ ra từ các thanh ghi
    done      <= done_reg;
    keyk0_out <= keyk0_reg;
    keyk1_out <= keyk1_reg;

    -- Process tuần tự (Cập nhật thanh ghi theo xung nhịp)
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg     <= IDLE;
            round_cnt_reg <= 0;
            k0_reg        <= (others => '0');
            k1_reg        <= (others => '0');
            keyk0_reg     <= (others => '0');
            keyk1_reg     <= (others => '0');
            done_reg      <= '0';
        elsif rising_edge(clk) then
            state_reg     <= state_next;
            round_cnt_reg <= round_cnt_next;
            k0_reg        <= k0_next;
            k1_reg        <= k1_next;
            keyk0_reg     <= keyk0_next;
            keyk1_reg     <= keyk1_next;
            done_reg      <= done_next;
        end if;
    end process;
    
    -- Process tổ hợp (Tính toán trạng thái tiếp theo)
    -- Sửa lỗi thiếu Sensitivity List
    process(state_reg, start, key_master, round_cnt_reg, k0_reg, k1_reg, o_data0, o_data1, keyk0_reg, keyk1_reg, done_reg)
    begin
        -- GIÁ TRỊ MẶC ĐỊNH CHO MỌI TÍN HIỆU (Chống Latch)
        state_next     <= state_reg;
        round_cnt_next <= round_cnt_reg;
        k0_next        <= k0_reg;
        k1_next        <= k1_reg;
        keyk0_next     <= keyk0_reg;
        keyk1_next     <= keyk1_reg;
        done_next      <= done_reg;

        case state_reg is
            when IDLE =>
                if start = '0' then
                    round_cnt_next <= 0;
                    done_next      <= '0';
                    keyk0_next <= key_master(255 downto 128);
                    keyk1_next <= (others => '0');
                elsif start = '1' then
                    round_cnt_next <= 1;
                    k0_next <= key_master(255 downto 128);
                    k1_next <= key_master(127 downto 0);
                    state_next <= MAIN_PROCESS;
                end if;
                
            when MAIN_PROCESS =>
                -- Không gán i_data ở đây nữa vì đã được gán liên tục ở ngoài
                state_next <= UPDATE_KEY;
                
            when UPDATE_KEY =>
                k0_next    <= o_data1;
                k1_next    <= o_data1 xor o_data0;
                state_next <= NEXT_ROUND;
                
            when NEXT_ROUND =>
                keyk0_next <= k1_reg;
                keyk1_next <= k0_reg;
                if round_cnt_reg = 9 then
                    state_next <= FINISH;
                else
                    round_cnt_next <= round_cnt_reg + 1;
                    state_next <= MAIN_PROCESS;
                end if;
                
            when FINISH =>
                done_next <= '1';
                if start = '0' then
                    state_next <= IDLE;
                end if;
                
            when others => 
                state_next <= ERROR;
        end case;
    end process;

end Behavioral;