-- NO TOCAR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Clock_Divider is
    Port ( clk                  : in std_logic;
           speed                : in std_logic_vector (1 downto 0);
           clock                : out std_logic);
end Clock_Divider;

architecture Behavioral of Clock_Divider is

constant full_max         : std_logic_vector(26 downto 0) := "000000000000000000000000001";
constant fast_max         : std_logic_vector(26 downto 0) := "000010111110101111000010000";
constant normal_max       : std_logic_vector(26 downto 0) := "001011111010111100001000000";
constant slow_max         : std_logic_vector(26 downto 0) := "101111101011110000100000000";

signal clock_divide_max     : std_logic_vector(26 downto 0);
signal clock_divide_counter : std_logic_vector(26 downto 0) := (others => '0');
signal internal_clock       : std_logic;
    
begin

with speed select
    clock_divide_max <= full_max    when "00",
                        fast_max    when "01",
                        normal_max  when "10",
                        slow_max    when "11";
                        
clock_divide : process (clk)
    begin
        if (rising_edge(clk)) then
            if (clock_divide_counter >= clock_divide_max) then
                clock_divide_counter <= (others => '0');
                internal_clock <= not internal_clock;
            else
                clock_divide_counter <= clock_divide_counter + 1;
            end if;
        end if;
    end process;
    
clock <= internal_clock;

end Behavioral;
