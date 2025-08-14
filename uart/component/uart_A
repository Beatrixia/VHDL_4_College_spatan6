----------------------------------------------------------------------------------
-- Create Date:    16:27:01 08/13/2025 
-- Module Name:    mai_uart - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_A is
    Port ( input ,clk ,rst : in  STD_LOGIC;
           output : out  STD_LOGIC);
end uart_A;

architecture Behavioral of uart_A is
	
	type state_type is (idle ,start ,data);
	signal state,next_state : state_type;
	
	signal data_sig : std_logic;
	signal sig_out : std_logic;
	signal cnt : integer range 0 to 7 := 0;
	signal char : std_logic_vector (7 downto 0) := x"41";
	
begin

	clk_state_decode : process (clk ,rst ,input ,state)
	begin
		if (rst = '0') then
			state <= idle;
		elsif (rising_edge(clk)) then
			if (state = idle) then
				if (input = '0') then
					state <= next_state;
				else
					state<= state;
				end if;
			else
				state <= next_state;
			end if;
		end if;
	end process clk_state_decode;
	
	next_state_decode : process (state ,input ,cnt)
	begin
		case (state) is
			when idle =>
				if (input = '0') then
					next_state <= start;
				else
					next_state <= idle;
				end if;
			when start => next_state <= data;
			when data =>
				if (cnt = 7) then
					next_state <= idle;
				else
					next_state <= data;
				end if;
			when others => next_state <= idle;
		end case;
	end process next_state_decode;
	
	data_count : process (clk ,rst ,cnt ,state)
	begin
		if (rst = '0') then
			cnt <= 0;
		elsif (rising_edge(clk)) then
			if (state = data) then
				if (cnt = 7) then
					cnt <= 0;
				else
					cnt <= cnt + 1;
				end if;
			end if;
		end if;
	end process data_count;
	
	data_sig_decode : process (clk ,char ,cnt ,state)
	begin
		if (state = data) then
			data_sig <= char(cnt);
		else
			data_sig <= '1';
		end if;
	end process data_sig_decode;
	
	data_send : process (state ,data_sig)
	begin
		case (state) is
			when start => sig_out <= '0';
			when data => sig_out <= data_sig;
			when others => sig_out <= '1';
		end case;
	end process data_send;
	
	char <= x"41";
	output <= sig_out;
	
end Behavioral;

