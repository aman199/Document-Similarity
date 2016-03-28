import os
import math
import sys

k=(int)(sys.argv[2])
type_of_shingles=sys.argv[3]
alpha=(int)(sys.argv[4])
path={}
i=1

basepath=sys.argv[1]
for fname in os.listdir(basepath):
    path[i]=os.path.join(basepath,fname)
    i=i+1

shingle_dict={}
for item in path:
    f=open(path[item])
    shingles=[]
    if(type_of_shingles=="char"):

        str=f.read(k)
        shingles.append(str)
        while True:
            c=f.read(1)
            if not c:
                break
            str=str[1:]+c
            shingles.append(str)
        shingle_dict[item]=set(shingles)

    else:
        lines=f.readlines()
        words=lines[0].split()
        i=0
        while i<len(words)-(k-1):
            p=0
            str=""
            while p<k:
                str=str+words[i+p]
                p=p+1
            shingles.append(str)
            i=i+1
        shingle_dict[item]=set(shingles)

for item in shingle_dict:
    print("No of Shingles in File",path[item],":",len(shingle_dict[item]))

i=1
while i<=len(shingle_dict)-1:
    j=i+1
    while j<=len(shingle_dict):

            union=len(shingle_dict[i])+len(shingle_dict[j])
            sum=0
            for k in shingle_dict[i]:
                for l in shingle_dict[j]:
                    if k==l:
                        sum=sum+1

            print("Jaccard Similarity between",path[i],"and",path[j],":",(float)(sum/(union-sum)))
            j=j+1
    i=i+1

#Minhashing
#Input Matrix

tot_shingles=[]
for item in shingle_dict:
    tot_shingles.extend(shingle_dict[item])

unique_shingles=set(tot_shingles)
unique_shingles=sorted(unique_shingles)


dict_matrix={} #input Matrix
i=0

while i<len(unique_shingles):
    a=[]
    j=1
    while j<=len(shingle_dict):
        if unique_shingles[i] in shingle_dict[j]:
            a.append(1)
        else:
            a.append(0)
        j=j+1
    dict_matrix[i]=a
    i=i+1
#print(dict_matrix)

dic_hashs={}
i=1
while i<=alpha:
    a=[]
    for k in range(len(unique_shingles)):
        a.append(((i*k)+1)%(len(unique_shingles)))
    dic_hashs[i]=a
    i=i+1
#print(dic_hashs)

#Signature Matrix

sig_matrix={}
i=1
while i<=alpha:
    j=1
    a=[]
    while j<=len(shingle_dict):
        a.append(float('inf'))
        j=j+1
    sig_matrix[i]=a
    i=i+1



i=0
while i<len(unique_shingles):
    j=1
    while j<=len(shingle_dict):
        if dict_matrix[i][j-1]==1:
            k=1
            while k<=alpha:
                if dic_hashs[k][i]<sig_matrix[k][j-1]:
                    sig_matrix[k][j-1]=dic_hashs[k][i]
                k=k+1

        j=j+1
    i=i+1


print("")
print("Min-Hash Signature for the Documents")
sig_dict={}
j=1
while j<=len(path):
    a=[]
    i=1
    while i<=alpha:
        a.append(sig_matrix[i][j-1])
        i=i+1
    print(path[j],":",a)
    sig_dict[j]=a
    j=j+1

#print(sig_dict)
i=1
while i<=len(shingle_dict)-1:
    j=i+1
    while j<=len(shingle_dict):
            sum=0
            for k in range(alpha):
                if sig_dict[i][k]==sig_dict[j][k]:

                    sum=sum+1

            print("Jaccard Similarity between",path[i],"and",path[j],":",(sum/alpha))
            j=j+1
    i=i+1


print("")
print("Candidate pairs obtained using LSH")

factors = []
i = 2
while i < alpha:
    if (alpha % i) == 0:
        factors.append(i)
    i += 1


#print(factors)
b=alpha
r=1
s=(float)(sys.argv[5])
for i in reversed(factors):
    oldb=b
    oldr=r

    if(i>(alpha/i)):
        b=i
        r=alpha/i
    else:
        b=alpha/i
        r=i
    if (math.pow((1/b),(1/r)))>s:
        b=oldb
        r=oldr
        break
#print((int)(b)," ",(int)(r))
b=(int)(b)
r=(int)(r)

div_dict={}
i=1;
k=0
while i<=b:

    dict={}
    j=1
    while j<=len(path):
        a=[]
        for l in range(k,k+r):

            a.append(sig_dict[j][l])

        dict[j]=a
        j=j+1
    div_dict[i]=dict
    i=i+1
    k=k+r
#print(div_dict)
hashed={}
for i in div_dict:

    j=1
    a=[]
    while j<=len(path):
        sum=0
        k=0
        while k<len(div_dict[i][j]):

            sum=sum+div_dict[i][j][k]
            k=k+1
        a.append((int)(sum%(b-(r))))
        j=j+1
    hashed[i]=a
#print("'hashed")
#print(hashed)

candidates=[]
for i in hashed:
    j=0
    while j<(len(path)-1):
        k=j+1
        while k<len(path):
            if hashed[i][j]==hashed[i][k]:
                c=[]

                c.append(j+1)
                c.append(k+1)
                c.sort()
                if c not in candidates:
                    candidates.append(c)
            k=k+1

        j=j+1
candidates.sort()

for i in candidates:
    a=i[0]
    b=i[1]
    c=[]
    c.append(path[a])
    c.append(path[b])
    c=tuple(c)
    print(c)
