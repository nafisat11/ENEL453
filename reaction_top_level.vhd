library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reaction_top_level is
  Port ( 
         clk   : in STD_LOGIC;
         reset : in STD_LOGIC;
         P1    : in STD_LOGIC;
         P2    : in STD_LOGIC;
         next_round : in STD_LOGIC;
         START_SW : in STD_LOGIC;
         MODE_SW : in STD_LOGIC_VECTOR(1 downto 0);
         CA    : out STD_LOGIC;
         CB    : out STD_LOGIC;
         CC    : out STD_LOGIC;
         CD    : out STD_LOGIC;
         CE    : out STD_LOGIC;
         CF    : out STD_LOGIC;
         CG    : out STD_LOGIC;
         DP    : out STD_LOGIC;
         AN1   : out STD_LOGIC;
         AN2   : out STD_LOGIC;
         AN3   : out STD_LOGIC;
         AN4   : out STD_LOGIC;
         FLASH   : inout STD_LOGIC_VECTOR(2 downto 0);
         SOUND   : out STD_LOGIC        
        );
end reaction_top_level;

architecture Behavioral of reaction_top_level is
-- Internal signals
signal in_DP, out_DP : STD_LOGIC;
signal an_i, dig1_i, dig2_i, dig3_i, disp_highscore: STD_LOGIC_VECTOR(3 downto 0);
signal digit_to_display : STD_LOGIC_VECTOR(3 downto 0);
signal sec_i, h_ms_i, t_ms_i, ms_i, digit_select_i, disp_score, disp_i: STD_LOGIC_VECTOR(3 downto 0);
signal CA_i, CB_i, CC_i, CD_i, CE_i, CF_i, CG_i : STD_LOGIC;
signal rand_num_i, zero : STD_LOGIC_VECTOR(11 downto 0);
signal db_left, db_right, db_middle : STD_LOGIC := '0';
signal clk_out_i, reset_i, selector_i, score_sel_i : STD_LOGIC;
signal start_count, play_i, buzz_i: STD_LOGIC;
signal p1_score_i, p2_score_i, winner_score_i : STD_LOGIC_VECTOR(7 downto 0);
signal l_sec1_i, l_h_ms1_i, l_t_ms1_i, l_ms1_i : STD_LOGIC_VECTOR(3 downto 0);
signal l_sec2_i, l_h_ms2_i, l_t_ms2_i, l_ms2_i : STD_LOGIC_VECTOR(3 downto 0);
signal f_sec_i, f_h_ms_i, f_t_ms_i, f_ms_i : STD_LOGIC_VECTOR(3 downto 0);
signal seg1_i, seg2_i, seg3_i, seg4_i : STD_LOGIC_VECTOR(3 downto 0);
signal winner_select_i : STD_LOGIC;

component seven_segment_digit_selector is
    PORT ( clk          : in  STD_LOGIC;
           digit_select : out  STD_LOGIC_VECTOR (3 downto 0);
           an_outputs : out  STD_LOGIC_VECTOR (3 downto 0);
           reset        : in  STD_LOGIC
          );
end component;

component buzzer is 
    PORT ( 
           clk : in STD_LOGIC;
           enable : in STD_LOGIC;
           sound_out : out STD_LOGIC
         );
end component;

component flashing is
    PORT( clk : in STD_LOGIC;
          enable : in STD_LOGIC;
          seg1 : out STD_LOGIC_VECTOR(3 downto 0);
          seg2 : out STD_LOGIC_VECTOR(3 downto 0);
          seg3 : out STD_LOGIC_VECTOR(3 downto 0);
          seg4 : out STD_LOGIC_VECTOR(3 downto 0)
        );
end component;

component dp_mux is
    PORT (
            dp_1   : in STD_LOGIC_VECTOR(3 downto 0);
            sel    : in STD_LOGIC_VECTOR(1 downto 0);
            dp_out : out STD_LOGIC
         );
end component;

component highscore_digit_mux is
    PORT ( 
           highscore_digit1 : in STD_LOGIC_VECTOR(3 downto 0);
           highscore_digit2 : in STD_LOGIC_VECTOR(3 downto 0);
           highscore_digit3 : in STD_LOGIC_VECTOR(3 downto 0);
           highscore_digit4 : in STD_LOGIC_VECTOR(3 downto 0);
           selector    : in STD_LOGIC_VECTOR(3 downto 0);
           output      : out STD_LOGIC_VECTOR(3 downto 0)
        );
end component;
 
