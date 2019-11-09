from instructions import INSTRUCTIONS as I
from utils import to_binary


def parse_inc_dec(instruction, variables_data):
    inst = instruction.split(' ')
    if inst[0] == 'DEC':
        return parse_dec(inst[1], variables_data)
    return parse_inc(inst[1].strip(' '), variables_data)    

def parse_dec(op_args, variables_data):
    if op_args == 'A':
        return I['DEC']['variants']['a']['lit'] + I['DEC']['variants']['a']['signal'] + I['DEC']['operation_code']

def parse_inc(op_args, variables_data):
    if op_args == 'A':  # A
        return I['INC']['variants']['a']['lit'] + I['INC']['variants']['a']['signal'] + I['INC']['operation_code']
    if op_args == 'B':  # B
        return I['INC']['variants']['b']['lit'] + I['INC']['variants']['b']['signal'] + I['INC']['operation_code']
    if '(' in op_args:  # (dir)
        memory_dir = op_args.strip('(').strip(')')
        lit = to_binary(memory_dir, 16) if memory_dir not in variables_data else to_binary(variables_data[memory_dir]['dir_memory'], 16)
        return lit + I['INC']['variants']['d']['signal'] + I['INC']['operation_code']
