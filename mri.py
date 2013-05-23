#!/usr/bin/python

import numpy as np
from numpy import linalg as la

def sign(x):
  if x > 0:
    return 1
  elif x < 0:
    return -1
  else:
    return 0

def soft(a, d):
  return sign(a) * max((abs(a) - d), 0)

def scale(x):
  col_mean = np.mean(x,0)
  for i in range(x.shape[0]):
    x[i] = x[i] - col_mean
  return x

# X = data, Y = actual values, l = lambda, e = epsilon 
def shooting(X, Y, l, e):
  nrow = X.shape[0]
  ncol = X.shape[1]
  Y_orig = Y
  X_orig = X
  X = scale(X)
  Y = scale(Y)
  W_last = []
  W_cur = la.inv(X.T * X + l * np.identity(ncol)) * X.T * Y
  X_temp = np.column_stack((np.matrix("1;" * (ncol - 1) + "1"), X))
  w_0 = (la.inv(X_temp.T * X.temp) * X_temp.T * Y)[0]
  diff = e + 1
  while diff > e:
    W_last = W_cur
    d = ncol
    n = nrow
  for i in range(d):
    a_j = 2 * X.T[i].T * X.T[i]
    c_j = 2 * sum(X.T[i] * (Y - X * W_cur + W_cur[i] * X.T[i]))
    W_cur[i] = soft(c_j/a_j, l/a_j)
  w_0 = np.mean(Y_orig) - sum(np.mean(X_orig, 0) * W_cur)
  W_diff = W_last - W_cur
  diff = math.sqrt(W_diff.T * W_diff)
  result = {"w_0":w_0, "weights":W_cur}
  return result
