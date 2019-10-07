----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 01:25:29
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           selALU : in STD_LOGIC_VECTOR (2 downto 0);
           dataOut : out STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
   component fulladder is
    signal carryIn : STD_LOGIC;
    signal cFulladder : STD_LOGIC;
    signal nFulladder : STD_LOGIC;
    signal zFulladder : STD_LOGIC;
    signal resultFulladder : STD_LOGIC
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           regB : in STD_LOGIC_VECTOR (15 downto 0);
           carryIn : in STD_LOGIC_VECTOR(15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
end component;
begin
   --- Se conectan los puestos
   G1: fulladder port map (A, B, carryIn, resultFulladder, cFulladder,zFulladder,nFulladder);

   --- Se definen variables que se puedan necesitar para cada modulo
   carryIn <= selALU(0);


  --- Aquí se realiza la asignacion da los datos de salida de la ALU
   with selALU select
        dataOut <= resultFulladder when "000", resultFulladder when "010", "0000000000000000" when others;
   with selALU select
        C <= cFullader when "000", cFulladder when "010", "0000000000000000" when others;
   with selALU select
        Z <= zFulladder when "000", zFulladder when "010", "0000000000000000" when others;
   with selALU select
        N <= nFulladder when "000", nFulladder when "010", "0000000000000000" when others;
                                 

        






end Behavioral;
