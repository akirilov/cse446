# Define SOFT function
soft = function(a, d)
{
  sign(a) * max((abs(a) - d), 0)
}

# Define LASSO function
lasso = function(lamda, X, Y)
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
  
  while (diff > epsilon)
  {
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

# Read data from files
setwd("~/Documents/Homework/cse446/proj")
trainX = read.table("???")
trainWords = read.table("???")

testX = read.table("???")
featureDict = read.table("???")

# set trainY with featureDict replacing in trainWords

result = lasso(exp(11), trainX, trainY)
w_0 = result$one
W = result$two

print(W)
print(w_0)