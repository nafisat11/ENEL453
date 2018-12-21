library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flashing is
    PORT( 
          clk : in STD_LOGIC;
          enable : in STD_LOGIC;
          seg1 : out STD_LOGIC_VECTOR(3 downto 0);
          seg2 : out STD_LOGIC_VECTOR(3 downto 0);
          seg3 : out STD_LOGIC_VECTOR(3 downto 0);
          seg4 : out STD_LOGIC_VECTOR(3 downto 0)
         );
end flashing;

architecture Behavioral of flashing is

signal count: integer range 0 to 98000000;

begin
process(clk)
    begin
    if rising_edge(clk) then
        if (enable = '1') then
            if count < (98000000 - 1) then
                count <= count + 1;
            else
                count <= 0;
                seg1 <= "1111";
                seg2 <= "1111";
                seg3 <= "1111";
                seg4 <= "1111";
            end if;
           seg1 <= "1101";
           seg2 <= "1010";
           seg3 <= "1100";
           seg4 <= "1011";
        elsif (enable = '0') then
            seg1 <= (others => '0');
            seg2 <= (others => '0');
            seg3 <= (others => '0');
            seg4 <= (others => '0');
      end if;
    end if;
end process;

end Behavioral;
