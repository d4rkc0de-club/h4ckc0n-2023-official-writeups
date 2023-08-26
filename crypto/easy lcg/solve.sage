from Crypto.Util.number import *
import itertools
import random
from Crypto.Util.Padding import pad , unpad
from Crypto.Cipher import AES
import os
def small_roots(f, bounds, m=1, d=None):
	if not d:
		d = f.degree()

	R = f.base_ring()
	N = R.cardinality()
	
	f /= f.coefficients().pop(0)
	f = f.change_ring(ZZ)

	G = Sequence([], f.parent())
	for i in range(m+1):
		base = N^(m-i) * f^i
		for shifts in itertools.product(range(d), repeat=f.nvariables()):
			g = base * prod(map(power, f.variables(), shifts))
			G.append(g)

	B, monomials = G.coefficient_matrix()
	monomials = vector(monomials)

	factors = [monomial(*bounds) for monomial in monomials]
	for i, factor in enumerate(factors):
		B.rescale_col(i, factor)

	B = B.dense_matrix().LLL()

	B = B.change_ring(QQ)
	for i, factor in enumerate(factors):
		B.rescale_col(i, 1/factor)

	H = Sequence([], f.parent().change_ring(QQ))
	for h in filter(None, B*monomials):
		H.append(h)
		I = H.ideal()
		if I.dimension() == -1:
			H.pop()
		elif I.dimension() == 0:
			roots = []
			for root in I.variety(ring=ZZ):
				root = tuple(R(root[var]) for var in f.variables())
				roots.append(root)
			return roots

	return []
def sum_x_y(w , z , t1 , t2 , n):
    P.<l>  = PolynomialRing(Zmod(n))
    f1 = (l + w)**102103 - t1 
    f2 = (l + z)**102103 - t2 
    g = gcd(f1 , f2)
    # return g
    return -int(g - l) % n
def a_b(sumw_x_y , sumx_y_z , modulus , a_leak , b_leak):
	P = PolynomialRing(Zmod(modulus), 2, 'xy')
	x , y = P.gens()
	f = ((a_leak) + x)*sumw_x_y + 3*(y +b_leak) - sumx_y_z 
	bounds = [2**138  , 2**132]
	res = small_roots(f , bounds , m = 2 , d =2 )
	a = a_leak + res[0][0]
	b = b_leak + res[0][1]
	return a , b

def solve():
	m =951831591126891226445616798859389634962506017435096204719527931037946751257386453
	w = 892538103095568571308055622527208537431386152119518651952902989508686849091191281
	z = -714614918124329204350158811799498833705782570226423726741176753053847594939138734 + w 
	t1 = 206209337084780433554785624204678129009126962593480063483551864579549057461933023
	t2 = 680739366199821941622286592665146415124500895349766350117022823852133107112874105
	a_leak = 25945561456487621837945697418527732002286927586820719714556024559957551611904
	b_leak = 35870844893076921936763915544352090373080963605393919941561612131892308475904
	sum_xy = sum_x_y(w , z , t1 , t2 , m )
	a_recovered , b_recovered = a_b(w + sum_xy , sum_xy + z , m , a_leak , b_leak)
	next_lcg = (a_recovered*z + b_recovered) %m
	print(next_lcg)
	ct = "929b4bf36c878d7dc87bd4159ab1e3febf678281f31ca328778af7e9eec6ec43b17323321c703842355ef33bf6a3cd0ef61d57e2a0f2a56b6a1536236182a7f6 "
	iv = "af49f69666194ebea4ba5eb8f3d678e0"
	key = long_to_bytes(int(next_lcg))[:32]
	cipher =AES.new(key , AES.MODE_CBC , bytes.fromhex(iv))
	print(unpad(cipher.decrypt(bytes.fromhex(ct)), 32))
solve()