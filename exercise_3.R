
#---- Aufgabe 1a ----

# Mit for loop

number_1 <- c(1:100)
sum_1 <- 0

for (i in number_1){
  sum_1 = sum_1 + i
}

print(sum_1)

# Mit while loop

number_1 <- 0

while (number_1 < 100){
  sum_1 = sum_1 + a
  number_1 = number_1 + 1
}

print(sum_1)


#---- Aufgabe 1b ----

number_1 <- c(1:100)
sum_1 <- 0

for (i in number_1){
  if (i %% 7 == 0 & i %% 3 == 0)
    sum_1 = sum_1 + i
}

cat("The sum of multiples of 3 and 7 within 1-100 is", sum_1)


#---- Aufgabe 2 ---

mymat <- matrix(c(6, 7, 3, NA, 15, 6, 7, 
                  NA, 9, 12, 6, 11, NA, 3, 
                  9, 4, 7, 3, 21, NA, 6, 
                  rep(NA, 7)),
                nrow = 4, byrow = TRUE)
myvec <- c(8, 4, 12, 9, 15, 6)

myvec_max <- max(myvec)

for (i in 1:nrow(mymat)){
  myvec_max <- max(myvec)
  for (j in 1:ncol(mymat)){
    if (is.na(mymat[i, j])){
      mymat[i, j] <- myvec_max
    }
  }
  myvec <- myvec[!(myvec == myvec_max)]
}

print(mymat)

#---- Aufgabe 3 ---

myvec_2 <- c(1:100)

for (i in 1:max(myvec_2)){
  if (myvec_2[i] <= 25){
    myvec_2[i] <- 6
  } else if (myvec_2[i] >= 65){
    myvec_2[i] <- -20
  } else {
    myvec_2[i] <- NA
  }
}

print(myvec_2)

vec_interpol <- approx(seq_along(myvec_2), myvec_2, method = "linear", seq_along(myvec_2))$y

plot(vec_interpol)
