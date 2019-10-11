----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 01:25:29
-- Design Name: 
-- Module Name: PC - Behavioral
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
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port ( loadPC : in STD_LOGIC;
           clock : in STD_LOGIC;
           countIn : in STD_LOGIC_VECTOR (11 downto 0);
           countOut : out STD_LOGIC_VECTOR (11 downto 0));
end PC;

architecture Behavioral of PC is

component Reg is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (11 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (11 downto 0));  -- Señales de salida de datos.
end component;


signal loader : std_logic;
signal result : std_logic_vector(11 downto 0);

begin
loader <= not(loadPC);
 
PC : Reg port map(
                  clock => clock,
                  load => loadPC,
                  up => loader,
                  down => '0',
                  datain => countin,
                  dataout => countout   
                    ); 



end Behavioral;
