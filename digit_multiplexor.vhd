library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity digit_multiplexor is
    PORT ( sec    : in STD_LOGIC_VECTOR(3 downto 0);
           h_ms   : in STD_LOGIC_VECTOR(3 downto 0);
           t_ms   : in STD_LOGIC_VECTOR(3 downto 0);
           ms     : in STD_LOGIC_VECTOR(3 downto 0);
           selector : in STD_LOGIC_VECTOR(3 downto 0);
           time_digit : out STD_LOGIC_VECTOR(3 downto 0)
         );
end digit_multiplexor;

architecture Behavioral of digit_multiplexor is

begin 

with selector select
    time_digit <= sec when "1000",
                  h_ms when "0100",
                  t_ms when "0010",
                  ms when "0001",
                  "0000" when others;

end Behavioral;
