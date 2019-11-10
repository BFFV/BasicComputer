library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Computer is
    Port (clk : in STD_LOGIC;
          sw : in STD_LOGIC_VECTOR (15 downto 0);
          btnClk : in STD_LOGIC;
          btnFast : in STD_LOGIC;
          btnSel : in STD_LOGIC;
          led : out STD_LOGIC_VECTOR (15 downto 0);
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
          W : out STD_LOGIC;
          selAdd : out STD_LOGIC_VECTOR (1 downto 0);
          incSP : out STD_LOGIC;
          decSP : out STD_LOGIC;
          selPC : out STD_LOGIC;
          selDIn : out STD_LOGIC);
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

component Status is
    Port (status : in STD_LOGIC_VECTOR (2 downto 0);
          clock : in STD_LOGIC;
          statusOut : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component RegA is
    Port (loadA : in STD_LOGIC;
          clock : in STD_LOGIC;
          dataIn : in STD_LOGIC_VECTOR (15 downto 0);
          dataOut : out STD_LOGIC_VECTOR (15 downto 0);
          selA : in STD_LOGIC_VECTOR (1 downto 0);
          valueA : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component RegB is
    Port (loadB : in STD_LOGIC;
          clock : in STD_LOGIC;
          dataIn : in STD_LOGIC_VECTOR (15 downto 0);
          dataOut : out STD_LOGIC_VECTOR (15 downto 0);
          selB : in STD_LOGIC_VECTOR (1 downto 0);
          memIn : in STD_LOGIC_VECTOR (15 downto 0);
          lit : in STD_LOGIC_VECTOR (15 downto 0);
          valueB : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component PC is
    Port (loadPC : in STD_LOGIC;
          clock : in STD_LOGIC;
          countIn : in STD_LOGIC_VECTOR (11 downto 0);
          countOut : out STD_LOGIC_VECTOR (11 downto 0));
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

component fulladder is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          regB : in STD_LOGIC_VECTOR (15 downto 0);
          carryIn : in STD_LOGIC;
          result : out STD_LOGIC_VECTOR (15 downto 0);
          carryOut : out STD_LOGIC);
end component;

component SP is
    Port (inc : in STD_LOGIC;
          dec : in STD_LOGIC;
          clock : in STD_LOGIC;
          dataOut : out STD_LOGIC_VECTOR (11 downto 0));
end component;

signal ins : STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";                      --- Control Instruction From ROM ---
signal swIns : STD_LOGIC_VECTOR (19 downto 0) := "00000000000000000000";                    --- Control Instruction From Switches (Testing) ---
signal statIn : STD_LOGIC_VECTOR (2 downto 0) := "000";                                     --- Status Codes ---
signal statOut : STD_LOGIC_VECTOR (2 downto 0) := "000";                                    --- Status Register Output ---
signal control : STD_LOGIC_VECTOR (16 downto 0) := "00000000000000000";                     --- Control Signals ---
signal DbtnClk : STD_LOGIC := '0';                                                          --- Manual Clock Input ---
signal DbtnFast : STD_LOGIC := '0';                                                         --- Increase Clock Speed ---   
signal DbtnSel : STD_LOGIC := '0';                                                          --- Switch Clock Mode (Manual/Automatic) ---
signal selClk : STD_LOGIC := '0';                                                           --- Clock Selector ---
signal autoClk : STD_LOGIC := '0';                                                          --- Automatic Clock ---
signal clkSpeed : STD_LOGIC_VECTOR (1 downto 0) := "11";                                    --- Automatic Clock Speed ---
signal compClk : STD_LOGIC := '0';                                                          --- Current Clock ---
signal result : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- ALU Result ---
signal memOut : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- RAM Data Out ---
signal romOut : STD_LOGIC_VECTOR (35 downto 0) := "000000000000000000000000000000000000";   --- ROM Instruction Out ---
signal opA : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                          --- ALU Input A ---
signal opB : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                          --- ALU Input B ---
signal valA : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                         --- A Register Value ---
signal valB : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                         --- B Register Value ---
signal romAdd : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";                           --- ROM Address ---
signal romSub : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- ROM Subroutine Address ---
signal subAdd : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                       --- ROM Subroutine Return Address ---
signal subCarry : STD_LOGIC := '0';                                                         --- ROM Subroutine Address Carry ---
signal ramIn : STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000";                        --- RAM Data In ---
signal pcIn : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";                             --- PC Input ---
signal ramAdd : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";                           --- RAM Address ---
signal spOut : STD_LOGIC_VECTOR (11 downto 0) := "000000000000";                            --- SP Data Out ---

begin

------------------------ Clock ------------------------

DClk: Debouncer port map(
    clk => clk,
    signalin => btnClk,
    signalout => DbtnClk);

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

pressClk : process(DbtnClk, selClk, sw)
    begin
        if (rising_edge(DbtnClk) and selClk = '1') then     --- Switches Input (Testing) ---
            swIns(19 downto 16) <= "0000";
            swIns(15 downto 0) <= sw(15 downto 0);
        end if;
end process pressClk;

pressSel : process(DbtnSel, selClk, autoClk, DbtnClk)
    begin
        if (rising_edge(DbtnSel)) then
            selClk <= not selClk;
        end if;
end process pressSel;

with selClk select                                          --- Select Clock ---
    compClk <= autoClk when '0',
               DbtnClk when '1';

pressSpeed : process(DbtnFast, clkSpeed)
    begin
        if (rising_edge(DbtnFast)) then                     --- Increase Clock Speed ---
            clkSpeed(0) <= not clkSpeed(0);
            clkSpeed(1) <= clkSpeed(1) xnor clkSpeed(0);
        end if;
end process pressSpeed;

------------------------ Control Unit ------------------------

CU: ControlUnit port map(
    insIn => ins,
    statusIn => statOut,
    loadA => control(10),
    loadB => control(9),
    selA => control(8 downto 7),
    selB => control(6 downto 5),
    loadPC => control(4),
    selALU => control(3 downto 1),
    W => control(0),
    selAdd => control(12 downto 11),
    incSP => control(13),
    decSP => control(14),
    selPC => control(15),
    selDIn => control(16));

led <= control(16 downto 1);  -- All control signals are shown through the leds, except for W (write to RAM)

------------------------ ALU ------------------------

PU: ALU port map(
    A => opA,
    B => opB,
    selALU => control(3 downto 1),
    dataOut => result,
    C => statIn(0),
    Z => statIn(2),
    N => statIn(1));

------------------------ RAM ------------------------

DMem: RAM port map(
    clock => compClk,
    write => control(0),
    address => romOut(31 downto 20),
    datain => result,
    dataout => memOut);

------------------------ ROM ------------------------

IMem: ROM port map(
    address => romAdd,
    dataout => romOut);
    
ins <= swIns(19 downto 0);  -- 'romOut' for ROM input, 'swIns' for Switches input (Testing)

------------------------ Status Register ------------------------

Stat: Status port map(
    status => statIn,
    clock => compClk,
    statusOut => statOut);

------------------------ A Register ------------------------

A: RegA port map(
    loadA => control(10),
    clock => compClk,
    dataIn => result,
    dataOut => opA,
    selA => control(8 downto 7),
    valueA => valA);

------------------------ B Register ------------------------

B: RegB port map(
    loadB => control(9),
    clock => compClk,
    dataIn => result,
    dataOut => opB,
    selB => control(6 downto 5),
    memIn => memOut,
    lit => romOut(35 downto 20),
    valueB => valB);

------------------------ Program Counter ------------------------

Counter: PC port map(
    loadPC => control(4),
    clock => compClk,
    countIn => pcIn,
    countOut => romAdd);

romSub(11 downto 0) <= romAdd;

------------------------ Display ------------------------

Display: Display_Controller port map(
    dis_a => valA(7 downto 4),
    dis_b => valA(3 downto 0),
    dis_c => valB(7 downto 4),
    dis_d => valB(3 downto 0),
    clk => clk,
    seg => seg,
    an => an);

------------------------ Adder ------------------------

Adder: fulladder port map(
    A => "0000000000000001",
    regB => romSub,
    carryIn => '0',
    result => subAdd,
    carryOut => subCarry);

------------------------ Mux DataIn ------------------------   

with control(16) select
    ramIn <= result when '0',
             subAdd when '1';

------------------------ Mux PC ------------------------   

with control(15) select
    pcIn <= romOut(31 downto 20) when '0',
            memOut(11 downto 0) when '1';

------------------------ Mux Address ------------------------   

with control(12 downto 11) select
    ramAdd <= romOut(31 downto 20) when "00",
              valB(11 downto 0) when "01",
              spOut when "10",
              "000000000000" when others;
 
------------------------ Stack Pointer ------------------------

 StackPointer: SP port map(
    inc => control(13),
    dec => control(14),
    clock => compClk,
    dataOut => spOut);
 
end Behavioral;
