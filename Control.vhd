LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY Control_unit IS
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
		st_div_zero : OUT STD_LOGIC;
		st_wrong_arg : OUT STD_LOGIC;
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
    	JE : IN STD_LOGIC;			-- PSW_Z
    	JNE : IN STD_LOGIC;			-- !PSW_Z
    	JG : IN STD_LOGIC;			-- !PSW_N
    	JGE : IN STD_LOGIC;			-- !PSW_N || PSW_Z
    	JL : IN STD_LOGIC;			-- PSW_N && !PSW_Z
    	JLE : IN STD_LOGIC;			-- PSW_N
    	JP : IN STD_LOGIC;			-- PSW_P
    	JNP : IN STD_LOGIC;			-- !PSW_P
    	JO : IN STD_LOGIC;			-- PSW_O
    	JNO : IN STD_LOGIC;			-- !PSW_O
    	LOOP_ins : IN STD_LOGIC;	-- dex_CX; !CX_Z
     	LOOPE : IN STD_LOGIC;		-- dec_CX; !CX_Z && PSW_Z
    	LOOPNE : IN STD_LOGIC;		-- dec_CX; !CX_Z && !PSW_Z
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
      CMP : IN STD_LOGIC;	-- SUB
      TEST : IN STD_LOGIC;	-- AND
        
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
	END Control_unit;
ARCHITECTURE description OF Control_unit IS
	
	COMPONENT register8 IS
		PORT (
			reg_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- input.
			ld : IN STD_LOGIC; -- load/enable.
			inc : IN STD_LOGIC; -- increment
			dec : IN STD_LOGIC; -- decrement
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			shl : IN STD_LOGIC; -- shift left
			r_bit : IN STD_LOGIC; -- new 0 bit after left shift
			shr : IN STD_LOGIC; -- shift right
			l_bit : IN STD_LOGIC; -- new 7 bit after right shift
			reg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- output
		);
	END COMPONENT register8;
	
	
	
	COMPONENT register16 IS
		PORT (
			reg_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- input.
			ld : IN STD_LOGIC; -- load/enable.
			inc : IN STD_LOGIC; -- increment
			dec : IN STD_LOGIC; -- decrement
			clr : IN STD_LOGIC; -- async. clear.
			clk : IN STD_LOGIC; -- clock.
			shl : IN STD_LOGIC; -- shift left
			r_bit : IN STD_LOGIC; -- new 0 bit after left shift
			shr : IN STD_LOGIC; -- shift right
			l_bit : IN STD_LOGIC; -- new 15 bit after right shift
			reg_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) -- output
		);
	END COMPONENT register16;
	
	COMPONENT mikroMemory IS
		PORT (
			addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- address
			dat_out  : OUT STD_LOGIC_VECTOR(76 DOWNTO 0); -- data to write
			clk : IN STD_LOGIC -- clock
		);
	END COMPONENT mikroMemory;
	
	SIGNAL branch : STD_LOGIC;
	SIGNAL branch_id : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL branch_dst : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL condition : STD_LOGIC;
	SIGNAL case_branch : STD_LOGIC;
	
	SIGNAL mComand : STD_LOGIC_VECTOR(76 DOWNTO 0);
	SIGNAL mPC_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mPC_inc : STD_LOGIC;
	SIGNAL mPC_ld : STD_LOGIC;
	
	SIGNAL ld_dw_res : STD_LOGIC;
	SIGNAL ld_res : STD_LOGIC;
	SIGNAL ld_flags : STD_LOGIC;
	SIGNAL mx_res : STD_LOGIC;
	
	SIGNAL cnt_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL cnt_inc : STD_LOGIC;
