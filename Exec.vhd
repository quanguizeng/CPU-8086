library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ExecutionUnit is
	port(clk: in std_logic; -- clock
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
		  registerACtrl: in std_logic_vector(1 downto 0); -- 11: Device1; 10: DX; 01: Result; 00: MemoryIn;
		  registerBCtrl: in std_logic; -- 1: Result; 0: MemoryIn
		  registerCCtrl: in std_logic; -- 1: Result; 0: MemoryIn
		  registerDCtrl: in std_logic_vector(1 downto 0); -- 11: 0; 10: AX; 01: Result; 00: MemoryIn
		  carryInCtrl: in std_logic_vector(2 downto 0); -- MX control for the carry bit
		  
		  operation : in std_logic_vector(5 downto 0);
		  
		  flags_out : out std_logic_vector(15 downto 0); -- value of the flags register
		  flags_in : in std_logic_vector(15 downto 0); -- input value of the flags register
		  ld_flags : in std_logic; -- load flags
		  
		  dec_cx : in std_logic;
		  c_zero : out std_logic;
		  second_arg_zero : out std_logic;
		  
		  cli : in std_logic;
		  sti : in std_logic;
		  clc : in std_logic;
		  stc : in std_logic;
		  
		  
		  AX_out : in std_logic_vector(15 downto 0);
		  BX_out : in std_logic_vector(15 downto 0);
		  CX_out : in std_logic_vector(15 downto 0);
		  DX_out : in std_logic_vector(15 downto 0);
		  
		  ld_ax : in std_logic;
		  ld_bx : in std_logic;
		  ld_cx : in std_logic;
		  ld_dx : in std_logic;
		  
		  inc_dx : in std_logic;
		  dec_dx : in std_logic
	);
end ExecutionUnit;

