def read_assembly(path):
    '''
    Este funcion lee línea por linea los
    archivos y omite los comentarios
    '''
    with open(path, 'r',encoding='utf-8') as file:
        for i in file:
            line = i.strip().replace('\t', ' ')
            parsed_line = delete_white_spaces(delete_comments(line))
            if parsed_line:
                yield parsed_line

def delete_comments(line):
    return line.split('//')[0]

def delete_white_spaces(line):
    separated_by_spaces = line.split(' ')
    final_line = []
    for i in separated_by_spaces:
        if i != '':
            final_line.append(i)
    if not final_line:
        return ''
    elif len(final_line) == 1:
        return final_line[0]
    return final_line[0] + ' ' + ''.join(final_line[1:])




