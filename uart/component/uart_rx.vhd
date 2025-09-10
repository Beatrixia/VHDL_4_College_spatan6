----------------------------------------------------------------------------------
-- Create Date:    15:22:24 09/09/2025 
-- Module Name:    rx_uart_echo - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_rx is
    Port ( clk ,rst ,rx : in  STD_LOGIC;
           flag : out  STD_LOGIC;
			  tx : out STD_LOGIC_VECTOR (7 downto 0));
end uart_rx;

architecture Behavioral of uart_rx is
	
	type state_type is (idle ,data ,send);
	signal state,next_state : state_type;
	
	signal cnt : std_logic_vector (3 downto 0) := x"1";
	signal char : std_logic_vector (7 downto 0) := x"ff";
	
	signal sig_flag : std_logic;
	
begin
	
	clk_state_decode : process (clk ,rst ,state)
	begin
		if (rst = '0') then
			state <= idle;
		elsif (rising_edge(clk)) then
			if (state = idle) then
				if (rx = '0') then
					state <= next_state;
				else
					state<= state;
				end if;
			else
				state <= next_state;
			end if;
		end if;
	end process clk_state_decode;
		
	next_state_decode : process (state ,cnt)
	begin
		case (state) is
			when idle => next_state <= idle;
			when data =>
				if (cnt(3) = '1') then
					next_state <= send;
				else
					next_state <= data;
				end if;
			when send => next_state <= idle;
			when others => next_state <= idle;
		end case;
	end process next_state_decode;
	
	sig_flag_decode : process (state)
	begin
		if (state = send) then
			sig_flag <= '1';
		else
			sig_flag <= '0';
		end if;
	end process sig_flag_decode;
	
	flag <= sig_flag;
	
	data_sig_decode : process (clk ,char ,cnt ,state ,rst)
	begin
		if (rst = '0') then
			char <= (others => '1');
		elsif (rising_edge(clk)) then
			if (state = data) then
				char <= rx & char(6 downto 0);
				cnt <= cnt + '1';
			else
				cnt <= x"1";
			end if;
		end if;
	end process data_sig_decode;
	
	tx <= char;
	

end Behavioral;

