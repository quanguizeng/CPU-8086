library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity addr is
    PORT(
        clk : IN STD_LOGIC;
        
        mx_a : IN STD_LOGIC;
		  
		  --mx_add :std_logic;
        
        ivtp_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        pc_out : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        mx_b : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        
        ivtdsp : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        IR : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
        
        add_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        sp_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        sp_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        ld_sp : IN STD_LOGIC;
        inc_sp : IN STD_LOGIC;
        dec_sp : IN STD_LOGIC;
		  
		  ALU_res : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		  mx_sp : IN STD_LOGIC
    );
end addr;

architecture addrImpl of addr is
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
	
	SIGNAL a: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL b: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL sp_input: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
    add_out <= STD_LOGIC_VECTOR(unsigned(a) + unsigned(b));
    sp: register16 PORT MAP(reg_in => sp_input, ld => ld_sp, inc => inc_sp, dec => dec_sp, clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => sp_out);
    
	 a <= ivtp_out when mx_a = '0' else
			pc_out when mx_a = '1';
	 
    --case mx_a is
    --  when "0" =>
    --    a <= ivtp_out;
    --  when "1" =>
    --    a <= pc_out;
    --end case;
    
	 b <= ivtdsp when mx_b = "00" else
			IR(7 DOWNTO 0) & IR(15 DOWNTO 8) when mx_b = "01" else
			"0000" & "000" & IR(15 DOWNTO 8) & "0" when mx_b = "11";
	 
    --case mx_b is
    --  when "0" =>
    --    b <= ivtdsp;
    --  when "1" =>
    --    pc_in <= IR(7 DOWNTO 0) & IR(15 DOWNTO 8);
    --end case;
	 
	 sp_input <= sp_in when mx_sp = '0' else ALU_res;
    
end addrImpl;

