----------------------------------------------------------------------------------
-- MariamSalah project MIPS processor
-- multiplexier.
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------- ENTITY --------------------------------------------
entity multiplexer is
	
	-- as always :)
	generic (n_in_out: integer := 1);
	
	--port description
	port
	(
		in_0: in std_logic_vector(n_in_out-1 downto 0);
		in_1: in std_logic_vector(n_in_out-1 downto 0);
		selector: in std_logic;
		z: out std_logic_vector(n_in_out-1 downto 0)
	);

end multiplexer;

architecture arc_multiplexer of multiplexer is
begin
	
	z <= in_0 when (selector = '0') else in_1;

end arc_multiplexer;
