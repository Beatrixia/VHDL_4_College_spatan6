----------------------------------------------------------------------------------
-- Create Date:    15:17:48 07/08/2025 
-- Module Name:    Toggle_switch - Behavioral 
-- Toggle switch with clock to not bouncing
-- Normal high (set it low at 18)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Toggle_switch is
    Port ( Sw, Clk_in, Rst : in  STD_LOGIC;
           Q : out  STD_LOGIC);
end Toggle_switch;

architecture Behavioral of Toggle_switch is
	
	signal Sw_prev : STD_LOGIC := '0';
	Signal Sig_q : STD_LOGIC := '1';
	-- '1' Means normal high
	
begin
	
	toggle : process(Clk_in, Rst, Sw)
	begin
		if (Rst = '0') then
			Sw_prev <= '0';
			Sig_q <= '1';
		elsif (Rising_edge(Clk_in)) then
		
			if ( Sw_prev = '0' and Sw = '1') then -- For gpt "Good CHAT!!"
				Sig_q <= not Sig_q; 
			end if;
			
			Sw_prev <= Sw;
		end if;
		
	end process toggle;
	
	Q <= Sig_q;
	
end Behavioral;

