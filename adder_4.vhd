----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:49:25 04/24/2019 
-- Design Name: 
-- Module Name:    adder_4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all ;

----------------------- ENTITY --------------------------------------------
entity adder4 is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	generic (n_in_out: integer := 32);

	--port description
	port (
		input: in std_logic_vector(n_in_out-1 downto 0);
		z: out std_logic_vector(n_in_out-1 downto 0)
	);
end adder4;

architecture arc_adder4 of adder4 is
signal ciao: std_logic_vector (n_in_out-1 downto 0);
begin

	z <=  input + "100";

end arc_adder4;