library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY top IS
  PORT (
    clk100MHz         :  in std_logic;
    sensor  :  in std_logic;
    reset       :  in std_logic;
    semcamin       : out std_logic_vector(0 to 1);
    semcarr      : out std_logic_vector(0 to 1) );
END top;

architecture Behavioral of top is
    signal clk : std_logic;
    component PRESCALER is
       port(
        clk100MHz: in std_logic;
        clk1Hz: out std_logic);
    end component; 
    
    component SEMAFORO is
       port (
        sensor: in  std_logic;
        reset: in  std_logic;
        clk1Hz : in  std_logic;
        semcamin   : out std_logic_vector(0 TO 1);
        semcarr    : out std_logic_vector(0 TO 1));
    end component;
        
begin
    Inst_prescaler: PRESCALER PORT MAP (
        clk100MHz => clk100MHz,
        clk1Hz => clk);
    Inst_semaforo: SEMAFORO PORT MAP (
        sensor => sensor,
        reset => reset,
        clk1Hz => clk,
        semcamin => semcamin,
        semcarr => semcarr );
        
end Behavioral;