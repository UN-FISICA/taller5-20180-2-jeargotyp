from matplotlib.pyplot import imread,imshow


def mean(L):
    m=sum(L)/len(L)
    return m

def acel(x,y):
    n=len(x)
    Sx=sum(x)
    Sy=sum(y)
    Sxy,Sxx,Sxxx,Sxxy,Sxxxx=[],[],[],[],[]
    
    for i in range(len(x)):
        Sxy.append(x[i]*y[i])
        Sxx.append(x[i]*x[i])
        Sxxx.append(x[i]*x[i]*x[i])
        Sxxy.append(x[i]*x[i]*y[i])
        Sxxxx.append(x[i]*x[i]*x[i]*x[i])
    
    s_xx=sum(Sxx)-(Sx**2/n)
    s_xy=sum(Sxy)-(Sx*Sy/n)
    s_xxx=sum(Sxxx)-(Sx/n)*(sum(Sxx))
    s_xxy=sum(Sxxy)-(Sy/n)*(sum(Sxx))
    s_xxxx=sum(Sxxxx)-(sum(Sxx)**2/n)
    a=(s_xxy*s_xx-s_xy*s_xxx)/(s_xx*s_xxxx-s_xxx**2)
    
    return a*2

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
    pix=im[0][0]
    ii=[]
    #labelizando
    for i in range(len(im)):
        for j in range(len(im[i])):
            if pix==1:
                if im[i][j]==0:
                    ii.append(i)
            else:              
                if im[i][j]==1:
                    ii.append(i)
    pc=[]
    for index in range(len(ii)):
        if index+1<len(ii):
            if  ii[index+1]-ii[index]!=1 and ii[index+1]-ii[index]!=0:
                pc.append(index)
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

    for t in range(len(cmy)):
        tiempo.append((t+1)/hz)

    x=tiempo
    y=cmy

    return acel(x,y)
