library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           clk_out  : out STD_LOGIC   
         );
end clock_divider;

architecture Behavioral of clock_divider is
    signal count: integer:= 1;
    signal end_count : std_logic := '0';
    
begin
    process(clk, reset)
        begin
            if (reset = '1') then
                count <= 1;
                end_count <= '0';
            elsif rising_edge(clk) then
                count <= count + 1;
            if (count = 50000) then
                end_count <= NOT end_count;
                count <= 1;
            end if;
            end if;
            clk_out <= end_count;
     end process;

end Behavioral;
