library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MKV_Decrypt_System_TB is
-- Testbench không có c?ng
end MKV_Decrypt_System_TB;

architecture Behavioral of MKV_Decrypt_System_TB is

    -- 1. Khai báo Component c?a h? th?ng gi?i mã
    component MKV_Decrypt_System
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            start      : in  std_logic;
            ciphertext : in  std_logic_vector(127 downto 0);
            key_master : in  std_logic_vector(127 downto 0);
            plaintext  : out std_logic_vector(127 downto 0);
            done       : out std_logic
        );
    end component;

    -- 2. Tín hi?u k?t n?i
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal start      : std_logic := '0';
    signal ciphertext : std_logic_vector(127 downto 0) := (others => '0');
    signal key_master : std_logic_vector(127 downto 0) := (others => '0');
    signal plaintext  : std_logic_vector(127 downto 0);
    signal done       : std_logic;

    -- Tín hi?u giá tr? k? v?ng (Expected)
    signal expected_plaintext : std_logic_vector(127 downto 0) := (others => '0');

    -- ??nh ngh?a chu k? xung nh?p (100MHz t??ng ?ng board Arty-A100T)
    constant clk_period : time := 10 ns;

begin

    -- 3. G?i th?c th? UUT (Unit Under Test)
    uut: MKV_Decrypt_System
        port map (
            clk        => clk,
            reset      => reset,
            start      => start,
            ciphertext => ciphertext,
            key_master => key_master,
            plaintext  => plaintext,
            done       => done
        );

    -- 4. Quy trình t?o xung nh?p
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Quy trình kích th? (Stimulus Process)
    stim_proc: process
    begin		
        -- Kh?i t?o h? th?ng
        reset <= '1';
        start <= '0';
        wait for 25 ns;
        reset <= '0';
        wait for clk_period;

        -----------------------------------------------------------
        -- TEST CASE 1: Gi?i mã b?n mã chu?n
        -----------------------------------------------------------
        -- Gi? s? ta có c?p Khóa và B?n rõ ban ??u
        key_master <= x"000102030405060708090A0B0C0D0E0F";
        -- Gi? s? ?ây là b?n mã thu ???c t? quá trình mã hóa 7 vòng
        ciphertext <= x"D1E1F1A1B1C1D1E1F101112131415161"; 
        -- Giá tr? b?n rõ k? v?ng sau khi gi?i mã xong
        expected_plaintext <= x"0123456789ABCDEF0123456789ABCDEF"; 

        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Ch? cho ??n khi tín hi?u 'done' b?t lên (sau khi ch?y h?t 7 vòng)
        wait until done = '1';
        wait for 5 ns; -- Ch? d? li?u ?n ??nh

        -- Ki?m tra k?t qu? t? ??ng (Assertion)
        assert (plaintext = expected_plaintext)
            report "KHONG KHOP: Ket qua giai ma sai so voi ban ro goc!"
            severity error;
        
        if (plaintext = expected_plaintext) then
            report "THANH CONG: Giai ma dung 7 vong MKV, ket qua trung khop!";
        end if;

        -----------------------------------------------------------
        -- D?ng mô ph?ng
        -----------------------------------------------------------
        wait for 100 ns;
        report "Ket thuc mo phong he thong Decrypt.";
        wait;
    end process;

end Behavioral;