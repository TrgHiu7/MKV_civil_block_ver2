library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MixWords_tb is
-- Testbench không có ngõ Port đầu ra/vào bên ngoài
end MixWords_tb;

architecture Behavior of MixWords_tb is

    -- Khai báo Đơn vị kiểm thử (UUT)
    component MixWords
        Port( data_in  : in  std_logic_vector(127 downto 0);
              data_out : out std_logic_vector(127 downto 0)
            );
    end component;

    -- Các chân tín hiệu giả lập kết nối
    signal data_in  : std_logic_vector(127 downto 0) := (others => '0');
    signal data_out : std_logic_vector(127 downto 0);

begin

    -- Gọi thực thể cần kiểm tra vào testbench
    uut: MixWords 
        port map (
            data_in  => data_in,
            data_out => data_out
        );

    stim_proc: process
    begin		

        wait for 20 ns;

        data_in <= X"1191e1d1b17161f121c151a141318100";
        -- mong muon ra A1616A670A5C467311F11141A2D57723
        wait for 80 ns;
        data_in <= X"9CD278FB3088184323EA80D647F0AE71";
        -- mong muon ra 4D0EFA4AD6AA9DE20D000AD2B10EEF2C
        wait for 40 ns;

        wait;
    end process;

end Behavior;