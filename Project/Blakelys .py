### calculates R=A*B mod n
### 0 <= a, b, R <= n-1
def ModMul(A, B, n):
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
    return R

def RSA(M, e, n):
    C = 1
    P = M
    for i in range(0, bits):
        if ((e >> i) & 0x1):
            C = ModMul(C, P, n)
        P = ModMul(P, P, n)
    return C

bits = 128

#a = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#b = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
n = 0x819DC6B2574E12C3C8BC49CDD79555FD

M = 0x0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
#expected = 0x7637EA28188632D8F2D92845DB649D14
#n =0x819DC6B2574E12C3C8BC49CDD79555FD
e = 0x00000000000000000000000000010001
d = 0x00000000000000000000000000010001

#print(hex(a*b%n))
#print(hex(ModMul(a, b, n)))
print(hex(RSA(RSA(M, e, n), d, n)))