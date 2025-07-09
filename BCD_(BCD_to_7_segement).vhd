----------------------------------------------------------------------------------
-- Create Date:    18:32:32 03/13/2025 
-- Module Name:    S7_seg - Behavioral 
-- This is HDL code for 7_segment with (DP)
-- Change entity name to change file name (S7_seg)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD is
    Port ( Cnt_in : in  STD_LOGIC_VECTOR (3 downto 0);
           En : in STD_LOGIC;
           Cnt_out : out  STD_LOGIC_VECTOR (7 downto 0));
end BCD;

architecture Behavioral of BCD is
	
	signal tmp : STD_LOGIC_VECTOR ( 7 downto 0 );
  -- we use tmp to be the output process
  -- we usally don't use "Cnt_out" directly to be process output

begin

	Seven_Segment : process(Cnt_in)
	begin
		case Cnt_in is
			-- 7_segment (DP)GFEDCBA
			when "0000" => tmp <= "00111111";	-- 0
			when "0001" => tmp <= "00000110";	-- 1
			when "0010" => tmp <= "01011011";	-- 2
			when "0011" => tmp <= "01001111";	-- 3
			when "0100" => tmp <= "01100110";	-- 4
			when "0101" => tmp <= "01101101";	-- 5
			when "0110" => tmp <= "01111101";	-- 6
			when "0111" => tmp <= "00100111";	-- 7
			when "1000" => tmp <= "01111111";	-- 8
			when "1001" => tmp <= "01101111";	-- 9
			when "1010" => tmp <= "01110111";	-- A
			when "1011" => tmp <= "01111100";	-- b
			when "1100" => tmp <= "00111001";	-- C
			when "1101" => tmp <= "01101111";	-- d
			when "1110" => tmp <= "01111001";	-- E
			when others => tmp <= "01110001";	-- F
		-- the meaning in this when part
		-- when "Cnt_in" => tmp <= "The vector that we want to set it to tmp";
		-- in tmp vector in this case(not the case fungtion) 1 is led on (1n 7 segment) 0 is led off (in 7 segment)
		
		end case;

	end process Seven_Segment;
	
	Cnt_out <= tmp;

end Behavioral;

