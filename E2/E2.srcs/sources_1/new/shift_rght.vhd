library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_rght is
    Port (s_in : in STD_LOGIC_VECTOR (15 downto 0);
          s_out : out STD_LOGIC_VECTOR (15 downto 0);
          s_carry : out STD_LOGIC);
end shift_rght;

architecture Behavioral of shift_rght is

begin

s_out(15) <= '0';
s_out(14) <= s_in(15);
s_out(13) <= s_in(14);
s_out(12) <= s_in(13);
s_out(11) <= s_in(12);
s_out(10) <= s_in(11);
s_out(9) <= s_in(10);
s_out(8) <= s_in(9);
s_out(7) <= s_in(8);
s_out(6) <= s_in(7);
s_out(5) <= s_in(6);
s_out(4) <= s_in(5);
s_out(3) <= s_in(4);
s_out(2) <= s_in(3);
s_out(1) <= s_in(2);
s_out(0) <= s_in(1);
s_carry <= s_in(0);

end Behavioral;
