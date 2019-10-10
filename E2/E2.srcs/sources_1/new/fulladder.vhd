library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fulladder is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          regB : in STD_LOGIC_VECTOR (15 downto 0);
          carryIn : in STD_LOGIC;
          result : out STD_LOGIC_VECTOR (15 downto 0);
          carryOut : out STD_LOGIC);
end fulladder;

architecture Behavioral of fulladder is

signal B: STD_LOGIC_VECTOR (15 downto 0);           --- B Input ---
signal carry1 : STD_LOGIC;                          --- Carry Values ---
signal carry2 : STD_LOGIC;
signal carry3 : STD_LOGIC;
signal carry4 : STD_LOGIC;
signal carry5 : STD_LOGIC;
signal carry6 : STD_LOGIC;
signal carry7 : STD_LOGIC;
signal carry8 : STD_LOGIC;
signal carry9 : STD_LOGIC;
signal carry10 : STD_LOGIC;
signal carry11 : STD_LOGIC;
signal carry12 : STD_LOGIC;
signal carry13 : STD_LOGIC;
signal carry14 : STD_LOGIC;
signal carry15 : STD_LOGIC;
signal carry16 : STD_LOGIC;

begin

------------------------ Select ADD/SUB ------------------------

selSign: process(carryIn, regB)
    begin
        case carryIn is
            when '1' => B <= not regB;
            when others => B <= regB;
        end case;
end process selSign;

------------------------ Half Adders ------------------------
-- Bit 1
result(0) <=  A(0) xor B(0) xor carryIn;
carry1 <= ((A(0) xor B(0)) and carryIn) or (A(0) and B(0)); 
-- Bit 2
result(1) <= A(1) xor B(1) xor carry1;
carry2 <= ((A(1) xor B(1)) and carry1) or (A(1) and B(1)); 
-- Bit 3
result(2) <= A(2) xor B(2) xor carry2;
carry3 <= ((A(2) xor B(2)) and carry2) or (A(2) and B(2)); 
-- Bit 4
result(3) <= A(3) xor B(3) xor carry3;
carry4 <= ((A(3) xor B(3)) and carry3) or (A(3) and B(3)); 
-- Bit 5
result(4) <= A(4) xor B(4) xor carry4; 
carry5 <= ((A(4) xor B(4)) and carry4) or (A(4) and B(4)); 
-- Bit 6
result(5) <= A(5) xor B(5) xor carry5;
carry6 <= ((A(5) xor B(5)) and carry5) or (A(5) and B(5)); 
-- Bit 7
result(6) <= A(6) xor B(6) xor carry6;
carry7 <= ((A(6) xor B(6)) and carry6) or (A(6) and B(6)); 
-- Bit 8
result(7) <= A(7) xor B(7) xor carry7;
carry8 <= ((A(7) xor B(7)) and carry7) or (A(7) and B(7)); 
-- Bit 9
result(8) <= A(8) xor B(8) xor carry8;
carry9 <= ((A(8) xor B(8)) and carry8) or (A(8) and B(8)); 
-- Bit 10
result(9) <= A(9) xor B(9) xor carry9;
carry10 <= ((A(9) xor B(9)) and carry9) or (A(9) and B(9)); 
-- Bit 11
result(10) <= A(10) xor B(10) xor carry10;
carry11 <= ((A(10) xor B(10)) and carry10) or (A(10) and B(10)); 
-- Bit 12
result(11) <= A(11) xor B(11) xor carry11;
carry12 <= ((A(11) xor B(11)) and carry11) or (A(11) and B(11)); 
-- Bit 13
result(12) <= A(12) xor B(12) xor carry12;
carry13 <= ((A(12) xor B(12)) and carry12) or (A(12) and B(12)); 
-- Bit 14
result(13) <= A(13) xor B(13) xor carry13;
carry14 <= ((A(13) xor B(13)) and carry13) or (A(13) and B(13)); 
-- Bit 15
result(14) <= A(14) xor B(14) xor carry14;
carry15 <= ((A(14) xor B(14)) and carry14) or (A(14) and B(14)); 
-- Bit 16
result(15) <= A(15) xor B(15) xor carry15;
carry16 <= ((A(15) xor B(15)) and carry15) or (A(15) and B(15)); 

-- Carry Out
carryOut <= carry16;
   
end Behavioral;
