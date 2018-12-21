library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity debounce_P2 is
    Port ( clk : in STD_LOGIC;
           P2 : in STD_LOGIC;
           db_P2 : out STD_LOGIC);
end debounce_P2;

architecture Behavioral of debounce_P2 is
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
            db_P2 <= std_logic(count(count'high));
            synced <= not_synced;
            not_synced <= P2;
        end if;
end process;
        
end Behavioral;
