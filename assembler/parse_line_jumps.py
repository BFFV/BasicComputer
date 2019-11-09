from read_asm import read_assembly


def get_line_jumps_info(path, variables_counter):
    jumps_data = {}
    file_ = read_assembly(path)
    is_code = False
    counter = variables_counter
    for line in file_:
        if ":" in line and line != "DATA:" and line != "CODE:":
            jumps_data[line.split(":")[0]] = {"number_line": counter}
        elif is_code and line:
            counter += 1
            if ('POP' in line) or ('RET' in line):
                counter += 1
        elif line == "CODE:":
            is_code = True
    return jumps_data
