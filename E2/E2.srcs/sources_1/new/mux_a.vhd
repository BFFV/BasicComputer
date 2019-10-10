----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2019 19:38:25
-- Design Name: 
-- Module Name: mux_a - Behavioral
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

entity mux_a is
    Port (  
      A      : in  std_logic_vector(15 downto 0);
      SelA     : in  std_logic_vector(1 downto 0);
      DataOut       : out std_logic_vector(15 downto 0) );
end mux_a;

architecture Behavioral of mux_a is

begin

with SelA select
    DataOut <= A when "00",
       "0000000000000001" when "10",
       "0000000000000000" when "01",
       A when others;

end Behavioral;
