----------------------------------------------------------------------------------
-- stand alone --
-- lighter --
-- Create Date:    15:04:02 07/16/2025 
-- Module Name:    State_test - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity State_test is
    Port ( Clk,input,Rst : in  STD_LOGIC;
			  output : out STD_LOGIC);
end State_test;

architecture Behavioral of State_test is
	
	type state_type is (OFF,
							  A1,A2,A3,A4,A5,A6,
							  B1,B2,B3,B4,
							  C1,C2,C3,C4,C5,C6,
							  D1,D2,D3,D4,
							  E1,E2,E3,E4,E5,E6);
	
	signal state,next_state : state_type;
	
	signal sig_out : STD_LOGIC := '0';
	
begin
	
	Clk_state : process (Clk)
	begin 
		if (rising_edge(Clk)) then
			if (rst = '0') then
				state <= OFF;
			elsif (input = '0' and state = OFF) then
				state <= next_state;
			elsif (state /= OFF) then
				state <= next_state;
			else
				state <= state;
			end if;
		end if;
	end process Clk_state;
	
	Next_state_jubu : process (state)
	begin
		case (state) is
			when OFF => next_state <= A1;
			when A1 => next_state <= A2;
			when A2 => next_state <= A3;
			when A3 => next_state <= A4;
			when A4 => next_state <= A5;
			when A5 => next_state <= A6;
			when A6 => next_state <= B1;
			when B1 => next_state <= B2;
			when B2 => next_state <= B3;
			when B3 => next_state <= B4;
			when B4 => next_state <= C1;
			when C1 => next_state <= C2;
			when C2 => next_state <= C3;
			when C3 => next_state <= C4;
			when C4 => next_state <= C5;
			when C5 => next_state <= C6;
			when C6 => next_state <= D1;
			when D1 => next_state <= D2;
			when D2 => next_state <= D3;
			when D3 => next_state <= D4;
			when D4 => next_state <= E1;
			when E1 => next_state <= E2;
			when E2 => next_state <= E3;
			when E3 => next_state <= E4;
			when E4 => next_state <= E5;
			when E5 => next_state <= E6;
			when E6 => next_state <= OFF;
			when others => next_state <= OFF;
		end case;
	end process Next_state_jubu;
	
	Out_state : process (state)
	begin
		case (state) is
			when OFF => sig_out <= '0';
			when A1 => sig_out <= '1';
			when A2 => sig_out <= '1';
			when A3 => sig_out <= '1';
			when A4 => sig_out <= '1';
			when A5 => sig_out <= '1';
			when A6 => sig_out <= '1';
			when B1 => sig_out <= '0';
			when B2 => sig_out <= '0';
			when B3 => sig_out <= '0';
			when B4 => sig_out <= '0';
			when C1 => sig_out <= '1';
			when C2 => sig_out <= '1';
			when C3 => sig_out <= '1';
			when C4 => sig_out <= '1';
			when C5 => sig_out <= '1';
			when C6 => sig_out <= '1';
			when D1 => sig_out <= '0';
			when D2 => sig_out <= '0';
			when D3 => sig_out <= '0';
			when D4 => sig_out <= '0';
			when E1 => sig_out <= '1';
			when E2 => sig_out <= '1';
			when E3 => sig_out <= '1';
			when E4 => sig_out <= '1';
			when E5 => sig_out <= '1';
			when E6 => sig_out <= '1';
			when others => sig_out <= '0';
		end case;
	end process Out_state;
	
	output <= sig_out;
	
end Behavioral;

