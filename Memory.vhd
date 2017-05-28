LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
USE ieee.Numeric_Std.ALL;

ENTITY memory IS
  PORT (
    wr : IN STD_LOGIC; -- write/ not(read)
    addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- address
    dat_in  : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- data to write
    dat_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- read data
	clk : IN STD_LOGIC -- clock
  );
END ENTITY memory;

ARCHITECTURE description OF memory IS

   TYPE ram_type IS ARRAY (0 TO (2**16-1)) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL ram : ram_type;

BEGIN

  process(clk)
  begin
    if rising_edge(clk) then
      if wr = '1' then
        ram(to_integer(unsigned(addr))) <= dat_in;
      end if;
    end if;
  end process RamProc;

  dat_out <= ram(to_integer(unsigned(addr)));

END description;