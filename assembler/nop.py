from instructions import INSTRUCTIONS as I


def parse_nop():
    return I['NOP']['lit'] + I['NOP']['lit'] + I['NOP']['operation_code']