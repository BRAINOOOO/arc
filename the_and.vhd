----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:50:17 04/24/2019 
-- Design Name: 
-- Module Name:    the_and - Behavioral 
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
------------------------ LIBRERIE ---------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------- ENTITY --------------------------------------------
entity and_port is
	--port description
	port (
		a: in std_logic;
		b: in std_logic;
		z: out std_logic
	);
end and_port;

architecture arc_and_port of and_port is

begin

	z <= a and b;


end arc_and_port;