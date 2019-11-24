library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
    Port ( insIn : in STD_LOGIC_VECTOR (19 downto 0);
           statusIn : in STD_LOGIC_VECTOR (2 downto 0);
           loadA : out STD_LOGIC;
           loadB : out STD_LOGIC;
           selA : out STD_LOGIC_VECTOR (1 downto 0);
           selB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selALU : out STD_LOGIC_VECTOR (2 downto 0);
           W : out STD_LOGIC;
           selAdd : out STD_LOGIC_VECTOR (1 downto 0);
           incSP : out STD_LOGIC;
           decSP : out STD_LOGIC;
           selPC : out STD_LOGIC;
           selDIn : out STD_LOGIC;
           loadOut : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is

signal movOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- MOV Configuration ---
signal opOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";      --- ADD/SUB/AND/OR/XOR Configuration ---
signal shnOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- NOT/SHL/SHR Configuration ---
signal incOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- INC/DEC Configuration ---
signal cmpOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- CMP Configuration ---
signal jmpOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- JMP/JEQ/JNE/JGT/JGE/JLT/JLE/JCR Configuration ---
signal pushOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";    --- CALL/PUSH Configuration ---
signal popOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";     --- RET/POP Configuration ---
signal inputOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";   --- IN Configuration ---
signal outputOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";  --- OUT Configuration ---
signal muxStat : STD_LOGIC := '0';                                          --- Conditional JMP Muxer ---
signal selectOut : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";  --- Control Signals ---

begin

------------------------ MOV ------------------------
movOut(0) <= insIn(8) nor insIn(9);
movOut(4 downto 1) <= "0000";
movOut(8 downto 5) <= insIn(7 downto 4);
movOut(10 downto 9) <= insIn(9 downto 8);
movOut(11) <= insIn(10);
movOut(17 downto 12) <= "000000";

------------------------ ADD/SUB/AND/OR/XOR ------------------------
opOut(0) <= insIn(9) nor insIn(10);
opOut(3 downto 1) <= insIn(6 downto 4);
opOut(4) <= '0';
opOut(6 downto 5) <= insIn(8 downto 7);
opOut(8 downto 7) <= "00";
opOut(10 downto 9) <= insIn(10 downto 9);
opOut(11) <= insIn(11);
opOut(17 downto 12) <= "000000";

------------------------ NOT/SHL/SHR ------------------------
shnOut(0) <= insIn(6) nor insIn(7);
shnOut(2 downto 1) <= insIn(5 downto 4);
shnOut(8 downto 3) <= "000001";
shnOut(10 downto 9) <= insIn(7 downto 6);
shnOut(11) <= insIn(8);
shnOut(17 downto 12) <= "000000";

------------------------ INC/DEC ------------------------
incOut(0) <= incOut(9) nor incOut(10);
incOut(1) <= insIn(4);
incOut(4 downto 2) <= "000";
incOut(6 downto 5) <= insIn(6 downto 5);
incOut(7) <= '0';
incOut(8) <= insIn(5) xnor insIn(6);
incOut(9) <= insIn(5) nor insIn(6);
incOut(10) <= insIn(5) xor insIn(6);
incOut(11) <= insIn(7);
incOut(17 downto 12) <= "000000";

------------------------ CMP ------------------------
cmpOut(4 downto 0) <= "00010";
cmpOut(6 downto 5) <= insIn(5 downto 4);
cmpOut(10 downto 7) <= "0000";
cmpOut(11) <= insIn(6);
cmpOut(17 downto 12) <= "000000";

------------------------ JMP/JEQ/JNE/JGT/JGE/JLT/JLE/JCR ------------------------
jmpOut(3 downto 0) <= "0000";

with insIn(6 downto 4) select
    muxStat <= statusIn(2) when "001",
               statusIn(1) when "010",
               statusIn(1) or statusIn(2) when "011",
               statusIn(0) when "100",
               '0' when others;

jmpOut(4) <= insIn(7) xnor muxStat;
jmpOut(17 downto 5) <= "0000000000000";

------------------------ CALL/PUSH ------------------------
pushOut(3 downto 0) <= "0001";
pushOut(4) <= insIn(5);
pushOut(5) <= not insIn(4);
pushOut(6) <= '0';
pushOut(7) <= insIn(4);
pushOut(15 downto 8) <= "01010000";
pushOut(16) <= insIn(5);
pushOut(17) <= '0';

------------------------ RET/POP ------------------------
popOut(3 downto 0) <= "0000";
popOut(4) <= insIn(6);
popOut(8 downto 5) <= "0111";
popOut(9) <= insIn(4);
popOut(10) <= insIn(5);
popOut(12 downto 11) <= "10";
popOut(13) <= (insIn(4) or insIn(5)) nor insIn(6);
popOut(17 downto 14) <= "0010";

------------------------ IN ------------------------
inputOut(0) <= insIn(4) nor insIn(5);
inputOut(8 downto 1) <= "11010000";
inputOut(9) <= insIn(4);
inputOut(10) <= insIn(5);
inputOut(17 downto 11) <= "0000001";

------------------------ OUT ------------------------
outputOut(4 downto 0) <= "00000";
outputOut(6 downto 5) <= insIn(5 downto 4);
outputOut(10 downto 7) <= "0000";
outputOut(11) <= insIn(6);
outputOut(16 downto 12) <= "00000";
outputOut(17) <= '1';

------------------------ Select Operation ------------------------

with insIn(3 downto 0) select
    selectOut <= movOut when "0001",
                 opOut when "0010",
                 shnOut when "0011",
                 incOut when "0100",
                 cmpOut when "0101",
                 jmpOut when "0110",
                 pushOut when "0111",
                 popOut when "1000",
                 inputOut when "1001",
                 outputOut when "1010",
                 "000000000000000000" when others;

loadOut <= selectOut(17);
selDIn <= selectOut(16);
selPC <= selectOut(15);
decSP <= selectOut(14);
incSP <= selectOut(13);
selAdd <= selectOut(12 downto 11);
loadA <= selectOut(10);
loadB <= selectOut(9);
selA <= selectOut(8 downto 7);
selB <= selectOut(6 downto 5);
loadPC <= selectOut(4);
selALU <= selectOut(3 downto 1);
W <= selectOut(0);

end Behavioral;
