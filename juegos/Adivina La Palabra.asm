DATA:

  cor  0                 // variable para el numero correcto
  num  00FFh             // Numero de intentos que se muestra en los led
  unos 0                 //

CODE:

  MOV A,1000             // Primera parte, espera unos segundos con std_wait_ms
  CALL std_wait_ms
  MOV A,4000
  PUSH A
  SHR A
  PUSH A
  MOV A,0008h            // Se muestra el numero de grupo en el display
  OUT A,0
  POP A
  CALL std_wait_ms
  PUSH A
  MOV A,0h
  OUT A,0
  POP A
  CALL std_wait_ms
  POP A
  CALL std_io_btn_wait   // Se espera a que el jugador aprete un boton para
  MOV B,0		             // Guardar los switches que quizo
  IN B,0
  MOV A,B
  MOV (cor),B  
  MOV A,(num)            // Se muestra en los led los 8 intentos
  OUT A,1
  
loop:
  CALL std_io_btn_wait   // Loop de juego de jugador 2
  MOV A,0      		       // Se espera a que elija q switches poner y cuando
  MOV (unos),A		       // apreta el boton se guarda este intento 
  IN B,0			
  MOV A,(cor) 
  CMP A,B                // Si esta bien gana, si no se descuenta un intento
  JNE desc
  MOV A,FFFFh
  OUT A,1
  MOV A,2000
  JMP ganar

desc:                    // Descuento de un intento, se resta 1 a num
  MOV A,(num)		         // Para hacer eso en binario es un shr
  SHR A			             // Si no quedan intentos se pierde.
  OUT A,1		             // Si quedan intentos, se para a contar cuantos sw
  CMP A,0		             // Eran correctos y se muestra en el display
  JEQ perder		         // Eso se hace en a, contar y mostrar
  MOV (num),A
  MOV A,(cor)
  XOR A,B
  NOT A
  JMP a

a: 
  SHR A
  JCR contar
  CMP A,0
  JEQ mostrar
  JMP a

contar:
  MOV B,(unos)
  INC B
  MOV (unos),B
  JMP a

mostrar:
  MOV A,(unos)
  OUT A,0
  JMP loop

end:
  JMP end  

perder:
  MOV A,1057h
  OUT A,0
  JMP end

ganar:                   // Si se gana se muestran led alternados cada 1 segundo 
  PUSH A
  SHR A
  PUSH A
  MOV A,AAAAh
  OUT A,1
  POP A
  CALL std_wait_ms
  PUSH A
  MOV A,5555h
  OUT A,1
  POP A
  CALL std_wait_ms
  POP A
  JMP ganar

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
  JEQ std_io_btn_wait_press_lp	// Continuar				//
 XOR B,A			// Bits cambiados			//
 std_io_btn_wait_release_lp:						//
  IN A,1			// Nuevo estado				//
  AND A,B			// Bits aun cambiados			//
  CMP A,2			// SI != 0				//
  JNE std_io_btn_wait_release_lp// Continuar				//
 MOV A,B			// Bits cambiados a A			//
 POP B				// Recupera B				//
RET				// Retorna Bit(s) en A			//
									//
//////////////////////////////////////////////////////////////////////////
