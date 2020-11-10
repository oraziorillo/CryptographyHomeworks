import binascii
from helpers import get_input_init_str


def my_gcd(a, b): 
    ''' Find the gcd of a and b (can be used to find the gcd of two polynomials over a ring)
    '''
    return a.monic() if b == 0 else my_gcd(b, a % b)


def find_related_message(delta, e, n, c1, c2):
    ''' Given that c1 and c2 are the ciphertext generated using an RSA encryption scheme with 
    public exponent e and modulo N, and that their respective plain messages are M1=f(M2) and M2,
    find the integer representation of M2
    
    Parameters
    ----------
    delta : integer
        coefficient with degree 0 of the linear monic polynomial f(x) = x + delta
    e : integer
        exponent of the RSA encryption scheme (must be 3 in order to be able to find M2)
    n : integer
        modulo of the RSA encryption scheme
    c1 : integer
        ciphertext obtained with the message M1
    c2 : integer 
        ciphertext obtained with the message M2
    
    Returns
    -------
    integer
        integer representation of M2
    '''

    P1.<x> = Zmod(n)[]
    f1 = x^e - c1
    f2 = (x + delta)^e - c2
    
    # Return the inverse of the term of degree 0
    return - my_gcd(f1, f2).coefficients()[0] 


def find_plain_msg(e, n, c1, c2):
    ''' Print the message M encrypted with 2 different paddings in c1 and c2 using RSA
    
    Parameters
    ----------
    e : integer
        exponent of the RSA encryption scheme (must be 3 in order to be able to find M)
    n : integer
        modulo of the RSA encryption scheme
    c1 : integer
        ciphertext obtained with the message M and padding r1
    c2 : integer 
        ciphertext obtained with the message M and padding r2
    '''
    
    Z_n = Zmod(n)
    P.<x, y> = PolynomialRing(Z_n)
    P2.<y> = PolynomialRing(Z_n)
    
    g1 = (P(x) ^ e - c1).change_ring(P2)
    g2 = ((P(x) + P(y)) ^ e - c2).change_ring(P2)
    
    # Find the resultant of g1 and g2
    res = g1.resultant(g2, x)
    univ_res = res.univariate_polynomial().change_ring(Z_n)
    
    # delta = r2 - r1 is a "small" root of the resultant polynomial
    # (the parameters of small_roots have been found empirically)
    delta = univ_res.small_roots(beta=1.0, epsilon=0.1)[0]
    
    # Find the message exploiting the knowledge of the difference between the paddings delta
    m2 = find_related_message(delta, e, n, c1, c2)
    
    # Test the possible values of m
    for m in range(2**Q3b_e):
        
        hex_msg = hex(Integer(m2 * pow(2, m)))
        
        # If hex_msg is a proper hexadecimal string, print it (it may be the correct message M)
        try:
            msg = binascii.unhexlify(hex_msg[2:]).decode('ascii', errors='ignore')
            print('\'' + msg + '\'\n')
            
        except:
            continue

# filename = "test_params/123-params.txt"
filename = "313423/313423-parameters.txt"

input_init_str = get_input_init_str(filename, ex=3)
exec(input_init_str)

print('The messages is:')
find_plain_msg(Q3b_e, Q3b_N, Q3b_c1, Q3b_c2)

