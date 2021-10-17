def bits_to_characters(bitstring):
    '''Converts bitstring to string of characters'''
    byts=bytes(int(bitstring[i : i + 8], 2) for i in range(0, len(bitstring), 8))
    message=byts.decode('ascii')
    return message
    
    
def xor(a, b):
    '''xor between two character bits'''
    if (a != '0' and a != '1') or (b != '0' and b != '1'):
        print(type(a), type(b))
        raise Exception('Invalid arguments')
        
    if(a != b):
        return '1'
    else:
        return '0'
    


