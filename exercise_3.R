
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

mymat[is.na(mymat)] <- myvec_max

print(mymat)

print(length(mymat[ ,1]))

for (i in length(mymat[ ,1])){
  for (j in length(mymat[i, ]){
    if (is.na(mymat[i, j])){
      mymat[i, j] <- myvec_max
    }
  }
}

print(mymat)

for (i in 1:nrow(mymat)){
  for (j in 1:ncol(mymat)){
    if (is.na(mymat[i, j])){
      mymat[i, j] <- myvec_max
    }
  }
}

print(mymat)
  


