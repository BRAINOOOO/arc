----------------------------------------------------------------------------------
-- MariamSalah project MIPS processor
-- ALU control
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
----------------------- ENTITY --------------------------------------------
entity ALUController is
	port
	(
		Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
		
		
		ALUOp: in std_logic_vector (3 downto 0); -- define the operation of the ALU here i asked
		                                         -- the doctor that it can be 4 bits for extensibility.
		
		
		ALUFunction: out std_logic_vector (3 downto 0) -- to define the type of the operation
	);
end ALUController;

architecture arc_ALUController of ALUController is
	
	--some terms for alucontrol .
	-- this a default case for no operation.
	constant ALU_NOOP: std_logic_vector(3 downto 0) :="0000"; 


	-- alu doing something but don't know it.
	constant ALU_DK: std_logic_vector(3 downto 0) :="1111"; 


	-- alu for add
	constant ALU_ADD: std_logic_vector(3 downto 0) :="0001"; 


        -- alu for subtract
	constant ALU_SUB: std_logic_vector(3 downto 0) :="0010"; 


        -- alu for and
	constant ALU_AND: std_logic_vector(3 downto 0):= "0011";


        -- alu for or
	constant ALU_OR: std_logic_vector(3 downto 0):= "0100"; 


        -- alu for nor
	constant ALU_NOR: std_logic_vector(3 downto 0):= "0101"; 

	--here the functions :)

        -- add fun
	constant FUNC_ADD: std_logic_vector(5 downto 0):= "100000"; 
        
        -- sub fun
	constant FUNC_SUB: std_logic_vector(5 downto 0):= "100010"; 

        -- and fun
	constant FUNC_AND: std_logic_vector(5 downto 0):= "100100"; 

        -- or fun
	constant FUNC_OR: std_logic_vector(5 downto 0):= "100101"; 

        -- for nor but i removed it
	--constant FUNC_NOR: std_logic_vector(5 downto 0):= "100010"; -- NOR FUNCTION



	--some gen contants
	constant CONST_ZERO: std_logic_vector(31 downto 0):= (others => '0');
	begin
		process (Instruction, ALUOp) 
		begin
			
			
			-- here what i am doing is dealing with some possible error 
			-- and after that i assign the default values.
			
			
			if (ALUOp = ALU_DK and Instruction = FUNC_ADD) 
				then
				ALUFunction <= ALU_ADD;
			
			elsif (ALUOp = ALU_DK and Instruction = FUNC_SUB) 
				then
				ALUFunction <= ALU_SUB;
			
			elsif (ALUOp = ALU_DK and Instruction = FUNC_AND) 
				then
				ALUFunction <= ALU_AND;
			
			elsif (ALUOp = ALU_DK and Instruction = FUNC_OR) 
				then
				ALUFunction <= ALU_OR;
			
			elsif (ALUOp = ALU_DK ) 
				then
				ALUFunction <= ALU_NOOP; --here for the possibile errors .
			else
				ALUFunction <= ALUOp;
			
			
			end if;
				
		end process;
	
end arc_ALUController;
