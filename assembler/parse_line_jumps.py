from read_asm import read_assembly


def get_line_jumps_info(path, variables_counter):
    jumps_data = {}
    file_ = read_assembly(path)
    is_code = False
    counter = variables_counter
    for line in file_:
        if ":" in line and line != "DATA:" and line != "CODE:":
            jumps_data[line.split(":")[0]] = {"number_line": counter}
        if is_code == True:
            counter += 1
            if 'PUSH' or 'RET' in line:
                counter += 1
        if line == "CODE:":
            is_code = True
    return jumps_data
