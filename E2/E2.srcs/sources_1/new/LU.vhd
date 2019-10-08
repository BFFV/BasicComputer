----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2019 18:31:01
-- Design Name: 
-- Module Name: LU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LU is
    Port (  A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           op : in STD_LOGIC_VECTOR(2 downto 0);
           resultado : out STD_LOGIC_VECTOR (15 downto 0);
           Zlu : out STD_LOGIC);
end LU;


architecture Behavioral of LU is

signal A1 : STD_LOGIC_VECTOR(15 downto 0);

   begin
   with op select
        resultado <= A and B when "010",
                     A or B when "011",
                     A xor B when "100",
                     not A when "101",
                     "0000000000000000" when others;
    with op select
        A1 <= A and B when "010",
                     A or B when "011",
                     A xor B when "100",
                     not A when "101",
                     "0000000000000000" when others;
     
     Zlu <= not(A1(0) or A1(1) or A1(2) or A1(3) or A1(4) or A1(5) or A1(6) or A1(7) or A1(8) or A1(9) or A1(10) or A1(11)or A1(12) or A1(13) or A1(14) or A1(15));


end Behavioral;
