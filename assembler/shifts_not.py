from instructions import INSTRUCTIONS as I
from utils import parse_dir


def parse_not_shifts(instruction, variables_data):
    inst = instruction.split(' ')
    return parse_args(inst[0], inst[1].strip(' '), variables_data)    


def parse_args(op, op_args, variables_data):
    if ',' in op_args:
        if op_args == 'B,A':  # B,A
            return I[op]['variants']['ba']['lit'] + \
                   I[op]['variants']['ba']['signal'] + I[op]['operation_code']
        elif op_args == '(B),A':  # (B),A
            return I[op]['variants']['dba']['lit'] + \
                   I[op]['variants']['dba']['signal'] + I[op]['operation_code']
        elif '(' in op_args:
            args = op_args.split(',')
            if args[1] == 'A':  # (dir),A
                lit = parse_dir(args[0], variables_data)
                return lit + I[op]['variants']['da']['signal'] + \
                    I[op]['operation_code']
    if op_args == 'A':  # A
        return I[op]['variants']['a']['lit'] + \
               I[op]['variants']['a']['signal'] + I[op]['operation_code']
