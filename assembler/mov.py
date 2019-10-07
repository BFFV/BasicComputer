from instructions import INSTRUCTIONS as I


CASES = {'A': None, 'B':None, '(':None}

def parse_mov(mov_instruction):
    '''
    mov_instruction tal que si la instruccion es MOV A,B
    entonces recibe [A,B]
    '''
    return CASES[mov_instruction[0]](mov_instruction[1][0])


def a_left(right_operand):
    '''
    Dado que se hizo un MOV A, algo, retorna la instruccion en binario
    '''
    if right_operand == 'B':
        return I['MOV']['A']['B']
    elif right_operand == '(':
        return I['MOV']
    
