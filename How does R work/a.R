library(ggplot2)


simulat_dice_clt <- function(n=1, rep=10000) {
  dice <- 1:6
  sums <- 0
  for (i in seq_len(n)) {
    sums <- sums + sample(dice, size=rep, replace=TRUE)
  }
  sums / n
}

s <- 10000

dist1  <- simulat_dice_clt(n=1, rep=s)
dist2  <- simulat_dice_clt(n=2, rep=s)
dist3  <- simulat_dice_clt(n=3, rep=s)
dist10 <- simulat_dice_clt(n=10, rep=s)
dist   <- data.frame(x = c(dist1, dist2, dist3, dist10),
                     n = rep(1:4, each=s))

ggplot(dist, aes(x=x, colour=n, )) +
  geom_histogram() +
  facet_wrap(~n)
