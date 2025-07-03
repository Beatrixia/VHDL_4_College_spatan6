----------------------------------------------------------------------------------
-- Create Date:    10:23:45 03/14/2025 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Adder is
    Port ( T1,T2,T3,T4,T5,Clk_in : in  STD_LOGIC;
           LED : out  STD_LOGIC_VECTOR (3 downto 0);
			  Digit : out  STD_LOGIC_VECTOR (5 downto 0);
			  S7_dig : out STD_LOGIC_VECTOR (7 downto 0));
end Adder;

architecture Behavioral of Adder is

	component S7_seg is
		 Port ( Cnt_in : in  STD_LOGIC_VECTOR (3 downto 0);
				  Cnt_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component S7_seg;
	
	signal B1,B2,B3,B4,B5 : STD_LOGIC := '0';
	-- signal use to be precess's output
	signal C1,C2,C3,C4 : STD_LOGIC := '1';
	-- signal use to be last status of input to toggle (T!)
	signal tmp : STD_LOGIC_VECTOR (3 downto 0);
	signal tt1 : integer := 0;
	signal tt2 : integer := 0;
	signal rs : integer := 0;
	signal iS7Tx : STD_LOGIC_VECTOR (7 downto 0);

	
begin
	
	process (Clk_in,T1,C1)
	begin
		if (rising_edge(Clk_in)) then
			if (T1 = '1' and C1 = '0') then
				B1 <= not B1;
			end if;
			
			C1 <= T1;
		
		end if;
	end process;
	
	process (Clk_in,T2,C2)
	begin
		if (rising_edge(Clk_in)) then
			if (T2 = '1' and C2 = '0') then
				B2 <= not B2;
			end if;
			
			C2 <= T2;
		
		end if;
	end process;
	
	process (Clk_in,T3,C3)
	begin
		if (rising_edge(Clk_in)) then
			if (T3 = '1' and C3 = '0') then
				B3 <= not B3;
			end if;
			
			C3 <= T3;
		
		end if;
	end process;
	
	process (Clk_in,T4,C4)
	begin
		if (rising_edge(Clk_in)) then
			if (T4 = '1' and C4 = '0') then
				B4 <= not B4;
			end if;
			
			C4 <= T4;
		
		end if;
	end process;
	
	B5 <= T5;
	
	process (B1,B2,B3,B4,B5,Clk_in)
	begin
		if (rising_edge(Clk_in)) then
			if (B1 = '1') then
				if(B2 = '1') then
					tt1 <= 3;
				else
					tt1 <= 2;
				end if;
			elsif (B2 = '1') then
				if (B1 = '1') then
					tt1 <= 3;
				else
					tt1 <= 1;
				end if;
			else
				tt1 <= 0;
			end if;
			
			if (B3 = '1') then
				if(B4 = '1') then
					tt2 <= 3;
				else
					tt2 <= 2;
				end if;
			elsif (B4 = '1') then
				if (B3 = '1') then
					tt2 <= 3;
				else
					tt2 <= 1;
				end if;
			else
				tt2 <= 0;
			end if;
			
			if (B5 = '0') then
				rs <= tt1 - tt2;
			else
				rs <= tt1 + tt2;
			end if;
		end if;
	end process;
	
	process (rs)
	begin
		case rs is
		when 0 => tmp <= "0000";
		when 1 => tmp <= "0001";
		when 2 => tmp <= "0010";
		when 3 => tmp <= "0011";
		when 4 => tmp <= "0100";
		when 5 => tmp <= "0101";
		when 6 => tmp <= "0110";
		when 7 => tmp <= "0111";
		when 8 => tmp <= "1000";
		when 9 => tmp <= "1001";
		when 10 => tmp <= "1010";
		when 11 => tmp <= "1011";
		when 12 => tmp <= "1100";
		when 13 => tmp <= "1101";
		when 14 => tmp <= "1110";
		when 15 => tmp <= "1111";
		when others => tmp <= "0000";
		end case;
	end process;
	
	Seven_seg : S7_seg
	port map (Cnt_in => tmp,
				Cnt_out => iS7Tx);
	
	LED <= B1 & B2 & B3 & B4;
	S7_dig <= not iS7Tx;
	Digit <= "111110";
	
end Behavioral;

