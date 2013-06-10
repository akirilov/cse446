setwd("~/Documents/Homework/cse446/proj/java/Shotgun")

lambdas = c(0.01, 0.02, 0.03, 0.04, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.4)
l_mistakes = c(13, 13, 13, 13, 13, 15, 16, 22, 27, 31, 31, 31)
l_errors = c(0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.25, 0.26666668, 0.36666667, 0.45, 0.51666665, 0.51666665, 0.51666665)

iters = c(0, 1, 21, 217, 2176, 10882, 21764, 43528, 87056, 130584, 174112, 217640, 326460, 435280)
i_mistakes = c(32, 11, 11, 12, 13, 12, 11, 13, 13, 13, 13, 12, 11, 12)
i_errors = c(0.53333336, 0.18333334, 0.18333334, 0.2, 0.21666667, 0.2, 0.18333334, 0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.2, 0.18333334, 0.2)
i_times = c(28.647, 82.108, 84.192, 83.433, 83.392, 82.364, 82.802, 125.383, 203.0, 276.489, 349.654, 421.932, 583.516, 729.275)

thresholds = c(0, 1.02, 1.03, 1.04, 1.05, 1.06, 1.07, 1.08)
t_items = c(21764, 7156, 5378, 3773, 2487, 1559, 918, 469)
t_mistakes = c(11, 17, 17, 19, 18, 23, 23.0, 24.0)
t_errors = c(0.18333334, 0.28333333, 0.28333333, 0.31666666, 0.3, 0.38333333, 0.38333333, 0.4)
t_times = c(424.972, 126.229, 91.387, 62.743, 38.879, 23.723, 12.995, 5.665)

p_dims = c(300)
p_mistakes = c(23)
p_errors = c(0.383333333333333)

##### LAMBDAS #####
png("lambdas-mistakes.png", width=640, height=480)
plot(lambdas, l_mistakes, xlab="Lambda value", ylab="Number of mistakes")
title("Lambda value vs Number of Mistakes")
dev.off()

png("lambdas-errors.png", width=640, height=480)
plot(lambdas, l_errors, xlab="Lambda value", ylab="Incorrect classification rate (% Errors)")
title("Lambda value vs Incorrect Classification Rate")
dev.off()
##### END LAMBDAS #####

##### ITERATIONS #####
png("iters-mistakes.png", width=640, height=480)
plot(iters, i_mistakes, log="x", xlab="SCD Iterations", ylab="Number of mistakes")
title("SCD Iterations vs Number of mistakes")
dev.off()

png("iters-errors.png", width=640, height=480)
plot(iters, i_errors, log="x", xlab="SCD Iterations", ylab="Incorrect classification rate (% Errors)")
title("SCD Iterations vs Incorrect Classification Rate")
dev.off()

png("iters-times.png", width=640, height=480)
plot(iters, i_times, log="x", xlab="SCD Iterations", ylab="Runtime (seconds)")
title("SCD Iterations vs Runtime")
dev.off()
##### END ITERATIONS #####

##### DIMENSIONALITY REDUCTION #####
png("dimreduction-mistakes.png", width=640, height=480)
plot(t_items, t_mistakes, log="x", xlab="# Dimensions used", ylab="Number of mistakes")
title("Dimensions used vs Number of mistakes")
dev.off()

png("dimreduction-errors.png", width=640, height=480)
plot(t_items, t_errors, log="x", xlab="# Dimensions used", ylab="Incorrect classification rate (% Errors)")
title("Dimensions used vs Incorrect Classification Rate")
dev.off()

png("dimreduction-times.png", width=640, height=480)
plot(t_items, t_times, log="x", xlab="# Dimensions used", ylab="Runtime (seconds)")
title("Dimensions used vs Runtime")
dev.off()
##### END DIMENSIONALITY REDUCTION #####