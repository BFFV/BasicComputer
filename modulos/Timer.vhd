library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Timer is
    Port ( clk : in STD_LOGIC;
           seconds : out STD_LOGIC_VECTOR (15 downto 0);
           mseconds: out STD_LOGIC_VECTOR (15 downto 0);
           useconds: out STD_LOGIC_VECTOR (15 downto 0));
           
end Timer;

architecture Behavioral of Timer is

constant max      : std_logic_vector(6 downto 0)  := "1100011"; -- 99
constant timermax : std_logic_vector(15 downto 0) := "0000001111100111"; -- 999
signal   counter  : std_logic_vector(6 downto 0)  := (others => '0');

signal stimer     : std_logic_vector(15 downto 0) := (others => '0');
signal mtimer    : std_logic_vector(15 downto 0) := (others => '0');
signal utimer    : std_logic_vector(15 downto 0) := (others => '0');

begin
    
timer_prosses : process (clk)
    begin
        if (rising_edge(clk)) then
            if (counter = max) then
                counter <= (others => '0');
                if(utimer = timermax) then
                    utimer  <= (others => '0');
                    if(mtimer = timermax) then
                        mtimer  <= (others => '0');
                        stimer  <= stimer + 1;
                    else
                        mtimer  <= mtimer + 1;
                    end if;
                else
                    utimer  <= utimer + 1;
                end if;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
seconds  <= stimer;
mseconds <= mtimer;
useconds <= utimer;

end Behavioral;
