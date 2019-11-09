// AQUI SE DEFINEN LAS VARIABLES
DATA: 
a 1
b 1
c 2
d 4
CODE:  //
  MOV A,0
  MOV B,2
  CMP A,B
  JEQ primer_salto


primer_salto:
  MOV A,1
  AND A,B
  CMP A,B
  JNE segundo_salto

segundo_salto:
    XOR A,B


