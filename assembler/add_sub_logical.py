from instructions import INSTRUCTIONS as I
from utils import to_binary, parse_lit


def parse_add_sub_logical(instruction, variables_data):
    inst = instruction.split(' ')
    return parse_args(inst[0], inst[1].strip(' '), variables_data)    


def parse_args(op, op_args, variables_data):
    if ',' in op_args:
        if op_args == 'A,B':  # A,B
            return I[op]['variants']['ab']['lit'] + \
                   I[op]['variants']['ab']['signal'] + I[op]['operation_code']
        elif op_args == 'B,A':  # B,A
            return I[op]['variants']['ba']['lit'] + \
                   I[op]['variants']['ba']['signal'] + I[op]['operation_code']
        elif op_args == 'A,(B)':  # A,(B)
            return I[op]['variants']['adb']['lit'] + \
                   I[op]['variants']['adb']['signal'] + I[op]['operation_code']
        elif op_args == 'B,(B)':  # B,(B)
            return I[op]['variants']['bdb']['lit'] + \
                   I[op]['variants']['bdb']['signal'] + I[op]['operation_code']
        args = op_args.split(',')
        if args[0] == 'A': 
            if '(' not in args[1]:
                lit = parse_lit(args[1], variables_data) 
                return lit + I[op]['variants']['al']['signal'] + \
                    I[op]['operation_code']
            else:  # A,(dir)
                memory_dir = args[1].strip('(').strip(')')
                lit = to_binary(variables_data[memory_dir]['dir_memory'], 16)
                return lit + I[op]['variants']['ad']['signal'] + \
                    I[op]['operation_code']
        if args[0] == 'B': 
            if '(' not in args[1]:  # B,lit
                lit = parse_lit(args[1], variables_data)
                return lit + I[op]['variants']['ab']['signal'] + \
                    I[op]['operation_code']
            else:  # B, (dir)
                memory_dir = args[1].strip('(').strip(')')
                lit = to_binary(variables_data[memory_dir]['dir_memory'], 16)
                return lit + I[op]['variants']['bd']['signal'] + \
                    I[op]['operation_code']
    elif '(' in op_args:
        memory_dir = op_args.strip('(').strip(')')
        lit = to_binary(variables_data[memory_dir]['dir_memory'], 16)
        return lit + I[op]['variants']['d']['signal'] + I[op]['operation_code']
