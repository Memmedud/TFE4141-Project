### calculates R=A*B mod n
### 0 <= a, b, R <= n-
from ast import Mod


def check_bit_num(int_input, index):
    return int( int_input & (1 << index) != 0)


def check_bit(input, bitNum):
    return input & (1<<(bitNum))
    
temp = True
def ModMul(A, B, n, temp):
    R = 0
    # Convert B to a binary list
    B = [1 if digit=='1' else 0 for digit in bin(B)[2:]]
    for bi in B:
        R = (R << 1)
        if (bi): # bi is either 1 or 0
            print("bi = 1")
            R += A
        if R >= n:
            print("R-n")
            R -= n
        if R >= n:
            print("R-n")
            R -= n
        if (temp):
            print(hex(R))
    if temp:
        print("Done with ModMul")
    return R

def RSA(M, e, n):
    print(hex(M))
    temp = False
    C = 1
    P = M
    for i in range(0, e.bit_length()):
        if (check_bit_num(e,i) == 1):
            C = ModMul(P, C, n, temp)
        temp = True
        P = ModMul(P, P, n, temp)
        temp = False
        print(hex(C))
    print("Result: ")
    return C

#a = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#b = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
n = 0x99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d
##print(hex(n)[::-1])
#print(hex(n))
#print(hex(n-2*n))
#print(hex(-2*n))

M = 0x85ee722363960779206a2b37cc8b64b5fc12a934473fa0204bbaaf714bc90c01
#expected = 0x7637EA28188632D8F2D92845DB649D14
#n =0x819DC6B2574E12C3C8BC49CDD79555FD
e = 0x0000000000000000000000000000000000000000000000000000000000010001
d = 0x0cea1651ef44be1f1f1476b7539bed10d73e3aac782bd9999a1e5a790932bfe9

#print(hex(a*b%n))
#print(hex(ModMul(a, b, n)))
#msg = RSA(M,e,n)
#print(hex(msg))
#print(hex(RSA(msg,d,n)))
#print(hex(RSA(RSA(M, e, n), d, n)))

print(hex(ModMul(M, M, n, True)))
print(hex(+M+(-2*n)))
print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M))
print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M-n))
print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M-2*n))