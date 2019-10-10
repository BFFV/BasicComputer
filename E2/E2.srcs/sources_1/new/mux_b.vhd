----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2019 19:40:56
-- Design Name: 
-- Module Name: mux_b - Behavioral
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

entity mux_b is
 Port (  
      B      : in  std_logic_vector(15 downto 0);
      SelB     : in  std_logic_vector(1 downto 0);
      Lit      : in std_logic_vector(15 downto 0);
      DRam     : in std_logic_vector(15 downto 0);
      DataOut       : out std_logic_vector(15 downto 0) );
end mux_b;

architecture Behavioral of mux_b is

begin

with SelB select
    DataOut <= B when "00",
       Lit when "10",
       "0000000000000000" when "01",
       DRam when "11",
       B when others;

end Behavioral;
