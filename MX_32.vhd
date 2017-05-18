LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx32 IS
	PORT(
		d00 : IN STD_LOGIC; -- signal 00
		d01 : IN STD_LOGIC; -- signal 01
		d02 : IN STD_LOGIC; -- signal 02
		d03 : IN STD_LOGIC; -- signal 03
		d04 : IN STD_LOGIC; -- signal 04
		d05 : IN STD_LOGIC; -- signal 05
		d06 : IN STD_LOGIC; -- signal 06
		d07 : IN STD_LOGIC; -- signal 07
		d08 : IN STD_LOGIC; -- signal 08
		d09 : IN STD_LOGIC; -- signal 09
		d0A : IN STD_LOGIC; -- signal 0A
		d0B : IN STD_LOGIC; -- signal 0B
		d0C : IN STD_LOGIC; -- signal 0C
		d0D : IN STD_LOGIC; -- signal 0D
		d0E : IN STD_LOGIC; -- signal 0E
		d0F : IN STD_LOGIC; -- signal 0F
		d10 : IN STD_LOGIC; -- signal 10
		d11 : IN STD_LOGIC; -- signal 11
		d12 : IN STD_LOGIC; -- signal 12
		d13 : IN STD_LOGIC; -- signal 13
		d14 : IN STD_LOGIC; -- signal 14
		d15 : IN STD_LOGIC; -- signal 15
		d16 : IN STD_LOGIC; -- signal 16
		d17 : IN STD_LOGIC; -- signal 17
		d18 : IN STD_LOGIC; -- signal 18
		d19 : IN STD_LOGIC; -- signal 19
		d1A : IN STD_LOGIC; -- signal 1A
		d1B : IN STD_LOGIC; -- signal 1B
		d1C : IN STD_LOGIC; -- signal 1C
		d1D : IN STD_LOGIC; -- signal 1D
		d1E : IN STD_LOGIC; -- signal 1E
		d1F : IN STD_LOGIC; -- signal 1F
		m0 : IN STD_LOGIC; -- control 0
		m1 : IN STD_LOGIC; -- control 1
		m2 : IN STD_LOGIC; -- control 2
		m3 : IN STD_LOGIC; -- control 3
		m4 : IN STD_LOGIC; -- control 4
		res : OUT STD_LOGIC; -- output signal
	END mx32;
ARCHITECTURE description OF mx32 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d00 and not m0 and not m1 and not m2 and not m3 and not m4) or
				(d01 and not m0 and not m1 and not m2 and not m3 and m4) or
				(d02 and not m0 and not m1 and not m2 and m3 and not m4) or
				(d03 and not m0 and not m1 and not m2 and m3 and m4) or
				(d04 and not m0 and not m1 and m2 and not m3 and not m4) or
				(d05 and not m0 and not m1 and m2 and not m3 and m4) or
				(d06 and not m0 and not m1 and m2 and m3 and not m4) or
				(d07 and not m0 and not m1 and m2 and m3 and m4) or
				(d08 and not m0 and m1 and not m2 and not m3 and not m4) or
				(d09 and not m0 and m1 and not m2 and not m3 and m4) or
				(d0A and not m0 and m1 and not m2 and m3 and not m4) or
				(d0B and not m0 and m1 and not m2 and m3 and m4) or
				(d0C and not m0 and m1 and m2 and not m3 and not m4) or
				(d0D and not m0 and m1 and m2 and not m3 and m4) or
				(d0E and not m0 and m1 and m2 and m3 and not m4) or
				(d0F and not m0 and m1 and m2 and m3 and m4) or
				(d10 and m0 and not m1 and not m2 and not m3 and not m4) or
				(d11 and m0 and not m1 and not m2 and not m3 and m4) or
				(d12 and m0 and not m1 and not m2 and m3 and not m4) or
				(d13 and m0 and not m1 and not m2 and m3 and m4) or
				(d14 and m0 and not m1 and m2 and not m3 and not m4) or
				(d15 and m0 and not m1 and m2 and not m3 and m4) or
				(d16 and m0 and not m1 and m2 and m3 and not m4) or
				(d17 and m0 and not m1 and m2 and m3 and m4) or
				(d18 and m0 and m1 and not m2 and not m3 and not m4) or
				(d19 and m0 and m1 and not m2 and not m3 and m4) or
				(d1A and m0 and m1 and not m2 and m3 and not m4) or
				(d1B and m0 and m1 and not m2 and m3 and m4) or
				(d1C and m0 and m1 and m2 and not m3 and not m4) or
				(d1D and m0 and m1 and m2 and not m3 and m4) or
				(d1E and m0 and m1 and m2 and m3 and not m4) or
				(d1F and m0 and m1 and m2 and m3 and m4);
	end process;
END description;