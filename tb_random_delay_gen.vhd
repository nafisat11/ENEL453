
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_random_delay_gen is
--  Port ( );
end tb_random_delay_gen;

architecture Behavioral of tb_random_delay_gen is

component random_delay_gen is
    PORT ( clk      : in STD_LOGIC;
       reset    : in STD_LOGIC;
       rand_num : out STD_LOGIC_VECTOR(11 downto 0)
     );
end component;

signal clk : std_logic;
signal reset : std_logic;
signal rand_num : std_logic_vector(11 downto 0);

constant clk_period : time := 10 ns;
   
begin

uut : random_delay_gen 
PORT MAP (
            clk => clk,
            reset => reset,
            rand_num => rand_num
         );
         
clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

stim_proc : process
begin
       reset <= '1';
       wait for clk_period;

reset <= '0';
wait for 200 ns; 
end process;
end Behavioral;
