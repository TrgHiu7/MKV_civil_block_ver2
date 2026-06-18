--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

--entity tb_MKV_CRYPTO_TOP is
--end tb_MKV_CRYPTO_TOP;

--architecture Behavioral of tb_MKV_CRYPTO_TOP is

--    -- Khai báo Component DUT
--    component MKV_CRYPTO_TOP
--        Port (
--            clk         : in  std_logic;
--            rst         : in  std_logic;
--            start       : in  std_logic;
--            key_master  : in  std_logic_vector(255 downto 0);
--            sel_crypt   : in  std_logic;
--            data_in     : in  std_logic_vector(127 downto 0);
--            done        : out std_logic;
--            data_out    : out std_logic_vector(127 downto 0)
--        );
--    end component;

--    -- Tín hiệu nội bộ
--    signal clk        : std_logic := '0';
--    signal rst        : std_logic := '1';
--    signal start      : std_logic := '0';
--    signal sel_crypt  : std_logic := '0';

--    signal key_master : std_logic_vector(255 downto 0) := (others => '0');
--    signal data_in    : std_logic_vector(127 downto 0) := (others => '0');

--    signal done       : std_logic;
--    signal data_out   : std_logic_vector(127 downto 0);

--    constant CLK_PERIOD : time := 10 ns;
    
--    -- Dữ liệu mẫu chuẩn để đối chiếu tự động
--    constant PT_REF : std_logic_vector(127 downto 0) := x"112233445566778899AABBCCDDEEFF00";
--    constant CT_REF : std_logic_vector(127 downto 0) := x"8a6f9bbc745bfee7005f04054dd1ff8e";

--begin

--    --------------------------------------------------------------------
--    -- DUT Instantiation
--    --------------------------------------------------------------------
--    DUT : MKV_CRYPTO_TOP
--    port map (
--        clk        => clk,
--        rst        => rst,
--        start      => start,
--        key_master => key_master,
--        sel_crypt  => sel_crypt,
--        data_in    => data_in,
--        done       => done,
--        data_out   => data_out
--    );

--    --------------------------------------------------------------------
--    -- Clock Generation
--    --------------------------------------------------------------------
--    clk_process : process
--    begin
--        loop
--            clk <= '0';
--            wait for CLK_PERIOD/2;
--            clk <= '1';
--            wait for CLK_PERIOD/2;
--        end loop;
--    end process;

--    --------------------------------------------------------------------
--    -- Stimulus Process (Kịch bản kích thích)
--    --------------------------------------------------------------------
--    stim_proc : process
--    begin
--        -- 1. Trạng thái Reset ban đầu
--        rst <= '1';
--        start <= '0';
--        sel_crypt <= '1'; -- Setup chế độ: 1 = Decrypt
--        key_master <= x"0102030405060708090A0B0C0D0E0F11" & 
--                      x"12131415161718191A1B1C1D1E1F2223";
--        data_in <= CT_REF; -- Đưa Ciphertext vào trước

--        wait for 30 ns;
--        rst <= '0';       -- Nhả Reset
--        wait for 20 ns;

--        --------------------------------------------------------------------
--        -- LẦN 1: DECRYPTION (GIẢI MÃ)
--        --------------------------------------------------------------------
--        report "--- BAT DAU GIAI MA (DECRYPTION) ---";
--        start <= '1';        -- Kích cờ báo bắt đầu
--        wait for CLK_PERIOD;
--        start <= '0';        -- Tạo xung (pulse) 1 nhịp clock

--        -- Chờ mạch chạy và báo done
--        wait until done = '1';
        
--        -- Đối chiếu kết quả giải mã
--        if data_out = PT_REF then
--            report "[SUCCESS] Giai ma thanh cong! Plaintext khop hoan toan." severity note;
--        else
--            report "[FAILED] Giai ma that bai! Vui long kiem tra lai Waveform." severity error;
--        end if;
        
--        -- Nghỉ 100ns trước khi chạy tiếp mã hóa
--        wait for 100 ns;

--        --------------------------------------------------------------------
--        -- LẦN 2: ENCRYPTION (MÃ HÓA)
--        --------------------------------------------------------------------
--        report "--- BAT DAU MA HOA (ENCRYPTION) ---";
        
