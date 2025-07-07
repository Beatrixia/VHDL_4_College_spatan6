----------------------------------------------------------------------------------
-- Create Date:    21:04:00 07/07/2025 
-- Module Name:    Timer - Behavioral
-- !! Have to change "Timer" at 10,14,28 name to use it propertly !!
-- !! Change timer at 44 !!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Timer is
    Port ( Clk_in, Rst, En, En_repeater, Rx_trig : in  STD_LOGIC;
           Tx_trig, Tx_stat : out  STD_LOGIC;
           Cnt : out  STD_LOGIC_VECTOR (3 downto 0));
end Timer;

-- ** Port explanation **
-- Clk_in is clock for timer
-- Rst is Reset (0-active low)
-- En is Enable (1-on/0-off)
-- En_repeater use for enable or disable repeat counting (1-on/0-off)
-- Rx_trig use for counting (1-on/0-off)

-- Tx_trig use to send signal when counting 0
-- Tx_stat use to send status if counting 0 (1-no/0-yes)

-- Cnt is count is total number of timer

architecture Behavioral of Timer is
    
    signal tt_cnt : STD_LOGIC_VECTOR (3 downto 0);

    signal sig_trig : STD_LOGIC := '0';
	-- use for Tx_trig

    signal sig_stat : STD_LOGIC := '0';
    -- use for Tx_stat

begin
    
    Timer : process(Clk_in, Rst, En, En_repeater, Rx_trig)
    begin
        if (Rst = '0') then

            tt_cnt <= "1001"; -- Please change "1001" with time of timer with binary
            sig_trig <= '0';

        elsif (En = '1') then

            if (rising_edge(Clk_in)) then

                if (tt_cnt = "0000") then
                    if (En_repeater = '1') then
                        tt_cnt <= "1001";
                    end if;
                elsif (Rx_trig = '1') then
                    tt_cnt <= tt_cnt - 1;
                end if;

            end if;
        end if;
    end process Timer ;
    
    Send_trig : process(tt_cnt)
    begin
        if (tt_cnt = "0001") then
            sig_trig <= '1';
        else
            sig_trig <= '0';
        end if;
    end process Send_trig;

    Send_stat : process(tt_cnt)
    begin
        if (tt_cnt = "0000") then
            sig_stat <= '0';
        else
            sig_trig <= '1';
        end if;
    end process Send_stat;

end architecture Behavioral;
