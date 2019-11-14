# Bitácora del Proyecto :pencil:

# Funcionamiento

## Componentes del Computador Básico

Se crearon los siguientes componentes del computador básico:

### Unidad de Control: 

Señales de Entrada:

- insIn: Palabra de control correspondiente a los 20 bits menos significativos de las instrucciones de la ROM. Se explica en detalle en la sección 'Estructura de las Instrucciones'.

- statusIn: Valores de los códigos de status Z, N y C provenientes del Registro de Status. Cuando un código tiene valor 1 indica que ocurrió tras la ejecución de la ALU.

Señales de Salida:

- loadA: Señal de control que habilita la carga de datos en el Registro A. Si toma valor 1 permite la carga.
  
- loadB: Señal de control que habilita la carga de datos en el Registro B. Si toma valor 1 permite la carga.

- selA: Señales de control que seleccionan la salida del Multiplexor A. Tienen las siguientes combinaciones posibles:
  
  - '00': Valor del Registro A
  - '01': Valor 0
  - '10': Valor 1
  - '11': No se ocupa actualmente

- selB: Señales de control que seleccionan la salida del Multiplexor B. Tienen las siguientes combinaciones posibles:
  
  - '00': Valor del Registro B
  - '01': Valor 0
  - '10': Literal
  - '11': Valor de salida de la memoria RAM
  
- loadPC: Señal de control que habilita la carga del Literal en el Program Counter. Si toma valor 1 permite la carga.

- selALU: Señales de control que seleccionan la operación de la ALU. Tienen las siguientes combinaciones posibles:
  
  - '000': ADD
  - '001': SUB
  - '010': AND
  - '011': OR
  - '100': NOT
  - '101': XOR
  - '110': SHL
  - '111': SHR

- W: Señal de control que habilita la carga de datos en la memoria RAM. Si toma valor 1 permite la carga.

- selAdd: Señales de control que seleccionan el tipo de direccionamiento de la memoria RAM. Tienen las siguientes combinaciones posibles:
  
  - '00': Literal
  - '01': Registro B
  - '10': Stack Pointer
  - '11': No se ocupa actualmente

- incSP: Señal de control que incrementa en 1 el valor del Stack Pointer.

- decSP: Señal de control que decrementa en 1 el valor del Stack Pointer.

- selPC: Señal de control que selecciona la salida del multiplexor PC. Permite elegir entre cargar el PC con un Literal (toma valor 0) o con un valor guardado en la RAM (toma valor 1).

- selDIn: Señal de control que selecciona la entrada de datos a la memoria RAM. Permite elegir entre cargar la RAM con la salida de la ALU (toma valor 0) o con el valor del PC + 1 (toma valor 1).

Arquitectura: La Unidad de Control recibe una palabra de control de 20 bits, la que es decodificada según se explica en la sección 'Estructura de las Instrucciones'. Para lograr esto, primero se interpretan los 20 bits de todas las formas posibles según los tipos de operaciones (MOV, ADD, etc...), y posteriormente se utiliza un Multiplexor para determinar cuál de todas las interpretaciones es la correcta, revisando los 4 bits menos significativos de la palabra de control, ya que estos tienen codificado el tipo de operación a realizar (más detalles de esto en la sección 'Estructura de las Instrucciones').

### ALU: 

Señales de Entrada:

- A: Primer número de entrada a la operación (16 bits).

- B: Segundo número de entrada a la operación (16 bits).

- selALU: Señales de control que seleccionan la operación a realizar (revisar sección Unidad de Control).

Señales de Salida:

- dataOut: Resultado de la operación sobre A y B (16 bits). 

- C: Toma valor 1 si hubo Carry en la operación.

- Z: Toma valor 1 si el resultado de la operación fue 0.

- N: Toma valor 1 si el resultado de la operación fue menor a 0 (representación en complemento a 2).

Arquitectura: 

- Para las operaciones ADD/SUB se utilizó un fulladder. El fulladder implementado es la concatenación de 32 half-adders como los vistos en clase. La suma consiste en pasar por dicho fulladder todos los bits de A y B, sumando el n-ésimo bit de A con el n-ésimo bit de B y entregando el Carry como CarryIn de la siguiente suma. Para poder restar, la ALU recibe una señal carryIn (proveniente del bit menos significativo de selALU), y en caso de ser 1, se aplica un NOT a la entrada de B y se usa el carryIn para poder sumarle 1 y representarlo en complemento a 2.

- Para las operaciones AND/OR/NOT/XOR se utilizó la LU. El módulo LU emula la unidad lógica de la ALU, la que frente a 4 combinaciones de bits de control (selALU), "010", "011", "100" y "101", realiza las operaciones lógicas A AND B, A OR B, NOT A y A XOR B, respectivamente, entregándolas como resultado por la salida de la ALU (16 bits). Para implementar lo anterior fue necesario utilizar un 'with select' y los operadores lógicos que Vivado entrega.

