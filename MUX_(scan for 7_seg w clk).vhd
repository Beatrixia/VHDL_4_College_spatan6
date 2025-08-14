----------------------------------------------------------------------------------
-- component --
-- 7segments --
-- Create Date:    18:35:06 03/13/2025 
-- Design Name:    mux_7s with no S7_seg inside
-- Module Name:    mux_7s - Behavioral 
-- this MUX is ONLY FOR this project!!!
-- this MUX require S7_seg(7_segment) to change bit from MOD(4bit) to S7_seg(8bit) before be in this input
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mux_7s is
    Port ( Dig1,Dig2 : in  STD_LOGIC_VECTOR (7 downto 0);
	 -- insert more Dig3.4.5.6 for more 7-Segment input to MOD.
           Clk_in,En : in  STD_LOGIC;
	   -- EN is enable, if enable is '0' 7_segment is not bright.
           Dig_out : out  STD_LOGIC_VECTOR (7 downto 0);
           Seldig : out  STD_LOGIC_VECTOR (5 downto 0));
end mux_7s;

architecture Behavioral of mux_7s is

	signal sel : STD_LOGIC_VECTOR (5 downto 0) := "000001";
	-- sel using for mux process to select(scan) 7-segment.
	
	signal tmp : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
	-- tmp use to set 7-secment digit to output (default is "00000000").
	
	signal en_sel : STD_LOGIC_VECTOR (5 downto 0);
	signal en_tmp : STD_LOGIC_VECTOR (7 downto 0);
	-- this signal is for "sel" and "tmp" to process enable and be out put.

begin

	setsel : process (Clk_in,sel)
	-- Use This process to scan 7_segment with Clk_in Hz
	begin
		if (rising_edge(Clk_in)) then
			if (sel = "000010") then
			-- Change "000010" to set the total 7segment
			-- for full range 6 digit set to "100000"
				sel <= "000001";
			else
				sel <= sel(4 downto 0) & '0';
				--This is the shiftbits process
				-- "&" in this process is for add the '0' at the end
			end if;
		end if;
	end process setsel;
	
	setdig : process (sel,Dig1,Dig2)
	begin
		case sel is
			when "000001" => tmp <= Dig1;
			when "000010" => tmp <= Dig2;
			-- when "000100" => tmp <= Dig3;
			-- when "001000" => tmp <= Dig4;
			-- when "010000" => tmp <= Dig5;
			-- when "100000" => tmp <= Dig6;
			-- insert more digit formore 7_segment
			when others => tmp <= "00000000";
		end case;
	end process setdig;
	
	enable : process (En,sel,tmp)
	begin
		if (En = '0') then
			en_sel <= "000000";
			en_tmp <= "00000000";
		else
			en_sel <= sel;
			en_tmp <= tmp;
		end if;
	end process enable;
	
	Seldig <= en_sel;
	Dig_out <= en_tmp;
	
end Behavioral;
