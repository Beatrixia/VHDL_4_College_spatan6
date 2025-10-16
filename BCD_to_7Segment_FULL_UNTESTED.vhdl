----------------------------------------------------------------------------------
-- Create Date:    09:21:20 10/02/2025 
-- Module Name:    SevenSegmentStandAlone - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSegmentStandAlone is
	Generic (
		gDigit					: integer := 1; -- 1 to 6
		gMaxDigit				: integer := 6;
		gMainClk				: integer := 50000000;
		gInverseSEGSEL			: STD_LOGIC := '1';
		gInverseSEGDIG			: STD_LOGIC := '1'
	);
	Port ( 
		iClk ,iRst				: in  STD_LOGIC;
		iBiToHex				: in  STD_LOGIC_VECTOR (((gDigit*4)-1) downto 0);
		oSEGDIG					: out  STD_LOGIC_VECTOR (7 downto 0);
		oSEGSEL					: out  STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0)
	);
end SevenSegmentStandAlone;
	
architecture Behavioral of SevenSegmentStandAlone is
	
	Constant cScanRate			: integer := (gDigit*100);
	Constant cScanTrigCnt		: integer := (gMainClk/cScanRate);
	Constant cBaseSEGSEL		: STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0) := (gMaxDigit-1 downto 1 => '0') & '1' ;
	Constant cSEGSEL			: STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0) := STD_LOGIC_VECTOR(unsigned(cBaseSEGSEL) sll (gDigit - 1));
	Constant cZeroVect			: STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0) := (others => '0');
	
	Type tDigitArray			is array (0 to (gDigit - 1)) of STD_LOGIC_VECTOR (3 downto 0);
	Signal rDigArr				: tDigitArray := (others => (others => '0'));
	Signal rScanTrig			: STD_LOGIC := '0';
	Signal rScanTrigCnt			: integer range 0 to cScanTrigCnt := cScanTrigCnt;
	
	Signal wSelectedHex			: STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
	
	Signal rSEGSEL				: STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0) := (others => '0');
	Signal rSEGDIG				: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
	
	Signal wInversedSEGSEL		: STD_LOGIC_VECTOR ((gMaxDigit-1) downto 0);
	Signal wInversedSEGDIG		: STD_LOGIC_VECTOR (7 downto 0);
	
	Signal rOneHotInt			: integer range 0 to (gMaxDigit-1);
	
begin
	
	---- Scan (Rate/Trig) Zone ----
	
	U_ScanCnt : Process (iRst ,iClk)
	begin
		if (iRst = '0') then
			rScanTrigCnt <= cScanTrigCnt;
		elsif (Rising_edge(iClk)) then
			if (rScanTrigCnt = 1 ) then
				rScanTrigCnt <= cScanTrigCnt;
			else
				rScanTrigCnt <= rScanTrigCnt - 1;
			end if;
		end if;
	end Process U_ScanCnt;
	
	U_ScanTrig : Process (iRst ,iClk ,rScanTrigCnt)
	begin
		if (iRst = '0') then
			rScanTrig <= '0';
		elsif (Rising_edge(iClk)) then
			if (rScanTrigCnt = 1 ) then
				rScanTrig <= '1';
			else
				rScanTrig <= '0';
			end if;
		end if;
	end Process U_ScanTrig;
	
	---- Scan Zone ----
	
	U_Scan_SEGSEL : Process (iRst ,iClk ,rScanTrig)
	begin
		if (iRst = '0') then
			rSEGSEL <= cZeroVect;
		elsif (Rising_edge(rScanTrig)) then
			if ( rSEGSEL = cZeroVect ) then
				rSEGSEL <= rSEGSEL((gMaxDigit-2) downto 0) & '1';
			elsif (rSEGSEL = cSEGSEL) then
				rSEGSEL <= cBaseSEGSEL;
			else
				rSEGSEL <= rSEGSEL((gMaxDigit-2) downto 0) & '0';
			end if;
		end if;
	end Process U_Scan_SEGSEL;
	
	---- Split Hex into array ----
	
	Gen_SplitData : for i in 1 to gDigit Generate
	begin
		rDigArr(i-1) <= iBiToHex( ((i*4)-1) downto ((i*4)-4) );
	end Generate Gen_SplitData;
	
	---- Select Number to Output ----
	
	U_OneHotInt : process(rSEGSEL)
	begin
		for i in 0 to gMaxDigit-1 loop
			if rSEGSEL(i) = '1' then
				rOneHotInt <= i;
			end if;
		end loop;
	end process U_OneHotInt;
		
	wSelectedHex <= rDigArr(rOneHotInt);
	
	---- BCD Zone ----
	
	U_BCD : Process (wSelectedHex)
	begin
		case (wSelectedHex) is
			when "0000" => rSEGDIG <= "00111111";	-- 0
			when "0001" => rSEGDIG <= "00000110";	-- 1
			when "0010" => rSEGDIG <= "01011011";	-- 2
			when "0011" => rSEGDIG <= "01001111";	-- 3
			when "0100" => rSEGDIG <= "01100110";	-- 4
			when "0101" => rSEGDIG <= "01101101";	-- 5
			when "0110" => rSEGDIG <= "01111101";	-- 6
			when "0111" => rSEGDIG <= "00100111";	-- 7
			when "1000" => rSEGDIG <= "01111111";	-- 8
			when "1001" => rSEGDIG <= "01101111";	-- 9
			when "1010" => rSEGDIG <= "01110111";	-- A
			when "1011" => rSEGDIG <= "01111100";	-- b
			when "1100" => rSEGDIG <= "00111001";	-- C
			when "1101" => rSEGDIG <= "01101111";	-- d
			when "1110" => rSEGDIG <= "01111001";	-- E
			when others => rSEGDIG <= "01110001";	-- F
		end case;
	end Process U_BCD;
			
	---- inverterzone ----
	
	wInversedSEGSEL <= not rSEGSEL;
	wInversedSEGDIG <= not rSEGDIG;
	
	U_InvSEGSEL : Process (rSEGSEL ,wInversedSEGSEL)
	begin
		if (gInverseSEGSEL = '1') then
			oSEGSEL <= wInversedSEGSEL;
		else
			oSEGSEL <= rSEGSEL;
		end if;
	end Process U_InvSEGSEL;
	
	U_InvSEGDIG : Process (rSEGDIG ,wInversedSEGDIG)
	begin
		if (gInverseSEGDIG = '1') then
			oSEGDIG <= wInversedSEGDIG;
		else
			oSEGDIG <= rSEGDIG;
		end if;
	end Process U_InvSEGDIG;
		
end Behavioral;

