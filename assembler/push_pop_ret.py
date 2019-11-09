from instructions import INSTRUCTIONS as I


def parse_push_pop_ret(instruction):
    inst = instruction.split(' ')
    if inst[0] == 'POP':
        return parse_pop(inst[0], inst[1].strip(' '))
    elif inst[0] == 'RET':
        return parse_ret(inst[0])
    return parse_push(inst[0], inst[1].strip(' ')) 


def parse_pop(op, op_args):
    if op_args == 'A':  # A
        return (I[op]['variants']['a1']['lit'] +
                I[op]['variants']['a1']['signal'] +
                I[op]['operation_code'] + '\",\n' + '       \"' + 
                I[op]['variants']['a2']['lit'] +
                I[op]['variants']['a2']['signal'] + I[op]['operation_code'])
    if op_args == 'B':  # B
        return (I[op]['variants']['b1']['lit'] +
                I[op]['variants']['b1']['signal'] + I[op]['operation_code']
                + '\",\n' + '       \"' + I[op]['variants']['b2']['lit'] +
                I[op]['variants']['b2']['signal'] + I[op]['operation_code'])


def parse_push(op, op_args):
    if op_args == 'A':  # A
        return I[op]['variants']['a']['lit'] + \
               I[op]['variants']['a']['signal'] + I[op]['operation_code']
    if op_args == 'B':  # B
        return I[op]['variants']['b']['lit'] + \
               I[op]['variants']['b']['signal'] + I[op]['operation_code']


def parse_ret(op):
    return (I[op]['variants']['1']['lit'] + I[op]['variants']['1']['signal'] +
            I[op]['operation_code'] + '\",\n' + '       \"' +
            I[op]['variants']['2']['lit'] + I[op]['variants']['2']['signal'] +
            I[op]['operation_code'])
