#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May  4 11:25:24 2022

@author: diego
"""


import numpy as np
import ordpy as op
from scipy.signal import hilbert
import itertools
from scipy.stats import norm


def binariza(x):
    mean = np.median(x)
    for i in range(len(x)):
        if x[i] >= mean:
            x[i] = 1
        else:
            x[i] = 0
    return x
    

def lempel_ziv_complexity_bin(x, type_bin=None):
    x = binariza(x)
    sequence = gen_pal(x)
    
    sub_strings = set()
    n = len(sequence)

    ind = 0
    inc = 1
    while True:
        if ind + inc > n:
            break
        sub_str = sequence[ind : ind + inc]
        if sub_str in sub_strings:
            inc += 1
        else:
            sub_strings.add(sub_str)
            ind += inc
            inc = 1
    return len(sub_strings)

# %%----------------------------------------------------------------
def lempel_ziv_complexity_op(x, d, tau):
    sequence = permut(x, d, tau)
    
    sub_states = list()
    n = len(sequence)

    ind = 0
    inc = 1
    while True:
        if ind + inc > n:
            break
        state = sequence[ind : ind + inc]
        if state in sub_states:
            inc += 1
        else:
            sub_states.append(state)
            ind += inc
            inc = 1
    return  len(sub_states)

def permut(x, d, tau):
    op_per = np.arange(d) # lista de valores para generar las permutaciones
    permutations = list(itertools.permutations(op_per)) # genero todas las permut.
    
    OX=op.ordinal_sequence(x, dx=d, taux=tau)
    ind_OX = [] # indice que mapea cada fila de OX a la tabla de permutaciones
    for f in range(OX.shape[0]):
      for per in range(len(permutations)):
        if list(OX[f,:]) == list(permutations[per]):
          ind_OX.append(per)
          break
    
    return ind_OX
# %%%-------------------------------------------------------------------


def gen_pal(inp):
    s = ''
    for val in inp:
        s+=str(val)
        
    return s


def lempel_ziv_complexity_hil(x):
    x = np.abs(hilbert(x))
    return lempel_ziv_complexity_bin(x)

# %%---------------------------------------------------------------
def joinDisc(M):
    Nc, Ns = M.shape
    Vexp = np.arange(0, Nc)
    V2 = (np.ones((1, Nc))*2)**Vexp;
    Xjd = np.zeros(Ns)
    for itime in range(Ns):
        Xv = M[:, itime]
        Xjd[itime] = np.sum(Xv*V2)
        
    return Xjd, Nc


def binariza_mat(M):
    fil, col = M.shape
    if fil> col:
        M = M.T
    Lchan, Ldata = M.shape
    Mbin = np.zeros((Lchan, Ldata))
    
    for i in range(Lchan):
        Xbin = binariza(M[i,:])
        Mbin[i,:] = Xbin
        
    return Mbin
# %%-------------------------------------------------------------
##### Esta es la General !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
def complexity(x):
    sub_states = list()
    n = len(x)

    ind = 0
    inc = 1
    while True:
        if ind + inc > n:
            break
        state = x[ind : ind + inc]
        if list(state) in sub_states:
            inc += 1
        else:
            sub_states.append(list(state))
            ind += inc
            inc = 1
    return len(sub_states)
# %-----------------------------------------------------------------------
def JLZC_v2(M, bin_mat=False):
    if not bin_mat:
        M = binariza_mat(M)
    Xjd, Nc = joinDisc(M)
    NAlphabet = 2**Nc
    
    JLZC = complexity(Xjd)
    
    b = len(Xjd)/(np.log(len(Xjd))/np.log(NAlphabet))
    nJLZC = JLZC/b
    
    return nJLZC
# %%%--------------------------------------------------------------
def dispersion(x, alpha):
    '''
    Quantization using dispersion entropy method.
    Dispersion entropy: a measure for time-series analysis.
    Rostaghi et. al.
    '''
    if np.std(x) == 0:
        seq = np.zeros(x.shape)
    else:
        seq = np.zeros(x.shape)
        y = norm.cdf(x, loc=np.mean(x), scale=np.std(x))
        seq = np.round(alpha * y + 0.5) - 1
    return seq
# %%%--------------------------------------------------------------

def quantile(x, alpha):
    '''
    Quantization thresholding with alpha-quantiles
    '''
    seq = np.zeros(x.shape)
    nq = (np.array(range(alpha - 1)) + 1) / alpha
    thl = np.quantile(x, q=nq)
    for i in range(len(thl) - 1):
        ind = np.where((x > thl[i]) * (x <= thl[i + 1]))[0]
        seq[ind] = i + 1
    ind = np.where((x > thl[-1]))[0]
    seq[ind] = alpha - 1
    return seq


# %% Complexity Normalization ----------------------------------------------------

def lz_normalization(complexity, n, Asize, norm_type='n1'):
    if norm_type == 'n1':
        h = norma01(complexity, n, Asize)
    elif norm_type == 'n2':
        h = norma02(complexity, n)
    if norm_type == 'n3':
        h = norma03(complexity, n, Asize)
    if norm_type == 'n4':
        h = norma04(complexity, n, Asize)
    return h


def norma01(complexity, n, Asize):
    '''
    Entropy estimation of very short symbolic sequences
    Lesne et. al.
    '''
    return (complexity / n) * (np.log(Asize) + np.log(complexity))


def norma02(complexity, n):
    '''
    On Lempel-Ziv complexity for multidimensional data analysis
    Zozor et. al.
    '''
    return complexity * np.log(n) / n


def norma03(complexity, n, Asize):
    '''
    Entropy estimation of very short symbolic sequences
    Lesne et. al.
    '''
    return (complexity / n) * (np.log(n) / np.log(Asize))


def norma04(complexity, n, Asize):
    '''
    Entropy estimation of very short symbolic sequences
    Lesne et. al.
    '''
    return (complexity / n) * (np.log(complexity) / np.log(Asize) + 1)
    
    
        
