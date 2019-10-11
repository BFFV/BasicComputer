library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is
    Port (loadPC : in STD_LOGIC;
          clock : in STD_LOGIC;
          countIn : in STD_LOGIC_VECTOR (11 downto 0);
          countOut : out STD_LOGIC_VECTOR (11 downto 0));
end PC;

architecture Behavioral of PC is

component Reg is
    Port (clock : in  std_logic;                            -- Se�al del clock.
          load : in  std_logic;                             -- Se�al de carga.
          up : in  std_logic;                               -- Se�al de subida.
          down : in  std_logic;                             -- Se�al de bajada.
          datain : in  std_logic_vector (15 downto 0);      -- Se�ales de entrada de datos.
          dataout : out std_logic_vector (15 downto 0));    -- Se�ales de salida de datos.
end component;

signal counter : std_logic := '1';
signal number : std_logic_vector(15 downto 0);
signal result : std_logic_vector(15 downto 0);

begin
 
PCReg: Reg port map(
    clock => clock,
    load => loadPC,
    up => counter,
    down => '0',
    datain => number,
    dataout => result); 

counter <= not loadPC;
number(11 downto 0) <= countIn;
countOut <= result(11 downto 0);

end Behavioral;
