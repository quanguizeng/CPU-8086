LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY CPU_8086 IS
	PORT(
		clk : IN STD_LOGIC
	);
END CPU_8086;

ARCHITECTURE description OF CPU_8086 IS
	COMPONENT BUS_block IS
		PORT(
			PC_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address for new instruction
			SP_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address for stack
			IR_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address from inddirect/direct memory access
			ALU_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address from relative access
			
			mx_mar : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- multiplexer deciding the mar_in value

			ld_mar : IN STD_LOGIC;	-- 1 : load value from addr to MAR

			dat_in : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);	-- data to write to DW
			ld_dw_l : IN STD_LOGIC;		-- 1 : load value to dw_l
			ld_dw_h : IN STD_LOGIC;		-- 1 : load value to dw_h
			mx_dw : IN STD_LOGIC;	-- 1 : load into dw from mdr
												-- 0 : load into dw from dat_in

			ld_mdr : IN STD_LOGIC;		-- 1 : load value to mdr
			mx_mdr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);	-- 00 : load mem_out to mdr
																	-- 01 : load dw_l to mdr
																	-- 10 : load dw_h to mdr

			mem_write : IN STD_LOGIC;	-- 1 : write mdr to memory

			mdr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- value from mdr

			dat_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- value from DW

			clk : IN STD_LOGIC	-- clock
		);
	END COMPONENT BUS_block;
	
	COMPONENT FETCH IS
		PORT(
			HLT : OUT STD_LOGIC;
			NOP : OUT STD_LOGIC;
			RET : OUT STD_LOGIC;
			IRET : OUT STD_LOGIC;
			CLI : OUT STD_LOGIC;
			STI : OUT STD_LOGIC;
			CLC : OUT STD_LOGIC;
			STC : OUT STD_LOGIC;
			  
			JMP : OUT STD_LOGIC;
			JE : OUT STD_LOGIC;
			JNE : OUT STD_LOGIC;
			JG : OUT STD_LOGIC;
			JGE : OUT STD_LOGIC;
			JL : OUT STD_LOGIC;
			JLE : OUT STD_LOGIC;
			JP : OUT STD_LOGIC;
			JNP : OUT STD_LOGIC;
			JO : OUT STD_LOGIC;
			JNO : OUT STD_LOGIC;
			LOOP_ins : OUT STD_LOGIC;
			LOOPE : OUT STD_LOGIC;
			LOOPNE : OUT STD_LOGIC;
			CALL : OUT STD_LOGIC;
		
			INT : OUT STD_LOGIC;
		
			NEG : OUT STD_LOGIC;
			NOT_ins : OUT STD_LOGIC;
			INC : OUT STD_LOGIC;
			DEC : OUT STD_LOGIC;
			RCL : OUT STD_LOGIC;
			RCR : OUT STD_LOGIC;
			ROL_ins : OUT STD_LOGIC;
			ROR_ins : OUT STD_LOGIC;
			SAHR : OUT STD_LOGIC;
			SAR : OUT STD_LOGIC;
			SAL : OUT STD_LOGIC;
			SHL : OUT STD_LOGIC;
			SHR : OUT STD_LOGIC;
			POP : OUT STD_LOGIC;
			PUSH : OUT STD_LOGIC;
			  
			ADD : OUT STD_LOGIC;
			SUB : OUT STD_LOGIC;
			MUL : OUT STD_LOGIC;
			AND_ins : OUT STD_LOGIC;
			OR_ins : OUT STD_LOGIC;
			XOR_ins : OUT STD_LOGIC;
			CMP : OUT STD_LOGIC;
			TEST : OUT STD_LOGIC;
			  
			DIV : OUT STD_LOGIC;
			  
			IN_ins : OUT STD_LOGIC;
			OUT_ins : OUT STD_LOGIC;
			  
			LDV : OUT STD_LOGIC;
			LDR : OUT STD_LOGIC;
			STR : OUT STD_LOGIC;
			MOV : OUT STD_LOGIC;
			  
			no_operand : OUT STD_LOGIC;
			branch : OUT STD_LOGIC;
			interrupt : OUT STD_LOGIC;
			one_register_operand : OUT STD_LOGIC;
			arlog : OUT STD_LOGIC;
			arlog_imm : OUT STD_LOGIC;
			arlog_reg : OUT STD_LOGIC;
			div_imm : OUT STD_LOGIC;
			div_reg : OUT STD_LOGIC;
			io : OUT STD_LOGIC;
			load_store : OUT STD_LOGIC;
			load_store_two_byte : OUT STD_LOGIC;
			load_store_three_byte : OUT STD_LOGIC;
			  
			one_byte : OUT STD_LOGIC;
			two_byte : OUT STD_LOGIC;
			three_byte : OUT STD_LOGIC;
			 
			dw_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			mx_pc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			  
			mdr_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  
			ld_ir0 : IN STD_LOGIC;
			ld_ir1 : IN STD_LOGIC;
			ld_ir2 : IN STD_LOGIC;
			inc_pc : IN STD_LOGIC;
			ld_pc : IN STD_LOGIC;
			  
			clk : IN STD_LOGIC;
			  
			pc_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			ir_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	END COMPONENT FETCH;
	 
	COMPONENT ADDR IS
		PORT(
			clk : IN STD_LOGIC;
			  
			mx_a : IN STD_LOGIC;
			  
			ivtp_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			pc_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			mx_b : IN STD_LOGIC;
			  
			ivtdsp : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			IR : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
			  
			add_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			sp_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			sp_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			  
			ld_sp : IN STD_LOGIC;
			inc_sp : IN STD_LOGIC;
			dec_sp : IN STD_LOGIC
		);
	END COMPONENT ADDR;

	COMPONENT ExecutionUnit IS
		PORT(
			clk: in bit; -- clock
			firstArgCtrl: in std_logic_vector(2 downto 0); -- first ALU argument
			secondArgCtrl: in std_logic_vector(2 downto 0); -- second ALU argument
			SP_in: in std_logic_vector(15 downto 0)); -- Stack Pointer input signal
			changes_S: in std_logic; -- active if current instruction affects S
			ld_S_in: in std_logic; -- control signal for S
			changes_N: in std_logic; -- active if current instruction affects N
			ld_N_in: in std_logic; -- control signal for N
			changes_Z: in std_logic; -- active if current instruction affects Z
			ld_Z_in: in std_logic; -- control signal for Z
			changes_O: in std_logic; -- active if current instruction affects O
			ld_O_in: in std_logic; -- control signal for O
			changes_C: in std_logic; -- active if current instruction affects C
			ld_C_in: in std_logic; -- control signal for C
			immediateArg: in std_logic_vector(15 downto 0); -- immediate argument from isntruction register
			memoryIn: in std_logic_vector(15 downto 0); -- 16 bit data from memory
			registerACtrl: in std_logic; -- 1: Result; 0: MemoryIn
			registerBCtrl: in std_logic; -- 1: Result; 0: MemoryIn
			registerCCtrl: in std_logic; -- 1: Result; 0: MemoryIn
			registerDCtrl: in std_logic; -- 1: Result; 0: MemoryIn
			carryInCtrl: in std_logic_vector(2 downto 0)); -- MX control for the carry bit
		);
	END COMPONENT ExecutionUnit;
	 
	 
