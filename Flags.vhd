entity FlagsRegister is
	port (clk: in std_logic;
			
			stS: in std_logic;
			clS: in std_logic;
			
			stZ: in std_logic;
			clZ: in std_logic;
			
			stP: in std_logic;
			clP: in std_logic;
			
			stC: in std_logic;
			clC: in std_logic;
			
			stO: in std_logic;
			clO: in std_logic;
			
			stT: in std_logic;
			clT: in std_logic;
			
			stI: in std_logic;
			clI: in std_logic;
			
			ldFlags: in std_logic;
			FlagsIn: in std_logic_vector(15 downto 0);
			
			FlagsOut: out std_logic_vector(15 downto 0)
			);
end FlagsRegister;

architecture FlagsRegisterImplementation is
begin
		process(clk, stS, clS, stZ, clZ, stP, clP, stC, clC, stO, clO, stT, clT, stI, clI, ldFlags, FlagsIn)
		begin
		
		if (rising_edge(clk)) then
			
			if (ldFlags = '1') then FlagsOut <= FlagsIn;
			
			if (stS = '1') then FlagsOut(0) <= '1';
			elsif (clS = '1') then FlagsOut(0) <= '0';
			end if;
			
			if (stZ = '1') then FlagsOut(1) <= '1';
			elsif (clZ = '1') then FlagsOut(1) <= '0';
			end if;
			
			if (stP = '1') then FlagsOut(2) <= '1';
			elsif (clP = '1') then FlagsOut(2) <= '0';
			end if;
			
			if (stC = '1') then FlagsOut(3) <= '1';
			elsif (clC = '1') then FlagsOut(3) <= '0';
			end if;
			
			if (stO = '1') then FlagsOut(4) <= '1';
			elsif (clO = '1') then FlagsOut(4) <= '0';
			end if;
			
			if (stT = '1') then FlagsOut(5) <= '1';
			elsif (clT = '1') then FlagsOut(5) <= '0';
			end if;
			
			if (stI = '1') then FlagsOut(6) <= '1';
			elsif (clI = '1') then FlagsOut(6) <= '0';
			end if;
		
		end if;
		
		end process;
end FlagsRegisterImplementation;
			