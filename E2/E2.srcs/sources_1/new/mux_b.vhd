library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_b is
 Port (B : in  std_logic_vector(15 downto 0);
       selB : in  std_logic_vector(1 downto 0);
       Lit : in std_logic_vector(15 downto 0);
       DRam : in std_logic_vector(15 downto 0);
       dataOut : out std_logic_vector(15 downto 0));
end mux_b;

architecture Behavioral of mux_b is

begin

with selB select
    dataOut <= B when "00",
               "0000000000000000" when "01",
               Lit when "10",
               DRam when "11";

end Behavioral;
