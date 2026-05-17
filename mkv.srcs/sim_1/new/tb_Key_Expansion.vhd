library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Key_Expansion is
-- Testbench không có port
end tb_Key_Expansion;

architecture behavior of tb_Key_Expansion is

    -- Khai báo Component cần test (Unit Under Test - UUT)
    component Key_Expansion
    Port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        start       : in  std_logic;
        key_master  : in  std_logic_vector(255 downto 0);
        
        done        : out std_logic;
        keyk0_out   : out std_logic_vector(127 downto 0);
        keyk1_out   : out std_logic_vector(127 downto 0)
    );
    end component;

    -- Khai báo các tín hiệu ảo để kết nối vào UUT
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal start      : std_logic := '0';
    signal key_master : std_logic_vector(255 downto 0) := (others => '0');

    signal done       : std_logic;
    signal keyk0_out  : std_logic_vector(127 downto 0);
    signal keyk1_out  : std_logic_vector(127 downto 0);

    -- Định nghĩa chu kỳ xung nhịp (10 ns tương đương 100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Khởi tạo Unit Under Test (UUT)
    uut: Key_Expansion PORT MAP (
        clk        => clk,
        rst        => rst,
        start      => start,
        key_master => key_master,
        done       => done,
        keyk0_out  => keyk0_out,
        keyk1_out  => keyk1_out
    );

    -- Tạo xung nhịp (Clock Process)
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Quá trình bơm dữ liệu kiểm tra (Stimulus Process)
    stim_proc: process
    begin
        -- 1. Đặt trạng thái Reset ban đầu
        rst <= '1';
        start <= '0';
        key_master <= (others => '0');
        wait for 20 ns;

        -- 2. Nhả Reset để mạch bắt đầu hoạt động
        rst <= '0';
        wait for 20 ns;

        -- 3. Cấp giá trị key_master và kéo start lên '1'
        -- Dữ liệu 256-bit theo định dạng Hexadecimal mà bạn yêu cầu
        key_master <= x"0102030405060708090A0B0C0D0E0F1112131415161718191A1B1C1D1E1F2223";
        wait for 10 ns;
        start <= '1';
        
        -- Chờ vài chu kỳ xung nhịp để FSM chuyển từ IDLE sang MAIN_PROCESS
        wait for clk_period * 2;
        
        -- 4. Chờ cho đến khi tiến trình xử lý xong (cờ done bật lên '1')
        wait until done = '1';
        
        -- 5. Kéo start xuống '0' theo yêu cầu thiết kế để FSM quay về trạng thái IDLE
        start <= '0';
        
        -- Chờ thêm một thời gian ngắn để quan sát dạng sóng ngõ ra
        wait for 50 ns;
        
        -- 6. Kết thúc mô phỏng (Dừng clock)
        assert false report "End of Simulation." severity failure;
        wait;
    end process;

end behavior;