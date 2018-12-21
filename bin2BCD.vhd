library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity bin2BCD is
    PORT (
--           clk   : in STD_LOGIC;
--           reset : in STD_LOGIC;
           binary_in : in STD_LOGIC_VECTOR(7 downto 0);
           dig1  : out STD_LOGIC_VECTOR(3 downto 0);
           dig2  : out STD_LOGIC_VECTOR(3 downto 0);
           dig3  : out STD_LOGIC_VECTOR(3 downto 0)
         );
end bin2BCD;

architecture Behavioral of bin2BCD is
--    signal count_total : integer range 0 to 255 := 0;
--    signal ones, tens, hundred : integer range 0 to 9 := 0;
    
begin

conv: process(binary_in)
        variable count_total : integer range 0 to 255 := 0;
        variable ones, tens, hundred : integer range 0 to 9 := 0;
    begin
        count_total := 0;
        if (binary_in(7) = '1') then
            count_total := count_total + 128;
        end if;
        
        if (binary_in(6) = '1') then
            count_total := count_total + 64;
        end if;
        
        if (binary_in(5) = '1') then
            count_total := count_total + 32;
        end if;
        
        if (binary_in(4) = '1') then
            count_total := count_total + 16;
        end if;
        
        if (binary_in(3) = '1') then
            count_total := count_total + 8;
        end if;
        
        if (binary_in(2) = '1') then
            count_total := count_total + 4;
        end if;
        
        if (binary_in(1) = '1') then
            count_total := count_total + 2;
        end if;
        
        if (binary_in(0) = '1') then
            count_total := count_total + 1;
        end if;
        
        ones := 0;
        tens := 0;
        hundred := 0;
        
        for i in 1 to 2 loop
            exit when (count_total >= 0 AND count_total < 100);
            hundred := hundred + 1;
            count_total := count_total - 100;
        end loop;
        
        for i in 1 to 9 loop
            exit when (count_total >= 0 AND count_total < 10);
            tens := tens + 1;
            count_total := count_total - 10;
        end loop;
        
        ones := count_total;
        
        case ones is
            when 9 => dig1 <= "1001";
            when 8 => dig1 <= "1000";
            when 7 => dig1 <= "0111";
            when 6 => dig1 <= "0110";
            when 5 => dig1 <= "0101";
            when 4 => dig1 <= "0100";
            when 3 => dig1 <= "0011";
            when 2 => dig1 <= "0010";
            when 1 => dig1 <= "0001";
            when 0 => dig1 <= "0000";
            when others => dig1 <= "0000";
        end case;
        
        case tens is 
            when 9 => dig2 <= "1001";
            when 8 => dig2 <= "1000";
            when 7 => dig2 <= "0111";
            when 6 => dig2 <= "0110";
            when 5 => dig2 <= "0101";
            when 4 => dig2 <= "0100";
            when 3 => dig2 <= "0011";
            when 2 => dig2 <= "0010";
            when 1 => dig2 <= "0001";
            when 0 => dig2 <= "0000";
            when others => dig2 <= "0000";
        end case;
        
        case hundred is
            when 2 => dig3 <= "0010";
            when 1 => dig3 <= "0001";
            when 0 => dig3 <= "0000";
            when others => dig3 <= "0000";
    end case;

end process conv;

end Behavioral;
