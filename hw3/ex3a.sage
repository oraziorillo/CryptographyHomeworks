import binascii
from helpers import get_input_init_str


def cont_frac(num, den, i = None):
    ''' Function that returns the unique finite sequence [a0, a1, ..., ak] of the terms of the
    continuous fraction of the rational number num/den
    
    Parameters
    ----------
    num : integer
        numerator of the rational number given as input
    den : integer
        denominator of the rational numbert given as input
    i : integer
        required to be non negative; if specified, returns the i-th convergent of num/den; 
        for any i<k the returned list will be of the type [a0, a1, ..., ai]
    '''
    a = num//den
    seq = [a]
    
    if num%den == 0 or i == 0:
        return seq
    
    num -= a*den
    
    if i == None:
        seq += cont_frac(den, num)
    else:
        seq += cont_frac(den, num, i - 1)
                         
    return seq


def sequence_to_frac(seq):
    ''' Given the unique sequence [a0, a1, ..., ak] of the terms of the continuous fraction 
    (or i-th convergent) of a rational number, returns the numerator and denominator of the
    fraction that corresponds to that sequence
    
    Parameters
    ----------
    seq : list
        terms of the continuous fraction (or i-th convergent) of the number
        
    Returns
    -------
    integer, integer
        numerator and denominator of the corresponding rational number
    '''
    
    # Base case: if the lenght is 1, then the continuos fraction contains just the numerator 
    # of the number itself
    if len(seq) == 1:
        return (seq[0], 1)
    
    # Iterative step: the rational number is composed by the first term in the sequence plus
    # the reciprocal of the rational number represented by the remaining subsequence
    num_a_succ, den_a_succ = sequence_to_frac(seq[1:])
    n = seq[0] + den_a_succ/num_a_succ
    return n.numerator(), n.denominator()


def floor_sqrt(x) : 
    ''' Function that computes the square root of a number (rounded to its floor)
    
    Parameters
    ----------
    x : int
        radicand
        
    Returns
    -------
    integer
        floor of the square root of x
    '''
    # Base cases 
    if (x == 0 or x == 1) : 
        return x 
   
    lower = 10**(len(str(x))//2 - 1) 
    upper = 10**(len(str(x))//2 + 1)
    
    while (lower <= upper) : 
        mid = (lower + upper) // 2
          
        # If x is a perfect square 
        if (mid*mid == x) : 
            return mid 
              
        # Since we need floor, we update  
        # answer when mid*mid is smaller 
        # than x, and move closer to sqrt(x) 
        if (mid * mid < x) : 
            lower = mid + 1
            ans = mid 
              
        else : 
              
            # If mid*mid is greater than x 
            upper = mid-1
              
    return ans 


def find_factors(n, phi_n):
    ''' Given n=pq with p and q primes and phi(n) (Euler's phi of n) retrieve p and q
    
    Parameters
    ----------
    n : integer
        product of two prime numbers
    phi_n : integer
        Euler's phi of n
    
    Returns
    -------
    p, q
        prime factors of n
    None 
        if no prime factor has been found
    
    '''
    
    # phi(n) = (p-1)(q-1) = pq-p-q+1 = n-p-q+1 => p+q = n-phi(n)+1
    sum_p_q = n - phi_n + 1
    
    if sum_p_q < 0:
        return None
    
    # Binary search of the factors (assuming that q < p < 2q)
    lower = floor_sqrt(n)
    upper = floor_sqrt(2 * n)
    
    while(lower <= upper):
        
        # Take the middle point
        q = (upper + lower) // 2
        p = sum_p_q - q
        
        if p * q == n:
            # Found them!
            return p, q
        elif p * q > n: 
            # To make the product smaller we want to increase the difference between p and q
            if q < p:
                upper = q - 1
            else:
                lower = q + 1
        elif p * q < n:
            # To make the product bigger we want to decrease the difference between p and q
            if q < p:
                lower = q + 1
            else:
                upper = q - 1
    return None


filename = "313423/313423-parameters.txt"

input_init_str = get_input_init_str(filename, ex=3)
exec(input_init_str)

# Find the continued fraction expansion of e/N
seq = cont_frac(Q3a_e, Q3a_N)

for i in range(len(seq) - 1):
    # Take the ith convergent
    ith_conv = seq[:i+1]
    # Recover the numerator and the denominator of the ith convergent
    hi, ki = sequence_to_frac(ith_conv)
    # If the numerator is non-zero (in that case we cannot compute phi)
    if hi != 0:
        # Compute phi(N)
        candidate_phi_n = (ki * Q3a_e - 1) // hi
        # Factorize N knowing phi(N)
        factors = find_factors(Q3a_N, candidate_phi_n)
        # If the candidate phi(N) was the correct one we should get the two factors (p and q) of N
        if factors != None:
            p, q = factors
            break

# Assert that the product of the found factors is exactly N and then print them
assert p * q == Q3a_N

print('The factors of N are:\n p =', p, '\n q =', q)
