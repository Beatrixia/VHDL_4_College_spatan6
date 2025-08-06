----------------------------------------------------------------------------------
-- Create Date:    15:36:50 07/02/2025 
-- Module Name:    c2hz_clock - Behavioral 
-- this is example of 2hz clock divider
-- we use spartan6 with 50Mhz clk
-- Change entity name to change file name (c2hz_clock)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity c2hz_clock is
    Port ( clk_in, rst : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end c2hz_clock;

architecture Behavioral of c2hz_clock is

	signal tmp : STD_LOGIC;
	-- we use tmp to be the output process
	-- we usually don't use "Cnt_out" directly to be process output
	
begin
	
	clk_divider : Process (clk_in, rst)
	variable tt_Clk : integer range 0 to 12499999 := 0;
	-- tt_Clk we use this signal to count the clock and the limit is its count range
	-- signal tt_Clk : integer;
	-- we can use this instead to remove the limit
	-- ":= 0" use for set starting count if we dont set it when simulation the tt_Clk is 'unknow'

	-- 25M clk is the clock we want to divide but in a clock we has 2 state is '1' and '0' to use 'rising_edge' and 'falling_edge'
	-- then we has to toggle clock at half clock that we want so 12500000 is total we want and -1 be cause we count 0 as 1

	-- 24 for 1MHz
	-- 24999 for 1kHz
	-- 249999 for 100Hz
	-- 499999 for 50Hz
	-- 999999 for 25Hz
	-- 2499999 for 10Hz
	-- 24999999 for 1Hz
	-- change at "if (tt_Clk = 12499999) then" too  !!!! it's the main part !!!!
	begin
		if (rst = '0') then
				tmp <= '0';
				tt_Clk := 0;
		elsif (rising_edge(clk_in)) then
			if (tt_Clk = 12499999) then
			-- change the "12499999" if we want to change the hz of divider
				tt_Clk := 0;
				tmp <= not tmp;
			else
				tt_Clk := tt_Clk + 1;
				tmp <= tmp;
			end if;
		end if;
	end Process clk_divider;
	
	clk_out <= tmp;
	
end Behavioral;
