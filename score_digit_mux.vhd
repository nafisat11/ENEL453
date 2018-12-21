library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity score_digit_mux is
    PORT ( 
           score_digit1 : in STD_LOGIC_VECTOR(3 downto 0);
           score_digit2 : in STD_LOGIC_VECTOR(3 downto 0);
           score_digit3 : in STD_LOGIC_VECTOR(3 downto 0);
           selector    : in STD_LOGIC_VECTOR(3 downto 0);
           output      : out STD_LOGIC_VECTOR(3 downto 0)
          );
end score_digit_mux;

architecture Behavioral of score_digit_mux is

begin

with selector select
    output    <=  score_digit1 when "0001",
                  score_digit2 when "0010",
                  score_digit3 when "0100",
                  "0000" when others;


end Behavioral;
