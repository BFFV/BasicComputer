library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecoderOut is
    Port (portIn : in STD_LOGIC_VECTOR (15 downto 0);
          loadOut : in STD_LOGIC;
          disOut : out STD_LOGIC;
          ledOut : out STD_LOGIC);
end DecoderOut;

architecture Behavioral of DecoderOut is

begin

with portIn select
    disOut <= loadOut when "0000000000000000",
              '0' when others;

with portIn select
    ledOut <= loadOut when "0000000000000001",
              '0' when others;

end Behavioral;
