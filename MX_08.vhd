LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx8 IS
	PORT(
		d0 : IN STD_LOGIC; -- signal 0
		d1 : IN STD_LOGIC; -- signal 1
		d2 : IN STD_LOGIC; -- signal 2
		d3 : IN STD_LOGIC; -- signal 3
		d4 : IN STD_LOGIC; -- signal 4
		d5 : IN STD_LOGIC; -- signal 5
		d6 : IN STD_LOGIC; -- signal 6
		d7 : IN STD_LOGIC; -- signal 7
		m0 : IN STD_LOGIC; -- control 0
		m1 : IN STD_LOGIC; -- control 1
		m2 : IN STD_LOGIC; -- control 2
		res : OUT STD_LOGIC; -- output signal
	END mx8;
ARCHITECTURE description OF mx8 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d0 and not m0 and not m1 and not m2) or
				(d1 and not m0 and not m1 and m2) or
				(d2 and not m0 and m1 and not m2) or
				(d3 and not m0 and m1 and m2) or
				(d4 and m0 and not m1 and not m2) or
				(d5 and m0 and not m1 and m2) or
				(d6 and m0 and m1 and not m2) or
				(d7 and m0 and m1 and m2);
	end process;
END description;
