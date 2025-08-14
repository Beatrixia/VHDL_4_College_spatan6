----------------------------------------------------------------------------------
-- structural --
-- 7segments --
-- Create Date:    17:42:25 07/08/2025 
-- Module Name:    Timer_main - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer_main is
    Port ( Clk, Rst, Sw1 : in  STD_LOGIC;
			  Led : out STD_LOGIC;
           S7_out : out  STD_LOGIC_VECTOR (7 downto 0);
           Dig_out : out  STD_LOGIC_VECTOR (5 downto 0));
end Timer_main;

architecture Behavioral of Timer_main is
	
	component c3_33hz_clock is
		 Port ( Clk_in,Rst : in  STD_LOGIC;
				  Clk_out : out  STD_LOGIC);
	end component c3_33hz_clock;
	
	component c1khz_clock is
		 Port ( Clk_in,Rst : in  STD_LOGIC;
				  Clk_out : out  STD_LOGIC);
	end component c1khz_clock;
	
	component c20hz_clock is
		 Port ( Clk_in,Rst : in  STD_LOGIC;
				  Clk_out : out  STD_LOGIC);
	end component c20hz_clock;
	
	component Timer10 is
		 Port ( Clk_in, Rst, En, En_repeater, Rx_trig : in  STD_LOGIC;
				  Tx_trig, Tx_stat : out  STD_LOGIC;
				  Cnt : out  STD_LOGIC_VECTOR (3 downto 0));
	end component Timer10;
	
	component Timer6 is
		 Port ( Clk_in, Rst, En, En_repeater, Rx_trig : in  STD_LOGIC;
				  Tx_trig, Tx_stat : out  STD_LOGIC;
				  Cnt : out  STD_LOGIC_VECTOR (3 downto 0));
	end component Timer6;
	
	component BCD is
		 Port ( Cnt_in : in  STD_LOGIC_VECTOR (3 downto 0);
				  Cnt_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component BCD;
	
	component BCD_dot is
		 Port ( Cnt_in : in  STD_LOGIC_VECTOR (3 downto 0);
				  Cnt_out : out  STD_LOGIC_VECTOR (7 downto 0));
	end component BCD_dot;
	
	component mux_7s is
		 Port ( Dig1,Dig2,Dig3 : in  STD_LOGIC_VECTOR (7 downto 0);
		 -- insert more Dig3.4.5.6 for more 7-Segment input to MOD.
				  Clk_in,En : in  STD_LOGIC;
			-- EN is enable, if enable is '0' 7_segment is not bright.
				  Dig_out : out  STD_LOGIC_VECTOR (7 downto 0);
				  Seldig : out  STD_LOGIC_VECTOR (5 downto 0));
	end component mux_7s;
	
	component Toggle_switch is
		 Port ( Sw, Clk_in, Rst : in  STD_LOGIC;
				  Q : out  STD_LOGIC);
	end component Toggle_switch;
	
	signal ic1khz : STD_LOGIC;
	signal ic3_33hz : STD_LOGIC;
	signal ic20hz : STD_LOGIC;
	
	signal Timer1_tx_trig : STD_LOGIC;
	signal Timer1_tx_stat : STD_LOGIC;
	signal Timer1_cnt : STD_LOGIC_VECTOR (3 downto 0);
	
	signal Timer2_tx_trig : STD_LOGIC;
	signal Timer2_tx_stat : STD_LOGIC;
	signal Timer2_cnt : STD_LOGIC_VECTOR (3 downto 0);
	
	signal Timer3_tx_trig : STD_LOGIC;
	signal Timer3_tx_stat : STD_LOGIC;
	signal Timer3_cnt : STD_LOGIC_VECTOR (3 downto 0);
	
	signal Timer_23_stat : STD_LOGIC;
	signal Timer_12_trig : STD_LOGIC;
	
	signal ibcd1_7seg_out : STD_LOGIC_VECTOR (7 downto 0);
	
	signal ibcd2_7seg_out : STD_LOGIC_VECTOR (7 downto 0);
	
	signal ibcd3_7seg_out : STD_LOGIC_VECTOR (7 downto 0);
	
	signal itoggle_sw : STD_LOGIC;
	
	signal sig_7seg : STD_LOGIC_VECTOR (7 downto 0);
	signal sig_dig : STD_LOGIC_VECTOR (5 downto 0);
	
begin

	clock_20hz : c20hz_clock
	Port map		(Clk_in => Clk,
					 Rst => Rst,
					 Clk_out => ic20hz);
	
	clock_3_33khz : c3_33hz_clock
	Port map		(Clk_in => Clk,
					 Rst => Rst,
					 Clk_out => ic3_33hz);
	
	clock_1khz : c1khz_clock
	Port map		(Clk_in => Clk,
					 Rst => Rst,
					 Clk_out => ic1khz);
	
	Timer_23_stat <= Timer2_tx_stat or Timer3_tx_stat;
	Timer_12_trig <= Timer1_tx_trig and Timer2_tx_trig;
	
	timer_dig1 : Timer10
	Port map 	(Clk_in => ic3_33hz, 
					 Rst => Rst, 
					 En => '1', 
					 En_repeater => Timer_23_stat, 
					 Rx_trig => itoggle_sw,
					 Tx_trig => Timer1_tx_trig, 
					 Tx_stat => Timer1_tx_stat,
					 Cnt => Timer1_cnt);
	
	timer_dig2 : Timer6
	Port map 	(Clk_in => ic3_33hz, 
					 Rst => Rst, 
					 En => '1', 
					 En_repeater => Timer3_tx_stat, 
					 Rx_trig => Timer1_tx_trig and itoggle_sw,
					 Tx_trig => Timer2_tx_trig, 
					 Tx_stat => Timer2_tx_stat,
					 Cnt => Timer2_cnt);
					 
	timer_dig3 : Timer10
	Port map 	(Clk_in => ic3_33hz, 
					 Rst => Rst, 
					 En => '1', 
					 En_repeater => '0', 
					 Rx_trig => Timer_12_trig and itoggle_sw,
					 Tx_trig => Timer3_tx_trig, 
					 Tx_stat => Timer3_tx_stat,
					 Cnt => Timer3_cnt);
	
	timer1_BCD : BCD
	Port map 	(Cnt_in => Timer1_cnt,
					 Cnt_out => ibcd1_7seg_out);
	
	timer2_BCD : BCD
	Port map 	(Cnt_in => Timer2_cnt,
					 Cnt_out => ibcd2_7seg_out);
	
	timer3_BCD : BCD_dot
	Port map 	(Cnt_in => Timer3_cnt,
					 Cnt_out => ibcd3_7seg_out);
	
	Sw_1 : Toggle_switch
	Port map 	(Sw => Sw1 ,
					 Clk_in => ic20hz,
					 Rst => Rst,
					 Q => itoggle_sw);
	
	Scanner : mux_7s
	Port map		(Dig1 => ibcd1_7seg_out,
					 Dig2 => ibcd2_7seg_out,
					 Dig3 => ibcd3_7seg_out,
					 Clk_in => ic1khz,
					 En => Rst,
					 Dig_out => sig_7seg,
					 Seldig => sig_dig);
	
	Led <= ic3_33hz;
	S7_out <= not sig_7seg;
	Dig_out <= not sig_dig;
	
end Behavioral;

