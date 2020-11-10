def get_input_init_str(filename, ex):
    f = open(filename, "r")
    print('Reading: \'' + filename + '\'')
    next_line = f.readline()
    while (next_line != "###### Exercise " + str(ex) + "\n"):
        next_line = f.readline()

    input_str = ""
    next_line = f.readline()
    while (next_line != "###### Exercise " + str(ex + 1) + "\n" and next_line != ''):
        input_str += next_line
        next_line = f.readline()
        
    f.close()
    return input_str