----------------------------------------------------------------------------------
-- Create Date:    15:44:20 09/30/2025 
-- Module Name:    Clk_divider - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Clk_divider is
	Generic ( MainClock : integer := 50000000;
				 Frequency : integer := 50);
	Port ( Clk_in, Rst : in  STD_LOGIC;
          Clk_out : out  STD_LOGIC);
end Clk_divider;

architecture Behavioral of Clk_divider is
	constant TotalClock : integer := (MainClock/Frequency);
	constant CntDivider : integer := (TotalClock/2) - 1;
	signal rCnt : integer range 0 to CntDivider := 0;
	signal rSigOut : STD_LOGIC := '0';
begin
	
	U_rCnt : Process (Clk_in, Rst)
	begin
		if (Rst = '0') then
			rCnt <= 0;
		elsif (Rising_edge(Clk_in)) then
			if (rCnt = CntDivider) then
				rCnt <= 0;
			else
				rCnt <= rCnt + 1;
			end if;
		end if;
	end process U_rCnt;
	
	U_rSigOut : Process (Clk_in, Rst)
	begin
		if (Rst = '0') then
			rSigOut <= '0';
		elsif (Rising_edge(Clk_in)) then
			if (rCnt = CntDivider) then
				rSigOut <= not rSigOut;
			else
				rSigOut <= rSigOut;
			end if;
		end if;
	end process U_rSigOut;
	
	Clk_out <= rSigOut;
	
end Behavioral;

