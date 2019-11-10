from instructions import INSTRUCTIONS as I
from utils import parse_lit, parse_dir


def parse_cmp(instruction, variables_data):
    inst = instruction.split(' ')
    return parse_args(inst[0], inst[1].strip(' '), variables_data)    


def parse_args(op, op_args, variables_data):
    if ',' in op_args:
        if op_args == 'A,B':  # A,B
            return I[op]['variants']['ab']['lit'] + \
                   I[op]['variants']['ab']['signal'] + I[op]['operation_code']
        if op_args == 'A,(B)':  # A,(B)
            return I[op]['variants']['adb']['lit'] + \
                   I[op]['variants']['adb']['signal'] + I[op]['operation_code']
        args = op_args.split(',')
        if '(' not in op_args:    
            if args[0] == 'A':  # A,Lit
                lit = parse_lit(args[1], variables_data)
                return lit + I[op]['variants']['al']['signal'] + \
                    I[op]['operation_code']
        elif '(' in op_args:
            if args[0] == 'A':  # A,(dir)
                lit = parse_dir(args[1], variables_data)
                return lit + I[op]['variants']['ad']['signal'] + \
                    I[op]['operation_code']
