library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
USE IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port ( clk : in  std_logic;
           signalin : in  std_logic;
           signalout : out  std_logic);
end Debouncer;

architecture Behavioral of Debouncer is

constant regmax : std_logic_vector := "1111111111111111";
signal counter : std_logic_vector(15 downto 0) := (others => '0');
signal result : std_logic := '1';

begin

debounce_process : process (clk)
begin
   if (rising_edge(clk)) then
      if (counter = regmax) then
         result <= not result;
      end if;
   end if;
end process;

counter_process : process (clk)
begin
	if (rising_edge(clk)) then
        if ((result = '1') xor (signalin = '1')) then
            if (counter = regmax) then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        else
            counter <= (others => '0');
        end if;
	end if;
end process;

signalout <= result;

end Behavioral;

