
from math import e
from math import log
import os
import numpy as np
import  csv
import xlrd
import scipy.io as sio
from openpyxl import Workbook






if __name__ == "__main__":


    filePath_N = 'Gaussian_Gene.mat'
    mat_contents_N = sio.loadmat(filePath_N)
    G = mat_contents_N['Gaussian_Gene']
    G =G.tolist()

    filePath_N = 'R.mat'
    mat_contents_N = sio.loadmat(filePath_N)
    R = mat_contents_N['R']
    R = R.tolist()

    filePath_N = 'Gaussian.mat'
    mat_contents_N = sio.loadmat(filePath_N)
    Gaussian_cricR = mat_contents_N['Gaussian_cricR']
    Gaussian_cricR = Gaussian_cricR.tolist()



    R=np.array(R)
    G = np.array(G)

    Cgene=R.T

    Cgene=Cgene.dot(G)

    Cgene = Cgene.dot(R)

    #Cgene = np.array(Cgene, dtype='double')
    sio.savemat('Cgene.mat', {'Cgene': Cgene})

    Cgene=Cgene.tolist()

    workbook = Workbook()
    booksheet = workbook.active

    for i in Cgene:
        # for j in SM :
        list = []
        # print type(j)

        booksheet.append(i)

    print("write xlsx")
    workbook.save("Cgene.xlsx")

































