----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2021 19:19:04
-- Design Name: 
-- Module Name: tb_SEMAFORO - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity tb_SEMAFORO is
end tb_SEMAFORO;

architecture tb of tb_SEMAFORO is

    component SEMAFORO
        port (sensor   : in std_logic;
              reset    : in std_logic;
              clk      : in std_logic;
              semcamin : out std_logic_vector (0 to 1);
              semcarr  : out std_logic_vector (0 to 1));
    end component;

    signal sensor   : std_logic;
    signal reset    : std_logic;
    signal clk      : std_logic;
    signal semcamin : std_logic_vector (0 to 1);
    signal semcarr  : std_logic_vector (0 to 1);
    constant period: time := 10ns;

begin

    dut : SEMAFORO
    port map (sensor   => sensor,
              reset    => reset,
              clk      => clk,
              semcamin => semcamin,
              semcarr  => semcarr);

    reloj : process
    begin
       CLK<='0';
       wait for 0.5*period;
       CLK<='1';
       wait for 0.5*period;
    end process;

    tester: process
    begin
        sensor <= '0';
        reset <= '1'; 
        wait for period;
        reset <= '0';
        wait for 5*period;
        sensor <='1';
        wait for 5*period;
        sensor <='0';
        wait for 18*period;
        
        assert false
            REPORT "[success]"
            SEVERITY failure;
    END PROCESS; 

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_SEMAFORO of tb_SEMAFORO is
    for tb
    end for;
end cfg_tb_SEMAFORO;