architecture ExecUnitImpl of ExecutionUnit is
	signal OperationCode: std_logic_vector(5 downto 0); -- control signal for ALU (operation code)
	signal Carry_In: std_logic; -- carry signal for ALU
	
	signal a_reg_in: std_logic_vector(15 downto 0);
	signal a_ld: std_logic;
	signal a_inc: std_logic;
	signal a_dec: std_logic;
	signal a_clr: std_logic;
	signal a_shl: std_logic;
	signal a_r_bit: std_logic;
	signal a_shr: std_logic;
	signal a_l_bit: std_logic;
	signal a_reg_out: std_logic_vector(15 downto 0);
	
	signal b_reg_in: std_logic_vector(15 downto 0);
	signal b_ld: std_logic;
	signal b_inc: std_logic;
	signal b_dec: std_logic;
	signal b_clr: std_logic;
	signal b_shl: std_logic;
	signal b_r_bit: std_logic;
	signal b_shr: std_logic;
	signal b_l_bit: std_logic;
	signal b_reg_out: std_logic_vector(15 downto 0);
	
	signal c_reg_in: std_logic_vector(15 downto 0);
	signal c_ld: std_logic;
	signal c_inc: std_logic;
	signal c_dec: std_logic;
	signal c_clr: std_logic;
	signal c_shl: std_logic;
	signal c_r_bit: std_logic;
	signal c_shr: std_logic;
	signal c_l_bit: std_logic;
	signal c_reg_out: std_logic_vector(15 downto 0);
	
	signal d_reg_in: std_logic_vector(15 downto 0);
	signal d_ld: std_logic;
	signal d_inc: std_logic;
	signal d_dec: std_logic;
	signal d_clr: std_logic;
	signal d_shl: std_logic;
	signal d_r_bit: std_logic;
	signal d_shr: std_logic;
	signal d_l_bit: std_logic;
	signal d_reg_out: std_logic_vector(15 downto 0);
	
	signal f_stS: std_logic;
	signal f_clS: std_logic;
	signal f_stZ: std_logic;
	signal f_clZ: std_logic;
	signal f_stP: std_logic;
	signal f_clP: std_logic;
	signal f_stC: std_logic;
	signal f_stO: std_logic;
	signal f_clC: std_logic;
	signal f_stT: std_logic;
	signal f_clT: std_logic;
	signal f_stI: std_logic;
	signal f_clI: std_logic;
	signal f_clO: std_logic;
	signal f_ldFlags: std_logic;
	signal f_FlagsIn: std_logic_vector(15 downto 0);
	signal f_FlagsOut: std_logic_vector(15 downto 0);
	
	signal ALU_firstArgument: std_logic_vector(15 downto 0);
	signal ALU_secondArgument: std_logic_vector(15 downto 0);
	signal ALU_opCode: std_logic_vector(5 downto 0);
	signal ALU_Carry_In: std_logic;
	signal ALU_Carry_Out: std_logic;
	signal ALU_Parity_Out: std_logic;
	signal ALU_Adjust_Out: std_logic;
	signal ALU_Overflow_Out: std_logic;
	signal ALU_Zero_Out: std_logic;
	signal ALU_Sign_Out: std_logic;
	signal ALU_Result: std_logic_vector(15 downto 0);
	

	
	
	
	component register16
		port(reg_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- input.
		ld : IN STD_LOGIC; -- load/enable.
		inc : IN STD_LOGIC; -- increment
		dec : IN STD_LOGIC; -- decrement
		clr : IN STD_LOGIC; -- async. clear.
		clk : IN STD_LOGIC; -- clock.
		shl : IN STD_LOGIC; -- shift left
		r_bit : IN STD_LOGIC; -- new 0 bit after left shift
		shr : IN STD_LOGIC; -- shift right
		l_bit : IN STD_LOGIC; -- new 15 bit after right shift
		reg_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
	end component;
	
	component ALU
		port (FirstArgument, SecondArgument: in std_logic_vector(15 downto 0);
			Operation: in std_logic_vector(5 downto 0);
			Carry_In: in std_logic;
			
			Carry_Out: out std_logic;
			Parity_Out: out std_logic;
			Adjust_Out: out std_logic;
			Overflow_Out: out std_logic;
			Zero_Out: out std_logic;
			Sign_Out: out std_logic;
			Result: out std_logic_vector(15 downto 0)
		);
	end component;
	
	component FlagsRegister
		port (clk: in std_logic;
			
			stS: in std_logic;
			clS: in std_logic;
			
			stZ: in std_logic;
			clZ: in std_logic;
			
			stP: in std_logic;
			clP: in std_logic;
			
			stC: in std_logic;
			clC: in std_logic;
			
			stO: in std_logic;
			clO: in std_logic;
			
			stT: in std_logic;
			clT: in std_logic;
			
			stI: in std_logic;
			clI: in std_logic;
			
			ldFlags: in std_logic;
			FlagsIn: in std_logic_vector(15 downto 0);
			
			FlagsOut: out std_logic_vector(15 downto 0)
			); 
	end component;
	
	begin
	RegisterA: register16
		port map(a_reg_in, a_ld, a_inc, a_dec, a_clr, clk, a_shl, a_r_bit, a_shr, a_l_bit, a_reg_out);
	RegisterB: register16
		port map(b_reg_in, b_ld, b_inc, b_dec, b_clr, clk, b_shl, b_r_bit, b_shr, b_l_bit, b_reg_out);
	RegisterC: register16
		port map(c_reg_in, c_ld, c_inc, c_dec, c_clr, clk, c_shl, c_r_bit, c_shr, c_l_bit, c_reg_out);
	RegisterD: register16
		port map(d_reg_in, d_ld, d_inc, d_dec, d_clr, clk, d_shl, d_r_bit, d_shr, d_l_bit, d_reg_out);
	Flags: FlagsRegister
		port map(clk, f_stS, f_clS, f_stZ, f_clZ, f_stP, f_clP, f_stC, f_clC, f_stO, f_clO, f_stT, f_clT, f_stI, f_clI, f_ldFlags, f_FlagsIn, f_FlagsOut);
	ALUCom: ALU
		port map(ALU_firstArgument, ALU_secondArgument, ALU_opCode, ALU_Carry_In, ALU_Carry_Out, ALU_Parity_Out, ALU_Adjust_Out, ALU_Overflow_Out, ALU_Zero_Out, ALU_Sign_Out, ALU_Result);
	

	ALU_firstArgument <=	a_reg_out when firstArgCtrl = "000" else
								b_reg_out when firstArgCtrl = "001" else
								c_reg_out when firstArgCtrl = "010" else
								d_reg_out when firstArgCtrl = "011" else
								SP_in when firstArgCtrl = "100" else
								"0000000000000000" when firstArgCtrl = "101" else
								immediateArg when firstArgCtrl = "111" else
								"1111111111111111" when firstArgCtrl = "110";
	
	ALU_secondArgument <=	a_reg_out when secondArgCtrl = "000" else
									b_reg_out when secondArgCtrl = "001" else
									c_reg_out when secondArgCtrl = "010" else
									d_reg_out when secondArgCtrl = "011" else
									SP_in when secondArgCtrl = "100" else
									"0000000000000000" when secondArgCtrl = "101" else
									immediateArg when secondArgCtrl = "111" else
									"1111111111111111" when secondArgCtrl = "110";
	
	a_reg_in <=	memoryIn when registerACtrl = "00" else
					ALU_Result when registerACtrl = "01" else
					device_in when registerACtrl = "10" else
					d_reg_out when registerACtrl = "11";
		
	b_reg_in <=	memoryIn when registerBCtrl = '0' else
					ALU_Result when registerBCtrl = '1';
	
	c_reg_in <=	memoryIn when registerCCtrl = '0' else
					ALU_Result when registerCCtrl = '1';
		
	d_reg_in <=	memoryIn when registerDCtrl = "00" else
					ALU_Result when registerDCtrl = "01" else
					a_reg_out when registerDCtrl = "10" else
					"0000" & "0000" & "0000" & "0000" when registerDCtrl = "11";
	
	Carry_In <=	'0' when carryInCtrl = "000" else -- 0
					'1' when carryInCtrl = "001" else -- 1
					f_FlagsOut(3) when carryInCtrl = "010" else -- Flags carry bit
					ALU_firstArgument(0) when carryInCtrl = "011" else -- Lowest bit of the first argument. Used in rotations
					ALU_firstArgument(15) when carryInCtrl = "100" else -- Highest bit of the first argument. Used in rotations and arithmetic shifts
					ALU_secondArgument(0) when carryInCtrl = "101" else -- Lowest bit of the second argument. Used in rotations
					ALU_firstArgument(15) when carryInCtrl = "110" else -- Highest bit of the second argument. Used in rotations and arithmetic shifts
					'1' when carryInCtrl = "111"; -- Placeholder
		
	-- changes Sign flag if the operation is supposed to change it, load signal is active and ALU flag is (in)active
	f_stS <= changes_S and ld_S_in and ALU_Sign_Out;
	f_clS <= changes_S and ld_S_in and not ALU_Sign_Out;
	
	f_stZ <= changes_Z and ld_Z_in and ALU_Zero_Out;
	f_clZ <= changes_Z and ld_Z_in and not ALU_Zero_Out;
	
	f_stO <= changes_O and ld_O_in and ALU_Overflow_Out;
	f_clO <= changes_O and ld_O_in and not ALU_Overflow_Out;
	
	f_stC <= (changes_C and ld_C_in and ALU_Carry_Out) or stc;
	f_clC <= (changes_C and ld_C_in and not ALU_Carry_Out) or clc;
	
	f_stI <= sti;
	f_clI <= cli;
	
	f_stP <= changes_P and ld_P_in and ALU_Parity_Out;
	f_clP <= changes_P and ld_P_in and not ALU_Parity_Out;
	
	flags_out <= f_flagsOut;
	
	c_dec <= dec_cx;
	c_zero <=	'1' when c_reg_out = "0000" & "0000" & "0000" & "0000" else
					'0';
					
	ALU_opCode <= operation;
	
	second_arg_zero <=	'1' when unsigned(ALU_secondArgument) = 0 else
								'0' when not (unsigned(ALU_secondArgument) = 0);
	
	end ExecUnitImpl;