----------------------------------------------------------------------------------
-- Create Date:    09:25:10 09/30/2025 
-- Module Name:    FIFA - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFA is
	 Generic ( Data_width : integer := 8;
				  Depth : integer := 50);
    Port ( Din : in  STD_LOGIC_VECTOR ((Data_width-1) downto 0);
           Dout : out  STD_LOGIC_VECTOR ((Data_width-1) downto 0);
           Clk ,Rst ,Wr_En ,Rd_En : in  STD_LOGIC;
           Full ,Empty : out  STD_LOGIC);
end FIFA;

architecture Behavioral of FIFA is
	
	type memo_type is array (0 to (Depth-1)) of STD_LOGIC_VECTOR ((Data_width-1) downto 0);
	signal memo : memo_type ;
	signal Wr_ptr   : integer range 0 to Depth-1 := 0;
	signal Rd_ptr   : integer range 0 to Depth-1 := 0;
	signal cnt    : integer range 0 to Depth := 0;
	
begin
	
	ptr_decode : process (Rst ,Clk)
	begin
		if (Rst = '0') then
			Wr_ptr <= 0;
			RD_ptr <= 0;
			cnt <= 0;
			memo <= (others => (others => '0'));
		elsif (rising_edge(Clk))then
			--write
			if (Wr_En = '1') and (cnt < Depth) then
				memo(Wr_ptr) <= Din;
				wr_ptr <= (wr_ptr + 1) mod Depth;
				cnt <= cnt + 1;
			end if;
			--read
			if (Rd_En = '1') and (cnt > 0) then
				Dout <= memo(Rd_ptr);
				rd_ptr <= (Rd_ptr + 1) mod Depth;
				cnt <= cnt - 1;
			end if;
		end if;
	end process ptr_decode;
	
	Full  <= '1' when cnt = Depth else '0';
	Empty  <= '1' when cnt = 0 else '0';

end Behavioral;

