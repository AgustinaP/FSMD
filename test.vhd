
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Top 
      generic(N: integer :=4);
      Port ( start, clk, reset: in std_logic;
             dividendo,divisor: in std_logic_vector(N-1 downto 0);
             cociente: out std_logic_vector(N-1 downto 0);
             tick: out std_logic);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal start : std_logic := '0';
   signal dividendo,divisor : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal tick : std_logic;
   signal cociente : std_logic_vector(3  downto 0);
   signal enable: std_logic :='1';
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
    utt: entity work.Top(Behavioral) PORT MAP(
          clk => clk,
          reset => reset,
          start => start,
          divisor => divisor,
          tick => tick,
          dividendo  => dividendo,
          cociente =>cociente
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		if enable = '0' then 
              wait;
        end if;    
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 5 ns;	
		
		reset <= '0';
	
		-- caso 0
		dividendo<="1111";
		divisor<= "0011";
		start <= '1';
		
		wait until rising_edge(tick);
		start <= '0';
--		assert cociente = "1110" report "Fallo caso cero" severity failure;
		
--		wait until ready <= '1';
		
--		-- caso 1
--		i<= CONV_STD_LOGIC_VECTOR(1,5);
--		start <= '1';

--		wait until rising_edge(done_tick);
--		start <= '0';
--		assert f = CONV_STD_LOGIC_VECTOR(1,20) report "Fallo caso uno" severity failure;


--		wait until ready <= '1';
		
--		-- caso 11
--		i <= CONV_STD_LOGIC_VECTOR(11,5);
--		start <= '1';

--		wait until rising_edge(done_tick);
--		start <= '0';
--		assert f = CONV_STD_LOGIC_VECTOR(89,20) report "Fallo caso once" severity failure;

--		wait until ready <= '1';
		enable<='0';
--		assert false report "Fin simulacion OK" severity failure;
        
        wait;
   end process;

END;