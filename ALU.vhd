----------------------------------------------------------------------------------
-- MariamSalah project MIPS processor
--  ALU
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

----------------------- ENTITY --------------------------------------------
-- here there was a bug.


entity ALU is
	-- use a generic to generalize the number of inputs/output defined as standard like 1
	-- here i defined n_in_out as generic bec it needs to be costomized and set a value to it by default 32.
	
	-- fe bug hna :( .
	generic (n_in_out: integer := 32 );

	--the port description
	port 
	(
		a: in std_logic_vector(n_in_out-1 downto 0);
		b: in std_logic_vector(n_in_out-1 downto 0);
		ALUOp: in std_logic_vector(4-1 downto 0);
		ALUResult: out std_logic_vector(n_in_out-1 downto 0);
		zero: out std_logic
	);
end ALU;

architecture arc_ALU of ALU is
	--CONSTANTS OF OPERATIONS
	-- i defined them as constant bec they aren't costomized.
	
	constant ADD_op: std_logic_vector(4-1 downto 0):= "0001";
	constant SUB_op: std_logic_vector(4-1 downto 0):= "0010";
	constant AND_op: std_logic_vector(4-1 downto 0):= "0011";
	constant OR_op: std_logic_vector(4-1 downto 0):= "0100";
	constant NOR_op: std_logic_vector(4-1 downto 0):= "0101";
	-- GENERAL CONSTANTS
	constant CONST_ZERO: std_logic_vector(n_in_out-1 downto 0):= (others => '0');
	
	--SIGNALS
	signal exit_operation : std_logic_vector(n_in_out-1 downto 0);

begin
	process
	
	begin
		if(ALUOp = ADD_op) then
			exit_operation <= a + b;
		elsif(ALUOp = SUB_op) then
			exit_operation <= a - b;
		elsif(ALUOp = AND_op) then
			exit_operation <= a AND b;
		elsif(ALUOp = OR_op) then
			exit_operation <= a OR b;
		elsif(ALUOp = NOR_op) then
			exit_operation <= a NOR b;
		end if;
                -- for zero flag 
		if( exit_operation = CONST_ZERO) then zero <= '1'; else zero <= '0';
		end if;

		ALUResult <= exit_operation;
		wait for 1 ns;
	end process;

end arc_ALU;
