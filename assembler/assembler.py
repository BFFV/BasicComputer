from parse_variables import get_variables_instructions
from parse_line_jumps import get_line_jumps_info
from parser_file import parse
from read_asm import read_assembly
from errors import NotNegative
import sys


def parse_file(path):
    dv = {}
    get_variables_instructions(dv, 0, path)
    jumps_dir = get_line_jumps_info(path, 2 * len(dv))
    instr = []
    founded = False
    for i in dv:
        for j in dv[i]['instructions']:
            instr.append((parse(j, dv, jumps_dir),
                          f'{i} = {dv[i]["value"]}'))
    counter = 1
    data_variables = {i: dv[i] for i in filter(
        lambda x: not x.isdigit(), dv.keys())}
    for i in read_assembly(path):
        if founded and ':' not in i:
            try:
                instr.append((parse(i, data_variables, jumps_dir), i))
                counter += 1
            except NotNegative:
                print(f'Error en CODE: Instruccion numero {counter}: '
                      f'{i} => No se permiten numeros negativos!')
                exit()
        elif i == 'CODE:':
            founded = True
    return instr


def write_file(instr, name):
    header = 'library IEEE;\nuse IEEE.STD_LOGIC_1164.ALL;\nuse ' \
             'IEEE.STD_LOGIC_UNSIGNED.ALL;\nUSE IEEE.NUMERIC_STD.ALL;\n\n'
    component = 'entity ROM is\n    Port (\n        address : in ' \
                'std_logic_vector (11 downto 0);\n        dataout : out ' \
                'std_logic_vector (35 downto 0)\n          );\nend ROM;\n\n'
    behavioral = 'architecture Behavioral of ROM is\n\ntype memory_array is ' \
                 'array (0 to ((2 ** 12) - 1) ) of std_logic_vector ' \
                 '(35 downto 0);\n'
    array = '\nsignal memory : memory_array:= (\n'
    end = '       );\nbegin\n\n    ' \
          'dataout <= memory(to_integer(unsigned(address)));\n\nend Behavioral;'
    with open(name + '.vhd', 'w', encoding='utf8') as file:
        file.write(header)
        file.write(component)
        file.write(behavioral)
        file.write(array)
        total = (2 ** 12)
        for i in instr:
            if (len(instr) >= total) and (i == instr[-1]):
                file.write(f'       "{i[0]}"  -- {i[1]} \n')
            else:
                file.write(f'       "{i[0]}", -- {i[1]} \n')
        empty = '0' * 36
        for i in range(total - len(instr)):
            if i == (total - len(instr) - 1):
                file.write(f'       "{empty}"  -- empty\n')
            else:
                file.write(f'       "{empty}", -- empty\n')
        file.write(end)


path_name = sys.argv[1]
inst = parse_file(path_name)
write_file(inst, 'ROM')
