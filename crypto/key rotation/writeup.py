from secrets import token_urlsafe
from sage.all import ZZ, random_matrix, matrix
import sys 

ans = input("Do you want to rotate the flag? (y/n) ")
if ans.startswith("y"):
    print("Rotating flag...")
else:
    print("Not rotating flag...Bye")
    exit(0)

with open("flag.txt") as f:
    flag = f.read().strip()
    flag = flag[:-3] + token_urlsafe(16) + flag[-3:]
    flag = flag.encode()

# print to err
print("DEBUG", flag, file=sys.stderr)

# i have heard  it is a good practice to rotate keys
# since i am smart, i will rotate the flag in n-dimensional space

# generate an n-dimensional rotation matrix

rot_matrix = random_matrix(ZZ, nrows=len(flag), x=2432564235)
while rot_matrix.det() == 0:
    rot_matrix = random_matrix(ZZ, nrows=len(flag), x=2432564235)

# rotate the flag
flag = matrix(flag).T
flag = rot_matrix * flag

flag_out = flag*flag.T
print("Printing Rotation Matrix")
print(rot_matrix)

# Hahaha you can't get the rotated flag from just this
print("Printing Rotated Flag Matrix")
print(flag_out)

### SOLUTION
inverted_matrix = rot_matrix.inverse()
flag_out_diagonal = flag_out.diagonal()
# square root each diagonal element and store in vector
for i in range(len(flag_out_diagonal)):
    flag_out_diagonal[i] = flag_out_diagonal[i].sqrt()

flag_vec = matrix(flag_out_diagonal).T
ans = inverted_matrix * flag_vec
# convert answer to bytestring
print(ans)
for i in ans:
    print(chr(int(str(i)[1:-1])), end="")