-- SIGNALS --
	SIGNAL IVTP_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IVTDSP : STD_LOGIC_VECTOR(15 DOWNTO 0);

	-- BUS SIGNALS --
	 
	SIGNAL DW_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DW_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL MDR_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	 
	SIGNAL ld_mar : STD_LOGIC;
	SIGNAL ld_dw_l : STD_LOGIC;
	SIGNAL ld_dw_h : STD_LOGIC;
	SIGNAL ld_mdr : STD_LOGIC;
	SIGNAL mem_wr: STD_LOGIC;
	SIGNAL mx_dw : STD_LOGIC;
	SIGNAL mx_mdr : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL mx_mar : STD_LOGIC_VECTOR(1 DOWNTO 0);
	-- END BUS SIGNALS --
	 
	-- FETCH SIGNALS --
	SIGNAL HLT : STD_LOGIC;
	SIGNAL NOP : STD_LOGIC;
	SIGNAL RET : STD_LOGIC;
	SIGNAL IRET : STD_LOGIC;
	SIGNAL CLI : STD_LOGIC;
	SIGNAL STI : STD_LOGIC;
	SIGNAL CLC : STD_LOGIC;
	SIGNAL STC : STD_LOGIC;
	
	SIGNAL JMP : STD_LOGIC;
	SIGNAL JE : STD_LOGIC;
	SIGNAL JNE : STD_LOGIC;
	SIGNAL JG : STD_LOGIC;
	SIGNAL JGE : STD_LOGIC;
	SIGNAL JL : STD_LOGIC;
	SIGNAL JLE : STD_LOGIC;
	SIGNAL JP : STD_LOGIC;
	SIGNAL JNP : STD_LOGIC;
	SIGNAL JO : STD_LOGIC;
	SIGNAL JNO : STD_LOGIC;
	SIGNAL LOOP_ins : STD_LOGIC;
	SIGNAL LOOPE : STD_LOGIC;
	SIGNAL LOOPNE : STD_LOGIC;
	SIGNAL CALL : STD_LOGIC;
	 
	SIGNAL INT : STD_LOGIC;
	 
	SIGNAL NEG : STD_LOGIC;
	SIGNAL NOT_INS : STD_LOGIC;
	SIGNAL INC : STD_LOGIC;
	SIGNAL DEC : STD_LOGIC;
	SIGNAL RCL : STD_LOGIC;
	SIGNAL RCR : STD_LOGIC;
	SIGNAL ROL_ins : STD_LOGIC;
	SIGNAL ROR_ins : STD_LOGIC;
	SIGNAL SAHR : STD_LOGIC;
	SIGNAL SAR : STD_LOGIC;
	SIGNAL SAL : STD_LOGIC;
	SIGNAL SHL : STD_LOGIC;
	SIGNAL SHR : STD_LOGIC;
	SIGNAL POP : STD_LOGIC;
	SIGNAL PUSH : STD_LOGIC;
	 
	SIGNAL ADD : STD_LOGIC;
	SIGNAL SUB : STD_LOGIC;
	SIGNAL MUL : STD_LOGIC;
	SIGNAL AND_ins : STD_LOGIC;
	SIGNAL OR_ins : STD_LOGIC;
	SIGNAL XOR_ins : STD_LOGIC;
	SIGNAL CMP : STD_LOGIC;
	SIGNAL TEST : STD_LOGIC;
	 
	SIGNAL DIV : STD_LOGIC;
	 
	SIGNAL IN_ins : STD_LOGIC;
	SIGNAL OUT_ins : STD_LOGIC;
	
	SIGNAL LDV : STD_LOGIC;
	SIGNAL LDR : STD_LOGIC;
	SIGNAL STR : STD_LOGIC;
	SIGNAL MOV : STD_LOGIC;
	 
	 
	 
	SIGNAL no_operand : STD_LOGIC;
	SIGNAL branch : STD_LOGIC;
	SIGNAL interrupt : STD_LOGIC;
	SIGNAL one_register_operand : STD_LOGIC;
	SIGNAL arlog : STD_LOGIC;
	SIGNAL arlog_imm : STD_LOGIC;
	SIGNAL arlog_reg : STD_LOGIC;
	SIGNAL div_imm : STD_LOGIC;
	SIGNAL div_reg : STD_LOGIC;
	SIGNAL io : STD_LOGIC;
	SIGNAL load_store : STD_LOGIC;
	SIGNAL load_store_two_byte : STD_LOGIC;
	SIGNAL load_store_three_byte : STD_LOGIC;
	 
	SIGNAL one_byte : STD_LOGIC;
	SIGNAL two_byte : STD_LOGIC;
	SIGNAL three_byte : STD_LOGIC;
	 
	 
	

	SIGNAL mx_pc : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ld_ir0 : STD_LOGIC;
	SIGNAL ld_ir1 : STD_LOGIC;
	SIGNAL ld_ir2 : STD_LOGIC;
	SIGNAL ld_pc : STD_LOGIC;
	SIGNAL inc_pc : STD_LOGIC;
	
	
	
	SIGNAL PC_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IR_out : STD_LOGIC_VECTOR(23 DOWNTO 0);
	-- END FETCH SIGNALS --
	
	
	-- ADDR SIGNALS --
	SIGNAL SP_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL SP_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ADDR_add_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	
	SIGNAL mx_a : STD_LOGIC;
	SIGNAL mx_b : STD_LOGIC;
	SIGNAL ld_sp : STD_LOGIC;
	SIGNAL inc_sp : STD_LOGIC;
	SIGNAL dec_sp : STD_LOGIC;
	-- END ADDR SIGNALS --
	
	
	-- EXEC SIGNALS --
	SIGNAL mx_first_arg : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL mx_second_arg : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL changes_N : STD_LOGIC;
	SIGNAL changes_C : STD_LOGIC;
	SIGNAL changes_O : STD_LOGIC;
	SIGNAL changes_Z : STD_LOGIC;
	SIGNAL changes_P : STD_LOGIC;
	
	SIGNAL ld_N : STD_LOGIC;
	SIGNAL ld_C : STD_LOGIC;
	SIGNAL ld_O : STD_LOGIC;
	SIGNAL ld_Z : STD_LOGIC;
	SIGNAL ld_P : STD_LOGIC;
	
	SIGNAL mx_AX : STD_LOGIC;
	SIGNAL mx_BX : STD_LOGIC;
	SIGNAL mx_CX : STD_LOGIC;
	SIGNAL mx_DX : STD_LOGIC;
	
	SIGNAL mx_PSWC : STD_LOGIC_VECTOR(2 DOWNTO 0);
	-- END EXEC SIGNALS --
