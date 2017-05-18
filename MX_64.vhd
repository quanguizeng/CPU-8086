LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx64 IS
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
		d20 : IN STD_LOGIC; -- signal 20
		d21 : IN STD_LOGIC; -- signal 21
		d22 : IN STD_LOGIC; -- signal 22
		d23 : IN STD_LOGIC; -- signal 23
		d24 : IN STD_LOGIC; -- signal 24
		d25 : IN STD_LOGIC; -- signal 25
		d26 : IN STD_LOGIC; -- signal 26
		d27 : IN STD_LOGIC; -- signal 27
		d28 : IN STD_LOGIC; -- signal 28
		d29 : IN STD_LOGIC; -- signal 29
		d2A : IN STD_LOGIC; -- signal 2A
		d2B : IN STD_LOGIC; -- signal 2B
		d2C : IN STD_LOGIC; -- signal 2C
		d2D : IN STD_LOGIC; -- signal 2D
		d2E : IN STD_LOGIC; -- signal 2E
		d2F : IN STD_LOGIC; -- signal 2F
		d30 : IN STD_LOGIC; -- signal 30
		d31 : IN STD_LOGIC; -- signal 31
		d32 : IN STD_LOGIC; -- signal 32
		d33 : IN STD_LOGIC; -- signal 33
		d34 : IN STD_LOGIC; -- signal 34
		d35 : IN STD_LOGIC; -- signal 35
		d36 : IN STD_LOGIC; -- signal 36
		d37 : IN STD_LOGIC; -- signal 37
		d38 : IN STD_LOGIC; -- signal 38
		d39 : IN STD_LOGIC; -- signal 39
		d3A : IN STD_LOGIC; -- signal 3A
		d3B : IN STD_LOGIC; -- signal 3B
		d3C : IN STD_LOGIC; -- signal 3C
		d3D : IN STD_LOGIC; -- signal 3D
		d3E : IN STD_LOGIC; -- signal 3E
		d3F : IN STD_LOGIC; -- signal 3F
		m0 : IN STD_LOGIC; -- control 0
		m1 : IN STD_LOGIC; -- control 1
		m2 : IN STD_LOGIC; -- control 2
		m3 : IN STD_LOGIC; -- control 3
		m4 : IN STD_LOGIC; -- control 4
		m5 : IN STD_LOGIC; -- control 5
		res : OUT STD_LOGIC; -- output signal
	END mx64;