- Para las operaciones SHL/SHR se asignaron los bits del resultado de manera directa, según se explica a continuación. Para el SHL se asignó el valor '0' al bit menos significativo del vector de salida, y luego se asignó el resto de los bits de entrada a los de salida, pero desplazados en 1 posición hacia la izquierda. En el caso del SHR ocurre casi lo mismo. Sin embargo, es en el sentido contrario: se asigna el valor '0' al bit más significativo del vector de salida y luego se van asignando los bits de entrada pero desplazados en 1 posición hacia la derecha.

- Los códigos de status de salida se obtienen de la siguiente forma:

  - Z: Se obtiene al hacer un OR entre todos los bits del resultado y luego aplicarle un NOT, de modo que si el resultado es 0 entonces Z será 1.

  - N: Corresponde al bit más significativo del resultado (si se trabaja con complemento a 2 es el bit de signo).

  - C: Depende de la operación realizada:

    - ADD/SUB: Corresponde al valor del CarryOut del último fulladder (el más significativo).
    - AND/OR/NOT/XOR: Toma valor 0.
    - SHL/SHR: Corresponde al valor del bit más significativo y menos significativo del vector de entrada, respectivamente.

### Adder:

Señales de Entrada:

- A: Valor 1 (en 16 bits).

- regB: Valor actual del Program Counter (en 16 bits).

- carryIn: Valor 0.

Señales de Salida:

- result: Valor de retorno del Program Counter al ejecutar el próximo RET (16 bits).

- carryOut: Carry resultante de la operación.

Arquitectura: El Adder es el mismo componente utilizado dentro de la ALU para las operaciones de suma y resta, ocupado en este caso para incrementar en 1 el valor de salida del PC y así guardar en la RAM la línea de retorno de las subrutinas.

### Multiplexor A: 

Señales de Entrada:

- A: Valor del Registro A.

- selA: Señales de control que seleccionan la salida del Multiplexor A (revisar sección Unidad de Control).

Señales de Salida:

- dataOut: Valor de entrada a la ALU (16 bits).

Arquitectura: El multiplexor A se compone de señales de control, según las que se definen los valores a entregar en la salida (utilizando with select). Según la combinación que entregue selA puede retornar en dataOut los valores A, "0000000000000001" y "0000000000000000".

### Multiplexor B: 

Señales de Entrada:

- B: Valor del Registro B.

- selB: Señales de control que seleccionan la salida del Multiplexor B (revisar sección Unidad de Control).

- Lit: Valor del literal proveniente de los 16 bits más significativos de las instrucciones de la ROM.

- DRam: Valor de salida de la memoria RAM.

Señales de Salida:

- dataOut: Valor de entrada a la ALU (16 bits).

Arquitectura: El multiplexor B se compone de señales de control, según las que se definen los valores a entregar en la salida (utilizando with select). Según la combinación que entregue selB puede retornar en dataOut los valores B, "0000000000000000", un dato proveniente de la RAM y un Literal proveniente de la ROM.

### Multiplexor DataIn:

Señales de Entrada:

- result: Resultado de la ALU.

- subAdd: Valor de salida del Adder (línea de retorno de las subrutinas).

- selDIn: Señal de control que selecciona la salida del Multiplexor DataIn (revisar sección Unidad de Control).

Señales de Salida:

- ramIn: Valor de entrada a la memoria RAM (16 bits).

Arquitectura: El multiplexor DataIn se compone de la señal de control selDIn, según la que se definen los valores a entregar en la salida (utilizando with select). Según el valor de selDIn puede retornar en ramIn los valores result y subAdd.

### Multiplexor PC:

Señales de Entrada:

- romOut: Valor del literal de la instrucción actual (12 bits menos significativos del literal).

- memOut: Valor de salida de la memoria RAM (12 bits menos significativos).

- selPC: Señal de control que selecciona la salida del Multiplexor PC (revisar sección Unidad de Control).

Señales de Salida:

- pcIn: Valor de entrada al Program Counter (12 bits).

Arquitectura: El multiplexor PC se compone de la señal de control selPC, según la que se definen los valores a entregar en la salida (utilizando with select). Según el valor de selPC puede retornar en pcIn los valores romOut (12 bits menos significativos del literal) y memOut (12 bits menos significativos).

### Multiplexor Address:

Señales de Entrada:

- romOut: Valor del literal de la instrucción actual (12 bits menos significativos del literal).

- valB: Valor del registro B (12 bits menos significativos).

- spOut: Valor del Stack Pointer.

- selAdd: Señales de control que seleccionan la salida del Multiplexor Address (revisar sección Unidad de Control).

Señales de Salida:

- ramAdd: Valor de la dirección de la memoria RAM (12 bits).

