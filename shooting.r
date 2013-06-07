# Define SOFT function
soft = function(a, d)
{
  sign(a) * max((abs(a) - d), 0)
}

# Define LASSO function
shooting = function(lambda, X, Y)
{
  # Threshold of convergence
  epsilon = 1e-6
  
  # Scale (working this part out)
  Y.orig = Y
  X.orig = X
  X = scale(X, scale=FALSE)
  Y = scale(Y, scale=FALSE)
  
  # Initialize weights W
  W_last = matrix(0, 90, 1)
  W_cur = solve(t(X) %*% X + lambda * diag(ncol(X))) %*% t(X) %*% Y
  X.temp = cbind(rep(1, dim(X)[1]), X)
  w_0 = (solve(t(X.temp) %*% X.temp) %*% t(X.temp) %*% Y)[1]
  
  diff = 999999
  
  iters = 0
  iterlim = 10 * ncol(X)
  while (diff > epsilon && iters < iterlim)
  {
    iters = iters + 1
    # Store last position
    W_last = W_cur
    
    # LASSO optimization magick
    d = ncol(X)
    n = nrow(X)
    for (j in 1:d)
    {
      a_j = 2 * sum(X[,j]^2)
      c_j = 2 * sum(t(X[,j]) %*% (Y - X %*% W_cur + W_cur[j] * X[,j]))
      W_cur[j] = soft(c_j/a_j, lambda/a_j)
    }
    # Update w_0
    w_0 = mean(Y.orig) - sum(colMeans(X.orig)*W_cur)
    
    # Update difference
    diff = sqrt(sum((W_last - W_cur)^2))
  }
  
  result = list(one=w_0, two=W_cur)
  return(result)
}

nnzero = function(x) {
  return(sum(x >= 0.01))
}

# Read data from files
setwd("~/Documents/Homework/cse446/proj")

# READ FILES - UNCOMMENT FOR FIRST READ, COMMENT OUT TO AVOID LOADING AGAIN WHEN VARIABLES IN MEMORY
##### FILES #####
# trainX = read.table("data/mri_data_train.txt")
# trainY = read.table("data/wordid_train.txt")
# trainY = trainY[,1]
# 
# testX = read.table("data/mri_data_test.txt")
# testChoices = read.table("data/wordid_test.txt")
# 
# featureDict = read.table("data/wordfeature_centered.txt")
##### END FILES #####

##### BEGIN PROCESSING #####
trainXvars = apply(trainX, 2, var)
colsToUse = sapply(trainXvars, function(x){x > 1.09})
trainXfinal = matrix(nrow = 300, ncol = 0)
for (i in seq(ncol(trainX))) {
  if (colsToUse[i]) {
    trainXfinal = cbind(trainXfinal, trainX[i])
  }
}
##### END PROCESSING #####
##### SHOOTING #####
W = matrix(nrow=ncol(trainXfinal), ncol=218)
w_0 = matrix(nrow=1, ncol=218)
for (i in seq(218)) {
  trainYtranslated = sapply(trainY, function(x){featureDict[x,i]})
  result = shooting(0.05, trainXfinal, trainY)
  w_0[i] = result$one
  W[,i] = result$two
}
##### END SHOOTING #####
estimates = as.matrix(trainXfinal) %*% W

# create testCorrect and testWrong matrices
# then for each testX, get the smallest distance between correct
# and wrong, and return 1 if wrong, 0 o.w.
# finally sum the number of mistakes
# and divide my number of test cases (60)

#print(W)
#print(w_0)