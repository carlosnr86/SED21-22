library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

ENTITY top IS
  PORT (
    CLK         :  IN std_logic;
    SENSOR  :  IN std_logic;
    reset       :  IN std_logic;
    semcamin       : OUT std_logic_vector(0 to 1);
    semcarr      : OUT std_logic_vector(0 to 1)
    
  );
END top;

architecture Behavioral of top is

    signal boton_sinc : std_logic;
    signal boton_edge : std_logic;

  component SYNCHRNZR is
   port (
     CLK      :  in std_logic;
     ASYNC_IN :  in std_logic;
     SYNC_OUT : out std_logic
   );
   end component;

  component EDGEDTCTR is
    port (
      CLK     :  in std_logic;
      SYNC_IN :  in std_logic;
      EDGE    : out std_logic
    );
  end component;

  component SEMAFORO is
    PORT (
    SENSOR       : in std_logic;
      RESET      : in std_logic;
      CLK        : in std_logic;
      semcamin      : out std_logic_vector(0 TO 1);
      semcarr      : out std_logic_vector(0 TO 1)
    );
  end component;
 
begin
  Inst_synchronizer: SYNCHRNZR PORT MAP (
    clk      => clk,
    ASYNC_IN => SENSOR,
    SYNC_OUT => boton_sinc
  );
  
  Inst_edgedetector: EDGEDTCTR PORT MAP (
    clk     => clk,
    SYNC_IN => boton_sinc,
    EDGE    => boton_edge
  );
  
  Inst_SEMAFORO: SEMAFORO PORT MAP (
    SENSOR     => boton_edge,
    reset      => reset,
    clk        => clk,
    semcamin   => semcamin,
    semcarr    => semcarr
  );

end Behavioral;
