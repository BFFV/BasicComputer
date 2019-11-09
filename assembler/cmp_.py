from instructions import INSTRUCTIONS as I
from utils import to_binary


def parse_cmp(instruction, variables_data):
    inst = instruction.split(' ')
    return parse_args(inst[0], inst[1].strip(' '), variables_data)    


def parse_args(op, op_args, variables_data):
    if ',' in op_args:
        if op_args == 'A,B':  # A,B
            return I[op]['variants']['ab']['lit'] + \
                   I[op]['variants']['ab']['signal'] + I[op]['operation_code']
        args = op_args.split(',')
        if '(' not in op_args:    
            if args[0] == 'A':  # A,LIT
                lit = to_binary(args[1], 16)
                return lit + I[op]['variants']['al']['signal'] + \
                    I[op]['operation_code']
        elif '(' in op_args:
            if args[0] == 'A':  # A,(dir)
                memory_dir = args[1].strip('(').strip(')')
                lit = to_binary(memory_dir, 16) \
                    if memory_dir not in variables_data \
                    else to_binary(variables_data[memory_dir]['dir_memory'], 16)
                return lit + I[op]['variants']['ad']['signal'] + \
                    I[op]['operation_code']
