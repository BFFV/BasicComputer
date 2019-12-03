DATA:

cor  0                 // variable para el numero correcto
num  00FFh             //  Numero de intentos que se muestra en los led
unos 0                 //               
disp 3100h             // numero que se muestra en display 
aux2 0 
btn  0   
niv  1    
aux  0

CODE:

  MOV A, 1000          // Primera parte, espera unos segundos con std_wait_ms
  CALL std_wait_ms    

  MOV A, 4000
  PUSH A
  SHR A
  PUSH A
  MOV A,(disp)          // Se muestra el numero de leds a mostrar/ nivel/ etapa
  OUT A,0
  POP A
  CALL std_wait_ms
  POP A

loop1:
  CALL std_io_btn_wait      // Se espera a que el jugadir aprete un botón para  
  MOV (btn),A
  
  MOV B,8                   // se retorna btn en A
  CMP A,B
  JEQ dere
   
  MOV A,(btn)
  MOV B,4
  CMP A,B
  JEQ izq
  
  MOV A,(btn)
  MOV B,1   
  CMP A,B
  JEQ centre
  JMP loop1                      
  centre:
      MOV B,0		    // Guardar los switches que quizo
      IN B,0
      MOV (cor),B
  
  CALL esperar_d
  
  MOV A,(cor)          // Se muestra en los led
  OUT A,1   
  CALL esperar_tiempo
  MOV A,0000h
  OUT A,1 
   
  CALL esperar_u
  
                 		    // Se espera a que elija q switches poner y cuando
  MOV A,(cor)		  // apreta el boton se guarda este intento 
  IN B,0		
  CMP A,B
  JEQ gana                 // Si esta bien gana, si no se descuenta un intento
  MOV A,0000h
  OUT A,0
  JMP end
  

end:
   JMP end  


ganar:                   // Si se gana se muestran led alternados cada 
  PUSH A		//1 segundo
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

gana: 
  MOV A,(aux2)
  CMP A,FFh  
  JEQ esperar_c
  MOV A,(disp)
  ADD A,0001h
  MOV (disp),A 
  OUT A,0 
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
    PUSH A
    PUSH B
    MOV B,(disp)
    MOV A,3F00h  
    CMP A,B 
    JNE subir  
    POP A
    POP B
    JMP 34 

subir:
    MOV A,0100h
    ADD B,A
    MOV (disp),B
    MOV A,B
    OUT A,0 
    
    MOV A,(niv)
    ADD A,1
    MOV (niv),A  
    POP A
    POP B
    JMP 34
    
izq: 
    PUSH A
    PUSH B
    MOV A,(disp)
    MOV B,3100h  
    PUSH A 
    PUSH B
    CMP A,B 
    JNE bajar
    POP A
    POP B 
    JMP 38  

bajar:  
    MOV B,0100h
    SUB A,B  
    MOV (disp),A
    OUT A,0   
    
    MOV A,(niv)
    SUB A,1
    MOV (niv),A 
    POP A
    POP B
    JMP 38
 
mostrar_lu:
  MOV A,(cor)          // Se muestran los led a adivinar 
  OUT A,1
  MOV A, 1000          // Espera los segundos con std_wait_ms AQUII
  CALL std_wait_ms
        
                              
display:
  PUSH A
  MOV A,(disp)          // Se muestra el nuevo display
  OUT A,0
  POP A
  RET
 
        
        
esperar_d:
 PUSH B				// Guarda B				// 
 PUSH A
 atrape:
  CALL std_io_btn_wait
            
  MOV B,10h  
  CMP A,B
  JNE atrape 
  
 POP B 
 POP A
 RET
 
esperar_u:
 PUSH B				// Guarda B				// 
 PUSH A
 atrap:
  CALL std_io_btn_wait
            
  MOV B,2  
  CMP A,B
  JNE atrap 
  
 POP B 
 POP A
 RET  
 
esperar_c:
  PUSH A
  PUSH B 
  atra:
    CALL std_io_btn_wait
            
    MOV B,1  
    CMP A,B
    JNE atra 
  POP A
  POP B
  JMP centre
        
esperar_tiempo:         //tiempo de mostrar leds
  PUSH B
  PUSH A
  MOV B,(niv)           //tiempo 4500mseg  
  MOV A,16
  SUB A,B
  MOV (aux),A
  esp300:
    MOV A,300
    CALL std_wait_ms 
    MOV A,(aux)
    SUB A,1
    MOV (aux),A
    CMP A,0
    JNE esp300 
  POP B
  POP A
  RET
     

//////////////////Libraria wait //////////////////////////////////////////
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
  JLT std_wait_ms_divide_end	// Terminar división			//
  SUB A,1000			// Mseg - 1000				//
  INC B				// Seg ++				//
  JMP std_wait_ms_divide_lp	// Continuar división			//
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

/////////////////Libreria std_io//////////////////////////////////////////
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
  AND A,B			// Bits aún cambiados			//
  CMP A,0			// SI != 0				//
  JNE std_io_btn_wait_release_lp// Continuar				//
  MOV A,B			// Bits cambiados a A			//
 POP B				// Recupera B				//
RET				// Retorna Bit(s) en A			//
						// 


							//
////////////////////////////////////////////////////////////////////////// 

 
