from parse_variables import get_variables_instructions
from parse_line_jumps import get_line_jumps_info
from parser import parse
from read_asm import read_assembly
import sys

def parse_file(path):
    data_variables = {}
    get_variables_instructions(data_variables, 0, path)
    JUMPS_DIR = get_line_jumps_info(path, 2 * len(data_variables))
    instr = []
    founded = False
    for i in data_variables:
        for j in data_variables[i]['instrucctions']:
            instr.append((parse(j, data_variables, JUMPS_DIR), f'{i} = {data_variables[i]["value"]}'))
    for i in read_assembly(path):
        if founded and ':' not in i:
            instr.append((parse(i, data_variables, JUMPS_DIR), i))
        elif i == 'CODE:':
            founded = True
    return instr

def write_file(instr, name):
    header = 'library IEEE;\nuse IEEE.STD LOGIC 1164.ALL;\nuse IEEE.STD LOGIC UNSIGNED.ALL;\nUSE IEEE.NUMERIC STD.ALL;\n'
    component = 'entity ROM is\n   Port (\n      address : in std logic vector (11 downto 0);\n      dataout : out std logic vector (35 downto 0)\n     );\nend ROM;\n'
    behavioral = 'architecture Behavioral of ROM is\n    type memory array is array (0 to ((2 ∗∗ 12) − 1) ) of std logic vector (35 downto 0);\n'
    array = '    signal memory : memory array:= (\n'
    end = '    );\nbegin\n\n    dataout <= memory(to integer(unsigned(address)));\nend Behavioral;'
    with open(name + '.vhd','w', encoding='utf8') as file:
        file.write(header)
        file.write(component)
        file.write(behavioral)
        file.write(array)
        counter = 0
        total = (2 ** 12)
        for i in instr:
            file.write(f'    \'{i[0]}\' -- {i[1]} \n')
            counter += 1
        empity = '0' * 36
        for i in range(total - counter):
            file.write(f'    \'{empity}\' -- empty\n')
        file.write(end)




path_name = sys.argv[1]
inst = parse_file(path_name)
write_file(inst, 'ROM')
