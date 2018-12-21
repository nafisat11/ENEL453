library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reaction_FSM is
    PORT ( clk            : in STD_LOGIC;
           reset          : in STD_LOGIC;
           enable         : in STD_LOGIC;
           player_one     : in STD_LOGIC;
           player_two     : in STD_LOGIC;
           new_round      : in STD_LOGIC;
           high_score     : in STD_LOGIC;
           gameover       : in STD_LOGIC;
           delay          : in STD_LOGIC_VECTOR(11 downto 0);
           winner_score   : out STD_LOGIC_VECTOR(7 downto 0);
           P1_score       : out STD_LOGIC_VECTOR(7 downto 0);
           P2_score       : out STD_LOGIC_VECTOR(7 downto 0);
           winner_select  : out STD_LOGIC;
           display_score  : out STD_LOGIC;
           reaction_time  : out STD_LOGIC;
           led            : out STD_LOGIC_VECTOR(2 downto 0);
           play           : out STD_LOGIC;
           buzz           : out STD_LOGIC
         );
end reaction_FSM;

architecture Behavioral of reaction_FSM is
Type timer_state is (new_game, idle, countdown, timing, readout, n_round, round_winner, end_game);
signal current_state, next_state : timer_state := new_game;
signal zeros : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
signal state_change : STD_LOGIC := '0';
signal countdown_done : STD_LOGIC := '0';
signal P1_wins, P2_wins : STD_LOGIC;
signal left_led_count, right_led_count : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal downcount : STD_LOGIC_VECTOR(11 downto 0);

begin

reaction_state_machine : process(clk)
    begin
        next_state <= current_state;
        CASE current_state is
            WHEN new_game =>
                if (enable = '1') then
                    next_state <= idle;
                end if;
            WHEN idle =>
                if (enable = '1') then
                    next_state <= countdown;
                end if;
            WHEN countdown =>
                if (countdown_done = '1') then
                    next_state <= timing;
                end if;
            
            WHEN timing => 
                if (player_one = '1' AND player_two = '0') then
                    P1_wins <= '1';
                    P2_wins <= '0';
                    next_state <= round_winner;
                                       
                elsif (player_one = '0' AND player_two = '1') then
                    P2_wins <= '1';
                    P1_wins <= '0';
                    next_state <= round_winner;
                    
                elsif (player_one = '1' AND player_two = '1') then
                    P1_wins <= '0';
                    P2_wins <= '0';
                    next_state <= countdown;
                end if;
            
            WHEN readout =>
                next_state <= readout;
                   if (new_round = '1') then
                        next_state <= n_round;
                   elsif (gameover = '1') then
                        next_state <= end_game;
                   end if;
                   
            WHEN round_winner =>
                if ( P1_wins <= '1' OR P2_wins <= '1') then
                    next_state <= readout;
                end if;
                
            WHEN n_round =>
                next_state <= idle;
                if (gameover = '1') then
                    next_state <= end_game;
                end if;
            
            WHEN end_game =>
                next_state <= end_game;
                if (new_round = '1') then
                    next_state <= new_game;
                end if;
                
            WHEN others =>
                next_state <= new_game;
                
         END CASE;
end process;

state_transitions : process(clk,reset)
    begin
            if (reset = '1') then
                current_state <= new_game;
            elsif rising_edge(clk) then
                current_state <= next_state;
            end if;
    end process;

output_process : process(current_state, clk)
    begin
        if rising_edge(clk) then
            CASE current_state is 
                WHEN new_game =>
                    buzz <= '1';
                    play <= '1';
                    led <= (others => '0');
                    downcount <= (others => '0');
                    reaction_time <= '0';
                    countdown_done <= '0';
                    left_led_count <= (others => '0');
                    right_led_count <= (others => '0');
                    P1_score <= (others => '0');
                    P2_score <= (others => '0');
                    
                WHEN idle =>
                    buzz <= '0';
                    play <= '0';
                    led <= (others => '0');
                    downcount <= delay;
                    reaction_time <= '0';
                    countdown_done <= '0';
               
                WHEN countdown =>
                    play <= '0';
                    downcount <= downcount - 1;
                    if (downcount = zeros) then
                        countdown_done <= '1';
                    end if;
                    
                WHEN timing =>
                    play <= '0';
                    led(1) <= '1';
                    reaction_time <= '1';
                   countdown_done <= '0';
                   
                WHEN readout => 
                    play <= '0';
                    led(1) <= '0';
                    reaction_time <= '0';
                
                WHEN round_winner =>
                    play <= '0';
                    if (P1_wins <= '1' AND P2_wins <= '0') then
                        led(2) <= '1';
                        led(0) <= '0';
                        left_led_count <= left_led_count + 1;
                        P1_score <= left_led_count;
                        winner_select <= '1';
                    elsif (P2_wins <= '1' AND P1_wins <= '0') then
                        led(0) <= '1';
                        led(2) <= '0'; 
                        right_led_count <= right_led_count + 1;
                        P2_score <= right_led_count;  
                        winner_select <= '0';  
                  end if;
                    
                WHEN n_round =>
                    play <= '0';
                
                WHEN end_game =>
                    play <= '0';
                    if (left_led_count > right_led_count) then
                        led(2) <= '1';
                        led(1) <= '0';
                        led(0) <= '0';
                        winner_score <= left_led_count;
                        if (gameover = '1') then
                            display_score <= '1';
                        else
                            display_score <= '0';
                            if (new_round <= '1') then
                                left_led_count <= (others => '0');
                            end if;
                        end if;
                    elsif (right_led_count > left_led_count) then
                        led(0) <= '1';
                        led(1) <= '0';
                        led(2) <= '0';
                        winner_score <= right_led_count;
                        if (gameover = '1') then
                            display_score <= '1';
                        else
                            display_score <= '0';
                            if (new_round <= '1') then
                                right_led_count <= (others => '0');
                            end if;
                        end if;
                    else
                        led <= (others => '0');
                        display_score <= '0';
                    end if;
                    
                WHEN others =>
                    play <= '0';
                    led <= (others => '0');
                    reaction_time <= '0';
                    countdown_done <= '0';
                    
           END CASE;
        end if;     
    end process;
end Behavioral;
