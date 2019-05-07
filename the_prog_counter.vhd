----------------------------------------------------------------------------------
-- MariamSalah MIPS processor.
-- pc of program.
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
-- i found a bug here take care

entity PC is

	port
	(
		address_in: in std_logic_vector (31 downto 0); -- here the address that i need to pass
		clk: in std_logic; -- the clock
		address_out: out std_logic_vector (31 downto 0) 
	);
	
end PC;

architecture arc_PC of PC is
	--GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
		
	begin
		process (clk) 
		begin
			if(falling_edge(clk) and (address_in(0) = '1' or address_in(0) ='0') ) then
				address_out <= address_in;
			elsif(falling_edge(clk)) then
				address_out <= CONST_ZERO;
			end if;
		end process;
	
end arc_PC;
