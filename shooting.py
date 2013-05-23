#!/usr/bin/python

import math
import numpy as np
from numpy import linalg as la

# Return the sign of x, or 0 if x has no sign
def sign(x):
    if x > 0:
        return 1
    elif x < 0:
        return -1
    else:
        return 0

# The soft function as defined in class
def soft(a, d):
    return sign(a) * max((abs(a) - d), 0)

# Centers the data
def center(x):
    col_mean = np.mean(x,0)
    for i in range(x.shape[0]):
        x[i] = x[i] - col_mean
    return x

# Lasso shooting algorithm
# X = data, Y = actual values, l = lambda, e = epsilon 
def shooting(X, Y, l, e):
    nrow = X.shape[0]
    ncol = X.shape[1]
    Y_orig = np.matrix(Y)
    X_orig = np.matrix(X)
    X = center(X)
    Y = center(Y)
    W_last = []
    W_cur = la.inv(X.T * X + l * np.matrix(np.identity(ncol))) * X.T * Y
    X_temp = np.column_stack((np.matrix('1;' * (nrow - 1) + '1'), X))
    w_0 = (la.inv(X_temp.T * X_temp) * X_temp.T * Y)[0]
    diff = e + 1
    while diff > e:
        W_last = np.matrix(W_cur)
        d = ncol
        n = nrow
        for i in range(d):
            a_j = 2 * (X.T[i] * X.T[i].T)[0,0]
            c_j = 2 * (X.T[i] * (Y - X * W_cur + W_cur[i,0] * X.T[i].T))[0,0]
            W_cur[i] = soft(c_j/a_j, l/a_j)
        w_0 = np.mean(Y_orig) - sum(np.mean(X_orig, 0) * W_cur)
        W_diff = W_last - W_cur
        diff = math.sqrt(W_diff.T * W_diff)
    result = {'w_0':w_0, 'weights':W_cur}
    return result

if __name__ == '__main__':
    testX = np.matrix('')
    testX.shape = (0, 91)
    testdata = open('musicdata.txt')

    # Read data from test file
    for line in testdata:
        testX = np.row_stack((testX, np.matrix(line)))

    # Pull out Y data
    testY = testX.T[0].T

    # Remove Y data from X matrix
    testX = testX.T[1:].T

    result = shooting(testX, testY, math.e ** 11, 0.000001)
    print result['w_0']
