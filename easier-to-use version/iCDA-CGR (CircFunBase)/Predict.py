# -*- coding: utf-8 -*

from numpy import *
from sklearn.externals import joblib
import  csv

def ReadMyCsv(SaveList, fileName):
    csv_reader = csv.reader(open(fileName))
    for row in csv_reader:
        SaveList.append(row)
    return
def StorFile(data, fileName):
    with open(fileName, "w", newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerows(data)
    return
def list_toRow(x):
    y=[]
    for i in x:

        y.append(i[0])
    return y


def Predict(circRNA,disease):
    List = []
    ReadMyCsv(List, "circFunbase_circRNA.csv")
    circRNA_List = list_toRow(List)

    List = []
    ReadMyCsv(List, "circFunbase_disease.csv")
    Disease_List = list_toRow(List)

    List = []
    ReadMyCsv(List, "Sd.csv")
    Sd = List

    List = []
    ReadMyCsv(List, "Sc.csv")
    Sc = List

    feature = []


    feature.extend(Sc[circRNA_List.index(circRNA)])
    feature.extend(Sd[Disease_List.index(disease)])

    model = joblib.load("iCDA-CGR(circFunBase).model")

    y_score = model.predict_proba([feature])

    return circRNA,disease,y_score[0][1]



if __name__ == "__main__":





    circRNA="hsa_circ_0041477"
    disease="severe acne"




    circRNA, disease,score=Predict(circRNA,disease)
    print(circRNA+" and "+disease+":"+str(score))