Arquitectura: El multiplexor Address se compone de señales de control, según las que se definen los valores a entregar en la salida (utilizando with select). Según la combinación que entregue selAdd puede retornar en ramAdd los valores romOut (12 bits menos significativos del literal), valB (12 bits menos significativos) y spOut.

### Registro A: 

Señales de Entrada:

- clock: Señal del Clock de la placa.

- loadA: Señal de control que habilita la carga de datos en el Registro A. Si toma valor 1 permite la carga.

- selA: Señales de control que seleccionan la salida del Multiplexor A (revisar sección Unidad de Control).

- dataIn: Valor del resultado de la ALU.

Señales de Salida:

- dataOut: Valor de entrada a la ALU (16 bits).

- valA: Valor de salida del Registro A, conectado directamente al Display.

Arquitectura: El módulo Registro A está compuesto por el Registro A y Multiplexor A, razón por la que recibe las señales de entrada de ambos componentes. Se encarga de almacenar valores en el Registro A (según la señal loadA y sólo en Flanco de Subida del Clock) y de entregar en la salida lo que se le indique con la señal selA.

### Registro B: 

Señales de Entrada:

- clock: Señal del Clock de la placa.

- loadB: Señal de control que habilita la carga de datos en el Registro B. Si toma valor 1 permite la carga.

- selB: Señales de control que seleccionan la salida del Multiplexor B (revisar sección Unidad de Control).

- dataIn: Valor del resultado de la ALU.

- memIn: Valor de salida de la memoria RAM.

- lit: Valor del literal proveniente de los 16 bits más significativos de las instrucciones de la ROM.

Señales de Salida:

- dataOut: Valor de entrada a la ALU (16 bits).

- valB: Valor de salida del Registro B, conectado directamente al Display. También se conecta al Multiplexor Address para realizar direccionamiento indirecto.

Arquitectura: El módulo Registro B está compuesto por el Registro B y Multiplexor B, razón por la que recibe las señales de entrada de ambos componentes. Se encarga de almacenar valores en el Registro B (según la señal loadB y sólo en Flanco de Subida del Clock) y de entregar en la salida lo que se le indique con la señal selB.

### Program Counter (PC): 

Señales de Entrada:

- clock: Señal del Clock de la placa.

- loadPC: Señal de control que habilita la carga de datos en el PC. Si toma valor 1 permite la carga.

- countIn: Valor de salida del Multiplexor PC.

Señales de Salida:

- countOut: Valor de entrada a la ROM (dirección de 12 bits). También se utiliza como el valor de entrada del Adder para poder utilizar subrutinas.

Arquitectura: Se utilizó un Program Counter de 12 bits de direccionamiento de la ROM, que incrementa en 1 el número almacenado en caso de que la señal loadPC sea 0. Si la señal loadPC es 1, se carga un nuevo número al contador (utilizado para Saltos y Retornos). Se siguió la plantilla asignando los inputs y outputs correspondientes, aprovechando además la señal Up del Registro entregado para simular la modalidad de contador ascendente.

### Registro de Status:

Señales de Entrada:

- clock: Señal del Clock de la placa.

- status: Valor de los 3 códigos de status de la ALU (Z, N, C).

Señales de Salida:

- statusOut: Valor de los 3 códigos de status de la ALU (Z, N, C), conectados a la Unidad de Control.

Arquitectura: Se creó la señal "regVal". Si el Clock está en flanco de subida, se actualiza esta señal con el valor de entrada "status". El valor de salida es el de la señal regVal, que se conecta con la Unidad de Control para permitir el uso de Saltos Condicionales.

### Stack Pointer (SP):

Señales de Entrada:

- clock: Señal del Clock de la placa.

- incSP: Señal de control que al tomar valor 1 incrementa en 1 el valor del SP.

- decSP: Señal de control que al tomar valor 1 decrementa en 1 el valor del SP.

Señales de Salida:

- spOut: Valor actual del SP (12 bits). Se conecta al Multiplexor Address, permitiendo direccionar la memoria de datos para manejar el Stack.

Arquitectura: Se utilizó un Stack Pointer de 12 bits de direccionamiento de la RAM, el que comienza con el valor inicial '111111111111' (última dirección de la memoria RAM), y sólo permite incrementar o decrementar su valor de a 1, dependiendo de los valores de las señales de control incSP y decSP. Su salida se conecta al Multiplexor Address, donde se utiliza al momento de ejecutar llamadas y retornos de subrutinas.

### Componentes Entregados

Se utilizaron los siguientes componentes entregados en el repositorio para facilitar el desarrollo de la entrega:

- ROM: Actúa como la memoria de Instrucciones del computador.

- RAM: Actúa como la memoria de Datos del computador.

- Reg: Registro multipropósito utilizado en los Registros A, B y PC.

