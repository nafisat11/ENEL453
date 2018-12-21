
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ms_clock_divider is
    PORT ( clk      : in  STD_LOGIC;
            reset    : in  STD_LOGIC;
            enable   : in  STD_LOGIC;
--            load     : in  STD_LOGIC;
            sec : out STD_LOGIC_VECTOR(3 downto 0);
            h_ms : out STD_LOGIC_VECTOR(3 downto 0);
            t_ms : out STD_LOGIC_VECTOR(3 downto 0);
            ms : out STD_LOGIC_VECTOR(3 downto 0)     
         );
end ms_clock_divider;

architecture Behavioral of ms_clock_divider is
signal tensms, onessec, singlems, hundredms : STD_LOGIC;
signal singleMillisec, singleSec : STD_LOGIC_VECTOR(3 downto 0);
signal tenMillisec, hundredMillisec : STD_LOGIC_VECTOR(3 downto 0);

component upcounter is
   Generic ( period : integer:= 4;
             WIDTH  : integer:= 3
           );
      PORT (  clk    : in  STD_LOGIC;
              reset  : in  STD_LOGIC;
--              load   : in  STD_LOGIC;
              enable : in  STD_LOGIC;
              zero   : out STD_LOGIC;
              value  : out STD_LOGIC_VECTOR(WIDTH-1 downto 0)
           );
end component;

begin

   singleMillisecClock: upcounter
   generic map(
               period => (10),   -- Counts numbers between 0 and 9 -> that's 10 values!
               WIDTH  => 4
              )
   PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => enable,
--               load   => load,
               zero   => singlems,
               value  => singleMillisec -- binary value of seconds we decode to drive the 7-segment display        
            );

tensMillisecClock: upcounter
generic map(
               period => (10),   -- Counts numbers between 0 and 5 -> that's 6 values!
               WIDTH  => 4
            )
PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => singlems,
--               load   => load,
               zero   => tensms,
               value  => tenMillisec -- binary value of tens seconds we decode to drive the 7-segment display        
          );
          
hundredMillisecClock: upcounter
          generic map(
                         period => (10),   -- Counts numbers between 0 and 9 -> that's 10 values!
                         WIDTH  => 4
                      )
          PORT MAP (
                         clk    => clk,
                         reset  => reset,
                         enable => tensms,
--                         load   => load,
                         zero   => hundredms,
                         value  => hundredMillisec -- binary value of seconds we decode to drive the 7-segment display        
                    );

tenMinutesClock: upcounter
generic map(
               period => (10),   -- Counts numbers between 0 and 5 -> that's 6 values!
               WIDTH  => 4
            )
PORT MAP (
               clk    => clk,
               reset  => reset,
               enable => hundredms,
--               load   => load,
               zero   => open,
               value  => singleSec -- binary value of seconds we decode to drive the 7-segment display        
          );
          
          sec      <= singleSec;
          h_ms     <= hundredMillisec;
          t_ms     <= tenMillisec;
          ms       <= singleMillisec;
          
end Behavioral;
