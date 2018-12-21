library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fastest_times is
  Port (    clk :               in STD_LOGIC;
            reset:              in STD_LOGIC;
            led:                in STD_LOGIC_VECTOR(2 downto 0);
            sec:                in STD_LOGIC_VECTOR(3 downto 0);
            h_ms:               in STD_LOGIC_VECTOR(3 downto 0);
            t_ms:               in STD_LOGIC_VECTOR(3 downto 0);
            ms:                 in STD_LOGIC_VECTOR(3 downto 0);
            P1_score:           in STD_LOGIC_VECTOR(7 downto 0);
            P2_score:           in STD_LOGIC_VECTOR(7 downto 0);
            l_sec1:             inout STD_LOGIC_VECTOR(3 downto 0);
            l_h_ms1:            inout STD_LOGIC_VECTOR(3 downto 0);
            l_t_ms1:            inout STD_LOGIC_VECTOR(3 downto 0);
            l_ms1:              inout STD_LOGIC_VECTOR(3 downto 0);
            l_sec2:             inout STD_LOGIC_VECTOR(3 downto 0);
            l_h_ms2:            inout STD_LOGIC_VECTOR(3 downto 0);
            l_t_ms2:            inout STD_LOGIC_VECTOR(3 downto 0);
            l_ms2:              inout STD_LOGIC_VECTOR(3 downto 0)
             );
end fastest_times;

architecture Behavioral of fastest_times is

BEGIN

load_times: process(clk, reset)
    begin       
        if(rising_edge(clk)) then
            if(reset = '1') then
                    l_sec1 <= "0000";
                    l_h_ms1 <= "0000";
                    l_t_ms1 <= "0000";
                    l_ms1 <= "0000";
                    l_sec2 <= "0000";
                    l_h_ms2 <= "0000";
                    l_t_ms2 <= "0000";
                    l_ms2 <= "0000"; 
            elsif(led(2) = '1') then
                    if(P1_score = "00000001") then --store time for first win
                        l_sec1 <= sec;
                        l_h_ms1 <= h_ms;
                        l_t_ms1 <= t_ms;
                        l_ms1 <= ms;
                    elsif((sec < l_sec1) OR ((sec = l_sec1) AND (h_ms < l_h_ms1)) OR ((sec = l_sec1) AND (h_ms = l_h_ms1) AND (t_ms < l_t_ms1)) OR ((sec = l_sec1) AND (h_ms = l_h_ms1) AND (t_ms = l_t_ms1) AND (ms < l_ms1))) then
                        l_sec1 <= sec;
                        l_h_ms1 <= h_ms;
                        l_t_ms1 <= t_ms;
                        l_ms1 <= ms;
                    end if;
              elsif(led(0) = '1') then
                    if(P2_score = "00000001") then
                            l_sec2 <= sec;
                            l_h_ms2 <= h_ms;
                            l_t_ms2 <= t_ms;
                            l_ms2 <= ms;
                     elsif((sec < l_sec2) OR ((sec = l_sec2) AND (h_ms < l_h_ms2)) OR ((sec = l_sec2) AND (h_ms = l_h_ms2) AND (t_ms < l_t_ms2)) OR ((sec = l_sec2) AND (h_ms = l_h_ms2) AND (t_ms = l_t_ms2) AND (ms < l_ms2))) then
                        l_sec2 <= sec;
                        l_h_ms2 <= h_ms;
                        l_t_ms2 <= t_ms;
                        l_ms2 <= ms;
                    end if;
            end if;
        end if;
    end process;
end Behavioral;