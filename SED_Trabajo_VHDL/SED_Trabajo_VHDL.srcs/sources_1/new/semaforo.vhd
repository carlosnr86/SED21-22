library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SEMAFORO is
    Port ( 
    sensor: in  STD_LOGIC;
    reset: in  STD_LOGIC;
    clk1Hz : in  STD_LOGIC;
    semcamin,semcarr: out  STD_LOGIC_VECTOR (0 to 1));--semcamin hace referencia al semaforo del camino y semcarr al de la carretera
end SEMAFORO;

architecture Behavioral of SEMAFORO is
    TYPE estado is (S0,S1,espera0,espera1); --declaracion de estados
    --S0-> Semaforo carretera verde y semaforo rural rojo
    --S1-> Semaforo carretera rojo y semafoto rural verde
    --espera0 y espera1-> Los dos semaforos en rojo
    CONSTANT verde: STD_LOGIC_VECTOR(0 TO 1):="01"; -- asignacion de constantes que representa el color verde
    CONSTANT rojo: STD_LOGIC_VECTOR(0 to 1):="10"; -- asignacion de constantes que representa el color rojo
    CONSTANT trojo: integer :=2;--ciclos de reloj, tiempo de espera
    CONSTANT tverdemin: integer :=10;--ciclos de reloj, tiempo minimo verde
    CONSTANT tverdemax: integer :=20;--ciclos de reloj, tiempo maximo semcamin verde
    SIGNAL presente: estado:=S0;--estado actual
    SIGNAL res_cont: boolean := false; --resetea el contador
    SIGNAL cont_rojo: integer RANGE 0 to 63;-- contador
    SIGNAL cont_verde: integer RANGE 0 to 63;
begin


maquina: PROCESS(clk1HZ,reset)-- Definición de la maquina de estados
BEGIN
	IF reset='1' THEN
            presente<=S0;
        ELSIF rising_edge(clk1Hz) then --Detecta el flanco ascendente de una señal
            CASE presente IS
                WHEN S0=> --cuando el estado actual sea inicial
                    IF (cont_verde>tverdemin AND sensor='1') THEN -- se detecta un coche y pasa un tiempo minimo
                        presente<=espera0; --el estado actual cambia a espera0
                    END IF;	
                WHEN espera0 => -- estado ambos semaforos en rojo
                    IF cont_rojo=trojo THEN --si el contador termina
                        presente<=S1;--el estado actual cambia a S1
                    END IF;		
                WHEN S1 => -- semaforo del camino en color verde
                    IF ((cont_verde>tverdemin AND sensor='0')OR cont_verde=tverdemax) THEN --Pasa un tiempo minimo y no hay coches o pasa un tiempo maximo
                        presente<=espera1;--el estado actual cambia a espera1
                    END IF;
                WHEN espera1 => -- estado ambos semaforos en rojo
                    IF cont_rojo=trojo THEN --si el contador termina
                        presente<=S0;--el estado actual cambia a S0
                    END IF;
            END CASE;
		END IF;
END PROCESS maquina;


salida: PROCESS(presente)-- independiente de las entradas
BEGIN
	CASE presente IS
            WHEN S0 =>
                semcarr <= verde;-- el semaforo de la carretera se encuentra en color verde
                semcamin <= rojo;-- el semaforo del camino se mantiene en rojo
	            res_cont <= true;--Se reinicia la cont_rojo e inicia cont_verde
	       WHEN espera0 =>
                semcarr <= rojo;--el semaforo de la carretera cambia a rojo 
                semcamin <= rojo;--el semaforo del camino se mantiene en rojo
                res_cont <= false;-- Se reinicia la cont_verde e inicia cont_rojo
            WHEN S1 =>
                semcarr <= rojo;--el semaforo del camino se mantiene en rojo 
                semcamin <= verde;--el semaforo del camino cambia a verde 
                res_cont <= true;--Se reinicia la cont_rojo e inicia cont_verde                 
            WHEN espera1 =>-- cuando el estado actual se encuantra en el semaforo del camino en verde
                semcarr <= rojo;--el semaforo de la carretera se mantiene en rojo 
                semcamin <= rojo;--el semaforo del camino cambia a rojo  
                res_cont<= false;--Se reinicia la cont_verde e inicia cont_rojo
        end case;
END PROCESS salida;


contador: PROCESS(clk1Hz)
BEGIN
	IF rising_edge(clk1Hz) THEN -- cuando sube los ciclos de reloj
		IF res_cont THEN 
		  cont_rojo<=0;-- y el res_cont_rojo esta en true o verdadero se establece la cont_rojo en 0
		  cont_verde <= cont_verde +1;
		ELSE 
		  cont_verde<=0;
		  cont_rojo<=cont_rojo+1;-- en cambio si res_cont_rojo es false cont_rojo empieza a incrementarce
		END IF;
	END IF;
END PROCESS contador;

end Behavioral;
