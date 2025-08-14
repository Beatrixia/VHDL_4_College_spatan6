----------------------------------------------------------------------------------
-- component --
-- Create Date:    09:49:35 03/22/2025 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity input_toggle is
    Port ( Input,Clk_in : in  STD_LOGIC;
					-- Clk_in is 50MHz (if change plz change the tt_clk at line 28) 
           Output : out  STD_LOGIC);
end input_toggle;

architecture Behavioral of input_toggle is
	
	signal Last_in : STD_LOGIC := '0';
	signal Sig_Out : STD_LOGIC := '0';
	
	signal tt_Clk : integer := 0 ;
	signal tmp : STD_LOGIC := '0';
	-- tmp its clkdivider signal for unstable button (bouncing)
	
begin
	
	Clk_divider : Process (Clk_in,tt_clk)
	begin
		if (rising_edge(Clk_in)) then
			if (tt_Clk = 999999) then
			-- this tt_clk is for 50MHz to 25Hz
				tt_Clk <= 0;
				tmp <= not tmp;
			else
				tt_Clk <= tt_Clk + 1;
				tmp <= tmp;
			end if;
		end if;
	end Process Clk_divider;
	
	process (tmp,Input,Last_in)
	begin
		if (rising_edge(tmp)) then
			if (Input = '1' and Last_in = '0') then
				Sig_Out <= not Sig_Out;
			end if;
			
			Last_in <= Input;
		
		end if;
	end process;
	
	Output <= Sig_Out;

end Behavioral;
