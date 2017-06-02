LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY CPU_8086 IS
	PORT (
		clk : IN STD_LOGIC;
		Device_output : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		INT_req : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		st_start : IN STD_LOGIC
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
			inc_mar : IN STD_LOGIC; -- 1 : increase MAR by 1
			
			PC_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			PSW_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			AX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			BX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			CX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			DX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			imm_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			ld_dw_l : IN STD_LOGIC;		-- 1 : load value to dw_l
			ld_dw_h : IN STD_LOGIC;		-- 1 : load value to dw_h
			mx_dw : IN STD_LOGIC_VECTOR(2 DOWNTO 0);	-- 000 : load into dw from mdr
																	-- 001 : load into dw from PC_val
																	-- 010 : load into dw from PSW_val
																	-- 011 : load into dw from AX_val
																	-- 100 : load into dw from BX_val
																	-- 101 : load into dw from CX_val
																	-- 110 : load into dw from DX_val

			ld_mdr : IN STD_LOGIC;		-- 1 : load value to mdr
			mx_mdr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);	-- 00 : load mem_out to mdr
																	-- 01 : load dw_l to mdr
																	-- 10 : load dw_h to mdr

			mem_write : IN STD_LOGIC;	-- 1 : write mdr to memory

			mdr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- value from mdr

			dat_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- value from DW

			clk : IN STD_LOGIC;	-- clock
			
			init_done : OUT STD_LOGIC
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
			
			carry: OUT STD_LOGIC;
			overflow: OUT STD_LOGIC;
			parity: OUT STD_LOGIC;
			sign: OUT STD_LOGIC;
			zero: OUT STD_LOGIC;
			 
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
			  
			mx_b : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
			  
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
			clk: in std_logic; -- clock
			firstArgCtrl: in std_logic_vector(2 downto 0); -- first ALU argument
			secondArgCtrl: in std_logic_vector(2 downto 0); -- second ALU argument
			SP_in: in std_logic_vector(15 downto 0); -- Stack Pointer input signal
			changes_S: in std_logic; -- active if current instruction affects S
			ld_S_in: in std_logic; -- control signal for S
			changes_P: in std_logic; -- active if current instruction affects N
			ld_P_in: in std_logic; -- control signal for N
			changes_Z: in std_logic; -- active if current instruction affects Z
			ld_Z_in: in std_logic; -- control signal for Z
			changes_O: in std_logic; -- active if current instruction affects O
			ld_O_in: in std_logic; -- control signal for O
			changes_C: in std_logic; -- active if current instruction affects C
			ld_C_in: in std_logic; -- control signal for C
			immediateArg: in std_logic_vector(15 downto 0); -- immediate argument from isntruction register
			device_in : in std_logic_vector(15 downto 0);
			memoryIn: in std_logic_vector(15 downto 0); -- 16 bit data from memory
			registerACtrl: in std_logic_vector(1 DOWNTO 0); -- 1: Result; 0: MemoryIn
			registerBCtrl: in std_logic; -- 1: Result; 0: MemoryIn
			registerCCtrl: in std_logic; -- 1: Result; 0: MemoryIn
			registerDCtrl: in std_logic_vector(1 downto 0); -- 11: 0; 10: AX; 01: Result; 00: MemoryIn
			carryInCtrl: in std_logic_vector(2 downto 0); -- MX control for the carry bit
			flags_out : out std_logic_vector(15 downto 0); -- value of the flags register
			flags_in : in std_logic_vector(15 downto 0); -- input value of the flags register
			ld_flags : in std_logic; -- load flags
			
			operation : in std_logic_vector(5 downto 0);
			
			dec_cx : in std_logic;
			c_zero : out std_logic;
			second_arg_zero : out std_logic;
			
			cli : in std_logic;
			sti : in std_logic;
			clc : in std_logic;
			stc : in std_logic;
			
			AX_out : out std_logic_vector(15 downto 0);
			BX_out : out std_logic_vector(15 downto 0);
			CX_out : out std_logic_vector(15 downto 0);
			DX_out : out std_logic_vector(15 downto 0);
		  
			ld_ax : in std_logic;
			ld_bx : in std_logic;
			ld_cx : in std_logic;
			ld_dx : in std_logic;
		  
			inc_dx : in std_logic;
			dec_dx : in std_logic
		);
	END COMPONENT ExecutionUnit;
	
	COMPONENT intr IS
		PORT (
			clk: in std_logic; -- clock signal
			interruptLines: in std_logic_vector(7 downto 0); -- I/O interrupt lines
			flags: in std_logic_vector(15 downto 0); -- flags register
			
			IVTPAddrOut: out std_logic_vector(15 downto 0); -- Interrupt Vector Table Pointer
			IVTDisp: out std_logic_vector(15 downto 0); -- Offset of the interrupt routine
			interrupt: out std_logic; -- Interrupt signal
			
			
			st_wrong_op_code : in std_logic;
			st_wrong_arg : in std_logic;
			st_div_zero : in std_logic;
			cl_wrong_op_code : in std_logic;
			cl_wrong_arg : in std_logic;
			cl_div_zero : in std_logic;
			
			wrong_op_code : out std_logic;
			wrong_arg : out std_logic;
			div_zero : out std_logic;
			
			br_in : in std_logic_vector(15 downto 0);
			ld_br : in std_logic;
			mx_br : in std_logic
		);
	END COMPONENT intr;
	
	COMPONENT Control_Unit IS
		PORT(
			ld_mar : OUT STD_LOGIC;
			inc_mar : OUT STD_LOGIC;
			mx_mar : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ld_mdr : OUT STD_LOGIC;
			mx_mdr : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			ld_ir0 : OUT STD_LOGIC;
			ld_ir1 : OUT STD_LOGIC;
			ld_ir2 : OUT STD_LOGIC;
			ld_pc : OUT STD_LOGIC;
			mx_pc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			inc_pc : OUT STD_LOGIC;
			cl_start : OUT STD_LOGIC;
			ld_dw_h : OUT STD_LOGIC;
			ld_dw_l : OUT STD_LOGIC;
			mx_dw : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			ld_PSW : OUT STD_LOGIC;
			clr_i : OUT STD_LOGIC;
			set_i : OUT STD_LOGIC;
			clr_c : OUT STD_LOGIC;
			set_c : OUT STD_LOGIC;
			mx_a : OUT STD_LOGIC;
			mx_b : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			mem_write : OUT STD_LOGIC;
			ALU_op_code : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
			mx_PSWC : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			
			ld_ax : OUT STD_LOGIC;
			ld_bx : OUT STD_LOGIC;
			ld_cx : OUT STD_LOGIC;
			ld_dx : OUT STD_LOGIC;
			
			mx_ax : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			mx_bx : OUT STD_LOGIC;
			mx_cx : OUT STD_LOGIC;
			mx_dx : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			
			inc_dx : OUT STD_LOGIC;
			dec_dx : OUT STD_LOGIC;
			dec_cx : OUT STD_LOGIC;
			
			ld_sp : OUT STD_LOGIC;
			incSP : OUT STD_LOGIC;
			decSP : OUT STD_LOGIC;
			
			ld_PSW_C : OUT STD_LOGIC;
			ld_PSW_N : OUT STD_LOGIC;
			ld_PSW_O : OUT STD_LOGIC;
			ld_PSW_P : OUT STD_LOGIC;
			ld_PSW_Z : OUT STD_LOGIC;
			
			ld_dev : OUT STD_LOGIC;
			st_wrong_op_code : OUT STD_LOGIC;
			st_wrong_arg : OUT STD_LOGIC;
			st_div_zero : OUT STD_LOGIC;
			ld_br : OUT STD_LOGIC;
			mx_br : OUT STD_LOGIC;
			br_in : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			
			cl_wrong_op_code : OUT STD_LOGIC;
			cl_wrong_arg : OUT STD_LOGIC;
			cl_div_zero : OUT STD_LOGIC;
			
			start : IN STD_LOGIC;
			one_byte : IN STD_LOGIC;
			two_byte : IN STD_LOGIC;
			PSW_Z : IN STD_LOGIC;
			PSW_N : IN STD_LOGIC;
			PSW_C : IN STD_LOGIC;
			PSW_P : IN STD_LOGIC;
			PSW_O : IN STD_LOGIC;
			c_zero : IN STD_LOGIC;
			second_arg_zero : IN STD_LOGIC;
			wrong_op_code : IN STD_LOGIC;
			wrong_arg : IN STD_LOGIC;
			div_zero : IN STD_LOGIC;
			interrupt : IN STD_LOGIC;
			
			
			HLT : IN STD_LOGIC;
			NOP : IN STD_LOGIC;
			RET : IN STD_LOGIC;
			IRET : IN STD_LOGIC;
			CLI : IN STD_LOGIC;
			STI : IN STD_LOGIC;
			CLC : IN STD_LOGIC;
			STC : IN STD_LOGIC;
			  
			JMP : IN STD_LOGIC;
			JE : IN STD_LOGIC;
			JNE : IN STD_LOGIC;
			JG : IN STD_LOGIC;
			JGE : IN STD_LOGIC;
			JL : IN STD_LOGIC;
			JLE : IN STD_LOGIC;
			JP : IN STD_LOGIC;
			JNP : IN STD_LOGIC;
			JO : IN STD_LOGIC;
			JNO : IN STD_LOGIC;
			LOOP_ins : IN STD_LOGIC;
			LOOPE : IN STD_LOGIC;
			LOOPNE : IN STD_LOGIC;
			CALL : IN STD_LOGIC;
		
			INT : IN STD_LOGIC;
		
			NEG : IN STD_LOGIC;
			NOT_ins : IN STD_LOGIC;
			INC : IN STD_LOGIC;
			DEC : IN STD_LOGIC;
			RCL : IN STD_LOGIC;
			RCR : IN STD_LOGIC;
			ROL_ins : IN STD_LOGIC;
			ROR_ins : IN STD_LOGIC;
			SAHR : IN STD_LOGIC;
			SAR : IN STD_LOGIC;
			SAL : IN STD_LOGIC;
			SHL : IN STD_LOGIC;
			SHR : IN STD_LOGIC;
			POP : IN STD_LOGIC;
			PUSH : IN STD_LOGIC;
			  
			ADD : IN STD_LOGIC;
			SUB : IN STD_LOGIC;
			MUL : IN STD_LOGIC;
			AND_ins : IN STD_LOGIC;
			OR_ins : IN STD_LOGIC;
			XOR_ins : IN STD_LOGIC;
			CMP : IN STD_LOGIC;
			TEST : IN STD_LOGIC;
			  
			DIV : IN STD_LOGIC;
			  
			IN_ins : IN STD_LOGIC;
			OUT_ins : IN STD_LOGIC;
			  
			LDV : IN STD_LOGIC;
			LDR : IN STD_LOGIC;
			STR : IN STD_LOGIC;
			MOV : IN STD_LOGIC;
			
			res_mx : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			clk : IN STD_LOGIC	-- clock
		);
	END COMPONENT Control_Unit;
	
	COMPONENT FlipFlop IS
		PORT
		(
			set : IN STD_LOGIC; -- load/enable.
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			sig_out : OUT STD_LOGIC -- output
		);
	END COMPONENT FlipFlop;
	 
