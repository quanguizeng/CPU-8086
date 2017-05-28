library IEEE;
use ieee.std_logic_1644.all;

entity fetch is
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
        
        ir_out : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    );
end fetch;

architecture fetchImpl of fetch is
    COMPONENT reg16 IS
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
	END COMPONENT reg16;
	
	COMPONENT reg8 IS
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
	END COMPONENT reg8;
	
	SIGNAL IR : STD_LOGIC_VECTOR(23 DOWNTO 0);
	SIGNAL PC_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL ir0_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ir1_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL ir2_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
    SIGNAL no_operand_inner : STD_LOGIC;
    SIGNAL branch_inner : STD_LOGIC;
    SIGNAL interrupt_inner : STD_LOGIC;
    SIGNAL one_register_operand_inner : STD_LOGIC;
    SIGNAL arlog_inner : STD_LOGIC;
    SIGNAL arlog_imm_inner : STD_LOGIC;
    SIGNAL arlog_reg_inner : STD_LOGIC;
    SIGNAL div_imm_inner : STD_LOGIC;
    SIGNAL div_reg_inner : STD_LOGIC;
    SIGNAL io_inner : STD_LOGIC;
    SIGNAL load_store_inner : STD_LOGIC;
    SIGNAL load_store_two_byte_inner : STD_LOGIC;
    SIGNAL load_store_three_byte_inner : STD_LOGIC;
    
    SIGNAL MOV_inner : STD_LOGIC;
    SIGNAL DIV_inner : STD_LOGIC;
    SIGNAL INT_inner : STD_LOGIC;
