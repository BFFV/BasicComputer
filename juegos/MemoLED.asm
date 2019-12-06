DATA:

  cor  0                 // Palabra correcta
  disp 3100h             // Numero que se muestra en display 
  aux2 0                 // Var. Auxiliar para los exitos
  btn  0                 // Boton presionado
  niv  1                 // Nivel actual de dificultad
  aux  0                 // Var. Auxiliar para el tiempo limite

CODE:

  MOV A,(disp)           // Se muestra la info en el display
  OUT A,0

loop1:
  CALL std_io_btn_wait   // Se espera a que el jugador aprete un boton
  MOV (btn),A
  MOV B,8                // Se retorna btn en A
  CMP A,B
  JEQ dere
   
seguir_der: 
  MOV A,(btn)
  MOV B,4
  CMP A,B
  JEQ izq
  
seguir_izq:
  MOV A,(btn)
  MOV B,1   
  CMP A,B
  JEQ centre
  JMP loop1     
                
centre:
  IN B,0                 // Guardar la palabra elegida para la ronda
  MOV (cor),B
  CALL esperar_d
  MOV A,(cor)            // Se muestran los Leds
  OUT A,1   
  CALL esperar_tiempo
  MOV A,0000h
  OUT A,1 
  CALL esperar_u         // Se espera el intento del jugador
  MOV A,(cor)
  IN B,0		
  CMP A,B
  JEQ gana               // Si esta bien gana, si no se descuenta 1 intento
  MOV A,3100h            // Reset del juego
  MOV (disp),A
  OUT A,0
  MOV A,0
  MOV (cor),A
  MOV (aux),A
  MOV (aux2),A
  MOV (btn),A
  INC A
  MOV (niv),A
  JMP loop1            

gana: 
  MOV A,(aux2)
  CMP A,FFh  
  JEQ esperar_c
  MOV A,(disp)
  ADD A,0001h
  MOV (disp),A 
  OUT A,0
  INC (aux2)
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A
  SHR A                
  CMP A,000Fh
  JEQ esperar_c 
  MOV A,(disp)
  ADD A,1000h
  MOV (disp),A
  OUT A,0
  JMP esperar_c

dere:
  MOV B,(disp)
  MOV A,3F00h  
  CMP A,B 
  JNE subir  
  JMP seguir_der 

subir:
  MOV A,0100h
  ADD B,A
  MOV (disp),B
  MOV A,B
  OUT A,0 
  INC (niv) 
  JMP seguir_der
    
izq: 
  MOV A,(disp)
  MOV B,3100h  
  CMP A,B 
  JNE bajar
  JMP seguir_izq  

bajar:  
  MOV B,0100h
  SUB A,B  
  MOV (disp),A
  OUT A,0   
  MOV A,(niv)
  DEC A
  MOV (niv),A 
  JMP seguir_izq     
        
esperar_d:
  PUSH B				           // Guarda A y B
  PUSH A

atrape:
  CALL std_io_btn_wait    
  MOV B,10h  
  CMP A,B
  JNE atrape 
  POP A 
  POP B
  RET
 
esperar_u:
  PUSH B				           // Guarda A y B
  PUSH A

atrap:
  CALL std_io_btn_wait         
  MOV B,2  
  CMP A,B
  JNE atrap 
  POP A
  POP B
  RET  
 
esperar_c:
  PUSH A
  PUSH B

atra:
  CALL std_io_btn_wait        
  MOV B,1  
  CMP A,B
  JNE atra 
  POP B
  POP A
  JMP centre
        
esperar_tiempo:          // Tiempo para mostrar los Leds
  PUSH B
  PUSH A
  MOV B,(niv)            // Tiempo max: 4500 ms 
  MOV A,16
  SUB A,B
  MOV (aux),A

esp300:
  MOV A,300
  CALL std_wait_ms 
  MOV A,(aux)
  DEC A
  MOV (aux),A
  CMP A,0
  JNE esp300 
  POP A
  POP B
  RET

////////////////// Lib wait //////////////////////////////////////////
									//
std_wait_abs_s_ms:		// Seg en A, Mseg en B			//
 PUSH B				// Guarda Mseg				//
 std_wait_abs_s:		 					//
  IN B,2			// Seg actual				//
  CMP A,B			// Seg > Seg actual			//
  JGT std_wait_abs_s		// Continuar espera			//
 POP B				// Recupera Mseg			//
 JMP std_wait_abs_s_sanity	// Comprobar sanidad de Seg		//
 std_wait_abs_ms_lp:							//
  MOV B,A			// Mseg a B				//
  POP A				// Recupera Seg				//
  std_wait_abs_s_sanity:						//
   PUSH B			// Guarda Mseg				//
   IN B,2			// Seg actual				//
   CMP A,B			// Seg != Seg actual			//
   JNE std_wait_abs_ms_end	// Terminar espera			//
   POP B			// Recupera Mseg			//
  PUSH A			// Guarda Seg				//
  MOV A,B			// Mseg a A				//
  IN B,3			// Mseg actual				//
  CMP A,B			// Mseg > Mseg actual			//
  JGT std_wait_abs_ms_lp	// Continuar espera			//
  MOV B,A			// Mseg a B				//
  POP A				// Recupera Seg				//
  RET				// Void					//
 std_wait_abs_ms_end:							//
 POP B				// Recupera Mseg			//
RET				// Void					//
									//
std_wait_ms:			// Mseg en A, * en B			//
 PUSH A				// Guarda los Mseg			//
 PUSH B				// Guarda B				//
 IN B,3				// Mseg actual				//
 ADD A,B			// Mas Mseg delay			//
 IN B,2				// Seg actual				//
 std_wait_ms_divide_lp:							//
  CMP A,1000			// Si Mseg < 1000			//
  JLT std_wait_ms_divide_end	// Terminar division			//
  SUB A,1000			// Mseg - 1000				//
  INC B				// Seg ++				//
  JMP std_wait_ms_divide_lp	// Continuar division			//
 std_wait_ms_divide_end:						//
 XOR A,B			// Intercambiar registros		//
 XOR B,A			// 					//
 XOR A,B			//					//
 CALL std_wait_abs_s_ms		// Espera absoluta Seg Mseg		//
 POP B				// Recupera B				//
 POP A				// Recupera los Mseg			//
RET				// Void					//
									//
//////////////////////////////////////////////////////////////////////////

///////////////// Lib std_io //////////////////////////////////////////
									//
std_io_btn_wait:		// * en A, * en B			//
 PUSH B				// Guarda B				//
 IN A,1				// Estado actual			//
 std_io_btn_wait_press_lp:						//
  IN B,1			// Nuevo estado				//
  CMP A,B			// Si ==				//
  JEQ std_io_btn_wait_press_lp	// Continuar
 XOR B,A			// Bits cambiados			//
 std_io_btn_wait_release_lp:						//
  IN A,1			// Nuevo estado				//
  AND A,B			// Bits aun cambiados			//
  CMP A,0			// SI != 0				//
  JNE std_io_btn_wait_release_lp// Continuar				//
  MOV A,B			// Bits cambiados a A			//
 POP B				// Recupera B				//
RET				// Retorna Bit(s) en A			//
						// 


							//
//////////////////////////////////////////////////////////////////////////