component score_digit_mux is
    PORT ( 
            score_digit1 : in STD_LOGIC_VECTOR(3 downto 0);
            score_digit2 : in STD_LOGIC_VECTOR(3 downto 0);
            score_digit3 : in STD_LOGIC_VECTOR(3 downto 0);
            selector    : in STD_LOGIC_VECTOR(3 downto 0);
            output      : out STD_LOGIC_VECTOR(3 downto 0)
         );
end component;

component display_mux is
    PORT ( 
           seg1        : in STD_LOGIC_VECTOR(3 downto 0);
           seg2        : in STD_LOGIC_VECTOR(3 downto 0);
           seg3        : in STD_LOGIC_VECTOR(3 downto 0);
           seg4        : in STD_LOGIC_VECTOR(3 downto 0);
           selector    : in STD_LOGIC_VECTOR(3 downto 0);
           output      : out STD_LOGIC_VECTOR(3 downto 0)
         );
end component; 
        
component digit_multiplexor is
    PORT (
            sec : in STD_LOGIC_VECTOR(3 downto 0);
            h_ms : in STD_LOGIC_VECTOR(3 downto 0);
            t_ms : in STD_LOGIC_VECTOR(3 downto 0);
            ms : in STD_LOGIC_VECTOR(3 downto 0);
            selector : in STD_LOGIC_VECTOR(3 downto 0);
            time_digit : out STD_LOGIC_VECTOR(3 downto 0)
         );
end component;

component seven_segment_decoder is
    PORT (
            data : in STD_LOGIC_VECTOR(3 downto 0);
            score : in STD_LOGIC_VECTOR(3 downto 0);
            highscore : in STD_LOGIC_VECTOR(3 downto 0);
            disp : in STD_LOGIC_VECTOR(3 downto 0);
            switch : in STD_LOGIC_VECTOR(2 downto 0);
            dp_in : in STD_LOGIC;
            CA : out STD_LOGIC;
            CB : out STD_LOGIC;
            CC : out STD_LOGIC;
            CD : out STD_LOGIC;
            CE : out STD_LOGIC;
            CF : out STD_LOGIC;
            CG : out STD_LOGIC;
            DP : out STD_LOGIC
         );
end component;

component button_debouncer is 
    PORT ( clk      : in STD_LOGIC;
           P1       : in STD_LOGIC;
           P2       : in STD_LOGIC;
           next_round : in STD_LOGIC;
           db_P1    : out STD_LOGIC;
           db_P2    : out STD_LOGIC;
           db_next_round : out STD_LOGIC
           
         );
end component;
       
component clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           clk_out  : out STD_LOGIC   
         );
end component;

component ms_clock_divider is
    PORT ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           enable   : in  STD_LOGIC;
           sec : out STD_LOGIC_VECTOR(3 downto 0);
           h_ms : out STD_LOGIC_VECTOR(3 downto 0);
           t_ms : out STD_LOGIC_VECTOR(3 downto 0);
           ms : out STD_LOGIC_VECTOR(3 downto 0)     
         );
end component;

component random_delay_gen is
    PORT ( clk      : in STD_LOGIC;
           reset    : in STD_LOGIC;
           rand_num : out STD_LOGIC_VECTOR(11 downto 0)
         );
end component;
       
component reaction_FSM is
    PORT ( clk            : in STD_LOGIC;
           reset          : in STD_LOGIC;
           enable         : in STD_LOGIC;
           player_one     : in STD_LOGIC;
           player_two     : in STD_LOGIC;
           new_round      : in STD_LOGIC;
           gameover       : in STD_LOGIC;
           high_score     : in STD_LOGIC;
           delay          : in STD_LOGIC_VECTOR(11 downto 0);
           P1_score       : out STD_LOGIC_VECTOR(7 downto 0);
           P2_score       : out STD_LOGIC_VECTOR(7 downto 0);
           winner_select  : out STD_LOGIC;
           winner_score   : out STD_LOGIC_VECTOR(7 downto 0);
           display_score  : out STD_LOGIC;
           reaction_time  : out STD_LOGIC;
           led            : out STD_LOGIC_VECTOR(2 downto 0);
           play           : out STD_LOGIC;
           buzz           : out STD_LOGIC
         );
end component;

--component score is
--    PORT( 
--          led   :  in STD_LOGIC_VECTOR(2 downto 0);
--          reset : in STD_LOGIC;
--          clk   : in STD_LOGIC;
--          p1_score : out STD_LOGIC_VECTOR(7 downto 0);
--          p2_score : out STD_LOGIC_VECTOR(7 downto 0)
--    );
--end component;  

