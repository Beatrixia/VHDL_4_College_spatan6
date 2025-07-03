----------------------------------------------------------------------------------
-- Create Date:    10:36:54 03/22/2025 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Enabler_led4bit is
    Port ( Led_in : in  STD_LOGIC_VECTOR (3 downto 0);
           Led_out : out  STD_LOGIC_VECTOR (3 downto 0);
           En : in  STD_LOGIC);
end Enabler_led4bit;

architecture Behavioral of Enabler_led4bit is
	
	signal en_led : STD_LOGIC_VECTOR (3 downto 0);
	
begin
	
	enabler : process (En,LED_in)
	begin
		if (En = '0') then
			en_led <= "0000";
		else
			en_led <= Led_in;
		end if;
	end process enabler;
	
	Led_out <= en_led;
	
end Behavioral;
