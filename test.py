import math
def xor(a, b):
    return bytes([aa^bb for aa, bb in zip(a, b)])
 

def shiftright(a):
    leng = len(a)
    carry = 0
    res = []
    for i in range(leng):
        swap = a[i] % 2
        res.append(a[i] // 2 + carry * (pow(2, 7)))
        carry = swap
    return bytes(res)

def hashmul(x, y):
    z = b'\x00' * 16 
    v = y
    ele = b'\xe1' + b'\x00' * 15
    
    for i in x:
        num = i
        for j in range(8):
            div = pow(2, 7 - j)
            here = num // div
            num = num % div
            
            if here == 1:
                z = xor(z, v)
            if v[-1] % 2 == 0:
                v = shiftright(v)
            else:
                v = shiftright(v)
                v = xor(v, ele)
    return z

x = bytes.fromhex('f' * 32)
y = bytes.fromhex('f' * 32)

hashmul(x, y).hex()