--        -- BƯỚC QUAN TRỌNG: Thiết lập tín hiệu ổn định trước khi start
--        sel_crypt <= '0';  -- Đổi sang chế độ Mã hóa
--        data_in   <= PT_REF; -- Đưa Plaintext gốc vào
--        wait for CLK_PERIOD; -- Đợi 1 nhịp clock để dữ liệu cập nhật vào port

--        -- Kích xung start để mạch chạy lại
--        start <= '1';
--        wait for CLK_PERIOD;
--        start <= '0';

--        -- Chờ mạch chạy xong
--        wait until done = '1';
        
--        -- Đối chiếu kết quả mã hóa
--        if data_out = CT_REF then
--            report "[SUCCESS] Ma hoa thanh cong! Ciphertext khop hoan toan." severity note;
--        else
--            report "[FAILED] Ma hoa that bai! Vui long kiem tra lai Waveform." severity error;
--        end if;

--        wait for 100 ns;
--        report "=== MO PHONG HOAN TAT ===";
--        wait; -- Dừng vĩnh viễn mô phỏng
        
--    end process;

--end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MKV_CRYPTO_TOP is
end tb_MKV_CRYPTO_TOP;

architecture Behavioral of tb_MKV_CRYPTO_TOP is

    component MKV_CRYPTO_TOP
        Port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            start       : in  std_logic;
            key_master  : in  std_logic_vector(255 downto 0);
            sel_crypt   : in  std_logic;
            data_in     : in  std_logic_vector(127 downto 0);
            done        : out std_logic;
            data_out    : out std_logic_vector(127 downto 0)
        );
    end component;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal start      : std_logic := '0';
    signal sel_crypt  : std_logic := '0';

    signal key_master : std_logic_vector(255 downto 0) := (others => '0');
    signal data_in    : std_logic_vector(127 downto 0) := (others => '0');

    signal done       : std_logic;
    signal data_out   : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 10 ns;
    
    constant PT_REF : std_logic_vector(127 downto 0) := x"112233445566778899AABBCCDDEEFF00";
    constant CT_REF : std_logic_vector(127 downto 0) := x"8a6f9bbc745bfee7005f04054dd1ff8e";

begin

    DUT : MKV_CRYPTO_TOP
    port map (
        clk        => clk,
        rst        => rst,
        start      => start,
        key_master => key_master,
        sel_crypt  => sel_crypt,
        data_in    => data_in,
        done       => done,
        data_out   => data_out
    );

    clk_process : process
    begin
        loop
            clk <= '0';
            wait for CLK_PERIOD/2;
            clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
    end process;

    stim_proc : process
    begin
        rst <= '1';
        start <= '0';
        sel_crypt <= '1'; 
        key_master <= x"0102030405060708090A0B0C0D0E0F11" & 
                      x"12131415161718191A1B1C1D1E1F2223";
        data_in <= CT_REF; 

        wait for 30 ns;
        rst <= '0';       
        wait for 20 ns;

        report "--- BAT DAU GIAI MA (DECRYPTION) ---";
        start <= '1';        
        wait for CLK_PERIOD;
        start <= '0';        

        wait until done = '1';
        
        if data_out = PT_REF then
            report "[SUCCESS] Giai ma thanh cong! Plaintext khop hoan toan." severity note;
        else
            report "[FAILED] Giai ma that bai! Vui long kiem tra lai Waveform." severity error;
        end if;
        
        wait for 100 ns;

        report "--- BAT DAU MA HOA (ENCRYPTION) ---";
        
        sel_crypt <= '0';  
        data_in   <= PT_REF; 
        wait for CLK_PERIOD; 

        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        wait until done = '1';
        
        if data_out = CT_REF then
            report "[SUCCESS] Ma hoa thanh cong! Ciphertext khop hoan toan." severity note;
        else
            report "[FAILED] Ma hoa that bai! Vui long kiem tra lai Waveform." severity error;
        end if;

        wait for 100 ns;
        report "=== MO PHONG HOAN TAT ===";
        wait; 
        
    end process;

end Behavioral;