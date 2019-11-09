from instructions import INSTRUCTIONS as I
from utils import to_binary


def parse_jumps(instruction, line_data):
    inst = instruction.split(' ')
    return parse_jump(inst[0], inst[1].strip(' '), line_data)   


def parse_jump(op, op_args, line_data):
    lit = to_binary(line_data[op_args]['number_line'], 16)
    return lit + I[op]['variants']['i']['signal'] + I[op]['operation_code']
