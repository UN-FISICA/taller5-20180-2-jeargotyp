from scipy.misc import imread
from pylab import where
import numpy as np
import scipy.ndimage as nd
from numpy.linalg import inv,lstsq

def calc(image, hz, dx):
        x=imread(image)
        x=np.asarray(x,dtype=np.float32)
        y=(x[:,:,0]+x[:,:,1]+x[:,:,2])/3
        im=nd.median_filter(y,(3,3))
        bi=where(im<200,1,0)
        label,n=nd.measurements.label(bi)
        cm,tiempo=[],[]
        j=0
        while j<n:
                cm.append(nd.measurements.center_of_mass(bi,label, j+1))
                j+=1
        #Asume que el primer label de la imagen no es bueno.
        cm=cm[1:]
        altura=[]
        for k in cm:
                altura.append(k[0]*dx)
        for t in range(len(altura)):
                tiempo.append((t+1)/hz)
        x=np.array(tiempo)
        y=np.array(altura)
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
