

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
  generic(N: integer :=4);
  Port ( start, clk, reset: in std_logic;
         dividendo,divisor: in std_logic_vector(N-1 downto 0);
         cociente: out std_logic_vector(N-1 downto 0);
         tick: out std_logic);
end Top;

architecture Behavioral of Top is
type state_type is(inicio,op,aux,stop);

signal state_reg,state_next: state_type;
signal ventana_reg, ventana_next: std_logic_vector(N-1 downto 0);
signal cociente_reg, cociente_next: std_logic_vector(N-1 downto 0);

signal c_reg,c_next: integer;
begin
    --state logic
    process(clk,reset)
    begin
        if reset = '1' then 
            state_reg<=inicio;
            ventana_reg<=(others=> '0');
            cociente_reg<=(others=>'0');   
            c_reg<=0;    
        elsif(clk'event and clk = '1') then
            state_reg<= state_next;
            cociente_reg<= cociente_next;
            ventana_reg<= ventana_next;
            c_reg<=c_next;        
    end if;
    end process;
    
   --next state logic
    process(state_reg,ventana_reg,divisor,start,c_reg)
    begin
        state_next<=state_reg;
        ventana_next<=ventana_reg;
        cociente_next<=cociente_reg;
        c_next<=c_reg;
        case state_reg is
        
            when inicio=>
                if start = '1' then 
                    state_next<=op;
                    cociente_next<=(others => '0');
                    ventana_next(0)<=dividendo(N-1);
                    c_next<=0;
                end if;
             when op=>
                if unsigned(ventana_reg)> unsigned(divisor) or unsigned(ventana_reg)= unsigned(divisor) then
                    ventana_next<=std_logic_vector(unsigned(ventana_reg) - unsigned(divisor));
                    state_next<= aux;
                    cociente_next<=cociente_reg(N-2 downto 0)&'1';
                    c_next<=c_reg+1;
                elsif unsigned(ventana_reg)< unsigned(divisor) then
                    cociente_next<=cociente_reg(N-2 downto 0)&'0';
                    state_next<= aux;
                    c_next<=c_reg+1;
                    ventana_next<=ventana_reg;                    
                end if;
             when aux =>
                if  c_reg > (N-1) then 
                    state_next<= stop;
                elsif c_reg<(N-1) or c_reg = (N-1) then
                    state_next<=op;
                    --auxiliar<=ventana_reg & dividendo(N-1-c_reg);
                    --ventana_next<=auxiliar(N-1 downto 0);                   
                    ventana_next<=ventana_reg(N-2 downto 0) & dividendo(N-1-c_reg);                      
                end if;
            when stop =>
                    state_next <= inicio;      
        end case;            
    end process;
 -- output logic
 process(state_reg)
 begin
       tick<='0';
       cociente<=(others=>'0');
       case state_reg is
            when stop=>
                tick<='1';
                cociente<=cociente_reg;
           when inicio =>
           when op=>
           when aux=>          
       end case;
 end process;

end Behavioral;
