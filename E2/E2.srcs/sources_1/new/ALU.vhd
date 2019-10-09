library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          B : in STD_LOGIC_VECTOR (15 downto 0);
          selALU : in STD_LOGIC_VECTOR (2 downto 0);
          dataOut : out STD_LOGIC_VECTOR (15 downto 0);
          C : out STD_LOGIC;
          Z : out STD_LOGIC;
          N : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is

component shift_lft is
    Port(s_in : in STD_LOGIC_VECTOR (15 downto 0);
         s_out : out STD_LOGIC_VECTOR (15 downto 0);
         s_carry: out STD_LOGIC);
end component;

component shift_rght is
    Port(s_in : in STD_LOGIC_VECTOR (15 downto 0);
         s_out : out STD_LOGIC_VECTOR (15 downto 0);
         s_carry : out STD_LOGIC);
end component;

signal shl_salida : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";    --- SHL Output ---
signal shl_carry : STD_LOGIC := '0';                                        --- SHL Carry ---
signal shr_salida : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";    --- SHR Output ---
signal shr_carry : STD_LOGIC := '0';                                        --- SHR Carry ---
signal result : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";        --- ALU Output ---
signal resA : STD_LOGIC := '0';                                             --- Checks Z Status ---
signal resB : STD_LOGIC := '0';                                             --- Checks Z Status ---

begin

SHLft: shift_lft port map(
    s_in => A,
    s_out => shl_salida,
    s_carry => shl_carry);

SHRght: shift_rght port map(
    s_in => A,
    s_out => shr_salida,
    s_carry => shr_carry);

------------------------ Select Operation ------------------------

selOp: process(selALU, shl_salida, shl_carry, shr_salida, shr_carry)
    begin
        case selALU is
            when "110" => result <= shl_salida; C <= shl_carry;
            when "111" => result <= shr_salida; C <= shr_carry;
            when others => result <= "0000000000000000";
        end case;
end process selOp;

dataOut <= result;

------------------------ Z/N Status Codes ------------------------
resA <= ((result(0) or result(1)) or (result(2) or result(3))) or
 ((result(4) or result(5)) or (result(6) or result(7)));
resB <= ((result(8) or result(9)) or (result(10) or result(11))) or
 ((result(12) or result(13)) or (result(14) or result(15)));
Z <= resA nor resB;
N <= result(15);

end Behavioral;

