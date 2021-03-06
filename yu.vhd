----------------------------------------------------------------------------------
-- MariamSalah MIPS project
-- finally test :)
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

-- entity declaration for your testbench.Dont declare any ports here
ENTITY test_tb IS 
END test_tb;

ARCHITECTURE behavior OF test_tb IS
   -- Component Declaration for the Unit Under Test (UUT)


	COMPONENT registers
	port
	(
		address_read_register1: in std_logic_vector (4 downto 0); --ADDRESS TO register 1
		address_read_register2: in std_logic_vector (4 downto 0); -- ADDRESS TO register 2
		address_write_register: in std_logic_vector (4 downto 0); -- ADDRESS TO BE WRITTEN in register
		data_to_write: in std_logic_vector (31 downto 0); -- ADDRESS TO BE WRITTEN in register
		is_to_write: in std_logic; --HIGH FOR WRITING
		read_data1: out std_logic_vector (31 downto 0); --DATA FROM ADDRESS 1
		read_data2: out std_logic_vector (31 downto 0)
	);
	END COMPONENT;




	COMPONENT multiplexer  
		generic (n_in_out: integer := 1);
		port (
			in_0: in std_logic_vector(n_in_out-1 downto 0);
			in_1: in std_logic_vector(n_in_out-1 downto 0);
			selector: in std_logic;
			z: out std_logic_vector(n_in_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT controller 
		port
		(
			Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
			RegDest: out std_logic; --SELECTOR FOR MUX 
			Jump: out std_logic; -- IS JUMP INSTRUCTION
			Branch: out std_logic;  -- IS BRANCH INSTRUCTION
			MemRead: out std_logic; -- IS MEMORY READING instruction
			MemtoReg: out std_logic; -- LOAD MEMORY to REGISTER
			ALUOp: out std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
			MemWrite: out std_logic; --Define write in memory instruction
			ALUSrc: out std_logic; -- Select source (MUX) for ALU
			RegWrite: out std_logic -- Write in Register
	);
	END COMPONENT;

	COMPONENT shiftleftby2
		generic (n_in: integer := 32; 
					n_out: integer := 32 
					);
		port (
			input: in std_logic_vector(n_in-1 downto 0);
			z: out std_logic_vector(n_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT adder4
		generic (n_in_out: integer := 32);
		port (
			input: in std_logic_vector(n_in_out-1 downto 0);
			z: out std_logic_vector(n_in_out-1 downto 0)
		);
	END COMPONENT;


	COMPONENT signExtend 
		generic (	n_in: integer := 5; 
						n_out: integer := 32 
					); 
		port (
			input: in std_logic_vector(n_in-1 downto 0);
			z: out std_logic_vector(n_out-1 downto 0)
		);
	END COMPONENT;

	COMPONENT memory 
		port
		(
			address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
			data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
			memWrite: in std_logic; --HIGH FOR WRITING 
			memRead: in std_logic; --HIGH FOR READING
			--clk: in std_logic; -- CLOCK
			data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
		);
	END COMPONENT;

	COMPONENT PC 
	port
	(
		address_in: in std_logic_vector (31 downto 0); --ADDRESS TO PASS
		clk: in std_logic; -- CLOCK
		address_out: out std_logic_vector (31 downto 0) --
	);
	END COMPONENT;

	
	COMPONENT ALU 
	generic (n_in_out: integer := 32 );

	port (
		a: in std_logic_vector(n_in_out-1 downto 0);
		b: in std_logic_vector(n_in_out-1 downto 0);
		ALUOp: in std_logic_vector(4-1 downto 0);
		ALUResult: out std_logic_vector(n_in_out-1 downto 0);
		zero: out std_logic
	);
	END COMPONENT;

	COMPONENT ALUController
		port
		(
			Instruction: in std_logic_vector (5 downto 0); -- INSTRUCTION 
			ALUOp: in std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
			ALUFunction: out std_logic_vector (3 downto 0) --DEFINE THE TYPE OF OPERATION TO DO FOR ALU
		);
	END COMPONENT;

	COMPONENT and_port
		
		port (
			a: in std_logic;
			b: in std_logic;
			z: out std_logic
		);
	END COMPONENT;

	COMPONENT datamemory
		port
		(
			address: in std_logic_vector (31 downto 0); --ADDRESS TO WRITE OR READ
			data_write: in std_logic_vector (31 downto 0); -- DATA TO BE WRITTEN
			memWrite: in std_logic; --HIGH FOR WRITING 
			memRead: in std_logic; --HIGH FOR READING
			--clk: in std_logic; -- CLOCK
			data_read: out std_logic_vector (31 downto 0) --DATA FROM ADDRESS address
		);
	END COMPONENT;


	-- CONSTANTS
	constant n_wires : integer := 5;
	constant n_EXT_wires : integer := 32;
	constant n_bit: integer := 32;
	constant ALU_ADD: std_logic_vector(3 downto 0) :="0001"; -- ALU ADD
	constant zero : std_logic := '0';
	constant one : std_logic := '1';
	constant nullIN : std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	-- SIGNALS
	--signal a_in : std_logic_vector(n_wires-1 downto 0) := "00010";
	
	
	
	signal clock : std_logic := '0';
	signal instruction: std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	signal PC_in: std_logic_vector(n_bit-1 downto 0) := "00000000000000000000000000000000";
	signal PC_out: std_logic_vector(n_bit-1 downto 0) ;
	signal add4_exit : std_logic_vector(n_bit-1 downto 0) ;
	signal mux3_exit : std_logic_vector(n_bit-1 downto 0) ;
	signal shifted_inst : std_logic_vector(28-1 downto 0) ;
	signal jump_address : std_logic_vector(n_bit-1 downto 0);
	signal ALU1_exit: std_logic_vector(n_bit-1 downto 0);
	signal shifted_before_ALU1: std_logic_vector(n_bit-1 downto 0);
	signal extended: std_logic_vector(n_bit-1 downto 0);
	signal write_register: std_logic_vector(5-1 downto 0);
	signal data1_to_ALU: std_logic_vector(n_bit-1 downto 0);
	signal data2_to_MUX2: std_logic_vector(n_bit-1 downto 0);
	signal MUX2_to_ALU : std_logic_vector(n_bit-1 downto 0);
	signal ALU_function:  std_logic_vector(4-1 downto 0);
	signal ALU_result: std_logic_vector(n_bit-1 downto 0);
	signal zero_ALU_result : std_logic;

	signal selectorMUX3 : std_logic;
	signal memory_to_MUX5: std_logic_vector(n_bit-1 downto 0);
	signal MUX5_to_REG: std_logic_vector(n_bit-1 downto 0);

	--CONTROLLER SIGNALS
	signal RegDest:std_logic; --SELECTOR FOR MUX 
	signal Jump: std_logic; -- IS JUMP INSTRUCTION
	signal Branch: std_logic;  -- IS BRANCH INSTRUCTION
	signal MemRead: std_logic; -- IS MEMORY READING instruction
	signal MemtoReg: std_logic; -- LOAD MEMORY to REGISTER
	signal ALUOp: std_logic_vector (3 downto 0); -- DEFINE THE OPERATION FOR THE ALU (4 bit for no implemented operation and extensibility)
	signal MemWrite: std_logic; --Define write in memory instruction
	signal ALUSrc: std_logic; -- Select source (MUX) for ALU
	signal RegWrite: std_logic; -- Write in Register
	

BEGIN


	ProgramCounter: PC PORT MAP ( address_in => PC_in, address_out => PC_out, clk => clock);
	
	InstrMemory : memory  PORT MAP(	address => PC_out, 
												data_write => nullIN, 
												memWrite => zero, 
												memRead => one, 
												--clk => clock, 
												data_read => instruction); 

	ADDER: adder4 GENERIC MAP( n_in_out => n_bit ) PORT MAP( input => PC_out, z => add4_exit);

	shifter1: shiftleftby2 GENERIC MAP( n_in => 26, n_out=>28) PORT MAP(input => instruction(25 downto 0), z => shifted_inst);

	--controller takes more space 
	CTRL : controller PORT MAP (	Instruction => instruction( 31 downto 26),
											RegDest => RegDest,
											Jump => Jump,
											Branch => Branch,
											MemRead => MemRead,
											MemtoReg => MemtoReg,
											ALUOp => ALUOp,
											MemWrite => MemWrite,
											ALUSrc => ALUSrc,
											RegWrite => RegWrite);

	MUX3: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>add4_exit, in_1 => ALU1_exit, selector => selectorMUX3, z=>mux3_exit);

	MUX4: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 => mux3_exit, in_1 => jump_address, selector => Jump, z=>PC_in);
	
	sign1: signExtend GENERIC MAP( n_in => 16, n_out => n_bit ) PORT MAP( input => instruction (15 downto 0), z => extended ); 
	
	shifter2: shiftleftby2 GENERIC MAP( n_in => n_bit, n_out=>n_bit) PORT MAP(input => extended, z => shifted_before_ALU1);
	
	--ALU 1 is quite uselles... it is used only to perform sums
	ALU1: alu GENERIC MAP (n_bit) PORT MAP(a => add4_exit, b => shifted_before_ALU1, ALUOp => ALU_ADD, ALUResult => ALU1_exit );

	MUX1: multiplexer GENERIC MAP (5) PORT MAP(in_0 => instruction(20 downto 16), in_1 => instruction(15 downto 11), selector => RegDest, z=>write_register);
	

	REGI: registers PORT MAP(	address_read_register1 => instruction(25 downto 21),
										address_read_register2 => instruction(20 downto 16), 
										address_write_register => write_register, 
										data_to_write => MUX5_to_REG, 
										is_to_write => RegWrite,
										read_data1 => data1_to_ALU,
										read_data2 => data2_to_MUX2);

	MUX2: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>data2_to_MUX2, in_1 => extended, selector => ALUSrc, z=>MUX2_to_ALU);
	
	ALUCTRL: ALUController PORT MAP( Instruction => Instruction(5 downto 0), ALUOp => ALUOp, ALUFunction => ALU_function);

	ALUPOWER: ALU GENERIC MAP(n_bit) PORT MAP(	a => data1_to_ALU, 
																b => MUX2_to_ALU, 
																ALUOp => ALU_function, 
																ALUResult => ALU_result, 
																zero => zero_ALU_result  );
	
	and1: and_port PORT MAP(a =>zero_ALU_result, b => Branch, z => selectorMUX3 );
	
	DATMemory: datamemory PORT MAP (	address => ALU_result, 
												data_write => data2_to_MUX2, 
												memWrite => MemWrite, 
												memRead => MemRead, 
												--clk => clock, 
												data_read => memory_to_MUX5);

	MUX5: multiplexer GENERIC MAP (n_bit) PORT MAP(in_0 =>ALU_result, in_1 => memory_to_MUX5, selector => MemtoReg, z=>MUX5_to_REG);

	
	
	-- WIRE CONNECTOR

	jump_address <= add4_exit(31 downto 28)& shifted_inst;


	--PROCESS

	clock_process: process
		begin
		clock <= '1';
		wait for 5 ns;
		clock <= '0';
		wait for 5 ns;
	end process;

	-- Main process
  main: process
   begin   
	wait for 2 ns;
  end process;

END;

