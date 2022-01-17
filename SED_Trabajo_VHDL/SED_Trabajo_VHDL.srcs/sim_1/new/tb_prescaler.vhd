library ieee;
use ieee.std_logic_1164.all;

entity tb_PRESCALER is
end tb_PRESCALER;

architecture tb of tb_PRESCALER is

    component PRESCALER
        port (clk100MHz : in std_logic;
              clk1Hz    : out std_logic);
    end component;

    signal clk100MHz : std_logic;
    signal clk1Hz    : std_logic;
    constant period: time := 10ns;

begin

    dut : PRESCALER
    port map (clk100MHz => clk100MHz,
              clk1Hz    => clk1Hz);

    clk : process
    begin
        clk100MHz <='0';
       wait for 0.5*period;
       clk100MHz <='1';
       wait for 0.5*period;
    end process;
    
    tester: process
    begin
        wait for 100000000*period;
        
        assert false
            REPORT "[success]"
            SEVERITY failure;
    END PROCESS;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PRESCALER of tb_PRESCALER is
    for tb
    end for;
end cfg_tb_PRESCALER;