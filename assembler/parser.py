from add_sub_logical import parse_add_sub_logical
from cmp_ import parse_cmp
from jumps import parse_jumps
from nop import parse_nop
from shifts_not import parse_not_shifts
from mov import parse_mov
from inc_dec import parse_inc_dec
from push_pop_ret import parse_push_pop_ret


SHIFTS_NOT = {'SHR', 'SHL', 'NOT'}
ADD_SUB_LOGICAL = {'ADD', 'SUB', 'AND', 'OR', 'XOR'}
INC_DEC = {'INC', 'DEC'}
JUMPS = {'CALL','JMP', 'JEQ', 'JNE', 'JGE', 'JGT', 'JLT', 'JLE', 'JCR'}
PP = {'PUSH', 'POP', 'RET'}


def parse(line, variable_data, line_data):
    instruction = line.split(' ')[0]
    if instruction in ADD_SUB_LOGICAL:
        return parse_add_sub_logical(line, variable_data)
    elif instruction in SHIFTS_NOT:
        return parse_not_shifts(line, variable_data)
    elif instruction in INC_DEC:
        return parse_inc_dec(line, variable_data)
    elif instruction in JUMPS:
        return parse_jumps(line, line_data)
    elif instruction in PP:
        return parse_push_pop_ret(line)
    elif instruction == 'MOV':
        return parse_mov(line, variable_data)
    elif instruction == 'CMP':
        return parse_cmp(line, variable_data)
    elif instruction == 'NOP':
        return parse_nop()
