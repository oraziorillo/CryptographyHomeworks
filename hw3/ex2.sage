import numpy as np
from itertools import combinations
from helpers import get_input_init_str

filename = "313423/313423-parameters.txt"

# Initialize problem parameters
input_init_str = get_input_init_str(filename, ex=2)
exec(input_init_str)

exponent_reps = {} # number of times each exponent has been used

# Count the number of times each exponent has been used
for mod, exp in Q2_G:
    
    # Increase the corrispondent entry of the dictionary
    if exp not in exponent_reps.keys():
        exponent_reps[exp] = 1
    else:
        exponent_reps[exp] += 1

# Store exponents and respective repetitions in two lists
exponents = []
repetitions = []
for key, val in exponent_reps.items():
    exponents.append(key)
    repetitions.append(val)

most_pop_exp = exponents[np.argmax(repetitions)] # most used exponent

# Store all the residues obtained taking the power of M to the most popular exponent
# and the moduli
residues = []
moduli = []
for idx, (mod, exp) in enumerate(Q2_G):
    if exp == most_pop_exp:
        residues.append(Q2_ciphertexts[idx])
        moduli.append(mod)

# Solve the system with the Chinese Remainder Theorem and then take the e-th root of the solution 
# where e is the most popular exponent
msg = crt(residues, moduli) ** (1/most_pop_exp)

print('The message is: ' + str(msg))

