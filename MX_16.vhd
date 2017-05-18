LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx16 IS
	PORT(
		d0 : IN STD_LOGIC; -- signal 0
		d1 : IN STD_LOGIC; -- signal 1
		d2 : IN STD_LOGIC; -- signal 2
		d3 : IN STD_LOGIC; -- signal 3
		d4 : IN STD_LOGIC; -- signal 4
		d5 : IN STD_LOGIC; -- signal 5
		d6 : IN STD_LOGIC; -- signal 6
		d7 : IN STD_LOGIC; -- signal 7
		d8 : IN STD_LOGIC; -- signal 8
		d9 : IN STD_LOGIC; -- signal 9
		dA : IN STD_LOGIC; -- signal A
		dB : IN STD_LOGIC; -- signal B
		dC : IN STD_LOGIC; -- signal C
		dD : IN STD_LOGIC; -- signal D
		dE : IN STD_LOGIC; -- signal E
		dF : IN STD_LOGIC; -- signal F
		m0 : IN STD_LOGIC; -- control 0
		m1 : IN STD_LOGIC; -- control 1
		m2 : IN STD_LOGIC; -- control 2
		m3 : IN STD_LOGIC; -- control 3
		res : OUT STD_LOGIC; -- output signal
	END mx16;
ARCHITECTURE description OF mx16 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d0 and not m0 and not m1 and not m2 and not m3) or
				(d1 and not m0 and not m1 and not m2 and m3) or
				(d2 and not m0 and not m1 and m2 and not m3) or
				(d3 and not m0 and not m1 and m2 and m3) or
				(d4 and not m0 and m1 and not m2 and not m3) or
				(d5 and not m0 and m1 and not m2 and m3) or
				(d6 and not m0 and m1 and m2 and not m3) or
				(d7 and not m0 and m1 and m2 and m3) or
				(d8 and m0 and not m1 and not m2 and not m3) or
				(d9 and m0 and not m1 and not m2 and m3) or
				(dA and m0 and not m1 and m2 and not m3) or
				(dB and m0 and not m1 and m2 and m3) or
				(dC and m0 and m1 and not m2 and not m3) or
				(dD and m0 and m1 and not m2 and m3) or
				(dE and m0 and m1 and m2 and not m3) or
				(dF and m0 and m1 and m2 and m3);
	end process;
END description;