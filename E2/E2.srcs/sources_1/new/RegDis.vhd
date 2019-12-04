library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegDis is
    Port (dataIn : in STD_LOGIC_VECTOR (15 downto 0);
          clock : in STD_LOGIC;
          loadDis : in STD_LOGIC;
          dataOut : out STD_LOGIC_VECTOR (15 downto 0));
end RegDis;

architecture Behavioral of RegDis is

component Reg is
    Port (clock : in  std_logic;                            -- Señal del clock.
          load : in  std_logic;                             -- Señal de carga.
          up : in  std_logic;                               -- Señal de subida.
          down : in  std_logic;                             -- Señal de bajada.
          datain : in  std_logic_vector (15 downto 0);      -- Señales de entrada de datos.
          dataout : out std_logic_vector (15 downto 0));    -- Señales de salida de datos.
end component;

begin

RDis: Reg port map (
    clock => clock,
    load => loadDis,
    up => '0',
    down => '0',
    datain => dataIn,
    dataout => dataOut); 

end Behavioral;
