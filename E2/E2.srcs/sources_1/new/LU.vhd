library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LU is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          B : in STD_LOGIC_VECTOR (15 downto 0);
          op : in STD_LOGIC_VECTOR(2 downto 0);
          resultado : out STD_LOGIC_VECTOR (15 downto 0));
end LU;

architecture Behavioral of LU is

begin

with op select
    resultado <= A and B when "010",
                 A or B when "011",
                 not A when "100",
                 A xor B when "101",
                 "0000000000000000" when others;

end Behavioral;
