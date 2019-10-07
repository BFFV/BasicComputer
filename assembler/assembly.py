from instructions import INSTRUCTIONS as I


def parse_instruction(instruction):
    pass

def get_literal(instruction):
    pass



def to_binary(n, bits):
    '''
    Extraida de https://stackoverflow.com/questions/12946116/twos-complement-binary-in-python
    '''
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)
