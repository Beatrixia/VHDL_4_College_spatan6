----------------------------------------------------------------------------------
-- component --
-- lighter --
-- Create Date:    16:44:21 07/23/2025 
-- Module Name:    Timer - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
    Port ( clk, rst, tsel ,tload : in  STD_LOGIC;
           done : out  STD_LOGIC);
end Timer;

architecture Behavioral of Timer is

	type state_type is (t0,t5,t4,t3,t2,t1);
	signal state,next_state : state_type;
	signal sig_done : STD_LOGIC;
	
begin
	
	done <= sig_done;
	
	clk_state : process (clk, state, rst)
	begin
		if (rst = '0') then
			state <= t0;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process clk_state;
	
	sig_done_decode : process (state)
	begin
		if (state = t0) then
			sig_done <= '1';
		else
			sig_done <= '0';
		end if;
	end process sig_done_decode;
	
	next_state_decode : process (state, tload, tsel)
	begin
		case (state) is
			when t0 =>
				if (tload = '1') then
					if (tsel = '1') then
						next_state <= t5;
					else
						next_state <= t3;
					end if;
				else
					next_state <= t0;
				end if;
			when t5 => next_state <= t4;
			when t4 => next_state <= t3;
			when t3 => next_state <= t2;
			when t2 => next_state <= t1;
			when others => next_state <= t0;
			end case;
	end process next_state_decode;
	
end Behavioral;

