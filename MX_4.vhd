LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx4 IS
	PORT(
		d0 : IN STD_LOGIC; -- signal 0
		d1 : IN STD_LOGIC; -- signal 1
		d2 : IN STD_LOGIC; -- signal 2
		d3 : IN STD_LOGIC; -- signal 3
		m0 : IN STD_LOGIC; -- control 0
		m1 : IN STD_LOGIC; -- control 1
		res : OUT STD_LOGIC; -- output signal
	END mx4;
ARCHITECTURE description OF mx4 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d0 and not m0 and not m1) or
				(d1 and not m0 and m1) or
				(d2 and m0 and not m1) or
				(d3 and m0 and m1);
	end process;
END description;