-- SIGNALS --

	-- BUS SIGNALS --
	 
	SIGNAL DW_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL DW_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL MDR_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
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
	SIGNAL SOFT_int : STD_LOGIC;
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
	
	SIGNAL changes_N : STD_LOGIC;
	SIGNAL changes_C : STD_LOGIC;
	SIGNAL changes_O : STD_LOGIC;
	SIGNAL changes_Z : STD_LOGIC;
	SIGNAL changes_P : STD_LOGIC;
	
	SIGNAL PC_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IR_out : STD_LOGIC_VECTOR(23 DOWNTO 0);
	-- END FETCH SIGNALS --
	
	
	-- ADDR SIGNALS --
	SIGNAL SP_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL SP_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ADDR_add_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- END ADDR SIGNALS --
	
	
	-- EXEC SIGNALS --
	SIGNAL First_arg : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL Second_arg : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	SIGNAL AX_out : std_logic_vector(15 downto 0);
	SIGNAL BX_out : std_logic_vector(15 downto 0);
	SIGNAL CX_out : std_logic_vector(15 downto 0);
	SIGNAL DX_out : std_logic_vector(15 downto 0);
	-- END EXEC SIGNALS --
	
	-- INTR SIGNALS --
	
	SIGNAL IVTP_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL IVTDSP : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL interrupt : STD_LOGIC;
	
	SIGNAL wrong_op_code : std_logic;
	SIGNAL wrong_arg : std_logic;
	SIGNAL div_zero : std_logic;
	-- END INTR SIGNALS --
	
	
	
	
	-- IO SIGNALS --
	SIGNAL Device_reg :  STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL Device_wr : STD_LOGIC;
	-- END IO SIGNALS --
	
	-- CONTROL SIGNAL --
	
		-- BUS CONTROL --
		SIGNAL ld_mar : STD_LOGIC;
		SIGNAL inc_mar : STD_LOGIC;
		
		SIGNAL ld_dw_l : STD_LOGIC;
		SIGNAL ld_dw_h : STD_LOGIC;
		SIGNAL ld_mdr : STD_LOGIC;
		SIGNAL mem_wr: STD_LOGIC;
		SIGNAL mx_dw : STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIGNAL mx_mdr : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL mx_mar : STD_LOGIC_VECTOR(1 DOWNTO 0);
		-- END BUS CONTROL --
		
		-- FETCH CONTROL --
		SIGNAL mx_pc : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL ld_ir0 : STD_LOGIC;
		SIGNAL ld_ir1 : STD_LOGIC;
		SIGNAL ld_ir2 : STD_LOGIC;
		SIGNAL ld_pc : STD_LOGIC;
		SIGNAL inc_pc : STD_LOGIC;
		-- END FETCH CONTROL --
		
		-- ADDR CONTROL --
		SIGNAL mx_a : STD_LOGIC;
		SIGNAL mx_b : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL ld_sp : STD_LOGIC;
		SIGNAL inc_sp : STD_LOGIC;
		SIGNAL dec_sp : STD_LOGIC;
		-- END ADDR CONTROL --
		
		-- EXEC CONTROL --
		SIGNAL ld_N : STD_LOGIC;
		SIGNAL ld_C : STD_LOGIC;
		SIGNAL ld_O : STD_LOGIC;
		SIGNAL ld_Z : STD_LOGIC;
		SIGNAL ld_P : STD_LOGIC;
		SIGNAL mx_AX : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL mx_BX : STD_LOGIC;
		SIGNAL mx_CX : STD_LOGIC;
		SIGNAL mx_DX : STD_LOGIC_VECTOR(1 DOWNTO 0);
		SIGNAL mx_PSWC : STD_LOGIC_VECTOR(2 DOWNTO 0);
		SIGNAL PSW_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
		SIGNAL ld_PSW : STD_LOGIC;
		SIGNAL set_c : STD_LOGIC;
		SIGNAL set_i : STD_LOGIC;
		SIGNAL clr_c : STD_LOGIC;
		SIGNAL clr_i : STD_LOGIC;
		SIGNAL ld_AX : std_logic;
		SIGNAL ld_BX : std_logic;
		SIGNAL ld_CX : std_logic;
		SIGNAL ld_DX : std_logic;
		SIGNAL inc_DX : STD_LOGIC;
		SIGNAL dec_DX : STD_LOGIC;
		SIGNAL CX_dec : STD_LOGIC;
		SIGNAL CX_Z : STD_LOGIC;
		SIGNAL ALU_OP_code : STD_LOGIC_VECTOR(5 DOWNTO 0);
		SIGNAL second_arg_zero : STD_LOGIC;
		-- END EXEC CONTROL --
		
		-- INTR CONTROL --
		SIGNAL BR_in : std_logic_vector(15 downto 0);
		SIGNAL ld_BR : std_logic;
		SIGNAL mx_BR : std_logic;
		SIGNAL st_wrong_op_code : std_logic;
		SIGNAL st_wrong_arg : std_logic;
		SIGNAL st_div_zero : std_logic;
		SIGNAL cl_wrong_op_code : std_logic;
		SIGNAL cl_wrong_arg : std_logic;
		SIGNAL cl_div_zero : std_logic;
		-- END INTR CONTROL --
	-- END CONTROL SIGNAL --
	
	-- OTHER SIGNALS --
	SIGNAL START : STD_LOGIC;
	SIGNAL cl_start : STD_LOGIC;
	
	SIGNAL init_sve : STD_LOGIC := '0';
	
	
	SIGNAL ucitana_memorija : STD_LOGIC := '0';
	
	SIGNAL IR_adr_or_imm : STD_LOGIC_VECTOR(15 DOWNTO 0);
	-- END OTHER SIGNALS --
	
