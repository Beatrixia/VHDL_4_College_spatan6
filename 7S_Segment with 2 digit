---------------------------------------------------------------------------------- 
-- Create Date:    13:22:37 02/28/2025 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity S7_Segment_ADA_DIGIT is
    Port ( Clk,Rst : in  STD_LOGIC;
           S7_out : out  STD_LOGIC_VECTOR (7 downto 0);
           Seldig : out  STD_LOGIC_VECTOR (5 downto 0));
end S7_Segment_ADA_DIGIT;

architecture Behavioral of S7_Segment_ADA_DIGIT is
	
	------ Component ------
	component clock_divider_1khz is
	-- ** this component is an example name of component "clock_divider_1khz" should be the same as entity of component name **
		Port ( Clk_in,Rst : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
	end component clock_divider_1khz;

	component clock_divider_2hz is
	-- read ** at line 17
		Port ( Clk_in,Rst : in  STD_LOGIC;
           Clk_out : out  STD_LOGIC);
	end component clock_divider_2hz;
	
	component mod_10_wTrig is
	-- read ** at line 17
    Port ( Clk_in,Rst,En : in  STD_LOGIC;
           Cnt_out : out  STD_LOGIC_VECTOR (3 downto 0);
			  Cry_out : out STD_LOGIC );
	end component mod_10_wTrig;
	
	component S7_Seg is
	-- read ** at line 17
		Port ( Cnt_in : in  STD_LOGIC_VECTOR (3 downto 0);
           Cnt_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component S7_Seg;
	
	component MUX_7S is
	-- read ** at line 17
		Port ( Dig1,Dig2 : in  STD_LOGIC_VECTOR (7 downto 0);
           Clk : in  STD_LOGIC;
           Dig_out : out  STD_LOGIC_VECTOR (7 downto 0);
           Seldig : out  STD_LOGIC_VECTOR (5 downto 0));
	end component MUX_7S;
	
	------ Signal ------
	
	-- signal for internal clock
	signal ic2hz : STD_LOGIC;
	signal ic1khz : STD_LOGIC;
	
	---- signal for mod10 ----
	signal modTx_1dig : STD_LOGIC_VECTOR (3 downto 0);
	signal EnTx_1dig : STD_LOGIC;
	
	signal modTx_2dig : STD_LOGIC_VECTOR (3 downto 0);
	-- signal EnWr_2dig : STD_LOGIC;
	-- trig from mod_10 we dont use for now. if use remove "--" comment
	
	---- signal for 7_segment ----
	signal S7_segTx_1dig : STD_LOGIC_VECTOR (7 downto 0);
	signal S7_segTx_2dig : STD_LOGIC_VECTOR (7 downto 0);
	
	---- signal for notgate ----
	signal iS7_out : STD_LOGIC_VECTOR (7 downto 0);
	signal iSeldig : STD_LOGIC_VECTOR (5 downto 0);
	-- notgate for correct logic to 7_segment
	
begin
	c2hz_clock : clock_divider_2hz
	port map	(Clk_in => Clk,
				Rst => Rst,
				Clk_out => ic2hz);
	
	c1khz_clock : clock_divider_1khz
	port map	(Clk_in => Clk,
				Rst => '1',
				Clk_out => ic1khz);
	
	mod10_1dig : mod_10_wTrig
	port map	(Clk_in => ic2hz,
				Rst => Rst,
				En => '1',
				Cnt_out => modTx_1dig,
				Cry_out => EnTx_1dig);
	
	mod10_2dig : mod_10_wTrig
	port map	(Clk_in => ic2hz,
				Rst => Rst,
				En => EnTx_1dig,
				Cnt_out => modTx_2dig,
				Cry_out => open);
	
	-- for more mod_10 you have to add and gate to mix-up carry out and add signal
	-- example
	-- and_carry <= EnTx_1dig and EnTx_2dig; -- and EnTx_3dig and EnTx_4dig
	-- if more 7_digit is more and
	
	S7_seg_1dig : S7_Seg
	port map (Cnt_in => modTx_1dig,
				Cnt_out => S7_segTx_1dig);
	
	S7_seg_2dig : S7_Seg
	port map (Cnt_in => modTx_2dig,
				Cnt_out => S7_segTx_2dig);
				
	mux : MUX_7S
	port map (Dig1 => S7_segTx_1dig,
				Dig2 => S7_segTx_2dig,
				Clk => ic1khz,
				Dig_out => iS7_out,
				Seldig => iSeldig);
	
	S7_out <= not iS7_out;
	Seldig <= not iSeldig;
	
end Behavioral;

