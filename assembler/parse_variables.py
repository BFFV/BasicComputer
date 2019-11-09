from read_asm import read_assembly
from utils import parser_number

def get_variables_instructions(VARIABLES_DATA,counter,direccion="test.asm"):
    for i in read_assembly(direccion):
        if "DATA:" in i:
            continue
        if "CODE:" in i:
            break
        if ' ' in i:
            value = parser_number(i.split(" ")[1].lower())
            VARIABLES_DATA[str(i.split(' ')[0])] = {"dir_memory": counter, "value": value, "instrucctions":
                    [f'MOV B,{counter}', f'MOV (B),{value}']}
            VARIABLES_DATA[str(counter)] = {"dir_memory": counter, "value": value, "instrucctions":
                    [f'MOV B,{counter}', f'MOV (B),{value}']}
            
        else:
            value = parser_number(i)
            VARIABLES_DATA[str(counter)] = {"dir_memory": counter, "value": value, "instrucctions":
                    [f'MOV B,{counter}', f'MOV (B),{value}']}
            
        counter += 1
    return VARIABLES_DATA


