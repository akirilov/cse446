setwd("~/Documents/Homework/cse446/proj/java/Shotgun")

lambdas = c(0.01, 0.02, 0.03, 0.04, 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.35, 0.4)
l_mistakes = c(13, 13, 13, 13, 13, 15, 16, 22, 27, 31, 31, 31)
l_errors = c(0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.25, 0.26666668, 0.36666667, 0.45, 0.51666665, 0.51666665, 0.51666665)

iters = c(0, 1, 21, 217, 2176, 10882, 21764, 43528, 87056, 130584, 174112, 217640, 326460, 435280)
i_mistakes = c(32, 11, 11, 12, 13, 12, 11, 13, 13, 13, 13, 12, 11, 12)
i_errors = c(0.53333336, 0.18333334, 0.18333334, 0.2, 0.21666667, 0.2, 0.18333334, 0.21666667, 0.21666667, 0.21666667, 0.21666667, 0.2, 0.18333334, 0.2)
i_times = c(28.647, 82.108, 84.192, 83.433, 83.392, 82.364, 82.802, 125.383, 203.0, 276.489, 349.654, 421.932, 583.516, 729.275)

thresholds = c()
t_mistakes = c()
t_errors = c()
t_times = c()

png("lambdas-mistakes.png", width=640, height=480)
plot(lambdas, l_mistakes, xlab="Lambda value", ylab="Number of mistakes")
title("Lambda value vs Number of Mistakes")
dev.off()

png("lambdas-errors.png", width=640, height=480)
plot(lambdas, l_errors, xlab="Lambda value", ylab="Incorrect classification rate (% Errors)")
title("Lambda value vs Incorrect Classification Rate")
dev.off()

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