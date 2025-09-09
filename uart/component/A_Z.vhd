----------------------------------------------------------------------------------
-- Create Date:    08:56:43 09/07/2025 
-- Module Name:    A_Z - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity A_Z is 
	Port ( input ,rst ,clk : in STD_LOGIC;
		   tx : out STD_LOGIC_VECTOR (7 downto 0);
		   trig : in STD_LOGIC;
		   flag : out STD_LOGIC);
end A_Z;

architecture Behavioral of A_Z is

	type state_type is (idle ,send ,plus);
	signal state,next_state : state_type;

	signal sig_data : std_logic_vector (7 downto 0) := x"41";
	signal cnt : integer range 0 to 25 := 0;

	signal sig_flag : std_logic := '0';

begin

	clk_state_decode: process(clk, rst ,state)
	begin
		if (rst = '0') then
			state <= idle;
		elsif (rising_edge(clk)) then
			if (state = idle) then
				if (input = '0' and trig = '1') then
					state <= next_state;
				else
					state <= state;
				end if;
			elsif (state = send) then
				if (trig = '1') then
					state <= next_state;
				end if;
			else
				state <= next_state;
			end if;
		end if;
	end process clk_state_decode;

	next_state_decode: process(state ,cnt)
	begin
		case (state) is
			when idle => next_state <= send;
			when send => next_state <= plus;
			when plus =>
				if (cnt = 25) then
					next_state <= idle;
				else
					next_state <= send;
				end if;
			when others => next_state <= idle;
		end case;
	end process next_state_decode;

	sig_flag_decode : process(state, rst)
	begin
		if (state = send) then
			sig_flag <= '1';
		else
			sig_flag <= '0';
		end if;
	end process sig_flag_decode ;
	
	flag <= sig_flag;
	
	sig_data_decode: process(clk, rst ,state ,sig_data)
	begin
		if (rst = '0') then
			sig_data <= x"41";
		elsif (rising_edge(clk)) then
			if (state = plus) then
				sig_data <= sig_data + '1';
			elsif (state = idle) then
				sig_data <= x"41";
			end if;
		end if;
	end process sig_data_decode;
	
	tx <= sig_data;
	
	cnt_decode : process(clk, rst, cnt)
	begin
		if (rst = '0') then
			cnt <= 0;
		elsif (rising_edge(clk)) then
			if (state = plus) then
				cnt <= cnt  + 1;
			elsif (state = idle) then
				cnt <= 0;
			end if;
		end if;
	end process cnt_decode ;

end Behavioral;