ARCHITECTURE description OF mx64 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d00 and not m0 and not m1 and not m2 and not m3 and not m4 and not m5) or
				(d01 and not m0 and not m1 and not m2 and not m3 and not m4 and m5) or
				(d02 and not m0 and not m1 and not m2 and not m3 and m4 and not m5) or
				(d03 and not m0 and not m1 and not m2 and not m3 and m4 and m5) or
				(d04 and not m0 and not m1 and not m2 and m3 and not m4 and not m5) or
				(d05 and not m0 and not m1 and not m2 and m3 and not m4 and m5) or
				(d06 and not m0 and not m1 and not m2 and m3 and m4 and not m5) or
				(d07 and not m0 and not m1 and not m2 and m3 and m4 and m5) or
				(d08 and not m0 and not m1 and m2 and not m3 and not m4 and not m5) or
				(d09 and not m0 and not m1 and m2 and not m3 and not m4 and m5) or
				(d0A and not m0 and not m1 and m2 and not m3 and m4 and not m5) or
				(d0B and not m0 and not m1 and m2 and not m3 and m4 and m5) or
				(d0C and not m0 and not m1 and m2 and m3 and not m4 and not m5) or
				(d0D and not m0 and not m1 and m2 and m3 and not m4 and m5) or
				(d0E and not m0 and not m1 and m2 and m3 and m4 and not m5) or
				(d0F and not m0 and not m1 and m2 and m3 and m4 and m5) or
				(d10 and not m0 and m1 and not m2 and not m3 and not m4 and not m5) or
				(d11 and not m0 and m1 and not m2 and not m3 and not m4 and m5) or
				(d12 and not m0 and m1 and not m2 and not m3 and m4 and not m5) or
				(d13 and not m0 and m1 and not m2 and not m3 and m4 and m5) or
				(d14 and not m0 and m1 and not m2 and m3 and not m4 and not m5) or
				(d15 and not m0 and m1 and not m2 and m3 and not m4 and m5) or
				(d16 and not m0 and m1 and not m2 and m3 and m4 and not m5) or
				(d17 and not m0 and m1 and not m2 and m3 and m4 and m5) or
				(d18 and not m0 and m1 and m2 and not m3 and not m4 and not m5) or
				(d19 and not m0 and m1 and m2 and not m3 and not m4 and m5) or
				(d1A and not m0 and m1 and m2 and not m3 and m4 and not m5) or
				(d1B and not m0 and m1 and m2 and not m3 and m4 and m5) or
				(d1C and not m0 and m1 and m2 and m3 and not m4 and not m5) or
				(d1D and not m0 and m1 and m2 and m3 and not m4 and m5) or
				(d1E and not m0 and m1 and m2 and m3 and m4 and not m5) or
				(d1F and not m0 and m1 and m2 and m3 and m4 and m5) or
				(d20 and m0 and not m1 and not m2 and not m3 and not m4 and not m5) or
				(d21 and m0 and not m1 and not m2 and not m3 and not m4 and m5) or
				(d22 and m0 and not m1 and not m2 and not m3 and m4 and not m5) or
				(d23 and m0 and not m1 and not m2 and not m3 and m4 and m5) or
				(d24 and m0 and not m1 and not m2 and m3 and not m4 and not m5) or
				(d25 and m0 and not m1 and not m2 and m3 and not m4 and m5) or
				(d26 and m0 and not m1 and not m2 and m3 and m4 and not m5) or
				(d27 and m0 and not m1 and not m2 and m3 and m4 and m5) or
				(d28 and m0 and not m1 and m2 and not m3 and not m4 and not m5) or
				(d29 and m0 and not m1 and m2 and not m3 and not m4 and m5) or
				(d2A and m0 and not m1 and m2 and not m3 and m4 and not m5) or
				(d2B and m0 and not m1 and m2 and not m3 and m4 and m5) or
				(d2C and m0 and not m1 and m2 and m3 and not m4 and not m5) or
				(d2D and m0 and not m1 and m2 and m3 and not m4 and m5) or
				(d2E and m0 and not m1 and m2 and m3 and m4 and not m5) or
				(d2F and m0 and not m1 and m2 and m3 and m4 and m5) or
				(d30 and m0 and m1 and not m2 and not m3 and not m4 and not m5) or
				(d31 and m0 and m1 and not m2 and not m3 and not m4 and m5) or
				(d32 and m0 and m1 and not m2 and not m3 and m4 and not m5) or
				(d33 and m0 and m1 and not m2 and not m3 and m4 and m5) or
				(d34 and m0 and m1 and not m2 and m3 and not m4 and not m5) or
				(d35 and m0 and m1 and not m2 and m3 and not m4 and m5) or
				(d36 and m0 and m1 and not m2 and m3 and m4 and not m5) or
				(d37 and m0 and m1 and not m2 and m3 and m4 and m5) or
				(d38 and m0 and m1 and m2 and not m3 and not m4 and not m5) or
				(d39 and m0 and m1 and m2 and not m3 and not m4 and m5) or
				(d3A and m0 and m1 and m2 and not m3 and m4 and not m5) or
				(d3B and m0 and m1 and m2 and not m3 and m4 and m5) or
				(d3C and m0 and m1 and m2 and m3 and not m4 and not m5) or
				(d3D and m0 and m1 and m2 and m3 and not m4 and m5) or
				(d3E and m0 and m1 and m2 and m3 and m4 and not m5) or
				(d3F and m0 and m1 and m2 and m3 and m4 and m5);
	end process;
END description;