- Display_Controller: Controlador del Display, conectado con la salida de los Registros A y B para mostrar sus bytes menos significativos en valor Hexadecimal.

- Clock_Divider: Permite disminuir la frecuencia del Clock de la placa. Es utilizado en conjunto con el Botón Derecho (btnFast) para modificar la velocidad del Clock en tiempo real.

- Debouncer: Es utilizado para estabilizar las señales de entrada de los Botones.

## Funcionalidades Extra

Se implementaron las siguientes funcionalidades Extra:

### Controlar Velocidad del Clock:

Con el botón de la derecha (btnFast) se puede aumentar la velocidad del Clock en tiempo real hasta llegar al máximo permitido por el Clock Divider. Si se vuelve a presionar después de esto simplemente volverá a la velocidad más lenta de nuevo.

### Clock Manual:

Con el botón de arriba (btnSel) se puede ALTERNAR en tiempo real entre utilizar el Clock automático (default) y un Clock manual. Este Clock manual se utiliza apretando el botón central (btnClk), lo que simula 1 ciclo de ejecución del computador. Mientras se esté en el modo manual no tendrá efecto el intentar cambiar la velocidad. Análogamente, mientras se esté en el modo automático no tendrá efecto el intentar apretar el botón de Clock manual. 

### Input con Switches:

Se puede CAMBIAR una línea en el apartado de la ROM dentro del módulo `Computer.vhd` para poder utilizar los switches a modo de input de instrucciones (en vez de recibirlas desde la ROM). Esto está permitido sólo en el modo de Clock manual (al estar en el modo automático se leerá la última configuración de switches que se usó en el modo manual). Como son sólo 16 switches, estos pueden representar solamente los 16 bits menos significativos de las instrucciones. Esto significa que no permiten elegir literal, sin embargo resultan útiles para probar distintas operaciones en el computador antes de escribirlas dentro de la ROM.

# Estructura de las Instrucciones

Los 36 bits de cada instrucción se dividieron de la siguiente forma:

- Los 16 bits más significativos representan el Literal de la instrucción (por default será 0)
- Los 20 bits menos significativos representan la palabra de control (explicada en detalle a continuación)

## Palabra de Control

Los 16 bits más significativos están reservados para representar el valor de distintas señales independientes entre sí. A esta sección de la palabra se le llamará 'Zona de Señales'. Los 4 bits menos significativos están reservados para representar el tipo de operación que se quiere realizar. A esta sección se le llamará 'Zona de Operaciones'.

La codificación de la Zona de Señales depende del tipo de operación a realizar, por lo que es DEPENDIENTE de la Zona de Operaciones. La construcción de la Zona de Señales se hizo buscando patrones y relaciones entre las señales de control de cada grupo de operaciones (por ejemplo buscar como relacionar las señales de control de distintas operaciones tipo MOV), finalmente dejando algunas de estas señales representadas en bits de la Zona de Señales, mientras que los valores de las otras son obtenidos mediante combinaciones de distintas puertas lógicas o valores default.

A continuación se detallan los distintos grupos de operaciones que se pueden realizar, junto a su codificación en ambas Zonas:

### NOP:

- Zona de Operaciones: '0000'

- Zona de Señales: '0000000000000000'

- Todas las señales valen 0.

### MOV:

- Zona de Operaciones: '0001'

- Zona de Señales: '000000000' + selAdd (1 bit, se omite el primero) + loadA (1 bit) + loadB (1 bit) + selA (2 bits) + selB (2 bits)

- El bit más significativo de la señal de control selAdd NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones MOV.

- El valor de la señal W (write) se obtiene haciendo loadA NOR loadB. Las demás señales valen 0.

### ADD/SUB/AND/OR/XOR:

- Zona de Operaciones: '0010'

- Zona de Señales: '00000000' + selAdd (1 bit, se omite el primero) + loadA (1 bit) + loadB (1 bit) + selB (2 bits) + selALU (3 bits)

- El bit más significativo de la señal de control selAdd NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones ADD/SUB/AND/OR/XOR.

- El valor de la señal W (write) se obtiene haciendo loadA NOR loadB. Las demás señales valen 0.

- Los valores de los 3 bits menos significativos de la Zona de Señales (selALU) representarán la operación a realizar.

### NOT/SHL/SHR:

- Zona de Operaciones: '0011'

- Zona de Señales: '00000000000' + selAdd (1 bit, se omite el primero) + loadA (1 bit) + loadB (1 bit) + selALU (2 bits, se omite el primero)

- El bit más significativo de la señal de control selAdd NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones NOT/SHL/SHR.

- El bit más significativo de la señal de control selALU NO está en la Zona de Señales de este grupo, ya que vale 1 para las operaciones NOT/SHL/SHR. Por lo tanto sólo los otros 2 bits aparecen en dicha Zona.

