entity intr is
	port (clk: in std_logic;
			interruptLines: in std_logic_vector(7 downto 0);
			flags: in std_logic_vector(15 downto 0));
			memoryIn: in std_logic_vector(15 downto 0);
			
			IVTPAddrOut: out std_logic_vector(15 downto 0);
			IVTDisp: out std_logic_vector(15 downto 0);
			interrupt: out std_logic;
end entity intr;

architecture behavioral of intr is
signal perIntr: std_logic;
signal UEXT: std_logic_vector(2 downto 0);

signal IVTP_reg_in: std_logic_vector(15 downto 0);
signal IVTP_ld: std_logic;
signal IVTP_inc: std_logic;
signal IVTP_dec: std_logic;
signal IVTP_clr: std_logic;
signal IVTP_shl: std_logic;
signal IVTP_shr: std_logic;
signal IVTP_r_bit: std_logic;
signal IVTP_l_bit: std_logic;
signal IVTP_reg_out: std_logic_vector(15 downto 0);

signal BR_reg_in: std_logic_vector(15 downto 0);
signal BR_ld: std_logic;
signal BR_inc: std_logic;
signal BR_dec: std_logic;
signal BR_clr: std_logic;
signal BR_shl: std_logic;
signal BR_shr: std_logic;
signal BR_r_bit: std_logic;
signal BR_l_bit: std_logic;
signal BR_reg_out: std_logic_vector(15 downto 0);

signal intrOffset: std_logic_vector(15 downto 0);


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
	
begin
registerIVTP: register16
	port map(IVTP_reg_in, IVTP_ld, IVTP_inc, IVTP_dec, IVTP_clr, clk, IVTP_shl, IVTP_r_bit, IVTP_shr, IVTP_l_bit, IVTP_reg_out);
registerBR: register16
	port map(BR_reg_in, BR_ld, BR_inc, BR_dec, BR_clr, clk, BR_shl, BR_r_bit, BR_shr, BR_l_bit, BR_reg_out);

perIntr <= interruptLines(0) and interruptLines(1) and interruptLines(2) and interruptLines(3) and interruptLines(4) and interruptLines(5) and interruptLines(6) and interruptLines(7);
interrupt <= perIntr and flags(6);

UEXT <=
	"000" when interruptLines(0) = '1' else
	"001" when interruptLines(1) = '1' else
	"010" when interruptLines(2) = '1' else
	"011" when interruptLines(3) = '1' else
	"100" when interruptLines(4) = '1' else
	"101" when interruptLines(5) = '1' else
	"110" when interruptLines(6) = '1' else
	"111" when interruptLines(7);
	
BR_reg_in <= "0000000000000" & UEXT;

intrOffset <= "000000000000" & BR_reg_out(2 downto 0) & "0";
IVTDisp <= intrOffset;
IVTPAddrOut <= IVTP_reg_out;

IVTP_reg_in <= MemoryIn;



	
end behavioral;