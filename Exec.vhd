entity ExecutionUnit is
	port(clk: in bit; -- clock
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
	signal f_clC: std_logic;
	signal f_stT: std_logic;
	signal f_clT: std_logic;
	signal f_stI: std_logic;
	signal f_clI: std_logic;
	signal f_ldFlags: std_logic;
	signal f_FlagsIn: std_logic_vector(15 downto 0);
	signal f_FlagsOut: std_logic_vector(15 downto 0);
	
	signal SP_in: std_logic_vector(15 downto 0);
	
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
		
	with firstArgCtrl select ALU_firstArgument <= -- MX 
		a_reg_out when "000";
		b_reg_out when "001";
		c_reg_out when "010";
		d_reg_out when "011";
		SP_in when "100";
		"0000000000000000" when "101";
		"1111111111111111" when "110";
		immediateArg when "111";
		
	with secondArgCtrl select ALU_secondArgument <=
		a_reg_out when "000";
		b_reg_out when "001";
		c_reg_out when "010";
		d_reg_out when "011";
		SP_in when "100";
		"0000000000000000" when "101";
		"1111111111111111" when "110";
		immediateArg when "111";
		
	with registerACtrl select a_reg_in <=
		memoryIn when '0';
		Result when '1';
		
	with registerBCtrl select b_reg_in <=
		memoryIn when '0';
		Result when '1';
		
	with registerCCtrl select c_reg_in <=
		memoryIn when '0';
		Result when '1';
		
	with registerDCtrl select d_reg_in <=
		memoryIn when '0';
		Result when '1';
		
	with carryInCtrl select Carry_In <=
		'0' when "000";
		'1' when "001";
		flags(3) when "010";
		firstArgument(0) when "011";
		firstArgument(15) when "100";
		secondArgument(0) when "101";
		secondArgument(15) when "110";
		'1' when "111";
		
	-- changes Sign flag if the operation is supposed to change it, load signal is active and ALU flag is (in)active
	f_stS <= changes_S and ld_S_in and ALU_Sign_Out;
	f_clS <= changes_S and ld_S_in and not ALU_Sign_Out;
	
	f_stZ <= changes_Z and ld_Z_in and ALU_Zero_Out_;
	f_clZ <= changes_Z and ld_Z_in and not ALU_Zero_Out;
	
	f_stO <= changes_O and ld_O_in and ALU_Overflow_Out;
	f_clO <= changes_O and ld_O_in and not ALU_Overflow_Out;
	
	f_stC <= changes_C and ld_C_in and ALU_Carry_Out;
	f_clC <= changes_C and ld_C_in and not ALU_Carry_Out;
	
	f_stP <= changes_P and ld_P_in and ALU_Parity_Out;
	f_clP <= changes_P and ld_P_in and not ALU_Parity_Out;
	
	
	
		
	
	end ExecUnitImpl;