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
            R += A
        if R >= n:
            R -= n
        if R >= n:
            R -= n
    if temp:
        print("Done with ModMul")
    return R

def RSA(M, e, n):
    temp = False
    C = 1
    P = M
    for i in range(0, e.bit_length()):
        if (check_bit_num(e,i) == 1):
            print("e[i] = 1")
            C = ModMul(P, C, n, temp)
        temp = False
        P = ModMul(P, P, n, temp)
        temp = False
        print("C: ", hex(C))
        print("P: ", hex(P))
    print("Result: ")
    return C

#a = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#b = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
n = 0x99925173ad65686715385ea800cd28120288fc70a9bc98dd4c90d676f8ff768d
##print(hex(n)[::-1])
#print(hex(n))
#print(hex(n-2*n))
#print(hex(-2*n))

M = 0x0a23232323232323232323232323232323232323232323232323232323232323
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

print(hex(RSA(M, e, n)))
#print(hex(+M+(-2*n)))
#print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M))
#print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M-n))
#print(hex(((0x9278ff566b3a2a55f2c5e4f4be4b4275a035c6e0d5663ec7d850130a1797bae7)<<1)+M-2*n))

#print(0x724a92d319c6a68b2b9bf7c79849a159f59c5660e4c2a7634ae4886b9e92a175 == 0x724a92d319c6a68b2b9bf7c79849a159f59c55f7e4c2a7634ae4886b9e92a175)
#print(hex(0x724a92d319c6a68b2b9bf7c79849a159f59c5660e4c2a7634ae4886b9e92a175 - 0x724a92d319c6a68b2b9bf7c79849a159f59c55f7e4c2a7634ae4886b9e92a175))
#print(hex(0x724a92d319c6a68b2b9bf7c79849a159f59c5660e4c2a7634ae4886b9e92a175 - 0x724a92d319c6a68b2b9bf7c79849a159f59c55f7e4c2a7634ae4886b9e92a175))
#print(hex(0x83173a13b9932de993a54af19b75b97b9b5212947c71792198729f58632c1543 - 0x83173a13b9932de993a54af19b75b97b9b51b36c7c71792198729f58632c1543))

#print(hex((0x10bdce446c72c0ef240d4566f9916c96bf82552688e7f404097755ee297921802 - n) - 0x0724a92d319c6a68b2b9bf7c79849a159f59c5660e4c2a7634ae4886b9e92a175))
#print(hex(M<<1))

#99925173ad65686715385ea800cd28120288fc07a9bc98dd4c90d676f8ff768d

#M in vivado: 1a77e44c6c960ee940654dce331d62daf38459c22ecf50402dd55fe82d390308
#n in vivado: 9994a8ec5b6a616e8ac1a751003b41840411f3e059d391bb2390b6e6f1ffe61b
