----------------------------------------------------------------------------------
-- component --
-- lighter --
-- Create Date:    15:46:27 07/23/2025 
-- Module Name:    FSM - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
    Port ( clk, rst, input, done : in  STD_LOGIC;
           tload, tsel , output : out  STD_LOGIC);
end FSM;

architecture Behavioral of FSM is
	
	type state_type is (OFF,A,B,C,D,E);
	signal state : state_type;
	signal next_state : state_type := OFF;
	
	signal sig_tload : STD_LOGIC;
	signal sig_tsel : STD_LOGIC;
	signal sig_output : STD_LOGIC;
	
begin
	
	tload <= sig_tload;
	tsel <= sig_tsel;
	output <= sig_output;
	
	clk_state : process (clk, state, rst)
	begin
		if (rst = '0') then
			state <= OFF;
		else
			if (rising_edge(clk)) then
				if (state = OFF) then
					if (input = '0') then
						state <= next_state;
					else
						state <= state;
					end if;
				elsif (done = '1') then
					state <= next_state;
				else
					state <= state;
				end if;
			end if;
		end if;
	end process clk_state;
	
	next_state_decode : process (state, next_state, input)
	begin
		case (state) is
			when OFF =>
				if (input = '0') then
					next_state <= A;
				else
					next_state <= OFF;
				end if;
			when A => next_state <= B;
			when B => next_state <= C;
			when C => next_state <= D;
			when D => next_state <= E;
			when others => next_state <= OFF;
			end case;
	end process next_state_decode;
	
	tload_decode : process (state, Input, done)
	begin
		case (state) is
			when OFF => sig_tload <= not Input;
			--when E => sig_tload <= '0';
			when others => sig_tload <= done;
			end case;
	end process tload_decode;
	
	tsel_decode : process (state)
	begin
		case (state) is
			when A => sig_tsel <= '0';
			when B => sig_tsel <= '1';
			when C => sig_tsel <= '0';
			when D => sig_tsel <= '1';
			when E => sig_tsel <= '0';
			when others => sig_tsel <= '1';
			end case;
	end process tsel_decode;
	
	output_decode : process (state)
	begin
		case (state) is
			when A => sig_output <= '1';
			when B => sig_output <= '0';
			when C => sig_output <= '1';
			when D => sig_output <= '0';
			when E => sig_output <= '1';
			when others => sig_output <= '0';
			end case;
	end process output_decode;
	
end Behavioral;