- El valor de la señal W (write) se obtiene haciendo loadA NOR loadB. Las demás señales valen 0.

### INC/DEC:

- Zona de Operaciones: '0100'

- Zona de Señales: '000000000000' + selAdd (1 bit, se omite el primero) + selB (2 bits) + selALU (1 bit, se omiten los 2 primeros)

- El LITERAL de la instrucción en la ROM deberá ser '0000000000000001' para todas las operaciones de este grupo (EXCEPTO las que requieran direccionar la memoria usando un literal), ya que las que lo ocupan requieren mover al Registro B el valor 1 (por ejemplo DEC A).

- El bit más significativo de la señal de control selAdd NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones INC/DEC.

- Los 2 bits más significativos de la señal de control selALU NO están en la Zona de Señales de este grupo, ya que valen 0 para las operaciones INC/DEC. Por lo tanto sólo el bit menos significativo aparece en dicha Zona (si toma valor 1 es un ADD, si toma valor 0 es un SUB).

- El valor de la señal loadA se obtiene aplicando un XOR entre los 2 bits de selB. El valor de loadB se obtiene aplicando un NOR entre los 2 bits de selB. El bit más significativo de selA se obtiene aplicando un XNOR entre los 2 bits de selB, mientras que el menos significativo toma valor 0. El valor de la señal W (write) se obtiene haciendo loadA NOR loadB. Las demás señales valen 0.

### CMP:

- Zona de Operaciones: '0101'

- Zona de Señales: '0000000000000' + selAdd (1 bit, se omite el primero) + selB (2 bits)

- El bit más significativo de la señal de control selAdd NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones CMP.

- La operación de la ALU es siempre un SUB, por lo que selALU toma valor '001' y no aparece en la Zona de Señales. Las demás señales valen 0.

### JMP/JEQ/JNE/JGT/JGE/JLT/JLE/JCR:

- Zona de Operaciones: '0110'

- Para este grupo se utilizarán bits que NO representan señales de control en la Zona de Señales. Estos serán los siguientes:

  - statusBits (3 bits):
     -  '000': Valor 0.
     -  '001': Status Code Z.
     -  '010': Status Code N.
     -  '011': N OR Z.
     -  '100': Status Code C.

  - compBit (1 bit): Representa el valor con el que se quiere comparar alguno de los valores representados en los statusBits. De esta manera se podrá revisar si los Status Codes cumplen la condición para el Salto.

- Zona de Señales: '000000000000' + compBit (1 bit) + statusBits (3 bits)

- El valor de la señal loadPC se obtiene haciendo compBit XNOR Value, donde Value es el valor representado en los statusBits. Por ejemplo para realizar JEQ se necesita que Z = 1 (puesto que al restar los números debe dar 0), por lo que los statusBits deben ser '001' (Status Code Z) y el compBit debe ser '1' (ya que se quiere que Z sea igual a 1).

- Las demás señales de control valen 0.

### CALL/PUSH:

- Zona de Operaciones: '0111'

- Zona de Señales: '00000000000000' + loadPC (1 bit) + selA (1 bit, se omite el primero)

- El bit más significativo de la señal de control selA NO está en la Zona de Señales de este grupo, ya que vale 0 para todas las operaciones CALL/PUSH.

- La señal selDIn toma el mismo valor que loadPC, el bit más significativo de selB es 0 y el menos significativo se obtiene aplicando un NOT al bit menos significativo de selA, selAdd toma valor '10' y las señales W y decSP toman ambas valor 1. Las demás señales de control valen 0.

### RET/POP:

- Zona de Operaciones: '1000'

- Zona de Señales: '0000000000000' + loadPC (1 bit) + loadA (1 bit) + loadB (1 bit)

- La señal incSP se obtiene aplicando (loadA OR loadB) NOR loadPC, selPC toma valor 1, selA toma valor '01', selB toma valor '11' y selAdd toma valor '10'. Las demás señales de control valen 0.

- Las operaciones de este grupo ocurren en 2 ciclos del clock, por lo que cada una está compuesta por 2 instrucciones consecutivas.

# Assembler

El archivo principal a ejecutar corresponde a `assembler.py`. Para utilizarlo se debe ejecutar el siguiente comando en la terminal, al interior de la carpeta `assembler` (requiere tener python 3.6 o 3.7 instalado):

```
$ python3 assembler.py path_archivo (.asm)
```

Como resultado se creará el archivo `ROM.vhd` en la misma carpeta desde la que se ejecutó el comando de arriba. Este archivo contiene las instrucciones de assembly básico del archivo `.asm` original, traducidas al lenguaje de máquina utilizado por nuestro computador básico. Para poder integrar dichas instrucciones al proyecto, se deberá colocar el archivo `ROM.vhd` dentro de la carpeta `modulos`, lo que actualizará la memoria ROM utilizada por el proyecto de Vivado.

