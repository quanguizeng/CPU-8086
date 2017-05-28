entity FlagsRegister is
	port (clk: in std_logic; -- clock signal
			
			stS: in std_logic; -- set Sign bit
			clS: in std_logic; -- clear Sign bit
			
			stZ: in std_logic; -- set Zero bit
			clZ: in std_logic; -- clear Zero bit
			
			stP: in std_logic; -- set Parity bit
			clP: in std_logic; -- clear Parity bit
			
			stC: in std_logic; -- set Carry bit
			clC: in std_logic; -- clear Carry bit
			
			stO: in std_logic; -- set Overflow bit
			clO: in std_logic; -- clear Overflow bit
			
			stT: in std_logic; -- set Trap bit
			clT: in std_logic; -- clear Trap bit
			
			stI: in std_logic; -- set Interrupt bit
			clI: in std_logic; -- clear Interrupt bit
			
			ldFlags: in std_logic; -- load flags register
			FlagsIn: in std_logic_vector(15 downto 0); -- data input lines
			
			FlagsOut: out std_logic_vector(15 downto 0) -- data output lines
			);
end FlagsRegister;

architecture FlagsRegisterImplementation is
begin
		process(clk, stS, clS, stZ, clZ, stP, clP, stC, clC, stO, clO, stT, clT, stI, clI, ldFlags, FlagsIn)
		begin
		
		if (rising_edge(clk)) then -- We react to the rising edge
			
			if (ldFlags = '1') then FlagsOut <= FlagsIn; end if; -- Load data
			
			if (stS = '1') then FlagsOut(0) <= '1'; -- Sign control
			elsif (clS = '1') then FlagsOut(0) <= '0';
			end if;
			
			if (stZ = '1') then FlagsOut(1) <= '1'; -- Zero control
			elsif (clZ = '1') then FlagsOut(1) <= '0';
			end if;
			
			if (stP = '1') then FlagsOut(2) <= '1'; -- Parity control
			elsif (clP = '1') then FlagsOut(2) <= '0';
			end if;
			
			if (stC = '1') then FlagsOut(3) <= '1'; -- Carry control
			elsif (clC = '1') then FlagsOut(3) <= '0';
			end if;
			
			if (stO = '1') then FlagsOut(4) <= '1'; -- Overflow control
			elsif (clO = '1') then FlagsOut(4) <= '0';
			end if;
			
			if (stT = '1') then FlagsOut(5) <= '1'; -- Trap control
			elsif (clT = '1') then FlagsOut(5) <= '0';
			end if;
			
			if (stI = '1') then FlagsOut(6) <= '1'; -- Interrupt control
			elsif (clI = '1') then FlagsOut(6) <= '0';
			end if;
		
		end if;
		
		end process;
end FlagsRegisterImplementation;
			