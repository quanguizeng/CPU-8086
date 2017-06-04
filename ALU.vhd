library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	port (FirstArgument, SecondArgument: in std_logic_vector(15 downto 0); -- ALU arguments
			Operation: in std_logic_vector(5 downto 0) := "000000"; -- Operation code
			Carry_In: in std_logic; -- Carry from the previous round
			
			-- Flags
			Carry_Out: out std_logic;
			Parity_Out: out std_logic;
			Adjust_Out: out std_logic;
			Overflow_Out: out std_logic;
			Zero_Out: out std_logic;
			Sign_Out: out std_logic;
			
			-- ALU Output
			Result: out std_logic_vector(15 downto 0)
		);
end entity ALU;

architecture Behavior of ALU is
	signal Result_val: std_logic_vector(15 downto 0);
	
	-- Temporary storage for addition
	signal TempAdd: std_logic_vector(16 downto 0);
	
	-- Temporary storage for bottom nibble for BCD operations and adjust flag
	signal Temp_Nibble: std_logic_vector(4 downto 0);
	
	-- Temporary storage for multiplication
	signal TempMul: std_logic_vector(31 downto 0);
	
	signal expand_carry: std_logic_vector(15 downto 0);
	signal nibble_carry: std_logic_vector(4 downto 0);
	
	signal carry_val: std_logic;
	
	constant ADD_OP:  std_logic_vector(5 downto 0) := "000000";
	constant SUB_OP:  std_logic_vector(5 downto 0) := "000001";
	constant AND_OP:  std_logic_vector(5 downto 0) := "000010";
	constant OR_OP:   std_logic_vector(5 downto 0) := "000011";
	constant XOR_OP:  std_logic_vector(5 downto 0) := "000100";
	constant NOT1_OP: std_logic_vector(5 downto 0) := "000101";
	constant NOT2_OP: std_logic_vector(5 downto 0) := "000110";
	constant NEG1_OP: std_logic_vector(5 downto 0) := "000111";
	constant NEG2_OP: std_logic_vector(5 downto 0) := "001000";
	constant SHL_OP: std_logic_vector(5 downto 0) := "001001";
	constant SHR_OP: std_logic_vector(5 downto 0) := "001010";
	constant MUL_OP: std_logic_vector(5 downto 0) := "001011";
	
begin
	
	expand_carry <=	"0000" & "0000" & "0000" & "0001" when Carry_In = '1' else
						"0000" & "0000" & "0000" & "0000" when Carry_In = '0';
	
	nibble_carry <=	"00001" when Carry_In = '1' else
							"00000" when Carry_In = '0';
	
	Temp_Nibble <= std_logic_vector(unsigned("0" & FirstArgument(3 downto 0)) + unsigned(nibble_carry) + unsigned("0" & SecondArgument(3 downto 0)));
	
	TempMul <= std_logic_vector(unsigned(FirstArgument) * unsigned(SecondArgument));
	
	TempAdd <=	std_logic_vector(unsigned("0" & expand_carry) + unsigned("0" & FirstArgument) + unsigned("0" & SecondArgument));
	
	carry_val <=	TempAdd(16) when Operation = ADD_OP else
						'1' when (Operation = SUB_OP and FirstArgument < SecondArgument) or (not (unsigned(TempMul(31 downto 16)) = 0) and Operation = MUL_OP) else
						FirstArgument(15) when Operation = SHL_OP else
						FirstArgument(0) when Operation = SHR_OP else
						'0';
	
	Carry_Out <= carry_val;
	
	Parity_Out <= Result_val(0);
	
	Sign_Out <= Result_val(15);
	
	Zero_Out <=	'1' when Result_val = "0000000000000000" else
					'0';
	
	Adjust_Out <=	Temp_Nibble(4) when Operation = ADD_OP else
						'1' when Operation = SUB_OP and FirstArgument(3 downto 0) < SecondArgument(3 downto 0) else
						'0';
	
	Overflow_Out <=	carry_val when Operation = ADD_OP or Operation = SUB_OP or Operation = MUL_OP else
							'1' when not(FirstArgument(15) = Result_val(15)) and (Operation = SHL_OP or Operation = SHR_OP) else
							'0';
	
	Result_val <=	TempAdd(15downto 0) when Operation = ADD_OP else
						std_logic_vector(unsigned(FirstArgument) - unsigned(SecondArgument)) when Operation = SUB_OP and FirstArgument >= SecondArgument else
						std_logic_vector(unsigned(FirstArgument) + unsigned(not SecondArgument) + 1) when Operation = SUB_OP and FirstArgument < SecondArgument else
						FirstArgument and SecondArgument when Operation = AND_OP else
						FirstArgument or SecondArgument when Operation = OR_OP else
						FirstArgument xor SecondArgument when Operation = XOR_OP else
						not FirstArgument when Operation = NOT1_OP else
						not SecondArgument when Operation = NOT2_OP else
						std_logic_vector(0 - unsigned(FirstArgument)) when Operation = NEG1_OP else
						std_logic_vector(0 - unsigned(SecondArgument)) when Operation = NEG2_OP else
						FirstArgument(14 downto 0) & Carry_In when Operation = SHL_OP else
						Carry_In & FirstArgument(15 downto 1) when Operation = SHR_OP else
						TempMul(15 downto 0) when Operation = MUL_OP else
						"0000000000000000";
	
	Result <= Result_val;
	
end Behavior;
		
			