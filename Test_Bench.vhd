LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.Numeric_Std.ALL;


ENTITY Test_Bench IS
	PORT (
		clk : IN STD_LOGIC;
		Device_output : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		st_start : IN STD_LOGIC
	);
END Test_Bench;


Architecture description of Test_Bench IS

COMPONENT CPU_8086 IS
	PORT (
		clk : IN STD_LOGIC;
		Device_output : INOUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		
		st_start : IN STD_LOGIC
	);
END COMPONENT CPU_8086;

BEGIN
	cpu : CPU_8086 PORT MAP(clk => clk, Device_output => Device_output, st_Start => st_Start);

END description;