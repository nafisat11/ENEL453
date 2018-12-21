library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity random_delay_gen is
    PORT ( clk      : in STD_LOGIC;
           reset    : in STD_LOGIC;
           rand_num : out STD_LOGIC_VECTOR(11 downto 0)
         );
end random_delay_gen;

architecture Behavioral of random_delay_gen is
signal count : STD_LOGIC_VECTOR(11 downto 0);
signal output : STD_LOGIC;

begin
    output <= not(count(11) xor count(10));
    
    process(clk, reset)
        begin
            if (reset = '1') then
                count <= (others => '0');
                elsif rising_edge(clk) then
                count <= count(10 downto 0) & output;
            end if;
        end process;
   rand_num <= count;
end Behavioral;
