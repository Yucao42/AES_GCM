import pyaes
import os
import math
from datetime import datetime as dt

class AES_GCM_128:
    
    def __init__(self, i_key):
        assert len(i_key) == 16, 'This class supports 128-bit key only!'
        self.i_key = i_key
        
        # Plain text and aad size
        self.plt_size = 0
        self.aad_size = 0

        # Cypher text and tag	
        self.C = 0
        self.T = 0
            
    def sendeth(self, payload, interface = "eth2"):
        cmd = 'python trans.py {}'.format(self.process_payload(payload))
        return os.system(cmd)

    def update_i_key(self, new_key):
        self.i_key = new_key
        
    @property
    def aes(self):
        return pyaes.AESModeOfOperationECB(self.i_key)
        
    @property
    def H(self):
        return self.aes.encrypt(bytes.fromhex("00"* 16))
         
    @staticmethod
    def xor(a, b):
        return bytes([aa^bb for aa, bb in zip(a, b)])

    def gctr(self, iv, x, phase='encrypt'):
        cb = []
        offset = 2 if phase == 'encrypt' else 1
        for i in range(len(x)// 16 + 5):
            cb.append(iv + b'\x00' * 3 + bytes([i]))
        if x == "":
            return ''
        y = []
        n = math.ceil(len(x) / 16)
        for j in range(n):
            cb_ = cb[j + offset]
            ciphed = self.aes.encrypt(cb_)
            y.append(self.xor(x[j* 16 : j* 16 + 16], ciphed))
        return y
    
    @staticmethod
    def process_payload(p):
        leng = len(p)
        payload = p
        print(leng)
        if leng % 32 != 0:
            payload = p + '0' * ( 32 - leng % 32)
        return payload

    @staticmethod
    def shiftright(a):
        leng = len(a)
        carry = 0
        res = []
        for i in range(leng):
            swap = a[i] % 2
            res.append(a[i] // 2 + carry * (pow(2, 7)))
            carry = swap
        return bytes(res)
    
    def hashmul(self, x, y):
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
                    z = self.xor(z, v)
                if v[-1] % 2 == 0:
                    v = self.shiftright(v)
                else:
                    v = self.shiftright(v)
                    v = self.xor(v, ele)
        return z

    def cal_size(self, aad, pt):
        self.aad_size = (len(aad) * 8).to_bytes(8, 'big')
        self.plt_size = (len(pt) * 8).to_bytes(8, 'big')
        
    def encrypt(self, iv, aad, pt, prt = True):
        # Encrypt the text
        self.cal_size(aad, pt)
        j0 = iv + b'00' * 3 + b'01'
        yy = self.gctr(iv, pt)
        C= b''
        for y in yy:
            C = C+ y  
        
        # Generate the tag
        y1 = b'\x00' * 16
        xx = aad + C + self.aad_size + self.plt_size
        for i in range(len(xx) // 16):
            y1 = self.hashmul(self.xor(xx[i * 16:i * 16 +16], y1), self.H)
        S = y1
        t = self.gctr(iv, S, 'tag')
        T = t[0]
        self.C = C
        self.T = T

        if prt:
            print('\nC is\t\t')
            for i in range(len(pt) // 16):
                print('\t\t', C[i * 16:i * 16 +16].hex())
            print('\nTag is\n','\t\t',T.hex())
       
        
if __name__ == '__main__':
    key = bytes.fromhex('00' * 16)
    iv = bytes.fromhex('00' * 12)
    gcm_aes = AES_GCM_128(key)
    pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A 86A7A953 1534F7DA 2E4C303D 8A318A72 1C3C0C95 95680953 2FCF0E24 49A6B525 B16AEDF5 AA0DE657 BA637B39 1AAFD255')
    pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A' * 4)
    pt = bytes.fromhex('62626262 62626262 62626262 62626262' )
    pt = bytes.fromhex('21000000 00000000 00000000 00000000' )
    pt = bytes.fromhex('21220102 12341234 2298abde 2fee2122'  )
    pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A 00000000 00000000 00000000 00000f0f' * 3)
    pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A 00000000 00000000 00000000 00000000' * 3)
    pt_str = '22220102123412342298abde2fee2122' * 12
    pt_str = '222201021234123123adf2934283242342ecdeda1238123ad140efacbcba9123123881ade'
    pt_str = '12345231223411abfcdeabd78111111111111111111111111110000000000000000000000000123dec'
    pt_str = 'Hey there, it is Yu. Nice to meet you world. The network class is awesome! New York has a great sunny day today.'.encode().hex()
    pt_str = 'Do you think we are gonna pass this course? New York has a great sunny day today.'.encode().hex()
    pt_hex = bytes.fromhex(gcm_aes.process_payload(pt_str))
    pt = pt_hex

    #pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A' * 4)
    #pt = bytes.fromhex('D9313225 F88406E5 A55909C5 AFF5269A' )
    #aad = bytes.fromhex('3AD77BB4 0D7A3660 A89ECAF3 2466EF97 F5D3D585 03B9699D E785895A 96FDBAAF 43B1CD7F 598ECE23 881B00E3 ED030688 7B0C785E 27E8AD3F 82232071 04725DD4')

    #pt = bytes.fromhex('00' * 16)
    print(pt)
    aad = bytes.fromhex('00' * 16)
    aad = bytes.fromhex('')
    print('\nPlaintext is\t\t')
    for i in range(len(pt) // 16):
        print('\t\t', pt[i * 16:i * 16 +16].hex())
    gcm_aes.encrypt(iv, aad, pt)
    print(dt.now())
    gcm_aes.sendeth(pt_str)
    #print( C.hex(), T.hex())
