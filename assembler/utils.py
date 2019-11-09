from errors import NotNegative


def parser_number(number):
    if '-' in number:
        raise NotNegative
    if len(number) == 1 and number.isalpha():
        return 0
    if 'b' == number[-1]:
        return int(number.replace('b', ''), 2)
    elif 'd' == number[-1]:
        return int(number.replace('d', ''))
    elif 'h' == number[-1]:
        return int(number.replace('h', ''), 16)
    return int(number)


def to_binary(n, bits):
    """
    Extraída de https://stackoverflow.com/questions/12946116/twos-complement-binary-in-python
    """
    s = bin(parser_number(str(n).lower()) & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % bits).format(s)


def parse_lit(literal, variables_data):
    try: 
        lit = to_binary(literal, 16)
    except ValueError:
        lit = to_binary(variables_data[literal]['dir_memory'], 16)
    return lit
