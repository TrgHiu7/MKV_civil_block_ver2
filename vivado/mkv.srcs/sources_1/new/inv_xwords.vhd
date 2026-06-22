library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity inv_xwords is
    Port (
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end inv_xwords;

architecture Behavioral of inv_xwords is
    signal y0, y1, y2, y3 : std_logic_vector(31 downto 0);
    signal x0, x1, x2, x3 : std_logic_vector(31 downto 0);
    signal S : std_logic_vector(31 downto 0);
begin
    y0 <= data_in(127 downto 96);
    y1 <= data_in(95 downto 64);
    y2 <= data_in(63 downto 32);
    y3 <= data_in(31 downto 0);

    -- Tính tổng S = y0 ^ y1 ^ y2 ^ y3
    -- Trong MKV, S = (x1^x2^x3) ^ (x0^x2^x3) ^ (x0^x1^x3) ^ (x0^x1^x2)
    -- Sau khi rút gọn, S = x0 ^ x1 ^ x2 ^ x3
    S <= y0 xor y1 xor y2 xor y3;
    
    -- Nghịch đảo: x_i = S ^ y_i
    x0 <= S xor y0;
    x1 <= S xor y1;
    x2 <= S xor y2;
    x3 <= S xor y3;
    
    data_out <= x0 & x1 & x2 & x3;
end Behavioral;