BEGIN
		bus_b : BUS_block PORT MAP
		(
			PC_adr => PC_out,
			SP_adr => SP_out,
			IR_adr => IR_out(7 DOWNTO 0) & IR_out(15 DOWNTO 8),
			ALU_adr => ADDR_add_out,
			ld_mar => ld_mar,
			mx_mar => mx_mar,
			dat_in => DW_in,
			ld_dw_l => ld_dw_l,
			ld_dw_h => ld_dw_h,
			mx_dw => mx_dw,
			ld_mdr => ld_mdr,
			mx_mdr => mx_mdr,
			mem_write => mem_wr,
			mdr_out => MDR_out,
			dat_out => DW_out,
			clk => clk
		);
		
		fetch_b : FETCH PORT MAP
		(
			HLT => HLT,
			NOP => NOP,
			RET => RET,
			IRET => IRET,
			CLI => CLI,
			STI => STI,
			CLC => CLC,
			STC => STC,
			  
			JMP => JMP,
			JE => JE,
			JNE => JNE,
			JG => JG,
			JGE => JGE,
			JL => JL,
			JLE => JLE,
			JP => JP,
			JNP => JNP,
			JO => JO,
			JNO => JNO,
			LOOP_ins => LOOP_ins,
			LOOPE => LOOPE,
			LOOPNE => LOOPNE,
			CALL => CALL,
		
			INT => INT,
		
			NEG => NEG,
			NOT_ins => NOT_ins,
			INC => INC,
			DEC => DEC,
			RCL => RCL,
			RCR => RCR,
			ROL_ins => ROL_ins,
			ROR_ins => ROR_ins,
			SAHR => SAHR,
			SAR => SAR,
			SAL => SAL,
			SHL => SHL,
			SHR => SHR,
			POP => POP,
			PUSH => PUSH,
			  
			ADD => ADD,
			SUB => SUB,
			MUL => MUL,
			AND_ins => AND_ins,
			OR_ins => OR_ins,
			XOR_ins => XOR_ins,
			CMP => CMP,
			TEST => TEST,
			  
			DIV => DIV,
			  
			IN_ins => IN_ins,
			OUT_ins => OUT_ins,
			  
			LDV => LDV,
			LDR => LDR,
			STR => STR,
			MOV => MOV,
			  
			no_operand => no_operand,
			branch => branch,
			interrupt => interrupt,
			one_register_operand => one_register_operand,
			arlog => arlog,
			arlog_imm => arlog_imm,
			arlog_reg => arlog_reg,
			div_imm => div_imm,
			div_reg => div_reg,
			io => io,
			load_store => load_store,
			load_store_two_byte => load_store_two_byte,
			load_store_three_byte => load_store_three_byte,
			  
			one_byte => one_byte,
			two_byte => two_byte,
			three_byte => three_byte,
			 
			dw_out => DW_out,
			addr => ADDR_add_out,
			  
			mx_pc => mx_pc,
			  
			mdr_out => MDR_out,
			  
			ld_ir0 => ld_ir0,
			ld_ir1 => ld_ir1,
			ld_ir2 => ld_ir2,
			inc_pc => inc_pc,
			ld_pc => ld_pc,
			  
			clk => clk,
			  
			pc_out => PC_out,
			  
			ir_out => IR_out
		);
	 
	 
		addr_b : ADDR PORT MAP
		(
			mx_a => mx_a,
			mx_b => mx_b,
			  
			ivtp_out => IVTP_out,
			ivtdsp => IVTDSP,
			
			pc_out => PC_out,
			IR => IR_out,
			add_out => ADDR_add_out,
			  
			sp_in => SP_in,
			sp_out => SP_out,
			ld_sp => ld_sp,
			inc_sp => dec_sp,
			dec_sp => inc_sp,
			
			clk => clk
		);
	 
		exec_b : ExecutionUnit PORT MAP
		(
			firstArgCtrl => mx_first_arg,
			secondArgCtrl => mx_second_arg,
			SP_in => SP_out,
			changes_S => changes_N,
			ld_S_in => ld_N,
			changes_P => changes_P,
			ld_P_in => ld_P,
			changes_Z => changes_Z
			ld_Z_in => ld_Z,
			changes_O => changes_O,
			ld_O_in => ld_O,
			changes_C => changes_C,
			ld_C_in => ld_C,
			immediateArg => IR_out(7 DOWNTO 0) & IR_out(15 DOWNTO 8),
			memoryIn => DW_out,
			registerACtrl => mx_AX,
			registerBCtrl => mx_BX,
			registerCCtrl => mx_CX,
			registerDCtrl => mx_DX,
			carryInCtrl => mx_PSWC,
			
			clk => clk
		);
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 


	 
	 
	 
	 
END description;
