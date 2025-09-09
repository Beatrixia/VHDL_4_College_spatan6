----------------------------------------------------------------------------------
-- Create Date:    13:14:54 09/09/2025 
-- Module Name:    UART_A_Z_Main - Behavioral  
-- using uart_tx ,clk9600 ,debounce_botton ,clk_botton ,A_Z
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART_A_Z_Main is
    Port ( btn ,rst ,clk : in  STD_LOGIC;
           tx : out  STD_LOGIC);
end UART_A_Z_Main;

architecture Behavioral of UART_A_Z_Main is

	component Debounce_button is
    Port ( btn_in ,clk  : in  STD_LOGIC;
           btn_out : out  STD_LOGIC);
	end component Debounce_button;
	
	component clk9600 is
    Port ( clk_in, rst : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
	end component clk9600;
	
	component A_Z is 
	Port ( input ,rst ,clk : in STD_LOGIC;
		   tx : out STD_LOGIC_VECTOR (7 downto 0);
		   trig : in STD_LOGIC;
		   flag : out STD_LOGIC);
	end component A_Z;
	
	component uart is
	Port ( input ,clk ,rst : in  STD_LOGIC;
		   flag : out STD_LOGIC;
		   rx : in STD_LOGIC_VECTOR ( 7 downto 0);
		   tx : out  STD_LOGIC);
	end component uart;
	
	component clk_btn is
    Port ( clk, rst, btn_in : in  STD_LOGIC;
           btn_out : out  STD_LOGIC);
	end component clk_btn;
	
	signal ibtn_de : std_logic;
	signal ibtn_clk : std_logic;
	signal irst_de : std_logic;
	
	signal iclk : std_logic;
	signal idata : std_logic_vector (7 downto 0);
	signal iflag : std_logic;
	signal itrig : std_logic;
	
begin
	
	inter_clk : clk9600
	port map ( clk_in => clk,
				  rst => irst_de,
				  clk_out => iclk);
	
	de_btn : Debounce_button
	port map ( btn_in => btn,
				  clk => clk,
				  btn_out => ibtn_de);
				  
	de_rst : Debounce_button
	port map ( btn_in => rst,
				  clk => clk,
				  btn_out => irst_de);
				  
	inter_clk_btn : clk_btn
	port map ( clk => iclk,
				  rst => irst_de,
				  btn_in => ibtn_de,
				  btn_out => ibtn_clk);
				  
	AZ : A_Z
	port map ( input => ibtn_clk,
				  rst => irst_de,
				  clk => iclk,
				  tx => idata,
				  trig => itrig,
				  flag => iflag);
				  
	uart_tx : uart
	port map ( input => iflag,
				  clk => iclk,
				  rst => irst_de,
				  flag => itrig,
				  tx => tx,
				  rx => idata);
	
end Behavioral;

