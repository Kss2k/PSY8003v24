library(ggplot2) # you might need to run `install.packages("ggplot2")`


sample_weighted_dice <- function(n, values, probs) {
  if (length(values) != length(probs)) 
      stop("values and prob must be of the same length")
  
  X <- rep(NA, n)
  
  for (i in seq_along(values)) {
    if (!any(is.na(X))) return(X)
    sub_p <- i:length(probs)
    probs[sub_p]  <- probs[sub_p] / sum(probs[sub_p]) # get conditional probabilities
    
    value <- values[[i]]
    prob  <- probs[[i]]
     
    success <- as.logical(rbinom(n=sum(is.na(X)), size=1, prob=prob))
    X[is.na(X)][success] <- value
  }
  
  X
}

simulate_dice_clt <- function(n=1, rep=10000, dice = 1:6, weights = rep(1, 6)) {
  out     <- NULL
  
  for (n_i in n) {
    X    <- sample_weighted_dice(n=rep * n_i, values=dice, probs=weights) 
    Y    <- matrix(X, ncol=n_i, nrow=rep)
    out  <- rbind(out, data.frame(x=rowMeans(Y), n=n_i, s=rep))    
  }
  
  out$n <- as.factor(out$n)
  out
}

# fair six-sided dice
dist_fair <- simulate_dice_clt(n=c(1, 2, 5, 20), # simulate throws with different number of dice 
                               rep=10000, # repetitions per simulation
                               dice = 1:6, # possible values for dice
                               weights = rep(1, 6)) # relative weights for each face of the die
                                                    # divided by the sum of weights to get
                                                    # the probability for getting a particular
                                                    # value. E.g., [1, 1, 1] / 3 = [0.33..., 0.33..., 0.33...]
                    
                          

ggplot(dist_fair, aes(x=x, y=after_stat(100*count/s), colour=n, fill=n, alpha=0.5)) +
  geom_histogram() +
  ylab("Percentage") +
  facet_wrap(~n)

# unfair six-sided dice
weights <- c(6, 2, 3, 0.5, 1, .7) # probabilities = [0.45454545 0.15151515 0.22727273 0.03787879 0.07575758 0.05303030]
dist_loaded <- simulate_dice_clt(n=c(1, 2, 5, 20), # simulate throws with different number of dice 
                                 rep=10000, # repetitions per simulation
                                 dice = 1:6, # possible values for dice (six sided)
                                 weights = weights) 

  
ggplot(dist_loaded, aes(x=x, y=after_stat(100*count/s), colour=n, fill=n, alpha=0.5)) +
  geom_histogram() +
  ylab("Percentage") +
  facet_wrap(~n)