component bin2BCD is
    PORT (
            binary_in : in STD_LOGIC_VECTOR(7 downto 0);
            dig1  : out STD_LOGIC_VECTOR(3 downto 0);
            dig2  : out STD_LOGIC_VECTOR(3 downto 0);
            dig3  : out STD_LOGIC_VECTOR(3 downto 0)
          );
end component;

component fastest_times is
    PORT(
                clk :               in STD_LOGIC;
                reset:              in STD_LOGIC;
                led:                in STD_LOGIC_VECTOR(2 downto 0);
                p1_score:           in STD_LOGIC_VECTOR(7 downto 0);
                p2_score:           in STD_LOGIC_VECTOR(7 downto 0);
                sec:                in STD_LOGIC_VECTOR(3 downto 0);
                h_ms:               in STD_LOGIC_VECTOR(3 downto 0);
                t_ms:               in STD_LOGIC_VECTOR(3 downto 0);
                ms:                 in STD_LOGIC_VECTOR(3 downto 0);
                l_sec1:             inout STD_LOGIC_VECTOR(3 downto 0);
                l_h_ms1:            inout STD_LOGIC_VECTOR(3 downto 0);
                l_t_ms1:            inout STD_LOGIC_VECTOR(3 downto 0);
                l_ms1:              inout STD_LOGIC_VECTOR(3 downto 0);
                l_sec2:             inout STD_LOGIC_VECTOR(3 downto 0);
                l_h_ms2:            inout STD_LOGIC_VECTOR(3 downto 0);
                l_t_ms2:            inout STD_LOGIC_VECTOR(3 downto 0);
                l_ms2:              inout STD_LOGIC_VECTOR(3 downto 0)
          );
end component;
         
component fastest_times_mux is
    PORT(
                l_sec1:                in   STD_LOGIC_VECTOR(3 downto 0);
                l_h_ms1:               in   STD_LOGIC_VECTOR(3 downto 0);
                l_t_ms1:               in   STD_LOGIC_VECTOR(3 downto 0);
                l_ms1:                 in   STD_LOGIC_VECTOR(3 downto 0);
                l_sec2 :               in   STD_LOGIC_VECTOR(3 downto 0);
                l_h_ms2:               in   STD_LOGIC_VECTOR(3 downto 0);
                l_t_ms2:               in   STD_LOGIC_VECTOR(3 downto 0);
                l_ms2:                 in   STD_LOGIC_VECTOR(3 downto 0);
                selector:              in   STD_LOGIC;
                f_sec:                 out  STD_LOGIC_VECTOR(3 downto 0);
                f_h_ms:                out  STD_LOGIC_VECTOR(3 downto 0);
                f_t_ms:                out  STD_LOGIC_VECTOR(3 downto 0);
                f_ms:                  out  STD_LOGIC_VECTOR(3 downto 0)
         );
end component;

BEGIN
   
   BUZZ : buzzer
   PORT MAP (
              clk => clk,
              enable => buzz_i,
              sound_out => SOUND
            );
            
   HIGHSCORE_MUX : highscore_digit_mux
   PORT MAP (
               highscore_digit1 => f_ms_i,
               highscore_digit2 => f_t_ms_i,
               highscore_digit3 => f_h_ms_i,
               highscore_digit4 => f_sec_i,
               selector => digit_select_i,
               output => disp_highscore
            );
   
   DISP_MUX : display_mux
   PORT MAP (  
               seg1 => seg1_i,
               seg2 => seg2_i,
               seg3 => seg3_i,
               seg4 => seg4_i,
               selector => digit_select_i,
               output => disp_i 
            );
             
   WINNER_TIMES: fastest_times_mux
         PORT MAP (
                     l_sec1       => l_sec1_i,
                     l_h_ms1      => l_h_ms1_i,
                     l_t_ms1      => l_t_ms1_i,
                     l_ms1        => l_ms1_i,
                     l_sec2       => l_sec2_i,
                     l_h_ms2      => l_h_ms2_i,
                     l_t_ms2      => l_t_ms2_i,
                     l_ms2        => l_ms2_i,
                     f_sec        => f_sec_i,
                     f_h_ms       => f_h_ms_i,
                     f_t_ms       => f_t_ms_i,
                     f_ms         => f_ms_i,
                     selector     => winner_select_i
                  );
          
      SAVE_TIMES: fastest_times
            PORT MAP (
                        clk          => clk,
                        reset        => reset,
                        led          => FLASH,
                        p1_score     => p1_score_i,
                        p2_score     => p2_score_i,
                        sec          => sec_i,
                        h_ms         => h_ms_i,
                        t_ms         => t_ms_i,
                        ms           => ms_i,
                        l_sec1       => l_sec1_i,
                        l_h_ms1      => l_h_ms1_i,
                        l_t_ms1      => l_t_ms1_i,
                        l_ms1        => l_ms1_i,
                        l_sec2       => l_sec2_i,
                        l_h_ms2      => l_h_ms2_i,
                        l_t_ms2      => l_t_ms2_i,
                        l_ms2        => l_ms2_i
                     );
   BIN_CONV : bin2BCD
   PORT MAP (
              binary_in => winner_score_i,
              dig1 => dig1_i,
              dig2 => dig2_i,
              dig3 => dig3_i
            );

   BLINK : flashing
   PORT MAP(
             clk => clk,
             enable => play_i,
             seg1 => seg1_i,
             seg2 => seg2_i,
             seg3 => seg3_i,
             seg4 => seg4_i
           );
           
