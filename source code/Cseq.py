from math import e
from math import log
import os
import numpy as np
import  csv
import scipy.io as sio
from math import sqrt
import numpy as np
import matplotlib.pyplot as plt
import xlrd
import scipy.ndimage
import scipy.stats
import matplotlib.image as mpimg
import numpy as np
np.random.seed(1337)  # for reproducibility
from openpyxl import Workbook
from keras.datasets import mnist
from keras.models import Model
from keras.layers import Dense, Input
from scipy.sparse.linalg import svds
import pandas as pd
import torch
def pigment(rna_seq):

    x=[]
    y=[]
    pre_x=0.5
    pre_y=0.5

    size = 2 ** 3








    for i in rna_seq[1]:

        if i=='A':
            pre_x = pre_x * 0.5
            pre_y = pre_y*0.5
            x.append(pre_x)
            y.append(pre_y)
            continue

        if i=='T':
            pre_x = pre_x * 0.5+0.5
            pre_y = pre_y*0.5
            x.append(pre_x)
            y.append(pre_y)
            continue

        if i == 'C':
            pre_x = pre_x * 0.5
            pre_y = pre_y * 0.5 +0.5
            x.append(pre_x)
            y.append(pre_y)
            continue

        if i == 'G':
            pre_x = pre_x * 0.5 +0.5
            pre_y = pre_y * 0.5 +0.5
            x.append(pre_x)
            y.append(pre_y)
            continue
    vector_x=[]
    vector_y = []
    vector_sum=[]
    label=[]
    a_x=[]
    a_y = []





    for i in range(len(x)):

        label.append(int(x[i] * size)+int(y[i] * size)*size)

    for i in range (size*size):
        x_sum = 0
        y_sum = 0
        sum = 0
        for j in range(len(label)):

            if i == label[j]:

                x_sum = x_sum+x[j]
                y_sum = y_sum +y[j]

                sum += 1


        if sum >0:
            x_sum = x_sum
            y_sum = y_sum
        else:
            x_sum = 0
            y_sum = 0

        #a_x.append(x_sum)
        #a_y.append(y_sum)
        vector_x.append(x_sum)
        vector_y.append(y_sum)
        vector_sum.append(sum)


    vector=[]

    for i in vector_sum:

        if sum==0:
            vector.append(0)

        else:
            z_score = (i-np.average(vector_sum))/np.std(vector_sum)

            vector.append(z_score)

    for i in vector_x:
        vector.append(i)

    for i in vector_y:
        vector.append(i)

    print(len(vector))








    return vector
            


def readxlsx():
    workbook3 = xlrd.open_workbook('CircR2Disease_circRNA sequence.xlsx')
    # print(workbook.sheet_names())
    booksheet3 = workbook3.sheet_by_index(0)
    booksheet3 = workbook3.sheet_by_name('final')

    nrows3 = booksheet3.nrows
    row_list3_2=[]
    for i in range(0, nrows3):
        row_list3 = []
        row_data3 = booksheet3.row_values(i)
        row_list3.append(row_data3[0])

        row_list3.append(row_data3[2])

        row_list3_2.append(row_list3)

    rna_seq = row_list3_2


    return rna_seq



def readpng(path):
    # coding=gbk
    from PIL import Image
    import numpy as np
    # import scipy

    path = "/Users/kichikudetokumeikun/Desktop/CUMT/work/miRNA-disease/paper2/chaos game/original/chaosgame/subsampled/"+path[0] + ".png"
    # 读取图片
    im = Image.open(path)

    # 显示图片
    #im.show()

    im = im.convert("L")
    data = im.getdata()

    data = np.matrix(data)

    data = np.array(data)
    data = data.astype('float32') / 255. - 0.5



    data=data.reshape(462,362)



    return data


