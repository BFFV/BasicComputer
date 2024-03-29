library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegLed is
    Port (dataIn : in STD_LOGIC_VECTOR (15 downto 0);
          clock : in STD_LOGIC;
          loadLed : in STD_LOGIC;
          dataOut : out STD_LOGIC_VECTOR (15 downto 0));
end RegLed;

architecture Behavioral of RegLed is

component Reg is
    Port (clock : in  std_logic;                            -- Se�al del clock.
          load : in  std_logic;                             -- Se�al de carga.
          up : in  std_logic;                               -- Se�al de subida.
          down : in  std_logic;                             -- Se�al de bajada.
          datain : in  std_logic_vector (15 downto 0);      -- Se�ales de entrada de datos.
          dataout : out std_logic_vector (15 downto 0));    -- Se�ales de salida de datos.
end component;

begin

RLed: Reg port map (
    clock => clock,
    load => loadLed,
    up => '0',
    down => '0',
    datain => dataIn,
    dataout => dataOut); 

end Behavioral;
