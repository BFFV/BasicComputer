from instructions import INSTRUCTIONS as I
from utils import to_binary, parse_lit, parse_dir


MOV_DICT = I['MOV']


def parse_mov(instruction, variables_data):
    inst = instruction.split(' ')
    return parse_args(inst[1].strip(' '), variables_data)    


def parse_args(mov_args, variables_data):
    print(variables_data)
    if mov_args == 'A,B':  # MOV A,B
        return MOV_DICT['variants']['ab']['lit'] + \
               MOV_DICT['variants']['ab']['signal'] + MOV_DICT['operation_code']
    elif mov_args == 'B,A':  # MOV B,A
        return MOV_DICT['variants']['ba']['lit'] + \
               MOV_DICT['variants']['ba']['signal'] + MOV_DICT['operation_code']
    elif mov_args == 'A,(B)':  # MOV A,(B)
        return MOV_DICT['variants']['adb']['lit'] + \
               MOV_DICT['variants']['adb']['signal'] + \
               MOV_DICT['operation_code']
    elif mov_args == 'B,(B)':  # MOV B,(B)
        return MOV_DICT['variants']['bdb']['lit'] + \
               MOV_DICT['variants']['bdb']['signal'] + \
               MOV_DICT['operation_code']
    elif mov_args == '(B),A':  # MOV (B),A
        return MOV_DICT['variants']['dba']['lit'] + \
               MOV_DICT['variants']['dba']['signal'] + \
               MOV_DICT['operation_code']
    args = [i.strip(' ') for i in mov_args.split(',')]
    if args[0] == 'A':
        if '(' not in args[1]:  # MOV A,lit
            lit = parse_lit(args[1], variables_data)
            return lit + MOV_DICT['variants']['al']['signal'] + \
                MOV_DICT['operation_code']
        else:  # MOV A,(dir)
            lit = parse_dir(args[1], variables_data)
            return lit + MOV_DICT['variants']['ad']['signal'] + \
                MOV_DICT['operation_code']
    if args[0] == 'B' or args[0] == '(B)': 
        if '(' not in args[1] and '(' not in args[0]:  # MOV B,lit
            lit = parse_lit(args[1], variables_data)
            return lit + MOV_DICT['variants']['bl']['signal'] + \
                MOV_DICT['operation_code']
        elif '(B)' not in args[0]:  # MOV B,(dir)
            memory_dir = args[1].strip('(').strip(')')
            lit = to_binary(variables_data[memory_dir]['dir_memory'], 16)
            return lit + MOV_DICT['variants']['bd']['signal'] + \
                MOV_DICT['operation_code']
        else:  # MOV (B), lit
            lit = parse_lit(args[1], variables_data)
            return lit + MOV_DICT['variants']['dbl']['signal'] + \
                MOV_DICT['operation_code']
    if args[1] == 'A': 
        if '(' in args[0]:  # MOV (dir),A
            lit = parse_dir(args[0], variables_data)
            return lit + MOV_DICT['variants']['da']['signal'] + \
                MOV_DICT['operation_code']
    if args[1] == 'B': 
        if '(' in args[0]:  # MOV (dir),B
            lit = parse_dir(args[0], variables_data)
            return lit + MOV_DICT['variants']['db']['signal'] + \
                MOV_DICT['operation_code']