Los módulos utilizados para parsear las instrucciones fueron los siguientes:

- `add_sub_logical.py` => Se encarga de parsear las operaciones ADD, SUB, AND, OR y XOR.
- `cmp_.py` => Parsea la operación CMP.
- `inc_dec.py` => Parsea las operaciones INC y DEC.
- `jumps.py` => Se encarga de parsear los saltos (JMP, JEQ, JNE, JGE, JGT, JLT, JLE, JCR), además de la operación CALL.
- `mov.py` => Parsea la operación MOV.
- `nop.py` => Parsea la operación NOP.
- `push_pop_ret.py` => Parsea las operaciones PUSH, POP y RET.
- `shifts_not.py` => Parsea las operaciones SHL, SHR y NOT.
- `parser_file.py` => Usando todos los módulos anteriores es capaz de parsear cualquier instrucción pedida para esta entrega.

Los módulos que se encargan de leer el archivo a parsear son:

- `read_asm.py` => Lee el archivo a parsear y le quita los comentarios, espacios, líneas en blanco, tabulaciones, etc. Finalmente deja el archivo en la forma estándar (OPERACION OPERANDO1,OPERANDO2).
- `parse_variables.py` => Se encarga de leer la sección DATA (una vez que el archivo ya fue procesado por el módulo anterior), y a cada asignación de variables las deja de la forma MOV B,CONTADOR_DE_MEMORIA - MOV (B), literal. De esta forma genera 2 instrucciones por cada variable declarada, las que se encargan de guardar los valores iniciales de las variables en la memoria RAM.
- `parse_line_jumps.py` => Se encarga de registrar los labels de saltos y subrutinas en el archivo, tomando en cuenta que hay instrucciones que en el archivo final contarán como 2 (los POP y RET).
- `assembler.py` => Lee el archivo `.asm` completo y se encarga de dejarlo en lenguaje de máquina, además de escribir el archivo `ROM.vhd`.

Finalmente, los siguientes módulos adicionales fueron utilizados en distintos archivos:

- `utils.py` => Contiene funciones que son usadas por los demás módulos sin tener una relación directa con el parser (convertir un número a binario o hexadecimal, por ejemplo).

- `instructions.py` => Contiene un diccionario con todas las instrucciones en forma genérica y en su versión en lenguaje de máquina, es decir, del estilo MOV A,B => 000......01, MOV A,LIT => 0101.....01.

- `errors.py` => Contiene la clase de la excepción NotNegative, que evita que se ingresen números negativos como literales.

# Distribución del Trabajo

Lo más difícil fue realizar el testing del assembler, ya que se iban descubriendo diversos errores específicos a medida que se probaban los distintos archivos `.asm` entregados, los que debían ser solucionados para finalmente completar el assembler.

A continuación se encuentra el trabajo realizado por cada integrante del grupo:

## Benjamín F. Farías:

Actualizar la Unidad de Control con las nuevas señales agregadas, extendiendo su diseño. Además agregar los nuevos componentes de Hardware al computador básico y conectarlos entre sí y con los que ya existían. También apoyar en el testing del assembler y llevar a cabo el testing de la placa.

## Karl M. Haller:

Trabajar en el assembler, en particular encargándose del parseo de los labels de saltos/subrutinas que aparecen en la sección CODE (archivo `parse_line_jumps.py`).

## Diego Navarro:

Crear e integrar el Stack Pointer, permitiendo manejar espacios de la memoria para realizar subrutinas.

## Juan I. Parot:

Trabajar en el assembler, en particular encargándose del parseo de las variables declaradas en la sección DATA (archivo `parse_variables.py`).

## Juan A. Romero:

Desarrollar el assembler, en particular encargándose de la transformación de instrucciones assembly a lenguaje de máquina, además de testear y unir los distintos módulos utilizados por el assembler.

# Instrucciones Soportadas

El computador creado soporta TODAS las instrucciones pedidas para la entrega. La tabla con dichas instrucciones y sus palabras de control se muestra a continuación:

