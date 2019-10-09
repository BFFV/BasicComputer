# Entrega 2, Grupo 3

## Integrantes:

- Benjam�n F. Far�as
- Karl M. Haller
- Diego Navarro
- Juan I. Parot
- Juan A. Romero


##  Como funciona la componente que hice

El fulladder implementado es la concatenación de 16 half-adders que fueron vistos en clases. Esto consiste en que para el n-ésimo bit de A y el n-ésimo bit de B se ejecuta la operación:


Para poder restar, la componente recibe una señal carryIn (Que puede ser 0 o 1 y se la entrega la ALU), en caso de ser 1, entonces la entrada en B se niega y se usa el carryIn para poder sumar el 1 necesario al aplicar complemento a 2.

Las señales de retorno se obtienen de la siguiente forma:

- Z : Se obtiene al hacer un or entre todos los bits del resultado y luego negando dicho resultado, de este modo, si el resultado es 0 entonces Z será 1.

- N : Es el último bit del resultado en caso de una resta, de lo contrario será 0.

- C : Corresponde al valor de la señal carry16.


## Lo que hice

Para esta entrega lo que realicé fue el sumador/restador de la ALU e incorporalo a esta. En particula los arhcivos en los que trabajé fueron:

- fulladder.vhd
- ALU.vhd

 Además escribí el algoritmo para multiplicar en assembly.


 ## Multiplicación

 ```
 DATA:
      resultado 0
      factorA 5
      factorB 2

CODE:
    MOV A, (factorA)
    MOV B, (factorB)
     multiplicacion: 
                     CMP A,0
                     JEQ end
                     MOV A, (resultado)
                     ADD (resultado)
                     MOV A, (factorA)
                     DEC A
                     MOV (factorA), A
                     JMP multiplicacion
    JMP end
     end: JMP end
 ```

 El algoriitmo implementado corresponde a:

 ```
 def multiplicar(a,b):
      resultado = 0
      while a > 0:
          resultado = resultado + b
          a - 1
     return resultado
 ```