BEGIN
	st_wrong_arg <= '0';
	
	cnt_inc <=	mPC_out(0);
	
	cnt : register16 PORT MAP(reg_in => "0000000000000000", ld => '0', inc => cnt_inc, dec => '0', clr => '0', shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => cnt_val, clk => clk);

	mPC : register8 PORT MAP (reg_in => branch_dst, ld => mPC_ld, inc => mPC_inc, dec => '0', clr => '0', shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => mPC_out, clk => clk);
	mMEM : mikroMemory PORT MAP(addr => mPC_out, dat_out => mComand, clk => clk);
	
	mPC_ld <= branch;
	mPC_inc <= not (branch);
	
	ld_mar <= mComand(75);
	mx_mar <= mComand(74 DOWNTO 73);
	ld_mdr <= mComand(72);
	mx_mdr <= mComand(71 DOWNTO 70);
	ld_ir0 <= mComand(69);
	ld_ir1 <= mComand(68);
	ld_ir2 <= mComand(67);
	ld_pc <= mComand(66);
	mx_pc <= mComand(76) & mComand(65);
	inc_pc <= mComand(64);
	cl_start <= mComand(63);
	ld_dw_l <= mComand(62);
	ld_dw_h <= mComand(61);
	mx_dw <=	mComand(60 DOWNTO 58) when ld_dw_res = '0' else
				STD_LOGIC_VECTOR(011 + unsigned(res_mx)) when ld_dw_res = '1';
	incSP <= mComand(57);
	decSP <= mComand(56);
	ld_PSW <= mComand(55);
	clr_i <= mComand(54);
	set_i <= mComand(53);
	clr_c <= mComand(52);
	set_c <= mComand(51);
	mx_a <= mComand(50);
	mx_b <= mComand(49 DOWNTO 48);
	dec_cx <= mComand(47);
	mem_write <= mComand(46);
	ALU_op_code <= "00" & mComand(45 DOWNTO 42);
	mx_PSWC <= mComand(41 DOWNTO 39);
	
	ld_res <= mComand(38);
	ld_flags <= mComand(37);
	mx_res <= mComand(36);
	
	ld_ax <= ld_res when res_mx = "000" else
				'1' when mComand(30) = '1' else
				'0' when mComand(30) = '0';
	mx_ax <= mComand(29 DOWNTO 28) when mComand(30) = '1' else
				"0" & mx_res when mComand(30) = '0';
	
	ld_bx <= ld_res when res_mx = "001" else
				'0' when not (res_mx = "001");
	mx_bx <= mx_res;
	
	ld_cx <= ld_res when res_mx = "010" else
				'0' when not (res_mx = "010");
	mx_cx <= mx_res;
	
	ld_dx <= ld_res when res_mx = "011" else
				'1' when mComand(35) = '1' else
				'0' when mComand(35) = '0';
	mx_dx <= mComand(34 DOWNTO 33) when mComand(35) = '1' else
				"0" & mx_res when mComand(35) = '0';
	
	ld_sp <= ld_res when res_mx = "100" else
				'0' when not(res_mx = "100");
	
	ld_PSW_C <= ld_flags;
	ld_PSW_N <= ld_flags;
	ld_PSW_Z <= ld_flags;
	ld_PSW_O <= ld_flags;
	ld_PSW_P <= ld_flags;
	
	dec_dx <= mComand(32);
	inc_dx <= mComand(31);
	
	ld_dw_res <= mComand(27);
	
	ld_dev <= mComand(26);
	st_wrong_op_code <= mComand(25);
	st_div_zero <= mComand(24);
	ld_br <= mComand(23);
	mx_br <= mComand(22);
	br_in <= "0000" & "0000" & "0000" & "10" & mComand(21 DOWNTO 20);
	
	inc_mar <= mComand(19);
	
	cl_wrong_op_code <= mComand(18);
	cl_wrong_arg <= mComand(17);
	cl_div_zero <= mComand(16);
	
