----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.10.2019 01:25:29
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (15 downto 0);
           B : in STD_LOGIC_VECTOR (15 downto 0);
           carryIn: in STD_LOGIC;
           dataOut : out STD_LOGIC_VECTOR (15 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    signal carry1 : STD_LOGIC;
    signal carry2 : STD_LOGIC;
    signal carry3 : STD_LOGIC;
    signal carry4 : STD_LOGIC;
    signal carry5 : STD_LOGIC;
    signal carry6 : STD_LOGIC;
    signal carry7 : STD_LOGIC;
    signal carry8 : STD_LOGIC;
    signal carry9 : STD_LOGIC;
    signal carry10 : STD_LOGIC;
    signal carry11 : STD_LOGIC;
    signal carry12 : STD_LOGIC;
    signal carry13 : STD_LOGIC;
    signal carry14 : STD_LOGIC;
    signal carry15 : STD_LOGIC;

begin
    -- Bit 1
    dataOut(0) <= (B(0) xor carryIn) xor A(0);
    carry1 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0)); 
    -- Bit 2
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    carry2 <= (B(1) and carry1) or (A(1) and carry1) or (A(1) and B(1));
    -- Bit 3
    dataOut(2) <= (B(2) xor carry2) xor A(2);
    carry3 <= (B(2) and carry2) or (A(2) and carry2) or (A(2) and B(2));
    -- Bit 4
    carry4 <= (B(3) and carry3) or (A(3) and carry3) or (A(3) and B(3));
    dataOut(3) <= (B(3) xor carry2) xor A(3);
    -- Bit 5
    carry5 <= (B(4) and carry4) or (A(4) and carry4) or (A(4) and B(4));
    dataOut(4) <= (B(3) xor carry3) xor A(3);    
    -- Bit 6
    carry6 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(5) <= (B(1) xor carry1) xor A(1);
    -- Bit 7
    carry7 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 8
    carry8 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 9
    carry9 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 10
    carry10 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 11
    carry11 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
   -- Bit 12
    carry12 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 13
    carry13 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 14
    carry14 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 15
    carry15 <= (B(0) and carryIn) or (A(0) and carryIn) or (A(0) and B(0));
    dataOut(1) <= (B(1) xor carry1) xor A(1);
    -- Bit 16
    
    dataOut(1) <= (B(1) xor carry1) xor A(1);
end Behavioral;