-- END SIGNALS --
BEGIN
		IR_adr_or_imm <= IR_out(7 DOWNTO 0) & IR_out(15 DOWNTO 8);
		start_ff : FlipFlop PORT MAP(set => st_start, clr => cl_start, sig_out => START, clk => clk);
		init_ff : FlipFlop PORT MAP(set => '1', clr => '0', clk => clk, sig_out => init_sve);

		First_arg <=	"0" & IR_out(17 DOWNTO 16) when one_register_operand = '1' else
							IR_out(18 DOWNTO 16) when (arlog = '1') or (load_store = '1') else
							"000" when div = '1';

		Second_arg <=	IR_out(15 DOWNTO 13) when (mov = '1') or (arlog_reg = '1') else
							"0" & IR_out(17 DOWNTO 16) when (div_reg = '1') else
							"111" when (arlog_imm = '1') or (div_imm = '1') or (LDV = '1') else
							"101" when (one_register_operand = '1');

		bus_b : BUS_block PORT MAP
		(
			PC_adr => PC_out,
			SP_adr => SP_out,
			IR_adr => IR_adr_or_imm,
			ALU_adr => ADDR_add_out,
			ld_mar => ld_mar,
			mx_mar => mx_mar,
			inc_mar => inc_mar,
			
			PC_val => PC_out,
			PSW_val => PSW_out,
			AX_val => AX_out,
			BX_val => BX_out,
			CX_val => CX_out,
			DX_val => DX_out,
			imm_val => IR_adr_or_imm,
			
			ld_dw_l => ld_dw_l,
			ld_dw_h => ld_dw_h,
			mx_dw => mx_dw,
			ld_mdr => ld_mdr,
			mx_mdr => mx_mdr,
			mem_write => mem_wr,
			mdr_out => MDR_out,
			dat_out => DW_out,
			clk => clk,
			
			
			init_done => ucitana_memorija
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
			interrupt => SOFT_int,
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
			
			carry => changes_C,
			parity => changes_P,
			sign => changes_N,
			overflow => changes_O,
			zero => changes_Z,
			 
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
			inc_sp => inc_sp,
			dec_sp => dec_sp,
			
			clk => clk
		);
	 
		exec_b : ExecutionUnit PORT MAP
		(
			firstArgCtrl => First_arg,
			secondArgCtrl => Second_arg,
			SP_in => SP_out,
			changes_S => changes_N,
			ld_S_in => ld_N,
			changes_P => changes_P,
			ld_P_in => ld_P,
			changes_Z => changes_Z,
			ld_Z_in => ld_Z,
			changes_O => changes_O,
			ld_O_in => ld_O,
			changes_C => changes_C,
			ld_C_in => ld_C,
			immediateArg => IR_adr_or_imm,
			device_in => DEVice_reg,
			memoryIn => DW_out,
			registerACtrl => mx_AX,
			registerBCtrl => mx_BX,
			registerCCtrl => mx_CX,
			registerDCtrl => mx_DX,
			carryInCtrl => mx_PSWC,
			flags_out => PSW_out,
			flags_in => DW_out,
			ld_flags => ld_PSW,
			
			operation => ALU_OP_code,
			dec_cx => CX_dec,
			c_zero => CX_Z,
			second_arg_zero => second_arg_zero,
			
			cli => clr_i,
			clc => clr_c,
			sti => set_i,
			stc => set_c,
			
			AX_out => AX_out,
			BX_out => BX_out,
			CX_out => CX_out,
			DX_out => DX_out,
			
			ld_ax => ld_AX,
			ld_bx => ld_BX,
			ld_cx => ld_CX,
			ld_dx => ld_DX,
			inc_dx => inc_DX,
			dec_dx => dec_DX,
			
			
			clk => clk
		);
	 
		intr_b : intr PORT MAP
		(
			interruptLines => INT_req,
			flags => PSW_out,
			
			IVTPAddrOut => IVTP_out,
			IVTDisp => IVTDSP,
			interrupt => interrupt,
			
			st_wrong_op_code => st_wrong_op_code,
			st_wrong_arg => st_wrong_arg,
			st_div_zero => st_div_zero,
			cl_wrong_op_code => cl_wrong_op_code,
			cl_wrong_arg => cl_wrong_arg,
			cl_div_zero => cl_div_zero,
			
			wrong_op_code => wrong_op_code,
			wrong_arg => wrong_arg,
			div_zero => div_zero,
			
			br_in => BR_in,
			ld_br => ld_BR,
			mx_br => mx_BR,			
			
			clk => clk
		);
	 
		control_b : Control_Unit PORT MAP
		(
			ld_mar => ld_mar,
			mx_mar => mx_mar,
			ld_mdr => ld_mdr,
			mx_mdr => mx_mdr,
			ld_dw_h => ld_dw_h,
			ld_dw_l => ld_dw_l,
			mx_dw => mx_dw,
			mem_write => mem_wr,
			inc_mar => inc_mar,
			
			ld_ir0 => ld_ir0,
			ld_ir1 => ld_ir1,
			ld_ir2 => ld_ir2,
			ld_pc => ld_pc,
			mx_pc => mx_pc,
			inc_pc => inc_pc,
			
			mx_a => mx_a,
			mx_b => mx_b,
			ld_sp => ld_sp,
			incSP => inc_sp,
			decSP => dec_sp,
			
			ld_PSW_C => ld_C,
			ld_PSW_N => ld_N,
			ld_PSW_O => ld_O,
			ld_PSW_P => ld_P,
			ld_PSW_Z => ld_Z,
			ld_PSW => ld_PSW,
			clr_i => clr_i,
			set_i => set_i,
			clr_c => clr_c,
			set_c => set_c,
			ld_ax => ld_ax,
			mx_ax => mx_ax,
			ld_bx => ld_ax,
			mx_bx => mx_bx,
			ld_cx => mx_cx,
			dec_cx => CX_dec,
			c_zero => CX_Z,
			ld_dx => ld_dx,
			mx_dx => mx_dx,
			inc_dx => inc_DX,
			dec_dx => dec_DX,
			ALU_op_code => ALU_OP_code,
			second_arg_zero => second_arg_zero,
			mx_PSWC => mx_PSWC,
			
			st_wrong_op_code => st_wrong_op_code,
			cl_wrong_op_code => cl_wrong_op_code,
			st_div_zero => st_div_zero,
			cl_div_zero => cl_div_zero,
			st_wrong_arg => st_wrong_arg,
			cl_wrong_arg => cl_wrong_arg,
			ld_br => ld_BR,
			mx_br => mx_BR,
			br_in => BR_in,
						
			start => START,
			one_byte => one_byte,
			two_byte => two_byte,
			PSW_Z => PSW_out(1),
			PSW_N => PSW_out(0),
			PSW_C => PSW_out(3),
			PSW_P => PSW_out(2),
			PSW_O => PSW_out(4),
			wrong_op_code => wrong_op_code,
			wrong_arg => wrong_arg,
			div_zero => div_zero,
			interrupt => interrupt,
			
			ld_dev => Device_wr,
			cl_start => cl_start,
			
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
			
			res_mx => First_arg,
			clk => clk
		);
		
		Device_reg <=	AX_out when Device_wr = '1' else
							Device_reg when Device_wr = '0';
		
		Device_output <= Device_reg;
		
END description;
