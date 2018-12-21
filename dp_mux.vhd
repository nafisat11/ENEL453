library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dp_mux is
    PORT (
           dp_1   : in STD_LOGIC_VECTOR(3 downto 0);
           sel    : in STD_LOGIC_VECTOR(1 downto 0);
           dp_out : out STD_LOGIC
         );
end dp_mux;

architecture Behavioral of dp_mux is
signal dec_pt : STD_LOGIC := dp_1(3);
signal no_dec_pt : STD_LOGIC := (dp_1(3) or dp_1(2));  

begin
--mux : process(dp_1, sel) begin
--    case sel is
--        when '1' => dp_out <= (dp_1(3) or dp_1(2));   
                     
--        when '0' => dp_out <= dp_1(3);        
--    end case; 

with sel select
    dp_out <= dec_pt WHEN "00",
              no_dec_pt WHEN "01",
              no_dec_pt WHEN "10",
              ('0')  WHEN others;

end Behavioral;
