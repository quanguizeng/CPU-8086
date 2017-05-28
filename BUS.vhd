LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY BUS_block IS
	PORT(
		addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address
		ld_mar : IN STD_LOGIC;	-- 1 : load value from addr to MAR

		dat_in : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);	-- data to write to DW
		ld_dw_l : IN STD_LOGIC;		-- 1 : load value to dw_l
		ld_dw_h : IN STD_LOGIC;		-- 1 : load value to dw_h

		ld_mdr : IN STD_LOGIC;		-- 1 : load value to mdr
		load_mem : IN STD_LOGIC;	-- 1 : load value from memory to mdr
		load_low : IN STD_LOGIC;	-- when load_mem is 0 then:
											-- 1 : load dw_l to mdr
											-- 0 : load dw_h to mdr

		mem_write : IN STD_LOGIC;	-- 1 : write mdr to memory

		mdr_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- value from mdr

		dat_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- value from DW

		clk : IN STD_LOGIC	-- clock
	);
	END BUS_block;
ARCHITECTURE description OF BUS_block IS
	COMPONENT memory IS
		PORT (
			wr : IN STD_LOGIC; -- write/ not(read)
			addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- address
			dat_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- data to write
			dat_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- read data
			clk : IN STD_LOGIC -- clock
		);
	END COMPONENT memory;
	
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
	
	SIGNAL mar_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mdr_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL load_mdr : STD_LOGIC;
	SIGNAL dw_l_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dw_h_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	mdr_in <=	mem_out when load_mem = '1' else
					dw_l_val when load_low = '1' else
					dw_h_val when load_low = '0';
	
	mem: memory PORT MAP(wr => mem_write, addr => mar_val, dat_in => mdr_out, dat_out => mem_out, clk => clk);
	mar: reg16 PORT MAP(reg_in => addr, ld => ld_mar, inc => '0', dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => mar_val);
	mdr: reg8 PORT MAP(reg_in => mdr_in, ld => ld_mdr, inc => '0', dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => mdr_out);
	dw_l: reg8 PORT MAP(reg_in => dat_in(7 DOWNTO 0), ld => ld_dw_l, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => dw_l_val);
	dw_h: reg8 PORT MAP(reg_in => dat_in(15 DOWNTO 8), ld => ld_dw_h, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => dw_h_val);
	dat_out <= dw_l_val & dw_h_val;
	
	process(clk)
	begin
		
	end process;
END description;