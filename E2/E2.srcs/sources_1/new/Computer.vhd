library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Computer is
    Port (clk : in STD_LOGIC;
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          btnClk : in STD_LOGIC;
          btnSlow : in STD_LOGIC;
          btnFast : in STD_LOGIC;
          btnSel : in STD_LOGIC;
          led : out STD_LOGIC_VECTOR (10 downto 0);
          seg : out STD_LOGIC_VECTOR (7 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0));
end Computer;

architecture Behavioral of Computer is

component ALU is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          B : in STD_LOGIC_VECTOR (15 downto 0);
          selALU : in STD_LOGIC_VECTOR (2 downto 0);
          dataOut : out STD_LOGIC_VECTOR (15 downto 0);
          C : out STD_LOGIC;
          Z : out STD_LOGIC;
          N : out STD_LOGIC);
end component;

component ControlUnit is
    Port (insIn : in STD_LOGIC_VECTOR (19 downto 0);
          statusIn : in STD_LOGIC_VECTOR (2 downto 0);
          loadA : out STD_LOGIC;
          loadB : out STD_LOGIC;
          selA : out STD_LOGIC_VECTOR (1 downto 0);
          selB : out STD_LOGIC_VECTOR (1 downto 0);
          loadPC : out STD_LOGIC;
          selALU : out STD_LOGIC_VECTOR (2 downto 0);
          W : out STD_LOGIC);
end component;

component RAM is
    Port (clock : in STD_LOGIC;
          write : in STD_LOGIC;
          address : in STD_LOGIC_VECTOR (11 downto 0);
          datain : in STD_LOGIC_VECTOR (15 downto 0);
          dataout : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ROM is
    Port (address : in STD_LOGIC_VECTOR (11 downto 0);
          dataout : out STD_LOGIC_VECTOR (35 downto 0));
end component;

component Display_Controller is
    Port (dis_a : in STD_LOGIC_VECTOR (3 downto 0);
          dis_b : in STD_LOGIC_VECTOR (3 downto 0);
          dis_c : in STD_LOGIC_VECTOR (3 downto 0);
          dis_d : in STD_LOGIC_VECTOR (3 downto 0);
          clk : in STD_LOGIC;
          seg : out STD_LOGIC_VECTOR (7 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Debouncer is
    Port (clk : in STD_LOGIC;
          signalin : in STD_LOGIC;
          signalout : out STD_LOGIC);
end component;

component Clock_Divider is
    Port (clk : in STD_LOGIC;
          speed : in STD_LOGIC_VECTOR (1 downto 0);
          clock : out STD_LOGIC);
end component;

signal ins : STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";                      --- Control Instruction From ROM ---
signal swIns : STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";                    --- Control Instruction From Switches (Testing) ---
signal statIn : STD_LOGIC_VECTOR (2 downto 0) := "000";                                     --- Status Codes ---
signal statOut : STD_LOGIC_VECTOR (2 downto 0) := "000";                                    --- Status Register Output ---
signal control : STD_LOGIC_VECTOR (10 downto 0) := "00000000000";                           --- Control Signals ---
signal DbtnClk : STD_LOGIC := '0';                                                          --- Manual Clock Input ---
signal DbtnSlow : STD_LOGIC := '0';                                                         --- Decrease Clock Speed ---
signal DbtnFast : STD_LOGIC := '0';                                                         --- Increase Clock Speed ---   
signal DbtnSel : STD_LOGIC := '0';                                                          --- Switch Clock Mode (Manual/Automatic) ---
signal selClk : STD_LOGIC := '0';                                                           --- Clock Selector ---
signal autoClk : STD_LOGIC := '0';                                                          --- Automatic Clock ---
signal clkSpeed : STD_LOGIC_VECTOR (1 downto 0) := "11";                                    --- Automatic Clock Speed ---
signal compClk : STD_LOGIC := '0';                                                          --- Current Clock ---
signal result : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- ALU Result ---
signal memOut : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- RAM Data Out ---
signal romOut : STD_LOGIC_VECTOR (35 downto 0) := "000000000000000000000000000000000000";   --- ROM Instruction Out ---

begin

------------------------ Clock ------------------------

DClk: Debouncer port map(
    clk => clk,
    signalin => btnClk,
    signalout => DbtnClk);

DSlow: Debouncer port map(
    clk => clk,
    signalin => btnSlow,
    signalout => DbtnSlow);

DFast: Debouncer port map(
    clk => clk,
    signalin => btnFast,
    signalout => DbtnFast);

DSel: Debouncer port map(
    clk => clk,
    signalin => btnSel,
    signalout => DbtnSel);

ClkDivider: Clock_Divider port map(
    clk => clk,
    speed => clkSpeed,
    clock => autoClk);

btnPress : process(DbtnClk, DbtnSlow, DbtnFast, DbtnSel, autoClk, selClk, clkSpeed)
    begin
        if (rising_edge(DbtnSlow) and (clkSpeed /= "11")) then
            clkSpeed(1) <= clkSpeed(1) xor clkSpeed(0);
            clkSpeed(0) <= not clkSpeed(0);
        end if;
        if (rising_edge(DbtnFast) and (clkSpeed /= "00")) then
            clkSpeed(1) <= clkSpeed(1) xnor clkSpeed(0);
            clkSpeed(0) <= not clkSpeed(0);
        end if;
        if (rising_edge(DbtnClk) and selClk = '1') then     --- Switches Input (Testing) ---
            swIns(19 downto 16) <= "0000";
            swIns(15 downto 0) <= sw(15 downto 0);
        end if;
        if (rising_edge(DbtnSel)) then
            selClk <= not selClk;
        end if;
        case selClk is                                      --- Select Clock ---
            when '0' => compClk <= autoClk;
            when '1' => compClk <= DbtnClk;
        end case;
end process btnPress;

------------------------ Control Unit ------------------------

CU: ControlUnit port map(
    insIn => ins,
    statusIn => statOut(2 downto 0),
    loadA => control(10),
    loadB => control(9),
    selA => control(8 downto 7),
    selB => control(6 downto 5),
    loadPC => control(4),
    selALU => control(3 downto 1),
    W => control(0));

led <= control;

------------------------ ALU ------------------------

PU: ALU port map(
    A => "0000000000000001",
    B => "1111111111111111",
    selALU => control(3 downto 1),
    dataOut => result,
    C => statIn(0),
    Z => statIn(2),
    N => statIn(1));

------------------------ RAM ------------------------

DMem: RAM port map(
    clock => compClk,
    write => control(0),
    address => "000000000000",
    datain => result,
    dataout => memOut);

------------------------ ROM ------------------------

IMem: ROM port map(
    address => "000000000000",
    dataout => romOut);
    
ins <= romOut(19 downto 0);  -- 'romOut' for ROM input, 'swIn' for Switches input (Testing)

------------------------ Display ------------------------

Display: Display_Controller port map(
    dis_a => result(7 downto 4),
    dis_b => result(3 downto 0),
    dis_c => result(7 downto 4),
    dis_d => result(3 downto 0),
    clk => clk,
    seg => seg,
    an => an);

end Behavioral;
