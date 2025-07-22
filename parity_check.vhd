----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flash is
    port ( inputs,clk : in STD_LOGIC;
           outputs : out STD_LOGIC );
end flash;

architecture Behavioral of flash is
    
    type state_type is (s0 ,s1);
    signal state,next_state : state_type
    signal parity : STD_LOGIC;

begin

    proc : process (clk)
    begin
        if rising_edge(clk) then
            if (rst = '0') then
                state <= s0;
            else
                state <= next_state;
            end if;
        end if;
    end process proc;

    output_decode : process (state)
    begin
        case (state) is 
            when s0 => 
                if (inputs = '0') then
                    parity <= '0';
                else
                    parity <= '1';
                end if;
            when s1 => 
                if (inputs = '0') then
                    parity <= '1';
                else
                    parity <= '0';
                end if;
            when others =>
                parity <= '0';
        end case;
    end process output_decode;

    next_state_decode : process (state,inputs)
    begin
        case (state) is
            when s0 =>
                if (inputs = '0') then
                    next_state <= s0;
                else
                    next_state <= s1;
                end if;
            when s1 =>
                if (inputs = '0') then
                    next_state <= s0;
                else
                    next_state <= s1;
                end if;
            when others => 
                next_state <= next_state;
        end case;
    end process next_state_decode;

    outputs <= parity;
    
end architecture Behavioral;
