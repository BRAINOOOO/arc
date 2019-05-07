----------------------------------------------------------------------------------
-- MariamSalah project MIPS processor.
-- ADDER_4
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all ;

----------------------- ENTITY --------------------------------------------
entity adder4 is
	
	-- i used comtomized n_in_out variable but by deafult is 32.
	
	generic (n_in_out: integer := 32);

	--the port description
	port 
        (
		input: in std_logic_vector(n_in_out-1 downto 0);
		z: out std_logic_vector(n_in_out-1 downto 0)
	);

end adder4;

architecture arc_adder4 of adder4 is
	
signal ciao: std_logic_vector (n_in_out-1 downto 0);

begin

	z <=  input + "100";

end arc_adder4;
