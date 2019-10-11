library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegA is
    Port (loadA : in STD_LOGIC;
          clock : in STD_LOGIC;
          dataIn : in STD_LOGIC_VECTOR (15 downto 0);
          dataOut : out STD_LOGIC_VECTOR (15 downto 0);
          selA : in STD_LOGIC_VECTOR (1 downto 0);
          valueA : out STD_LOGIC_VECTOR (15 downto 0));
end RegA;

architecture Behavioral of RegA is

component Reg is
    Port (clock : in  std_logic;                            -- Señal del clock.
          load : in  std_logic;                             -- Señal de carga.
          up : in  std_logic;                               -- Señal de subida.
          down : in  std_logic;                             -- Señal de bajada.
          datain : in  std_logic_vector (15 downto 0);      -- Señales de entrada de datos.
          dataout : out std_logic_vector (15 downto 0));    -- Señales de salida de datos.
end component;

component mux_a is
    Port (A : in  std_logic_vector(15 downto 0);
          selA : in  std_logic_vector(1 downto 0);
          dataOut : out std_logic_vector(15 downto 0));
end component;

signal mux_out : std_logic_vector(15 downto 0);
signal reg_out : std_logic_vector(15 downto 0);

begin
 
Ra: Reg port map (
    clock => clock,
    load => loadA,
    up => '0',
    down => '0',
    datain => dataIn,
    dataout => reg_out); 

Ma: mux_a port map(
    A => reg_out,
    selA => selA,              
    dataOut => mux_out);

dataout <= mux_out;
valueA <= reg_out;

end Behavioral;
