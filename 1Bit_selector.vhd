----------------------------------------------------------------------------------
-- component --
-- Create Date:    10:13:56 03/22/2025 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Selector_1bit is
    Port ( Input : in  STD_LOGIC;
           Sel1,Sel2 : out  STD_LOGIC);
end Selector_1bit;

architecture Behavioral of Selector_1bit is
	
	signal tmp1 : STD_LOGIC := '0';
	signal tmp2 : STD_LOGIC := '0';
	
begin
	
	process (Input)
	begin
		if (Input = '0') then
			tmp1 <= '1';
			tmp2 <= '0';
		else
			tmp1 <= '0';
			tmp2 <= '1';
		end if;
	end process;
	
	Sel1 <= tmp1;
	Sel2 <= tmp2;
	
end Behavioral;
