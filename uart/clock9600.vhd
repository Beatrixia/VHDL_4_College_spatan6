----------------------------------------------------------------------------------
-- component --
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clk9600 is
    Port ( clk_in, rst : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end clk9600;

architecture Behavioral of clk9600 is

	signal tmp : STD_LOGIC;

begin
	
	clk_divider : Process (clk_in, rst)
	variable tt_Clk : integer range 0 to 5208 := 0;
	begin
		if (rst = '0') then
			tmp <= '0';
			tt_Clk := 0;
		elsif (rising_edge(clk_in)) then
			if (tt_Clk = 5208) then
				tt_Clk := 0;
				tmp <= '1';
			else
				tt_Clk := tt_Clk + 1;
				tmp <= '0';
			end if;
			
		end if;
	end Process clk_divider;
	
	clk_out <= tmp;
	
end Behavioral;
