library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_a is
    Port (A : in  std_logic_vector(15 downto 0);
          selA : in  std_logic_vector(1 downto 0);
          dataOut : out std_logic_vector(15 downto 0));
end mux_a;

architecture Behavioral of mux_a is

begin

with selA select
    dataOut <= A when "00",
               "0000000000000000" when "01",
               "0000000000000001" when "10",
               A when others;

end Behavioral;
