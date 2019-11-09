from read_asm import read_assembly
from utils import parser_number
from errors import NotNegative


def get_variables_instructions(VARIABLES_DATA, counter, direccion="test.asm"):
    for i in read_assembly(direccion):
        if "DATA:" in i:
            continue
        if "CODE:" in i:
            break
        try:
            if ' ' in i:
                value = parser_number(i.split(" ")[1].lower())
                VARIABLES_DATA[str(i.split(' ')[0])] = {
                    "dir_memory": counter, "value": value, "instructions":
                        [f'MOV B,{counter}', f'MOV (B),{value}']}
                VARIABLES_DATA[str(counter)] = {
                    "dir_memory": counter, "value": value, "instructions":
                        [f'MOV B,{counter}', f'MOV (B),{value}']}
            else:
                value = parser_number(i)
                VARIABLES_DATA[str(counter)] = {
                    "dir_memory": counter, "value": value, "instructions":
                        [f'MOV B,{counter}', f'MOV (B),{value}']}
        except NotNegative:
            print(f'Error en DATA: Instruccion numero {counter + 1}: {i} =>  '
                  f'No se permiten numeros negativos!')
            exit()
        counter += 1
    return VARIABLES_DATA
