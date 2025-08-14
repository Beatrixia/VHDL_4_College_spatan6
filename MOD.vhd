----------------------------------------------------------------------------------
-- component --
-- Create Date:    18:12:54 03/13/2025 
-- Module Name:    mod_10 - Behavioral
-- this mod_10 is 4 bit output 
-- Change entity name to change file name (mod_10)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mod_10 is
    Port ( Clk_in,Rst,En : in  STD_LOGIC;
			-- in this MOD we use En(Enable) to stop counting

           Cnt_out : out  STD_LOGIC_VECTOR (3 downto 0);
			-- this out put count to 16 (4bit)
			-- in this project our 7_segment use 4bit input so we don't want to create another 7_segment then we use the same 4bit output

           Cry_out : out  STD_LOGIC);
			-- [ MOD_10 ] Cry_out is carry out signal when counted 9 (set to 8 because delay to use with clock) when it's mod_10
			-- [ MOD_6 ]  Cry_out is carry out signal when counted 5 (set to 4 because delay to use with clock) when it's mod_6
end mod_10;

architecture Behavioral of mod_10 is

	signal tt_Cnt : STD_LOGIC_VECTOR ( 3 downto 0 );
	-- we can set the start bit by add [:= "0000"] before ; (not the [])

	signal tmp : STD_LOGIC := '0';
	-- declare signal to be an output to an process

begin

	Counter : process (Clk_in,Rst,tt_Cnt,En)
	begin
		if (Rst = '0') then
				tt_Cnt <= "0000";
				tmp <= '0';
		elsif (En = '1')then
			if (falling_edge(Clk_in)) then

				---- Counting ----
				if (tt_Cnt = "1001") then
				-- in this case it's "1001"(9) because this code is for MOD_10
				-- For MOD_6 "0100"
					tt_Cnt <= "0000";
				else
					tt_Cnt <= tt_Cnt + '1';
				end if;

				---- Carring out ----
				if (tt_Cnt = "1000") then
				-- in this case it's "1000"(8) because this code is for MOD_10
				-- For MOD_6 "0011"
					tmp <= '1';
				else
					tmp <= '0';
				end if;
				
			end if;
		end if;
	end process Counter;
	
	Cnt_out <= tt_Cnt;
	Cry_out <= tmp;

end Behavioral;

