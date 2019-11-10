library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity SP is
    Port (inc : in STD_LOGIC;
          dec : in STD_LOGIC;
          clock : in STD_LOGIC;
          dataOut : out STD_LOGIC_VECTOR (11 downto 0));
end SP;

architecture Behavioral of SP is

signal value : STD_LOGIC_VECTOR (11 downto 0) := "111111111111";

begin

sp_process : process (clock)
        begin
          if (rising_edge(clock)) then
            if (inc = '1') then
                value <= value + 1;         -- Si inc = 1 incrementa el registro en 1
            elsif (dec = '1') then
                value <= value - 1;         -- inc = 0 y dec = 1 decrementa el registro en 1          
            end if;
          end if;
end process;
        
dataOut <= value;                         -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;
