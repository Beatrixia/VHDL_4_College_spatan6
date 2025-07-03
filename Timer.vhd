----------------------------------------------------------------------------------
-- Create Date:    14:56:09 07/03/2025 
-- Module Name:    Timer - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Timer is
    Port ( Clk_in,Rst,Rx_trig,En : in  STD_LOGIC;
           Tx_trig : out  STD_LOGIC;
           Cnt : out  STD_LOGIC_VECTOR (3 downto 0));
end Timer;

architecture Behavioral of Timer is
	
	signal tt_cnt : STD_LOGIC_VECTOR (3 downto 0);
	
	signal tmp : STD_LOGIC := '0';
	-- use for tx_trig
	
begin
	
	Timer : process (Clk_in,Rst,Rx_trig,En)
	begin
		if (Rst = '0') then
			tt_cnt <= "1001";
			tmp <= '0';
		elsif (En = '1') then
			if (rising_edge(Clk_in)) then
			
				if (tt_cnt = "0000") then
					if (Rx_trig = '0') then
						tt_cnt <= "1001";
					end if;
				else
					tt_cnt <= tt_cnt - 1;
				end if;
				
				if (tt_cnt = "0001") then
					tmp <= '1';
				else
					tmp <= '0';
				end if;
				
			end if;
		end if;
	end process timer;
	
	Cnt <= tt_cnt;
	tx_trig <= tmp;
		
end Behavioral;
