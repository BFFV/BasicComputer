----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 01:25:29
-- Design Name: 
-- Module Name: RegB - Behavioral
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

entity RegB is
    Port ( loadB : in STD_LOGIC;
           clock : in STD_LOGIC;
           dataIn : in STD_LOGIC_VECTOR (15 downto 0);
           dataOut : out STD_LOGIC_VECTOR (15 downto 0);
           selB : in STD_LOGIC_VECTOR (1 downto 0);
           memIn : in STD_LOGIC_VECTOR (15 downto 0);
           lit : in STD_LOGIC_VECTOR (15 downto 0));
           
end RegB;

architecture Behavioral of RegB is

component Reg is
    Port ( clock    : in  std_logic;                        -- Señal del clock (reducido).
           load     : in  std_logic;                        -- Señal de carga.
           up       : in  std_logic;                        -- Señal de subida.
           down     : in  std_logic;                        -- Señal de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Señales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Señales de salida de datos.
end component;

component mux_b is
 Port (  
      B      : in  std_logic_vector(15 downto 0);
      SelB     : in  std_logic_vector(1 downto 0);
      Lit      : in std_logic_vector(15 downto 0);
      DRam     : in std_logic_vector(15 downto 0);
      DataOut       : out std_logic_vector(15 downto 0) );
end component;

signal mux_out : std_logic_vector(15 downto 0);
signal reg_out : std_logic_vector(15 downto 0);


begin
 
Ra: Reg port map (
           clock => clock,
           load => loadB,
           up => '0'    ,
           down => '0'   ,
           datain => DataIn  ,
           dataout => reg_out
                    ); 

Ma: mux_b port map(
                    B => reg_out,
                    Dram => memin, 
                    selB => selB,
                    lit => lit,                 
                    DataOut => mux_out
                       ); 
dataout <= mux_out;


end Behavioral;