| Operación | Operandos | Literal          | Zona de Señales  | Zona de Operaciones |
|-----------|-----------|------------------|------------------|---------------------|
| MOV       | A,B       | 0000000000000000 | 0000000000100100 | 0001                |
| MOV       | B,A       | 0000000000000000 | 0000000000010001 | 0001                |
| MOV       | A,Lit     | Lit              | 0000000000100110 | 0001                |
| MOV       | B,Lit     | Lit              | 0000000000010110 | 0001                |
| MOV       | A,(Dir)   | Dir              | 0000000000100111 | 0001                |
| MOV       | B,(Dir)   | Dir              | 0000000000010111 | 0001                |
| MOV       | (Dir),A   | Dir              | 0000000000000001 | 0001                |
| MOV       | (Dir),B   | Dir              | 0000000000000100 | 0001                |
| MOV       | A,(B)     | 0000000000000000 | 0000000001100111 | 0001                |
| MOV       | B,(B)     | 0000000000000000 | 0000000001010111 | 0001                |
| MOV       | (B),A     | 0000000000000000 | 0000000001000001 | 0001                |
| MOV       | (B),Lit   | Lit              | 0000000001000110 | 0001                |
| ADD       | A,B       | 0000000000000000 | 0000000001000000 | 0010                |
| ADD       | B,A       | 0000000000000000 | 0000000000100000 | 0010                |
| ADD       | A,Lit     | Lit              | 0000000001010000 | 0010                |
| ADD       | B,Lit     | Lit              | 0000000000110000 | 0010                |
| ADD       | A,(Dir)   | Dir              | 0000000001011000 | 0010                |
| ADD       | B,(Dir)   | Dir              | 0000000000111000 | 0010                |
| ADD       | (Dir)     | Dir              | 0000000000000000 | 0010                |
| ADD       | A,(B)     | 0000000000000000 | 0000000011011000 | 0010                |
| ADD       | B,(B)     | 0000000000000000 | 0000000010111000 | 0010                |
| SUB       | A,B       | 0000000000000000 | 0000000001000001 | 0010                |
| SUB       | B,A       | 0000000000000000 | 0000000000100001 | 0010                |
| SUB       | A,Lit     | Lit              | 0000000001010001 | 0010                |
| SUB       | B,Lit     | Lit              | 0000000000110001 | 0010                |
| SUB       | A,(Dir)   | Dir              | 0000000001011001 | 0010                |
| SUB       | B,(Dir)   | Dir              | 0000000000111001 | 0010                |
| SUB       | (Dir)     | Dir              | 0000000000000001 | 0010                |
| SUB       | A,(B)     | 0000000000000000 | 0000000011011001 | 0010                |
| SUB       | B,(B)     | 0000000000000000 | 0000000010111001 | 0010                |
| AND       | A,B       | 0000000000000000 | 0000000001000010 | 0010                |
| AND       | B,A       | 0000000000000000 | 0000000000100010 | 0010                |
| AND       | A,Lit     | Lit              | 0000000001010010 | 0010                |
| AND       | B,Lit     | Lit              | 0000000000110010 | 0010                |
| AND       | A,(Dir)   | Dir              | 0000000001011010 | 0010                |
| AND       | B,(Dir)   | Dir              | 0000000000111010 | 0010                |
| AND       | (Dir)     | Dir              | 0000000000000010 | 0010                |
| AND       | A,(B)     | 0000000000000000 | 0000000011011010 | 0010                |
| AND       | B,(B)     | 0000000000000000 | 0000000010111010 | 0010                |
| OR        | A,B       | 0000000000000000 | 0000000001000011 | 0010                |
| OR        | B,A       | 0000000000000000 | 0000000000100011 | 0010                |
| OR        | A,Lit     | Lit              | 0000000001010011 | 0010                |
| OR        | B,Lit     | Lit              | 0000000000110011 | 0010                |
| OR        | A,(Dir)   | Dir              | 0000000001011011 | 0010                |
| OR        | B,(Dir)   | Dir              | 0000000000111011 | 0010                |
| OR        | (Dir)     | Dir              | 0000000000000011 | 0010                |
| OR        | A,(B)     | 0000000000000000 | 0000000011011011 | 0010                |
| OR        | B,(B)     | 0000000000000000 | 0000000010111011 | 0010                |
| XOR       | A,B       | 0000000000000000 | 0000000001000101 | 0010                |
| XOR       | B,A       | 0000000000000000 | 0000000000100101 | 0010                |
| XOR       | A,Lit     | Lit              | 0000000001010101 | 0010                |
| XOR       | B,Lit     | Lit              | 0000000000110101 | 0010                |
| XOR       | A,(Dir)   | Dir              | 0000000001011101 | 0010                |
| XOR       | B,(Dir)   | Dir              | 0000000000111101 | 0010                |
| XOR       | (Dir)     | Dir              | 0000000000000101 | 0010                |
| XOR       | A,(B)     | 0000000000000000 | 0000000011011101 | 0010                |
| XOR       | B,(B)     | 0000000000000000 | 0000000010111101 | 0010                |
| NOT       | A         | 0000000000000000 | 0000000000001000 | 0011                |
| NOT       | B,A       | 0000000000000000 | 0000000000000100 | 0011                |
| NOT       | (Dir),A   | Dir              | 0000000000000000 | 0011                |
| NOT       | (B),A     | 0000000000000000 | 0000000000010000 | 0011                |
| SHL       | A         | 0000000000000000 | 0000000000001010 | 0011                |
| SHL       | B,A       | 0000000000000000 | 0000000000000110 | 0011                |
| SHL       | (Dir),A   | Dir              | 0000000000000010 | 0011                |
| SHL       | (B),A     | 0000000000000000 | 0000000000010010 | 0011                |
| SHR       | A         | 0000000000000000 | 0000000000001011 | 0011                |
| SHR       | B,A       | 0000000000000000 | 0000000000000111 | 0011                |
| SHR       | (Dir),A   | Dir              | 0000000000000011 | 0011                |
| SHR       | (B),A     | 0000000000000000 | 0000000000010011 | 0011                |
| INC       | A         | 0000000000000001 | 0000000000000100 | 0100                |
| INC       | B         | 0000000000000001 | 0000000000000000 | 0100                |
| INC       | (Dir)     | Dir              | 0000000000000110 | 0100                |
| INC       | (B)       | 0000000000000001 | 0000000000001110 | 0100                |
| DEC       | A         | 0000000000000001 | 0000000000000101 | 0100                |
| CMP       | A,B       | 0000000000000000 | 0000000000000000 | 0101                |
| CMP       | A,Lit     | Lit              | 0000000000000010 | 0101                |
| CMP       | A,(Dir)   | Dir              | 0000000000000011 | 0101                |
| CMP       | A,(B)     | 0000000000000000 | 0000000000000111 | 0101                |
| JMP       | Ins       | Ins              | 0000000000000000 | 0110                |
| JEQ       | Ins       | Ins              | 0000000000001001 | 0110                |
| JNE       | Ins       | Ins              | 0000000000000001 | 0110                |
| JGT       | Ins       | Ins              | 0000000000000011 | 0110                |
| JGE       | Ins       | Ins              | 0000000000000010 | 0110                |
| JLT       | Ins       | Ins              | 0000000000001010 | 0110                |
| JLE       | Ins       | Ins              | 0000000000001011 | 0110                |
| JCR       | Ins       | Ins              | 0000000000001100 | 0110                |
| CALL      | Ins       | Ins              | 0000000000000010 | 0111                |
| PUSH      | A         | 0000000000000000 | 0000000000000000 | 0111                |
| PUSH      | B         | 0000000000000000 | 0000000000000001 | 0111                |
| RET (1st) | -         | 0000000000000000 | 0000000000000000 | 1000                |
| RET (2nd) | -         | 0000000000000000 | 0000000000000100 | 1000                |
| POP (1st) | A         | 0000000000000000 | 0000000000000000 | 1000                |
| POP (2nd) | A         | 0000000000000000 | 0000000000000010 | 1000                |
| POP (1st) | B         | 0000000000000000 | 0000000000000000 | 1000                |
| POP (2nd) | B         | 0000000000000000 | 0000000000000001 | 1000                |
| NOP       | -         | 0000000000000000 | 0000000000000000 | 0000                |