--   SCORING : score
--   PORT MAP (
--               led   => FLASH,
--               reset => reset,
--               clk   => clk,
--               p1_score => p1_score_i,
--               p2_score => p2_score_i
--           );
   DP_SEL : dp_mux
   PORT MAP ( 
              dp_1 => an_i,
              sel(0) => selector_i,
              sel(1) => play_i,
              dp_out => in_DP
            );
              
   SCORE_MUX : score_digit_mux
   PORT MAP (
              score_digit1 => dig1_i,
              score_digit2 => dig2_i,
              score_digit3 => dig3_i,
              selector => digit_select_i,
              output => disp_score
            );
            
   DEBOUNCER : button_debouncer
   PORT MAP ( 
              clk => clk,
              P1    => P1,
              P2    => P2,
              next_round => next_round,
              db_P1 => db_left,
              db_P2 => db_right,
              db_next_round => db_middle
            );         
   
   DIVIDER : clock_divider
   PORT MAP ( 
              clk => clk,
              reset => reset,
              clk_out => clk_out_i
            );
            
    MS_DIVIDER: ms_clock_divider
            PORT MAP( clk => clk_out_i,
                      reset => START_SW,
                      enable => start_count,
                      sec   => sec_i,  
                      h_ms   => h_ms_i, 
                      t_ms   => t_ms_i,  
                      ms   => ms_i
                    );
   
   RANDOM_DELAY : random_delay_gen
   PORT MAP (               
              clk => clk_out_i,
              reset => reset,
              rand_num => rand_num_i
            );
   
            
   FSM : reaction_FSM
   PORT MAP ( 
              clk => clk_out_i,
              reset => reset,
              enable => db_middle,
              player_one => db_left,
              player_two => db_right,
              P1_score   => p1_score_i,
              P2_score   => p2_score_i,
              new_round  => START_SW,
              gameover   => MODE_SW(0),
              high_score => MODE_SW(1),
              delay => rand_num_i,
              display_score => selector_i,
              winner_score => winner_score_i,
              winner_select => winner_select_i,
              reaction_time => start_count,
              led => FLASH,
              play => play_i,
              buzz => buzz_i
            );
            
   SELECTOR : seven_segment_digit_selector
            PORT MAP( clk          => clk,
                      digit_select => digit_select_i, 
                      an_outputs   => an_i,
                      reset        => reset
                    );

   DIGIT_MUX : digit_multiplexor
   PORT MAP( 
             sec   => sec_i,  
             h_ms   => h_ms_i, 
             t_ms   => t_ms_i,  
             ms   => ms_i,  
             selector   => digit_select_i,  
             time_digit => digit_to_display

           );
           
    DECODE: seven_segment_decoder
           PORT MAP(
                     data => digit_to_display,
                     score => disp_score,
                     disp => disp_i,
                     highscore => disp_highscore,
                     switch(0) => selector_i,
                     switch(1) => MODE_SW(1),
                     switch(2) => play_i,
--                     selector2 => HIGHSCORE_SW(0),
--                     selector3 => HIGHSCORE_SW(1),
                     dp_in => in_DP,
                     CA => CA_i,
                     CB => CB_i,
                     CC => CC_i,
                     CD => CD_i,
                     CE => CE_i,
                     CF => CF_i,
                     CG => CG_i,
                     DP => DP
                    );


   CA <= CA_i;
   CB <= CB_i;
   CC <= CC_i;
   CD <= CD_i;
   CE <= CE_i;
   CF <= CF_i;
   CG <= CG_i;
   
 
   AN1 <= an_i(0); 
   AN2 <= an_i(1); 
   AN3 <= an_i(2); 
   AN4 <= an_i(3); 
                    
end Behavioral;
