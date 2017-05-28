library IEEE;
use ieee.std_logic_1644.all;

entity addr is
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
        ld_inc : IN STD_LOGIC;
        ld_dec : IN STD_LOGIC;
    );
end addr;

architecture addrImpl of addr is
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
	
	SIGNAL a: STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL b: STD_LOGIC_VECTOR(15 DOWNTO 0);
begin
    add_out <= a + b;
    sp: reg16 PORT MAP(reg_in => sp_in, ld => ld_sp, inc => inc_sp, dec => dec_sp, clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => sp_out);
    
    case mx_a is
      when "0" =>
        a <= ivtp_out;
      when "1" =>
        a <= pc_out;
    end case;
    
    case mx_b is
      when "0" =>
        b <= ivtdsp;
      when "1" =>
        pc_in <= IR(7 DOWNTO 0) & IR(15 DOWNTO 8);
    end case;
    
end addrImpl;