# Anexo - Entregas Pasadas

# Entrega 2

# Distribución del Trabajo

Lo más difícil fue diseñar la palabra de control de manera que se pudiesen aprovechar los distintos 'patrones' formados entre las señales de control de distintas instrucciones, y además permitir una alta escalabilidad para las siguientes entregas. Finalmente se optó por la estructura explicada en la sección 'Estructura de las Instrucciones'.

A continuación se encuentra el trabajo realizado por cada integrante del grupo:

## Benjamín F. Farías:

Crear la Unidad de Control y el diseño de la palabra de control. Además participar en la transcripción del código assembly a lenguaje de máquina y apoyar en distintas tareas.

## Karl M. Haller:

Desarrollar los shifts de la ALU y aportar en el desarrollo de esta (módulos **shift_left.vhd** y **shift_rght.vhd**).

## Diego Navarro:

Crear el Program Counter de 12 bits de direccionamiento y el Registro de Status.

## Juan I. Parot:

Crear la LU, los registros A y B (con sus multiplexores) y apoyar en el desarrollo de la ALU.

## Juan A. Romero: 

Crear el sumador/restador de la ALU e incorporarlo a esta (módulos **fulladder.vhd** y **ALU.vhd**). Además idear el algoritmo para multiplicar en assembly y participar en la transcripción de este a lenguaje de máquina.

# Código Assembly

El siguiente código multiplica dos números positivos (factorA y factorB), guardando el resultado en la variable con dicho nombre:

 ```
DATA:
    resultado 0
    factorA 2
    factorB 9

CODE:
    MOV A,(factorA)
    MOV B,(factorB)
multiplicar: 
    CMP A,0
    JEQ end
    MOV A,(resultado)
    ADD (resultado)
    MOV A,(factorA)
    DEC A
    MOV (factorA),A
    JMP multiplicar
    JMP end
end:
    JMP end
 ```

El algoritmo implementado corresponde a:

 ```
def multiplicar(a,b):
    resultado = 0
    while a > 0:
        resultado += b
        a -= 1
    return resultado
 ```
