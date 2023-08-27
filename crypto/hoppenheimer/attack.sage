
import json
import numpy as np
from hashlib import sha256
from random import randrange
import os
import socket

# modify for netcat endpoint
nc_conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
nc_conn.connect(("64.227.131.98", 10002))

N = 1024
q = 12289
Zq = IntegerModRing(q)
R.<x> = PolynomialRing(Zq)
I = R.ideal(x^N + 1)
Rq = R.quotient_ring(I)
choicefill = nc_conn.recv(1024)
print(choicefill)
S = [0]*N

def hashit(x):
	s = ""
	for i in range(0, len(x), 8):
		o = "".join(str(g) for g in x[i:i + 8])
		s += chr(int(o, 2))
	return sha256(s.encode()).digest().hex()

class Node:
	def __init__(self, i, J, left, right, coeff):
		self.id = i
		self.left = left
		self.right = right
		self.J = J
		self.coeff = coeff

def query_oracle(a, l, k):
	U = Rq(a)*(Rq(x)^(-k))
	c = [0]*N
	for i in range(4):
		c[256*i] = int((l[i] + 4)%8)
	c = Rq(c)
	# return oracle(S, c, U, mue)
	# modify for netcat endpoint
	nc_conn.send("2\n".encode())
	(nc_conn.recv(1024))
	nc_conn.send((str(list(c))+"\n").encode())
	(nc_conn.recv(1024000))
	nc_conn.send((str(list(U))+"\n").encode())
	(nc_conn.recv(1024000))
	nc_conn.send((str(mue)+"\n").encode())
	# receive boolean value
	resp = nc_conn.recv(1024)
	(resp)
	resp = resp.decode().strip().split("\n")[0].strip()
	print(resp)
	return "-" if resp=="True" else "+"

def new_node(x):
	return Node(x[0], x[4:], x[1], x[2], x[3])

def create_tree(fname):
	f = json.loads(open(fname, 'r').read())

	all_nodes = []
	for x in f:
		all_nodes.append(new_node(x))
	for node in all_nodes:
		if node.left != None:
			node.left = all_nodes[node.left - 1]
		if node.right != None:
			node.right = all_nodes[node.right - 1]

	return all_nodes[-1]

def recover():
	global hypo, S
	hypo = True
	for k in range(256):
		print ("Recovering K -", k)
		if hypo == True:
			s, leftmost = T2(k)
			if hypo == False:
				s = T1(k)
		else:
			s = T1(k)
		print ("recovered:", s)
		for j in range(4):
			S[k + 256*j] = s[j]
	return Rq(S)

def T1(k):
	node = root_T1
	while node.left != None:
		a, l = node.coeff, node.J
		b = query_oracle(a, l, k)
		if b == "+":
			node = node.left
		else:
			node = node.right
	return node.J

def T2(k):
	global hypo
	node = root_T2
	leftmost = True
	while node.left != None:
		a, l = node.coeff, node.J
		b = query_oracle(a, l, k)
		if b == "+":
			node = node.left
		else:
			leftmost = False
			node = node.right

	if leftmost == True:
		a, l = extra
		b = query_oracle(a, l, k)
		if b == "+":
			hypo = False

	return node.J, leftmost

hypo = True
extra = (768, [0, 0, 0, -1])

root_T1 = create_tree("T1.txt")
root_T2 = create_tree("T2.txt")

vE = [1] + [0]*255
mue = hashit(vE)

recovered_S = recover()
print ("PRINTING RECOVERED S---------------\n",recovered_S,"FINISHED-------------------")
# send to server
nc_conn.send("3\n".encode())
nc_conn.recv(1024)
nc_conn.send((str(list(recovered_S))+"\n").encode())
# receive flag
flag = nc_conn.recv(1024).decode().strip()
print(flag)
# print (S == recovered_S)
