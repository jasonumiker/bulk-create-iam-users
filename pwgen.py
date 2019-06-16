#!/usr/bin/python
import string
import random

u = string.ascii_uppercase
l = string.ascii_lowercase
n = string.digits

psswrd = ""

for i in range(4):
	psswrd += random.choice(u)
	psswrd += random.choice(l)
	psswrd += random.choice(n)

psswrd += "$"
print (psswrd)
