library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PRESCALER is
    port(
        clk100MHz: in std_logic;
        clk1Hz: out std_logic);
end PRESCALER;

architecture Behavioral of PRESCALER is
    signal contador : integer range 0 to 499999999 := 0;
    signal temporal : std_logic;
begin
    process (clk100MHz)
    begin 
        if (contador = 499999999) then
            temporal <= NOT(temporal);
            contador <= 0;
        else
            contador <= contador+1;
        end if;
    end process;
end Behavioral;
