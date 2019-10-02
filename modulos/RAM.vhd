-- NO TOCAR

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity RAM is
    Port (
        clock       : in   std_logic;
        write       : in   std_logic;
        address     : in   std_logic_vector (11 downto 0);
        datain      : in   std_logic_vector (15 downto 0);
        dataout     : out  std_logic_vector (15 downto 0)
          );
end RAM;

architecture Behavioral of RAM is

    type memory_array is array (0 to ( 2 ** 12 ) - 1  ) of std_logic_vector (15 downto 0);
	signal memory : memory_array;
	
begin

process (clock)
    begin
       if (rising_edge(clock)) then
            if (write = '1') then
                memory(to_integer(unsigned(address))) <= datain;
           end if;
       end if;
end process;

dataout <= memory(to_integer(unsigned(address)));

end Behavioral;
