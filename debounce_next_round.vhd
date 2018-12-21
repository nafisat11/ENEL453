library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity debounce_next_round is
    Port ( clk : in STD_LOGIC;
           next_round : in STD_LOGIC;
           db_next_round : out STD_LOGIC);
end debounce_next_round;

architecture Behavioral of debounce_next_round is
    signal count      : unsigned(20 downto 0) := (others => '0');
    signal not_synced : std_logic := '0';
    signal synced     : std_logic := '0';
    
begin

process(clk)
    begin
        if rising_edge(clk) then
            if synced = '0' then
                if count(count 'high) = '1' then
                    count <= count - 1;
                else
                    count <= (others => '0');
                end if;
            else
                if count(count 'high) = '0' then
                    count <= count + 1;
                else
                    count <= (others => '1');
                end if;
            end if;
            db_next_round <= std_logic(count(count'high));
            synced <= not_synced;
            not_synced <= next_round;
        end if;
end process;
        
end Behavioral;
