# Generating sequence of non-random numbers

[R Vocab Topics](index) &#187; [Numbers](numbers) &#187; Generating sequence of non-random numbers

<br>

# Specifing Numbers within a Sequence

```r
# create a vector of integers between 1 and 10
1:10         
##  [1]  1  2  3  4  5  6  7  8  9 10

# create a vector consisting of 1, 5, and 10
c(1, 5, 10)   
## [1]  1  5 10

# save the vector of integers between 1 and 10 as object x
x <- 1:10 
x
##  [1]  1  2  3  4  5  6  7  8  9 10
```

<br>

# Generating Regular Sequences 


```r
# generate a sequence of numbers from 1 to 21 by increments of 2
seq(1, 21, by = 2)             
##  [1]  1  3  5  7  9 11 13 15 17 19 21

# generate a sequence of numbers from 1 to 21 that has 15 equal incremented numbers
seq(0, 21, length.out = 15)    
##  [1]  0.0  1.5  3.0  4.5  6.0  7.5  9.0 10.5 12.0 13.5 15.0 16.5 18.0 19.5
## [15] 21.0
```

<br>


```r
# replicates the values in x a specified number of times
rep(1:4, times = 2)   
## [1] 1 2 3 4 1 2 3 4

# replicates the values in x in a collated fashion
rep(1:4, each = 2)    
## [1] 1 1 2 2 3 3 4 4
```

<br>

<small><a href="#">Go to top</a></small>
