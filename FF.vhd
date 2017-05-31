LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.std_logic_arith.ALL;
--USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
ENTITY FlipFlop IS
	PORT(
		set : IN STD_LOGIC; -- load/enable.
		clr : IN STD_LOGIC; -- async. clear.
		clk : IN STD_LOGIC; -- clock.
		sig_out : OUT STD_LOGIC -- output
	);
	END FlipFlop;
ARCHITECTURE description OF FlipFlop IS
	SIGNAL ff_val : STD_LOGIC := '0';
BEGIN
	sig_out <= ff_val;
	process(clk, clr)
	begin
		if rising_edge(clk) then
			if set = '1' then
				ff_val <= '1';
			elsif clr = '1' then
				ff_val <= '0';
			end if;
		end if;
	end process;
END description;