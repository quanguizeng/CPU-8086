LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY BUS_block IS
	PORT(
		PC_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address for new instruction
		SP_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address for stack
		IR_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address from inddirect/direct memory access
		ALU_adr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- address from relative access
		
		mx_mar : IN STD_LOGIC_VECTOR(1 DOWNTO 0); -- multiplexer deciding the mar_in value

		ld_mar : IN STD_LOGIC;	-- 1 : load value from addr to MAR
		inc_mar : IN STD_LOGIC; -- 1 : increase MAR by 1

		
		PC_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		PSW_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		AX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		BX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		CX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		DX_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		imm_val : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		ld_dw_l : IN STD_LOGIC;		-- 1 : load value to dw_l
		ld_dw_h : IN STD_LOGIC;		-- 1 : load value to dw_h
		
		mx_dw : IN STD_LOGIC_VECTOR(2 DOWNTO 0);		-- 000 : load into dw from mdr
																	-- 001 : load into dw from PC_val
																	-- 010 : load into dw from PSW_val
																	-- 011 : load into dw from AX_val
																	-- 100 : load into dw from BX_val
																	-- 101 : load into dw from CX_val
																	-- 110 : load into dw from DX_val
																	-- 111 : load into dw from imm_val

		ld_mdr : IN STD_LOGIC;		-- 1 : load value to mdr
		mx_mdr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);	-- 00 : load mem_out to mdr
																-- 01 : load dw_l to mdr
																-- 10 : load dw_h to mdr

		mem_write : IN STD_LOGIC;	-- 1 : write mdr to memory

		mdr_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- value from mdr

		dat_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- value from DW

		clk : IN STD_LOGIC;	-- clock
		
		
		init_done : OUT STD_LOGIC
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
			
			--init_done : OUT STD_LOGIC
		);
	END COMPONENT memory;
	
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
	
	SIGNAL mar_val : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mdr_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mdr_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL load_mdr : STD_LOGIC;
	SIGNAL dw_l_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dw_h_val : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL dw_l_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL dw_h_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL mar_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
	
BEGIN
	mdr_in <=	mem_out when mx_mdr = "00" else
					dw_l_val when mx_mdr = "01" else
					dw_h_val when mx_mdr = "10";
	
-- 000 : load into dw from mdr
-- 001 : load into dw from PC_val
-- 010 : load into dw from PSW_val
-- 011 : load into dw from AX_val
-- 100 : load into dw from BX_val
-- 101 : load into dw from CX_val
-- 110 : load into dw from DX_val
	
	
	dw_l_in <=	mdr_val when mx_dw = "000" else
					PC_val(7 DOWNTO 0) when mx_dw = "001" else
					PSW_val(7 DOWNTO 0) when mx_dw = "010" else
					AX_val(7 DOWNTO 0) when mx_dw = "011" else
					BX_val(7 DOWNTO 0) when mx_dw = "100" else
					CX_val(7 DOWNTO 0) when mx_dw = "101" else
					DX_val(7 DOWNTO 0) when mx_dw = "110" else
					imm_val(7 DOWNTO 0) when mx_dw = "111";

	dw_h_in <= mdr_val when mx_dw = "000" else
					PC_val(15 DOWNTO 8) when mx_dw = "001" else
					PSW_val(15 DOWNTO 8) when mx_dw = "010" else
					AX_val(15 DOWNTO 8) when mx_dw = "011" else
					BX_val(15 DOWNTO 8) when mx_dw = "100" else
					CX_val(15 DOWNTO 8) when mx_dw = "101" else
					DX_val(15 DOWNTO 8) when mx_dw = "110" else
					imm_val(15 DOWNTO 8) when mx_dw = "111";
	
	mar_in <=	PC_adr when mx_mar = "00" else
					IR_adr when mx_mar = "01" else
					SP_adr when mx_mar = "10" else
					ALU_adr when mx_mar = "11";
	
	mem: memory PORT MAP(wr => mem_write, addr => mar_val, dat_in => mdr_val, dat_out => mem_out, clk => clk);
	mar: register16 PORT MAP(reg_in => mar_in, ld => ld_mar, inc => inc_mar, dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => mar_val);
	mdr: register8 PORT MAP(reg_in => mdr_in, ld => ld_mdr, inc => '0', dec => '0', clr => '0', clk => clk, shl => '0', r_bit => '0', shr => '0', l_bit => '0', reg_out => mdr_val);
	dw_l: register8 PORT MAP(reg_in => dw_l_in, ld => ld_dw_l, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => dw_l_val);
	dw_h: register8 PORT MAP(reg_in => dw_h_in, ld => ld_dw_h, inc => '0', dec => '0', clr => '0', clk => clk, r_bit => '0', shr => '0', shl => '0', l_bit => '0', reg_out => dw_h_val);
	dat_out <= dw_l_val & dw_h_val;
	
	mdr_out <= mdr_val;
	
	process(clk)
	begin
		
	end process;
END description;