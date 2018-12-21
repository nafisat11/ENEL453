library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity button_debouncer is
    PORT ( clk      : in STD_LOGIC;
           P1       : in STD_LOGIC;
           P2       : in STD_LOGIC;
           next_round : in STD_LOGIC;
           db_P1    : out STD_LOGIC;
           db_P2    : out STD_LOGIC;
           db_next_round : out STD_LOGIC
         );
end button_debouncer;


architecture Behavioral of button_debouncer is
    signal count      : unsigned(20 downto 0) := (others => '0');
    signal not_synced : std_logic := '0';
    signal synced     : std_logic := '0';
    signal P1_i, P2_i, next_round_i : std_logic;
    
component debounce_P1 is
    PORT ( clk      : in STD_LOGIC;
            P1      : in STD_LOGIC;
            db_P1    : out STD_LOGIC
         );
end component;

component debounce_P2 is
    PORT ( clk      : in STD_LOGIC;
           P2      : in STD_LOGIC;
           db_P2    : out STD_LOGIC
         );
end component;   

component debounce_next_round is
    PORT ( clk      : in STD_LOGIC;
           next_round       : in STD_LOGIC;
           db_next_round    : out STD_LOGIC
         );
end component;

begin

DEBOUNCE_LEFT : debounce_P1
PORT MAP (
           clk => clk,
           P1  => P1,
           db_P1 => db_P1
         );

DEBOUNCE_RIGHT : debounce_P2
PORT MAP (
            clk => clk,
            P2  => P2,
            db_P2 => db_P2
         );
         
DEBOUNCE_MID : debounce_next_round 
PORT MAP (
            clk => clk,
            next_round => next_round,
            db_next_round => db_next_round
         );

end Behavioral;
