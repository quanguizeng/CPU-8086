LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY mx2 IS
	PORT(
		d0 : IN STD_LOGIC; -- signal 0
		d1 : IN STD_LOGIC; -- signal 1
		m0 : IN STD_LOGIC; -- control 0
		res : OUT STD_LOGIC; -- output signal
	END mx2;
ARCHITECTURE description OF mx2 IS

BEGIN
	process(clk, clr)
	begin
		res <=	(d0 and not m0) or
				(d1 and m0);
	end process;
END description;
