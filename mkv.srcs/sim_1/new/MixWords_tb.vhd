library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixWords_tb is
end MixWords_tb;

architecture Behavioral of MixWords_tb is

    -- 1. Khai báo Component
    component MixWords
        Port (
            data_in  : in  std_logic_vector(127 downto 0);
            data_out : out std_logic_vector(127 downto 0)
        );
    end component;

    -- 2. Tín hiệu kết nối
    signal tb_data_in       : std_logic_vector(127 downto 0) := (others => '0');
    signal tb_data_out      : std_logic_vector(127 downto 0);
    signal expected_out     : std_logic_vector(127 downto 0) := (others => '0'); -- Tín hiệu giá trị kỳ vọng

    constant wait_time : time := 20 ns;

begin

    -- 3. Gọi thực thể MixWords
    uut: MixWords
        port map (
            data_in  => tb_data_in,
            data_out => tb_data_out
        );

    -- 4. Quy trình kiểm thử có đối chiếu Expected
    stim_proc: process
    begin
        report "--- BAT DAU KIEM THU MIXWORDS ---";

        -----------------------------------------------------------
        -- Test Case 1: Input All Zeros (0x00...00)
        -----------------------------------------------------------
        -- Giải thích tính toán:
        -- 1. Qua SubCells: s(0x00) = 0x01.
        -- 2. Ma trận hàng 0: (01*02) xor (01*03) xor (01*01) xor (01*01) = 02 ^ 03 ^ 01 ^ 01 = 01.
        -- Kết quả kỳ vọng mỗi Word là 0x01010101.
        tb_data_in   <= (others => '0');
        expected_out <= x"01010101010101010101010101010101";
        wait for wait_time;
        assert (tb_data_out = expected_out)
            report "Loi o Test Case 1: Ket qua khong khop voi expected!" severity error;

        -----------------------------------------------------------
        -- Test Case 2: Thay đổi 1 byte (0x24 ở cột 0)
        -----------------------------------------------------------
        -- Giải thích tính toán:
        -- 1. Qua SubCells: s(0x24) = 0x1C, các byte khác 0x00 -> 0x01.
        -- 2. Cột 0: s0=1C, s1=01, s2=01, s3=01.
        -- 3. Hàng 0: (1C*02) ^ (01*03) ^ (01*01) ^ (01*01) = 38 ^ 03 ^ 01 ^ 01 = 3B.
        -- 4. Hàng 1: (1C*01) ^ (01*02) ^ (01*03) ^ (01*01) = 1C ^ 02 ^ 03 ^ 01 = 1C.
        -- 5. Hàng 2: (1C*01) ^ (01*01) ^ (01*02) ^ (01*03) = 1C ^ 01 ^ 02 ^ 03 = 1C.
        -- 6. Hàng 3: (1C*03) ^ (01*01) ^ (01*01) ^ (01*02) = (38^1C) ^ 01 ^ 01 ^ 02 = 24 ^ 02 = 26.
        -- Vậy Word 0 expected: 0x3B1C1C26. Các Word khác vẫn là 0x01010101.
        tb_data_in   <= x"00000000000000000000000024000000";
        expected_out <= x"0101010101010101010101013B1C1C26";
        wait for wait_time;
        assert (tb_data_out = expected_out)
            report "Loi o Test Case 2: Ket qua khong khop voi expected!" severity error;

        -----------------------------------------------------------
        -- Test Case 3: Toàn bộ 4 cột giống nhau (Tính độc lập)
        -----------------------------------------------------------
        tb_data_in   <= x"24000000240000002400000024000000";
        expected_out <= x"3B1C1C263B1C1C263B1C1C263B1C1C26";
        wait for wait_time;
        assert (tb_data_out = expected_out)
            report "Loi o Test Case 3: Ket qua khong khop voi expected!" severity error;

        report "--- KET THUC MO PHONG: TAT CA CAC TEST PASS ---";
        wait;
    end process;

end Behavioral;