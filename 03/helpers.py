def get_input_init_str(filename, ex_number):
    f = open(filename, "r")
    next_line = f.readline()
    while (next_line != "###### Exercise " + str(ex_number) + "\n"):
        next_line = f.readline()

    input_str = ""
    next_line = f.readline()
    while (next_line != "###### Exercise " + str(ex_number + 1) + "\n" and next_line != ''):
        input_str += next_line
        next_line = f.readline()
        
    f.close()
    return input_str