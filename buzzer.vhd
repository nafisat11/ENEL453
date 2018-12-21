library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity buzzer is
    PORT ( 
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sound_out : out STD_LOGIC
         );
end buzzer;

architecture Behavioral of buzzer is

signal count : integer := 0;
signal s_out : std_logic := '0';
begin

process(clk)
begin

    if rising_edge(clk) then
      if (enable = '1') then
          if (count = 4999) then
            count <= 0;
            s_out <= (not s_out);
            sound_out <= s_out;
          else
            count <= count + 1;
--        if (i <= 49999999) then
--            i <= i + 1;
--            sound_out <= '1';
            
--        elsif (i > 49999999 AND i < 99999999) then
--            i <= i + 1;
--            sound_out <= '0';
        
--        elsif (i = 99999999) then
--            i <= 0;
        
--        elsif (enable = '0') then
--            sound_out <= '0';
        end if;
    end if;
  end if;
end process;
end Behavioral;
