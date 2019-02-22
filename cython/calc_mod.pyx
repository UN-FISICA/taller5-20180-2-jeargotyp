from scipy.misc import imread
from numpy.linalg import inv,lstsq
import numpy as np

def mean(L):
    m=sum(L)/len(L)
    return m

def calc(image,dx,hz):
	x=imread(image)
	#blanco y negro
	im=(x[:,:,0]+x[:,:,1]+x[:,:,2])/3
    #binarizando
    k=40
    for i in range(len(im)):
        for j in range(len(im[i])):
            if im[i][j]<=k:
                im[i][j]=1
            else:
                im[i][j]=0
    #imshow(im)
    ii=[]
    #labelizando
    for i in range(len(im)):
        for j in range(len(im[i])):
            if im[i][j]==1:
                ii.append(i)
    #print(ii)
    pc=[]
    for index in range(len(ii)):
        if index+1<len(ii):
            if  ii[index+1]-ii[index]!=1 and ii[index+1]-ii[index]!=0:
                pc.append(index)
    #print(pc)
    L=[]
    for k in range(len(pc)):
        mati=[]   

        if k+1<len(pc):
            for j in range(pc[k]+1,pc[k+1]):
                mati.append(ii[j])
            L.append(mati)
        else:
            L.append(ii[pc[len(pc)-1]:])

    
    cmy=[]

    #coordenada y del centro de masa
    for i in L:
        cmy.append(mean(i)*dx)
    tiempo=[]
    #print(cmy)
    for t in range(len(cmy)):
        tiempo.append((t+1)/hz)

    x=np.array(tiempo)
    y=np.array(cmy)

    f=[]
    f.append(lambda x:np.ones_like(x))
    f.append(lambda x:x)
    f.append(lambda x:x**2)

    Xt=[]

    for fu in f:
        Xt.append(fu(x))
    Xt=np.array(Xt)  

    X=Xt.transpose()

    a = np.dot(np.dot(inv(np.dot(Xt,X)),Xt),y)

    return a[2]*2
