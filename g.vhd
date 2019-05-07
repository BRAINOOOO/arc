----------------------------------------------------------------------------------
-- MariamSalah project MIPS processor.
-- shiftleftby2
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
----------------------- ENTITY --------------------------------------------
entity shiftleftby2 is
	
	-- as i always do some generics :)
	
	generic (n_in: integer := 32;
		 n_out: integer := 32
		 );

	--the port des.
	port 
	(
		input: in std_logic_vector(n_in-1 downto 0);
		z: out std_logic_vector(n_out-1 downto 0)
	);

end shiftleftby2;

architecture arc_shiftleftby2 of shiftleftby2 is


begin
	
	process(input)
	constant ZERO: std_logic_vector(n_out-1 downto 0) := (others => '0');
        -- new way i learned to set all constant to zero

	begin 
		if (n_in = n_out) 
			then
			z <= input(n_in-3 downto 0) & "00";
		
		elsif(n_in = n_out - 2) 
			then
			z <= "00" & (input(n_in-3 downto 0) & "00");
		
		else
			z <= ZERO;
		end if;
			
	end process;

end arc_shiftleftby2;
