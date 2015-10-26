# Integer vs. Double

[R Vocab Topics](index) &#187; [Numbers](numbers) &#187; Integer vs. Double

<br>

The two most common numeric classes used in R are integer and double (for double precision floating point numbers).  R automatically converts between these two classes when needed for mathematical purposes.  As a result, it's feasible to use R and perform analyses for years without specifying these differences.

<br>

# Creating Integer and Double Vectors

```r
# create a string of double-precision values
dbl_var <- c(1, 2.5, 4.5)  
dbl_var
## [1] 1.0 2.5 4.5

# placing an L after the values creates a string of integers
int_var <- c(1L, 6L, 10L)
int_var
## [1]  1  6 10
```

<br>

# Converting Between Integer and Double Values
By default, if you read in data that has no decimal points or you [create numeric values](generating_sequence_numbers) using the `x <- 1:10` method the numeric values will be coded as integer.  If you want to change a double to an integer or vice versa: 


```r
# converts integers to double-precision values
as.double(int_var)     
## [1]  1  6 10

# identical to as.double()
as.numeric(int_var)    
## [1]  1  6 10

# converts doubles to integers
as.integer()           
## integer(0)
```

# Checking for Numeric Type
To check whether a vector is made up of integer or double values:


```r
# identifies the vector type (double, integer, logical, or character)
typeof(x)     
```

<br>

<small><a href="#">Go to top</a></small>
