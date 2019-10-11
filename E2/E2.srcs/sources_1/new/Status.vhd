library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Status is
    Port (status : in STD_LOGIC_VECTOR(2 downto 0);
          clock : in STD_LOGIC;
          statusOut : out STD_LOGIC_VECTOR (2 downto 0));
end Status;

architecture Behavioral of Status is

signal regVal : STD_LOGIC_VECTOR (2 downto 0) := "000";

begin

status_process : process (clock, status)           -- Proceso sensible al clock
    begin
        if (rising_edge(clock)) then  -- Condición de flanco de subida del clock
            regVal <= status;
        end if;
end process;         

statusOut <= regVal;

end Behavioral;