def AE(mat_contents):


    y_test_test = []
    x_train_test = []
    x_test_test = []


    i = 0
    for row in mat_contents:  # 接口
        a = row
        # a=np.array(a)

        x_train_test.append(a)

        # if i>100 :
        #     x_train_test.append(a)
        # else:
        #     x_test_test.append(a)

        i = i + 1

    x_train_test = np.array(x_train_test)
    x_train_test = x_train_test.astype('float32') / 255. - 0.5
    x_test_test = np.array(x_test_test)
    # print (len(x_train_test))
    # print (len(x_train_test_test))



    (x_train, _), (x_test, y_test) = mnist.load_data()



    x_train_test = x_train_test.reshape((x_train_test.shape[0], -1))

    x_train = x_train_test


    # in order to plot in a 2D figure
    encoding_dim = 32

    # this is our input placeholder
    input_img = Input(shape=(2310,))

    # encoder layers
    encoded = Dense(2000, activation='relu')(input_img)
    encoded = Dense(1000, activation='relu')(encoded)
    encoded = Dense(500, activation='relu')(encoded)
    encoded = Dense(100, activation='relu')(encoded)
    #encoded = Dense(100, activation='relu')(encoded)
    #encoded = Dense(100, activation='relu')(encoded)
    encoder_output = Dense(encoding_dim)(encoded)
    print()
    # decoder layers
    decoded = Dense(100, activation='relu')(encoder_output)
    decoded = Dense(500, activation='relu')(decoded)
    #decoded = Dense(500, activation='relu')(decoded)
    decoded = Dense(1000, activation='relu')(decoded)
    #decoded = Dense(5000, activation='relu')(decoded)
    decoded = Dense(2000, activation='relu')(decoded)
    decoded = Dense(2310, activation='tanh')(decoded)

    # construct the autoencoder model
    autoencoder = Model(input=input_img, output=decoded)

    # construct the encoder model for plotting
    encoder = Model(input=input_img, output=encoder_output)

    # compile autoencoder
    autoencoder.compile(optimizer='adam', loss='mse')

    # training
    autoencoder.fit(x_train, x_train,
                    epochs=10,
                    batch_size=100,
                    shuffle=True)

    # plotting
    encoded_imgs = encoder.predict(x_train)

    # to xlsx
    from openpyxl import Workbook

    workbook = Workbook()
    booksheet = workbook.active

    for rows in encoded_imgs:
        booksheet.append(rows.tolist())

    workbook.save("vae_RNAchaos_feature.xlsx")
    # plt.scatter(encoded_imgs[:, 0], encoded_imgs[:, 1], c=y_test_test)
    # plt.colorbar()
    # plt.show()

def svd(seq_data_part):
    (U, S, VT) = svds(seq_data_part, 5)

    S = U * S

    S = S.reshape((1, 2310))

    return S

def Global_distance(a,b):

    nw = 0
    xw = 0
    yw = 0
    sx = 0
    sy = 0
    rw = 0
    for i in range(len(a)):



        nw = nw+a[i]*b[i]

        xw = xw+a[i]*a[i]*b[i]
        yw = yw+a[i]*b[i]*b[i]
    if nw == 0:
        print(a)
        print(b)

    xw = xw/nw

    yw = yw/nw


    for i in range(len(a)):
        sx=sx+(a[i]-xw)*(a[i]-xw)*a[i]*b[i]
        sy=sy+(b[i]-yw)*(b[i]-yw)*a[i]*b[i]
    if sx==0:

        print(a)
        print(b)
    if sy == 0:
        print("error2")
    sx = sx/nw
    sy = sy/nw



    for i in range(len(a)):

        rw = rw+((a[i]-xw)/sqrt(sx)) * ((b[i]-yw)/sqrt(sy))*a[i]*b[i]

    rw =1 - rw/nw


    return rw


def P(a,b):
    s1 = pd.Series(a)
    s2 = pd.Series(b)
    corr = s1.corr(s2)

    return corr




def Euclidean_distance(a,b):

    sum=0

    for i in range(len(a)):

        if a[i][0]==0 and a[i][1]==0 and b[i][0]==0 and b[i][1]==0:
            sum = sum+0
        else:
            if (a[i][0]==0 and a[i][1]==0) or  (b[i][0]==0 and b[i][1]==0):
                sum = sum+0.177

            else:

                sum = sum+(a[i][0]-b[i][0])**2+(a[i][1]-b[i][1])**2

    distance = sqrt(sum)/3

    return distance
if __name__ == "__main__":


    rna_seq=readxlsx()

    j=0

    rna_name=[]
    seq_data=[]


    rw=[]

    for i in rna_seq:


        if i[1]!='':
           j=j+1



        seq_data.append(pigment(i))


    print('j',j)

    k=0




    for i in seq_data:

        rw_part = []
        for j in seq_data:

                rw_part.append( P(i, j) )

                k=k+1

        rw.append(rw_part)


    print(k)

    rw = np.array(rw, dtype='double')
    sio.savemat('Cseq.mat', {'Cseq': rw})

    rw=rw.tolist()
    workbook = Workbook()
    booksheet = workbook.active

    for rows in rw:
        booksheet.append(rows)
    print("start save xlsx")
    workbook.save("seq_sim.xlsx")