begin
    IR <= ir0_out & ir1_out & ir2_out;
    
    no_operand <= no_operand_inner;
    branch <= branch_inner;
    interrupt <= interrupt_inner;
    one_register_operand <= one_register_operand_inner;
    arlog <= arlog_inner;
    arlog_imm <= arlog_imm_inner;
    arlog_reg <= arlog_reg_inner;
    div_imm <= div_imm_inner;
    div_reg <= div_reg_inner;
    io <= io_inner;
    load_store <= load_store_inner;
    load_store_two_byte <= load_store_two_byte_inner;
    load_store_three_byte <= load_store_three_byte_inner;
    
    no_operand_inner <= IR(23) and IR(22) and IR(21) and IR(20) and IR(19);
    
    HLT <= no_operand_inner and (not IR(18)) and (not IR(17)) and (not IR(16));
    NOP <= no_operand_inner and (not IR(18)) and (not IR(17)) and IR(16);
    RET <= no_operand_inner and (not IR(18)) and IR(17) and (not IR(16));
    IRET <= no_operand_inner and (not IR(18)) and IR(17) and IR(16);
    CLI <= no_operand_inner and IR(18) and (not IR(17)) and (not IR(16));
    STI <= no_operand_inner and IR(18) and (not IR(17)) and IR(16);
    CLC <= no_operand_inner and IR(18) and IR(17) and (not IR(16));
    STC <= no_operand_inner and IR(18) and IR(17) and IR(16);
    
    branch_inner <= IR(23) and IR(22) and IR(21) and (not IR(20)) and (not INT_inner);
    
    JMP <= branch_inner and (not IR(19)) and (not IR(18)) and (not IR(17)) and (not IR(16));
	JE <= branch_inner and (not IR(19)) and (not IR(18)) and (not IR(17)) and IR(16);
	JNE <= branch_inner and (not IR(19)) and (not IR(18)) and IR(17) and (not IR(16));
	JG <= branch_inner and (not IR(19)) and (not IR(18)) and IR(17) and IR(16);
	JGE <= branch_inner and (not IR(19)) and IR(18) and (not IR(17)) and (not IR(16));
	JL <= branch_inner and (not IR(19)) and IR(18) and (not IR(17)) and IR(16);
	JLE <= branch_inner and (not IR(19)) and IR(18) and IR(17) and (not IR(16));
	JP <= branch_inner and (not IR(19)) and IR(18) and IR(17) and IR(16);
	JNP <= branch_inner and IR(19) and (not IR(18)) and (not IR(17)) and (not IR(16));
	JO <= branch_inner and IR(19) and (not IR(18)) and (not IR(17)) and IR(16);
	JNO <= branch_inner and IR(19) and (not IR(18)) and IR(17) and (not IR(16));
	LOOP_ins <= branch_inner and IR(19) and (not IR(18)) and IR(17) and IR(16);
 	LOOPE <= branch_inner and IR(19) and IR(18) and (not IR(17)) and (not IR(16));
	LOOPNE <= branch_inner and IR(19) and IR(18) and (not IR(17)) and IR(16);
	CALL <= branch_inner and IR(19) and IR(18) and IR(17) and (not IR(16));
    
    interrupt_inner <= INT_inner;
    
    INT <= INT_inner;
    
    INT_inner <= IR(23) and IR(22) and IR(21) and (not IR(20)) and IR(19) and IR(18) and IR(17) and IR(16);
    
    one_register_operand_inner <= IR(23) and (not IR(22)) and (not io_inner);
    
    NEG <= one_register_operand_inner and (not IR(21)) and (not IR(20)) and (not IR(19)) and (not IR(18));
    NOT_ins <= one_register_operand_inner and (not IR(21)) and (not IR(20)) and (not IR(19)) and IR(18);
    INC <= one_register_operand_inner and (not IR(21)) and (not IR(20)) and IR(19) and (not IR(18));
    DEC <= one_register_operand_inner and (not IR(21)) and (not IR(20)) and IR(19) and IR(18);
    RCL <= one_register_operand_inner and (not IR(21)) and IR(20) and (not IR(19)) and (not IR(18));
    RCR <= one_register_operand_inner and (not IR(21)) and IR(20) and (not IR(19)) and IR(18);
    ROL_ins <= one_register_operand_inner and (not IR(21)) and IR(20) and IR(19) and (not IR(18));
    ROR_ins <= one_register_operand_inner and (not IR(21)) and IR(20) and IR(19) and IR(18);
    SAHR <= one_register_operand_inner and IR(21) and (not IR(20)) and (not IR(19)) and (not IR(18));
    SAR <= one_register_operand_inner and IR(21) and (not IR(20)) and (not IR(19)) and IR(18);
    SAL <= one_register_operand_inner and IR(21) and (not IR(20)) and IR(19) and (not IR(18));
    SHL <= one_register_operand_inner and IR(21) and (not IR(20)) and IR(19) and IR(18);
    SHR <= one_register_operand_inner and IR(21) and IR(20) and (not IR(19)) and (not IR(18));
    POP <= one_register_operand_inner and IR(21) and IR(20) and (not IR(19)) and IR(18);
    PUSH <= one_register_operand_inner and IR(21) and IR(20) and IR(19) and (not IR(18));
    
    arlog_inner <= not IR(23);
    
    ADD <= arlog_inner and (not IR(22)) and (not IR(21)) and (not IR(20));
    SUB <= arlog_inner and (not IR(22)) and (not IR(21)) and IR(20);
    MUL <= arlog_inner and (not IR(22)) and IR(21) and (not IR(20));
    AND_ins <= arlog_inner and (not IR(22)) and IR(21) and IR(20);
    OR_ins <= arlog_inner and IR(22) and (not IR(21)) and (not IR(20));
    XOR_ins <= arlog_inner and IR(22) and (not IR(21)) and IR(20);
    CMP <= arlog_inner and IR(22) and IR(21) and (not IR(20));
    TEST <= arlog_inner and IR(22) and IR(21) and IR(20);
    
    arlog_imm_inner <= arlog_inner and IR(19);
    arlog_reg_inner <= arlog_inner and (not IR(19));

    DIV <= DIV_inner;

    DIV_inner <= IR(23) and IR(22) and IR(21) and IR(20) and (not IR(19));
    
    div_imm_inner <= DIV_inner and IR(18);
    div_reg_inner <= DIV_inner and (not IR(18));
    
    io_inner <= IR(23) and (not IR(22)) and IR(21) and IR(20) and IR(19) and IR(18);
    
    IN_ins <= io_inner and (not IR(17)) and (not IR(16));
    OUT_ins <= io_inner and (not IR(17)) and IR(16);
    
    load_store_inner <= IR(23) and IR(22) and (not IR(21));
    
    LDV <= load_store_inner and (not IR(20)) and (not IR(19));
    LDR <= load_store_inner and (not IR(20)) and IR(19);
    STR <= load_store_inner and IR(20) and (not IR(19));
    MOV_inner <= load_store_inner and IR(20) and IR(19);
    
    MOV <= MOV_inner;
    
    load_store_two_byte_inner <= MOV_inner;
    load_store_three_byte_inner <= load_store and (not MOV_inner);
    
    one_byte <= no_operand_inner or one_register_operand_inner or div_reg_inner;
    two_byte <= interrupt_inner or arlog_reg_inner or io_inner or load_store_two_byte_inner;
    three_byte <= branch_inner or arlog_imm_inner or div_imm_inner or load_store_three_byte_inner;
    
    pc: reg16 PORT MAP(reg_in => pc_in, ld => ld_pc, inc => inc_pc, dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => pc_out);
	ir0: reg8 PORT MAP(reg_in => mdr_out, ld => ld_ir0, inc => '0', dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => ir0_out);
	ir1: reg8 PORT MAP(reg_in => mdr_out, ld => ld_ir1, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => ir1_out);
	ir2: reg8 PORT MAP(reg_in => mdr_out, ld => ld_ir2, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => ir2_out);
	
	ir_out <= IR;
	
	case mx_pc is
      when "00" =>
        pc_in <= dw_out;
      when "01" =>
        pc_in <= addr;
      when "10" =>
        pc_in <= ir2_out & ir1_out;
    end case;
    
end fetchImpl;

