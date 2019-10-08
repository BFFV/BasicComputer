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
    signal carryIn : STD_LOGIC;
    signal cFulladder : STD_LOGIC;
    signal nFulladder : STD_LOGIC;
    signal zFulladder : STD_LOGIC;
    signal resultFulladder: STD_LOGIC_VECTOR(15 downto 0);
    signal zLU        : STD_LOGIC;
    signal resultLU: STD_LOGIC_VECTOR(15 downto 0);
    
  component fulladder is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           regB : in STD_LOGIC_VECTOR (15 downto 0);
           carryIn : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
    end component;
    
  component LU is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           op : in STD_LOGIC_VECTOR(2 downto 0);
           resultado : out STD_LOGIC_VECTOR (15 downto 0);
           Zlu : out STD_LOGIC);
    end component;
begin
   --- Se conectan los puestos
   G1: fulladder port map (A => A,
                           regB => B,
                           carryIn => carryIn,  
                           C => cFulladder,
                           Z => zFulladder,
                           N => nFulladder,
                           result => resultFulladder);
   L1: LU port map (A => A,
                    B => B,
                    Zlu => zLU,
                    op => SelALU,
                    resultado => resultLU ) ;
                    
   --- Se definen variables que se puedan necesitar para cada modulo
   carryIn <= selALU(0);


  --- Aquí se realiza la asignacion da los datos de salida de la ALU
   with selALU select
        dataOut <= resultFulladder when "000",
                   resultFulladder when "001",
                   resultLU when "010",
                   resultLU when "011",
                   resultLU when "100",
                   resultLU when "101",
          "0000000000000000" when others;
          
   with selALU select
        C <= cFulladder when "000", cFulladder when "001", '0' when others;
   with selALU select
                   Z <= zFulladder when "000", 
                   zFulladder when "001", 
                   zLU when "010",
                   zLU when "011",
                   zLU when "100",
                   zLU when "101",
                   '0' when others;
                   
   with selALU select
        N <= nFulladder when "000", nFulladder when "001", '0' when others;
                                 

     

end Behavioral;
