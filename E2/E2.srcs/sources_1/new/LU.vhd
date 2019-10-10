library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LU is
    Port (A : in STD_LOGIC_VECTOR (15 downto 0);
          B : in STD_LOGIC_VECTOR (15 downto 0);
          op : in STD_LOGIC_VECTOR(2 downto 0);
          resultado : out STD_LOGIC_VECTOR (15 downto 0));
end LU;

architecture Behavioral of LU is

begin

selOp: process(op, A, B)
    begin
        case op is
            when "010" => resultado <= A and B;
            when "011" => resultado <= A or B;
            when "100" => resultado <= not A;
            when "101" => resultado <= A xor B;
            when others => resultado <= "0000000000000000";
        end case;
end process selOp;

end Behavioral;
