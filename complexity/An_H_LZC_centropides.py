#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar  6 19:47:47 2025

Analisis de H y LZC sobre los centroides de Gaby y Pablo

@author: diego
"""

import scipy.io
import numpy as np
import mod_LZC as LZC
import matplotlib.pyplot as plt

def calcular_entropia(vector, bins):
    # Calcular el histograma
    hist, bin_edges = np.histogram(vector, bins=bins)

    # Calcular las probabilidades de cada bin
    p = hist / np.sum(hist)

    # Calcular la entropía utilizando la fórmula de Shannon
    entropia = -np.sum(p * np.log2(p + np.finfo(float).eps))
    
    entropia=entropia/np.log2(bins)

    return entropia


# Cargar el archivo .mat
mat_data = scipy.io.loadmat('centroides-para-diego.mat')

Mdata_centropides=mat_data['centroides']




Mat_LZC_H=np.zeros((2,5))
# %% 

for icent in range(5):
    ncentroide=icent

    matriz=Mdata_centropides[ncentroide,:,:]
    
    triangular_superior = matriz#[np.triu_indices(128, k=0)]
    # Convertir a un array 1D
    Xvalues = triangular_superior.flatten()
    Xvalues2 = Xvalues#[Xvalues != 0]
    
    # Crear el histograma con 10 bins
    bins=128
    hist, bin_edges = np.histogram(Xvalues2, bins=bins)
    
    # Mostrar el histograma
    # plt.hist(Xvalues2, bins=90, edgecolor='black')
    # plt.xlabel('Valor')
    # plt.ylabel('Frecuencia')
    # plt.title('centropide ' + str(ncentroide))
    # plt.show()
    
    # Crear un nuevo array indicando en qué bin cae cada valor del array original
    bin_indices = np.digitize(Xvalues2, bins=bin_edges) - 1
    
    # Asegurarse de que los valores en los bordes caigan en el bin correcto
    bin_indices[bin_indices == -1] = 0
    bin_indices[bin_indices == len(bin_edges)-1] = len(bin_edges)-2
    
    n=len(bin_indices)
    Asize=128
    
    lzc=LZC.complexity(bin_indices)
    nlzc=LZC.norma03(lzc, n, Asize)
    Mat_LZC_H[0,icent]=nlzc
    
    #calculamos la entropia de shannon 
    entropia = calcular_entropia(Xvalues2, bins)
    Mat_LZC_H[1,icent]=entropia
# %%
fig, ax = plt.subplots(figsize=(6,6))
colors = ["#f5e342", "#ffa85c", "#ff8d5c", "#ff5c5c", "#913030"]
for i in range(5):
    ax.scatter(Mat_LZC_H[1,i], Mat_LZC_H[0,i], label=f"centroide {i+1}", c=colors[i], s=81)

ax.spines[['right', 'top']].set_visible(False)
#plt.legend()
plt.show()