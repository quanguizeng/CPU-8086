library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	port (FirstArgument, SecondArgument: in std_logic_vector(15 downto 0); -- ALU arguments
			Operation: in std_logic_vector(5 downto 0); -- Operation code
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
	-- Temporary storage for addition
	signal Temp: std_logic_vector(16 downto 0);
	
	-- Temporary storage for bottom nibble for BCD operations and adjust flag
	signal Temp_Nibble: std_logic_vector(4 downto 0);
	
	-- Temporary storage for multiplication
	signal TempMul: std_logic_vector(31 downto 0);
	
	signal carry_val : std_logic_vector(15 DOWNTO 0);
	signal carry_nib : std_logic_vector(3 DOWNTO 0);
	
	signal Result_val : std_logic_vector(15 DOWNTO 0);
	
begin

	Result <= Result_val;

	carry_val <= "0000" & "0000" & "0000" & "0001" when Carry_In = '1' else
						"0000" & "0000" & "0000" & "0000" when Carry_In = '0';
	
	carry_nib <= "0001" when Carry_In = '1' else
						"0000" when Carry_In = '0';

	process(FirstArgument, SecondArgument, Operation, Temp, Carry_In) is
	
	-- Operation constants
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
		Carry_Out <= '0';
		Parity_Out <= '0';
		Adjust_Out <= '0';
		Overflow_Out <= '0';
		Zero_Out <= '0';
		Sign_Out <= '0';
		
		case Operation is
		
		when ADD_OP => -- Result = Arg1 + Arg2, Flag = Carry = Overflow
		
			-- Add arguments
			Temp <= std_logic_vector((unsigned("0" & FirstArgument) + unsigned("0" & SecondArgument) + unsigned("0" & carry_val)));
			
			-- Add bottom nibble
			Temp_Nibble <= std_logic_vector(unsigned("0" & FirstArgument(3 downto 0)) + unsigned("0" & SecondArgument(3 downto 0)) + unsigned("0" & carry_nib));
			
			-- Save result
			Result_val <= Temp(15 downto 0);
			
			-- Set carry and overflow
			Carry_Out <= Temp(16);
			Overflow_Out <= Temp(16);
			
			
			-- Set adjust
			Adjust_Out <= Temp_Nibble(4);
			
		when SUB_OP => -- Result = |Arg1 - Arg2|, Flag = 1 iff Arg2 > Arg1
		
			-- If the result is positive
			if (FirstArgument >= SecondArgument) then
				-- Save result
				Result_val <= std_logic_vector(unsigned(FirstArgument) - unsigned(SecondArgument));
				-- No overflow
				Overflow_Out <= '0';
				
				-- Set carry
				Carry_Out <= '0';
		
			else
				-- Overflow occurs
				Result_val <= std_logic_vector(unsigned(SecondArgument) - unsigned(FirstArgument));
				
				-- Set overflow
				Overflow_Out <= '1';
				-- Set carry
				Carry_Out <= '1';

				
			end if;
			
			-- Set adjust flag
			if (FirstArgument(3 downto 0) >= SecondArgument(3 downto 0)) then
					Adjust_Out <= '0';
				else
					Adjust_Out <= '1';
			end if;	
		when AND_OP => -- Result = Arg1 AND Arg2
			Result_val <= FirstArgument and SecondArgument;
		when OR_OP => -- Result = Arg1 OR Arg2
			Result_val <= FirstArgument or SecondArgument;
		when XOR_OP => -- Result = Arg1 XOR Arg2
			Result_val <= FirstArgument xor SecondArgument;
		when NOT1_OP => -- Result = NOT Arg1
			Result_val <= not FirstArgument;
		when NOT2_OP => -- Result = NOT Arg2
			Result_val <= not SecondArgument;
		when NEG1_OP => -- Result = -Arg1
			Result_val <= std_logic_vector(0 - unsigned(FirstArgument));
		when NEG2_OP => -- Result = - Arg2
			Result_val <= std_logic_vector(0 - unsigned(SecondArgument));
		when SHL_OP => -- Result = Arg1 | Carry_In
			Result_val <= FirstArgument(14 downto 0) & Carry_In;
			Carry_Out <= FirstArgument(15); 
			if (FirstArgument(15) = Result_val(15)) then
				Overflow_Out <= '0';
			else
				Overflow_Out <= '1';
			end if;
		when SHR_OP => -- Result = Carry_In | Arg1
			Result_val <= Carry_In & FirstArgument(15 downto 1);
			Carry_Out <= FirstArgument(0);
			if (FirstArgument(15) = Result_val(15)) then
				Overflow_Out <= '0';
			else
				Overflow_Out <= '1';
			end if;
		when MUL_OP => -- Result = Arg1 x Arg2 N.B. It must be a cross product in a left-handed cartesian system
			-- Multiply
			TempMul <= std_logic_vector(unsigned(FirstArgument) * unsigned(SecondArgument));
			
			-- Save lower 16 bits
			Result_val <= TempMul(15 downto 0);
			
			-- Check for carry and overflow
			if (unsigned(TempMul(31 downto 16)) = 0) then
				Carry_Out <= '0';
				Overflow_Out <= '0';
			else
				Carry_Out <= '1';
				Overflow_out <= '1';
			end if;
		when others =>
			-- do SAHR
			report "unreachable" severity failure;
		end case;
		
		-- Set Parity and Sign
		Parity_Out <= Result_val(0);
		Sign_Out <= Result_val(15);
		
		-- Set Zero
		if Result_val = "0000000000000000" then
			Zero_Out <= '1';
		end if;
	end process;
end Behavior;
		
			