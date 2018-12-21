library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity display_mux is
  Port ( 
         seg1     : in STD_LOGIC_VECTOR(3 downto 0);
         seg2     : in STD_LOGIC_VECTOR(3 downto 0);
         seg3     : in STD_LOGIC_VECTOR(3 downto 0);
         seg4     : in STD_LOGIC_VECTOR(3 downto 0);
         selector : in STD_LOGIC_VECTOR(3 downto 0);
         output : out STD_LOGIC_VECTOR(3 downto 0)
         );
end display_mux;

architecture Behavioral of display_mux is
--signal sseg1 : STD_LOGIC_VECTOR(3 downto 0) := "1101";
--signal sseg2 : STD_LOGIC_VECTOR(3 downto 0) := "1010";
--signal sseg3 : STD_LOGIC_VECTOR(3 downto 0) := "1100";
--signal sseg4 : STD_LOGIC_VECTOR(3 downto 0) := "1011";

begin

with selector select
    output    <=  seg1 when "0001",
                  seg2 when "0010",
                  seg3 when "0100",
                  seg4 when "1000",
                  "0000" when others;             
end Behavioral;
