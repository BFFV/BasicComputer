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
    
    signal shl_salida : STD_LOGIC_VECTOR(15 downto 0);
    signal shl_carry : STD_LOGIC;

    component shift_lft is
        Port( s_entrada : in STD_LOGIC_VECTOR (15 downto 0);
               s_salida : out STD_LOGIC_VECTOR (15 downto 0);
               s_carry: out STD_LOGIC);
    end component;

    signal shr_salida : STD_LOGIC_VECTOR(15 downto 0);
    signal shr_carry : STD_LOGIC;

    component shift_rght is
        Port( s_entrada : in STD_LOGIC_VECTOR (15 downto 0);
               s_salida : out STD_LOGIC_VECTOR (15 downto 0);
               s_carry : out STD_LOGIC);
    end component;

begin
    --- Se conectan los puestos
                           
   SHLf: shift_lft PORT MAP (s_entrada => A, s_salida => shl_salida, s_carry => shl_carry); --ver si el s_carry es => C, ver la orientacion de '=>'.
   SHLr: shift_rght PORT MAP (s_entrada => A, s_salida => shr_salida, s_carry => shr_carry);
    
   --- Se definen variables que se puedan necesitar para cada modulo


  --- Aquí se realiza la asignacion da los datos de salida de la ALU
        
   -- shift left
   with selALU select
        dataOut <= shr_salida when "110", "0000000000000000" when others; -- no cache bien para que son los "0000000000000000"
   with selALU select
        C <= shr_carry when "110", '0' when others;
   with selALU select
        Z <= '0' when "110",'0' when others;
   with selALU select
        N <= '0' when "110", '0' when others;
        
   -- shift right
   with selALU select
        dataOut <= shl_salida when "111", "0000000000000000" when others;
   with selALU select
        C <= shl_carry when "111", '0' when others;
   with selALU select
        Z <= '0' when "111", '0' when others;
   with selALU select
        N <= '0' when "111", '0' when others;   



end Behavioral;
