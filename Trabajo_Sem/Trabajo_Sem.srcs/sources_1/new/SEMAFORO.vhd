library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SEMAFORO is
    Port ( 
    sensor: in  STD_LOGIC;
    reset: in  STD_LOGIC;
    clk : in  STD_LOGIC;
    semcamin,semcarr : out  STD_LOGIC_VECTOR (0 to 1));
end SEMAFORO;
-- el puerto de salida semcamin hace referencia al semaforo del camino o la via rural
-- el puerto de salida semcarr hace referencia al semaforo de la carretera o la via principal
architecture Behavioral of SEMAFORO is

TYPE estado is --declaracion de estados
(S0,S1,espera1,espera2);
--S0-> Semaforo carretera verde y semaforo rural rojo
--S1->semaforo carretera rojo y semafoto rural verde
--espera -> espera de 30 s (si la frecuencia es de 1s por periodo)en S1
-- asignacion de constantes que representan los colores de los semaforos
CONSTANT verde: STD_LOGIC_VECTOR(0 TO 1):="01";
CONSTANT rojo: STD_LOGIC_VECTOR(0 to 1):="10";
CONSTANT tespera: integer :=2;--ciclos de reloj, tiempo de espera
CONSTANT tverde: integer :=10;--ciclos de reloj, tiempo semcamin verde
SIGNAL presente: estado:=S0;--estado actual
SIGNAL rescont: boolean:=false;--setea el contador en 0
SIGNAL cuenta: integer RANGE 0 to 63;-- contador
begin
-- Definición de la maquina de estados
maquina:
PROCESS(clk,reset)
BEGIN
	IF reset='1' THEN
            presente<=S0;
        ELSIF rising_edge(clk) then --Detecta el flanco ascendente de una señal
            CASE presente IS
                WHEN S0=> --cuando el estado actual sea inicial
                    IF sensor='1' THEN -- si el semaforo de camino detecta que hay un auto cambia el estado actual
                        presente<=espera1; --el estado actual cambia a espera1
                    END IF;	
                WHEN espera1 => -- estado ambos semaforos en rojo
                    IF cuenta=tespera THEN --si el contador termina
                        presente<=S1;--el estado actual cambia a S1
                    END IF;		
                WHEN S1 => -- si el estado actual se encuentra en el semaforo del camino en color verde
                    IF cuenta=(tespera + tverde) THEN --si el contador termina
                        presente<=espera2;--el estado actual cambia a espera2
                    END IF;
                WHEN espera2 => -- estado ambos semaforos en rojo
                    IF cuenta=(2*tespera + tverde) THEN --si el contador termina
                        presente<=S0;--el estado actual cambia a S0
                    END IF;
            END CASE;
		END IF;
END PROCESS maquina;

salida:
-- independiente de las entradas
PROCESS(presente)
BEGIN
	CASE presente IS
            WHEN S0 => -- cuando el estado actual o presente se encuantra en el estado inicial
                semcarr <= verde;-- el semaforo de la carretera se encuentra en color verde
                semcamin <= rojo;-- el semaforo del camino se mantiene en rojo
	            rescont <= true;--Se reinicia la cuenta
	       WHEN espera1 =>-- cuando el estado actual se encuantra en el semaforo del camino en verde
                semcarr <= rojo;--el semaforo de la carretera cambia a rojo 
                semcamin <= rojo;--el semaforo del camino se mantiene en rojo
                rescont <= false;-- el contador empieza su funcion
            WHEN S1 =>-- cuando el estado actual se encuantra en el semaforo del camino en verde
                semcarr <= rojo;--el semaforo del camino se mantiene en rojo 
                semcamin <= verde;--el semaforo del camino cambia a verde    
            WHEN espera2 =>-- cuando el estado actual se encuantra en el semaforo del camino en verde
                semcarr <= rojo;--el semaforo de la carretera se mantiene en rojo 
                semcamin <= rojo;--el semaforo del camino cambia a rojo  
        end case;
END PROCESS salida;

-- este proceso se encarga de definir el contador

contador:
PROCESS(clk)
BEGIN
	IF clk='1' THEN -- cuando sube los ciclos de reloj
		IF rescont THEN cuenta<=0;-- y el rescont esta en true o verdadero se establece la cuenta en 0
		ELSE cuenta<=cuenta+1;-- en cambio si rescont es false cuenta empieza a incrementarce
		END IF;
	END IF;
END PROCESS contador;

end Behavioral;