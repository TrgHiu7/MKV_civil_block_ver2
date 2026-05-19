--------------------------------------------------------------------------------------
------ Company: Hoc vien ky thuat mat ma
------ Engineer: Tran Trong Hieu
------ Create Date: 05/12/2026 02:48:18 PM
------ Design Name: MixWords
------ Module Name: MixWords - Behavioral
------ Project Name: mkv
------ Target Devices: arty100
------ Tool Versions: 2022.2
------ Description: 
--     ma tran M4x4 chuan MKV-128:
---    encrypt
--     [01 02 01 03]
--     [03 07 01 04]
--     [04 0B 03 0C]
--     [0C 1E 06 14]        
--     decrypt
--     [14 06 18 0B]
--     [0B 02 0D 05]
--     [05 01 07 02]
--     [02 01 03 01]
------ Dependencies: 
------ Revision:
------ Revision 0.01 - File Created
------ Additional Comments:
--------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MixWords is
    Port(
        data_in  : in  std_logic_vector(127 downto 0);
        data_out : out std_logic_vector(127 downto 0)
    );
end MixWords;

architecture Behavioral of MixWords is
    function xtime(
        a : std_logic_vector(7 downto 0)
    ) return std_logic_vector is
        variable temp : std_logic_vector(7 downto 0);
    begin    
        if a(7) = '1' then
            temp := (a(6 downto 0) & '0') xor x"2B";
        else
            temp := (a(6 downto 0) & '0');
        end if;    
        return temp;
    end function;
begin
    gen_cols: for i in 0 to 3 generate
        concurrency_block: block
            signal x0, x1, x2, x3 : std_logic_vector(7 downto 0);
            signal y0, y1, y2, y3 : std_logic_vector(7 downto 0);
        begin
            x0 <= data_in(127 - 32*i downto 120 - 32*i);
            x1 <= data_in(119 - 32*i downto 112 - 32*i);
            x2 <= data_in(111 - 32*i downto 104 - 32*i);
            x3 <= data_in(103 - 32*i downto 96 - 32*i);

            y0 <= x0 xor x2 xor x3 xor (xtime(x1 xor x3));
            y1 <= x1 xor x3 xor y0 xor (xtime(x2 xor y0));
            y2 <= x2 xor y0 xor y1 xor (xtime(x3 xor y1));
            y3 <= x3 xor y1 xor y2 xor (xtime(y0 xor y2));
            
            data_out(127 - 32*i downto 120 - 32*i) <= y0;
            data_out(119 - 32*i downto 112 - 32*i) <= y1;
            data_out(111 - 32*i downto 104 - 32*i) <= y2;
            data_out(103 - 32*i downto 96 - 32*i)  <= y3;
        end block;
    end generate gen_cols;

end Behavioral;