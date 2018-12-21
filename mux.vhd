library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
  Port ( 
         input1: in STD_LOGIC_VECTOR(3 downto 0);
         input2: in STD_LOGIC_VECTOR(3 downto 0);
         input3: in STD_LOGIC_VECTOR(3 downto 0);
         input4 : in STD_LOGIC_VECTOR(3 downto 0);
         selector : in STD_LOGIC_VECTOR(2 downto 0);
         output : out STD_LOGIC_VECTOR(3 downto 0)
        );
end mux;

architecture Behavioral of mux is
begin

with selector select
    output <= input1 WHEN "001",
              input2 WHEN "000",
              input3 WHEN "011",
              input4 WHEN "100",
              (others => '0')  WHEN others;

end Behavioral;
