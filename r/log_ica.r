#!/usr/local/bin/r
######################################################################
##        Copyright (c) 2017 Carsten Wulff Software, Norway
## ###################################################################
## Created       : wulff at 2017-10-22
## ###################################################################
##   This program is free software: you can redistribute it and/or modify
##   it under the terms of the GNU General Public License as published by
##   the Free Software Foundation, either version 3 of the License, or
##   (at your option) any later version.
##
##   This program is distributed in the hope that it will be useful,
##   but WITHOUT ANY WARRANTY; without even the implied warranty of
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##   GNU General Public License for more details.
##
##   You should have received a copy of the GNU General Public License
##   along with this program.  If not, see <http://www.gnu.org/licenses/>.
######################################################################
library(fastICA)

#- A few filters
mav <- function(x,n=5){filter(x,rep(1/n,n), sides=2)} #Average
mmed <- function(x,n=5){runmed(x,n)} #Median

#- Read logs
dr <- "~/Dropbox/utility/logs"
f <- list.files(dr)

#- Initialize vars
max = 0
min = 1e5
N <- length(f)
l = vector("list",N)
i <- 1

#- Read data, apply filter, and store, the data have slightly different lengths, probably because I loose packets
#- TODO: account for timing, so I get the correct data per X seconds
for( fx in f){
  df <- read.table(paste(dr,fx, sep="/"),header=FALSE, sep = ";")
  kw = df[,2]
  kw = mmed(kw,150)
  l[[i]] <- kw
  i <- i+1
  M <- length(kw)
  if(M > max){
    max <- M
  }
  if(M < min){
    min = M
  }
}

#- Combine the days into a matrix that fastICA can read
X <- l[[1]][1:min]
for(i in 2:N){
  df <- l[[i]][1:min]
  X <- cbind(X,df) 
}

#- Magic
a <- fastICA(X, N, alg.typ = "parallel", fun = "logcosh", alpha = 1, method ="R", row.norm = FALSE, maxit = 500, tol = 0.0001, verbose = TRUE)

#- Plot
par(mfcol = c(3, N/3))
for(i in 1:N){
  plot(1:min, a$S[,i], type = "l", xlab = paste("S'",i,sep=""), ylab = "")
}


