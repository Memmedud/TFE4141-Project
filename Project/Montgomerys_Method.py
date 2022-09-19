import math

#e = 14503
#p = 39989
#q = 91423

e = 5
p = 7
q = 17

n = p*q
tot = (p-1)*(q-1)
d = int(((tot*(e-1))+1)/e)

print((d*e)%tot)
print(d)
print(n)
print(tot)

def bitfield(n):   # converts int to list of bits
    return [1 if digit=='1' else 0 for digit in bin(n)[2:]]

# calculates R=A*B mod n
def ModMul(A, B, n):
    R = 0
    Blist = bitfield(B)
    print(Blist)
    k = len(Blist)
    for i in range(0, k-1):
        R = 2*R + A*(Blist[k-1-i])
        if R >= n:
            R -= n
        if R >= n:
            R -= n
    return R

M = 77

#C = 1
#P = M

#elist = bitfield(e)
#for i in range(0, k-1):
#    if elist[i]:
#        C = ModMul(P, 1, n, k)
#    P = P*P

C = ModMul(ModMul(M, e, n), d, n)

#cipher = RSA(A, B, N, k)
print(C)