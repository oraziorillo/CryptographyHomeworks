import hashlib
from helpers import get_input_init_str


def find_common_factors(N, N_i_list):
    ''' Find common factor between N and any element in N_i_list
    
    Parameters
    ----------
    N : int
        integer to find a factor of
    N_i_list : list
        list of numbers that can have a common factor with N
        
    Returns
    -------
    list
        list of found factors of N
    '''
    
    factors = []
    for ni in N_i_list:
        div = gcd(N, ni)
        if div > 1:
            factors.append(div)
    return factors


def phi(N):
    ''' This function computes phi(N) where N is the product of 3 prime numbers: p, q and r.
    
    Parameters
    ----------
    N : list
        list of the three prime factors of N
        
    Returns
    -------
    int
        phi(N)
    '''
    return (N[0]-1)*(N[1]-1)*(N[2]-1)


filename = "313423/313423-parameters.txt"

# Initialize problem parameters
input_init_str = get_input_init_str(filename, ex=1)
exec(input_init_str)
tmp = Q1_N # product of the still unknown factors of N

# Initialize the list of the factors of n with the factors in common with the 
# other pseudo-randomly generated moduli exploiting the low entropy of the seed
N_factorized = find_common_factors(Q1_N, Q1_L_mod)
for f in N_factorized:
    tmp /= f 
    
# Try to find faulted decrypted ciphertext i.e a pair (pt, dec_ct) 
# in which the plaintext pt is different from the decrypted ciphertext dec_ct
faulted_pairs = list(filter(lambda x: x[0] != x[1], Q1_L_x))

for fp in faulted_pairs:
    
    correct_pt = fp[0]
    wrong_pt = fp[1]

    # For each faulted pair use try to find a divisor in common between tmp and the difference 
    # of the correct plaintext and the faulted decryption 
    f = gcd(correct_pt - wrong_pt, tmp)
    if f != 1:
        N_factorized.append(f)
        tmp /= f

# Append the product of the remaining factors
# Note that if all of them have been found already then tmp will just be the last factor
N_factorized.append(tmp)

# Assert that the product of the found factors is N
assert N_factorized[0]*N_factorized[1]*N_factorized[2] == Q1_N

# To decrypt the plaintext once N is factorized, 
# first we recover the secret key for the RSA encryption algorithm (d)
sk = inverse_mod(Q1_e, phi(N_factorized))
# Then we use it to decrypt the text encrypted with RSA
x = power_mod(Q1_ct_RSA, sk, Q1_N)
# We generate the key used for encrypting the password with an hash function 
key = hashlib.sha512(str(x).encode('ascii')).digest()
# Finally, we decrypt the password by inverting the xor operation
pt = ''
for (a, b) in zip(key, Q1_ct_pwd):
    pt += chr(a ^^ b)

print('The password is: \'' + pt + '\'')
