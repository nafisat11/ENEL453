library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fastest_times_mux is
  PORT ( 
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
end fastest_times_mux;


architecture Behavioral of fastest_times_mux is

BEGIN
 
process(selector)
    begin
        case selector is
        when '1' => f_sec       <= l_sec1;
                    f_h_ms      <= l_h_ms1;
                    f_t_ms      <= l_t_ms1;
                    f_ms        <= l_ms1;
        when others => f_sec       <= l_sec2;
                       f_h_ms      <= l_h_ms2;
                       f_t_ms      <= l_t_ms2;
                       f_ms        <= l_ms2;
        end case;
    end process;

END Behavioral;