-- BRANCH --
	
	
	branch_id <= mComand(15 DOWNTO 8);
	
	condition <=	'1' when ((branch_id = "00000000") and start = '0') else
						'1' when (branch_id = "00000001" and one_byte = '1') else
						'1'when (branch_id = "00000010" and two_byte = '1') else
						'1'when (branch_id = "00000011") else
						'1'when (branch_id = "00000100" and PSW_Z = '0') else
						'1'when (branch_id = "00000101" and PSW_Z = '1') else
						'1'when (branch_id = "00000110" and (PSW_N = '1' or PSW_Z = '1')) else
						'1'when (branch_id = "00000111" and PSW_N = '1') else
						'1'when (branch_id = "00001000" and PSW_N = '0') else
						'1'when (branch_id = "00001001" and (PSW_N = '0' and PSW_Z = '0')) else
						'1'when (branch_id = "00001010" and PSW_P = '0') else
						'1'when (branch_id = "00001011" and PSW_P = '1') else
						'1'when (branch_id = "00001100" and PSW_O = '0') else
						'1'when (branch_id = "00001101" and PSW_O = '1') else
						'1'when (branch_id = "00001110" and c_zero = '1') else
						'1'when (branch_id = "00001111" and (c_zero = '1' or PSW_Z = '0')) else
						'1'when (branch_id = "00010000" and (c_zero = '1' or PSW_Z = '1')) else
						'1'when (branch_id = "00010001" and second_arg_zero = '1') else
						'1'when (branch_id = "00010010" and PSW_C = '0') else
						'1'when (branch_id = "00010011" and wrong_op_code = '0') else
						'1'when (branch_id = "00010100" and wrong_arg = '0') else
						'1'when (branch_id = "00010101" and div_zero = '0') else
						'1'when (branch_id = "00010110" and interrupt = '0') else
						'1'when (branch_id = "00011000" and not(cnt_val = "0000001111111111")) else
						'0';

	case_branch <= '1' when branch_id = "00010111" else
						'0' when not(branch_id = "00010111");
	
	branch <= condition or case_branch;
	
	branch_dst <=   mComand(7 DOWNTO 0) when condition = '1' else
                        "00010000" when (case_branch = '1' and HLT = '1') else
                        "00010001" when (case_branch = '1' and NOP = '1') else
                        "00010010" when (case_branch = '1' and IRET = '1') else
                        "00011000" when (case_branch = '1' and RET = '1') else
                        "00011110" when (case_branch = '1' and CLI = '1') else
                        "00011111" when (case_branch = '1' and STI = '1') else
                        "00100000" when (case_branch = '1' and CLC = '1') else
                        "00100001" when (case_branch = '1' and STC = '1') else
                        "00100010" when (case_branch = '1' and JE = '1') else
                        "00100100" when (case_branch = '1' and JNE = '1') else
                        "00100110" when (case_branch = '1' and JG = '1') else
                        "00101000" when (case_branch = '1' and JGE = '1') else
                        "00101010" when (case_branch = '1' and JL = '1') else
                        "00101100" when (case_branch = '1' and JLE = '1') else
                        "00101110" when (case_branch = '1' and JP = '1') else
                        "00110000" when (case_branch = '1' and JNP = '1') else
                        "00110010" when (case_branch = '1' and JO = '1') else
                        "00110100" when (case_branch = '1' and JNO = '1') else
                        "00110110" when (case_branch = '1' and JMP = '1') else
                        "00110111" when (case_branch = '1' and LOOP_ins = '1') else
                        "00111010" when (case_branch = '1' and LOOPE = '1') else
                        "00111101" when (case_branch = '1' and LOOPNE = '1') else
                        "01000000" when (case_branch = '1' and CALL = '1') else
                        "01000110" when (case_branch = '1' and INT = '1') else
                        "01010001" when (case_branch = '1' and NEG = '1') else
                        "01010010" when (case_branch = '1' and NOT_ins = '1') else
                        "01010011" when (case_branch = '1' and INC = '1') else
                        "01010100" when (case_branch = '1' and DEC = '1') else
                        "01010101" when (case_branch = '1' and RCL = '1') else
                        "01010110" when (case_branch = '1' and RCR = '1') else
                        "01010111" when (case_branch = '1' and ROL_ins = '1') else
                        "01011000" when (case_branch = '1' and ROR_ins = '1') else
                        "01011001" when (case_branch = '1' and SAHR = '1') else
                        "01011010" when (case_branch = '1' and SAR = '1') else
                        "01011011" when (case_branch = '1' and (SAL = '1' or SHL = '1')) else
                        "01011100" when (case_branch = '1' and SHR = '1') else
                        "01011101" when (case_branch = '1' and POP = '1') else
                        "01100011" when (case_branch = '1' and PUSH = '1') else
                        "01101000" when (case_branch = '1' and ADD = '1') else
                        "01101001" when (case_branch = '1' and SUB = '1') else
                        "01101010" when (case_branch = '1' and MUL = '1') else
                        "01101011" when (case_branch = '1' and AND_ins = '1') else
                        "01101100" when (case_branch = '1' and OR_ins = '1') else
                        "01101101" when (case_branch = '1' and XOR_ins = '1') else
                        "01101110" when (case_branch = '1' and CMP = '1') else
                        "01101111" when (case_branch = '1' and TEST = '1') else
                        "01110000" when (case_branch = '1' and DIV = '1') else
                        "01110110" when (case_branch = '1' and LDV = '1') else
                        "01111000" when (case_branch = '1' and LDR = '1') else
                        "01111110" when (case_branch = '1' and STR = '1') else
                        "10000011" when (case_branch = '1' and MOV = '1') else
                        "10000101" when (case_branch = '1' and IN_ins = '1') else
                        "10000110" when (case_branch = '1' and OUT_ins = '1') else
                        "10000111" when (case_branch = '1');
	
	process(clk)
	begin
	end process;
END description;