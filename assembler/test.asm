// AQUI SE DEFINEN LAS VARIABLES
DATA: // Sección de VARIABLES
largo 10
arreglo 0
1
10b                      
3                       
4                   
5                    
6  
                         7                                                                 
                        8
9

resultado  0
res1 0
res2 0
res3 0

// El siguente código suma los numeros de un arreglo y los guarda en resultado
// Posteriormente ejecuta algunas acciones sobre el resultado
// [!AQUI EMPIEZA TU código] NO BORRAR ESTAS LINEAS


CODE:

    MOV A,(largo)
    MOV          B,                                 0         //Con esto // Se llevaran los contadores
    CALL loop
    MOV A,(resultado)
MOV (res1),A  // Se guarda el resultado
MOV   A , (largo)
MOV B,   0
    CALL MULTIPLICALOOP   // Multiplica todos los elementos del array
MOV   A , (largo)
MOV B,   0
CALL loop  // Se vuelve a sumar
MOV (res2),A
SHR A
NOT A
MOV (res3),A


// Esto simula un for
loop:
                               CMP A,B    // si son // 0 entonces / se sale del ciclo
                               JEQ ReTurN
                               PUSH A 
                               PUSH B    // SE GUARDAN ESTAS VARIABLES:=> porque cambiaran MOV A,HOLA (ESTO NO ES UNA INSTRUCCION)
                               CALL SUMA
                               POP B
                               POP A
                               INC B
                               JMP loop  // Se ejecuta el for

ReTurN: 
    RET
    
SUMA:
    MOV A,(B)
    MOV B,(resultado)
    ADD B,A
    MOV (resultado),B
    RET 

MULTIPLICALOOP:
 CMP A,B    // si son // 0 entonces / se sale del ciclo
                               JEQ ReTurN
                               PUSH A 
                               PUSH B    // SE GUARDAN ESTAS VARIABLES:=> porque cambiaran MOV A,HOLA (ESTO NO ES UNA INSTRUCCION)
                               CALL Multiplica
                               POP B
                               POP A
                               INC B
                               JMP loop  // Se ejecuta el for

Multiplica:
      MOV A,(B)
      SHL A  // SE MULTIPLICA POR 2
      MOV (B),A
      RET

