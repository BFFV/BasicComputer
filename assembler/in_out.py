from instructions import INSTRUCTIONS as I
from utils import parse_lit, parse_dir


def parse_in_out(instruction, variables_data):
    inst = instruction.split(' ')
    if inst[0] == 'IN':
        return parse_in(inst[1].split(','), variables_data)
    return parse_out(inst[1].split(','), variables_data)


def parse_in(args, variables_data):
    if args[0] == 'A':  # A,Lit
        lit = parse_lit(args[1], variables_data)
        return lit + I['IN']['variants']['al']['signal'] + \
            I['IN']['operation_code']
    if args[0] == 'B':  # B,Lit
        lit = parse_lit(args[1], variables_data)
        return lit + I['IN']['variants']['bl']['signal'] + \
            I['IN']['operation_code']
    if args[0] == '(B)':  # (B),Lit
        lit = parse_lit(args[1], variables_data)
        return lit + I['IN']['variants']['dbl']['signal'] + \
            I['IN']['operation_code']


def parse_out(args, variables_data):
    if args[0] == 'A' and args[1] == 'B':  # A,B
        return I['OUT']['variants']['ab']['lit'] + \
            I['OUT']['variants']['ab']['signal'] + I['OUT']['operation_code']
    if args[0] == 'A' and args[1] == '(B)':  # A,(B)
        return I['OUT']['variants']['adb']['lit'] + \
            I['OUT']['variants']['adb']['signal'] + I['OUT']['operation_code']
    if args[0] == 'A' and '(' in args[1]:  # A,(Dir)
        lit = parse_dir(args[1], variables_data)  
        return lit + I['OUT']['variants']['ad']['signal'] + \
            I['OUT']['operation_code']
    if args[0] == 'A':  # A,Lit
        lit = parse_lit(args[1], variables_data)
        return lit + I['OUT']['variants']['al']['signal'] + \
            I['OUT']['operation_code']
