library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Key_Expansion is
-- Testbench không có ngõ vào/ra (Port)
end tb_Key_Expansion;

architecture Behavior of tb_Key_Expansion is

    -- 1. Khai báo component cho Đơn vị cần kiểm tra (UUT)
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

    -- 2. Khai báo các tín hiệu kết nối nội bộ
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal start      : std_logic := '0';
    signal key_master : std_logic_vector(255 downto 0) := (others => '0');
    
    -- Ngõ ra từ UUT
    signal done       : std_logic;
    signal keyk0_out  : std_logic_vector(127 downto 0);
    signal keyk1_out  : std_logic_vector(127 downto 0);

    -- Định nghĩa chu kỳ xung Clock (Ví dụ: 100 MHz -> 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- 3. Gọi thực thể cần test (Instantiate UUT)
    uut: Key_Expansion 
        port map (
            clk        => clk,
            rst        => rst,
            start      => start,
            key_master => key_master,
            done       => done,
            keyk0_out  => keyk0_out,
            keyk1_out  => keyk1_out
        );

    -- 4. Tiến trình tạo xung Clock liên tục
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Tiến trình cấp Kịch bản kích thích dữ liệu (Stimulus Process)
    stim_proc: process
    begin
        ------------------------------------------------------------
        -- BƯỚC 1: Khởi động hệ thống & Reset mạch quay về trạng thái mặc định
        ------------------------------------------------------------
        rst <= '1';
        start <= '0';
        key_master <= (others => '0');
        wait for clk_period * 2;
        
        -- Nhả reset
        rst <= '0';
        wait for clk_period;

        ------------------------------------------------------------
        -- BƯỚC 2: Cấp khóa Master 256-bit mẫu để chuẩn bị mở rộng
        ------------------------------------------------------------
        -- Định dạng Hex mẫu ngẫu nhiên (Mỗi nửa là 128-bit k0 và k1 ban đầu)
        key_master <= X"0102030405060708090A0B0C0D0E0F1112131415161718191A1B1C1D1E1F2223";
        wait for clk_period;

        ------------------------------------------------------------
        -- BƯỚC 3: Kích xung 'start' lên 1 chu kỳ để FSM chạy vào MAIN_PROCESS
        ------------------------------------------------------------
        start <= '1';
        wait for clk_period;
        start <= '0'; -- Hạ chân start ngay sau khi FSM đã nhận diện lệnh chạy

        ------------------------------------------------------------
        -- BƯỚC 4: Chờ cho đến khi mạch tính toán xong 9 vòng (done = '1')
        ------------------------------------------------------------
        wait until done = '1';
        
        -- Giữ nguyên trạng thái kết quả một vài chu kỳ để dễ quan sát dạng sóng (Waveform)
        wait for clk_period * 5;

        ------------------------------------------------------------
        -- BƯỚC 5: Kết thúc mô phỏng mô hình
        ------------------------------------------------------------
        -- Ghi chú: Dòng lệnh dưới giúp dừng hẳn quá trình chạy trên ModelSim/Vivado Simulator
        report "Simulation Finished Successfully!" severity failure;
        
        wait;
    end process;

end Behavior;