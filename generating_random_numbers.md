# Generating Random Numbers

[R Vocab Topics](index) &#187; [Numbers](numbers) &#187; Generating sequence of random numbers

<br>

* <a href="#uniform">Uniform numbers</a> 
* <a href="#normal">Normal distribution</a>
* <a href="#binomial">Binomial distribution</a>
* <a href="#poisson">Poisson distribution</a>
* <a href="#exponential">Exponential distribution</a>
* <a href="#gamma">Gamma distribution</a>

<br>

# Uniform numbers 
<a name="uniform"></a>

```r
# generate n random numbers between the default values of 0 and 1
runif(n)            

# generate n random numbers between 0 and 25
runif(n, min = 0, max = 25)       

# generate n random numbers between 0 and 25 (with replacement)
sample(0:25, n, replace = TRUE)   

# generate n random numbers between 0 and 25 (without replacement)
sample(0:25, n, replace = FALSE)  
```

For example, to generate 25 random numbers between the values 0 and 10:

```r
runif(25, min = 0, max = 10) 
##  [1] 9.2494720 1.0276421 9.6061007 7.4582455 8.3666868 0.8090925 7.5638221
##  [8] 4.2810155 2.5850736 9.7962788 6.1705894 0.7037997 9.5056240 4.7589622
## [15] 7.9750129 5.3932881 5.1624935 1.2704098 8.7064680 8.6649293 0.1049461
## [22] 1.4827342 2.7337917 7.5236131 3.9803653
```

<br>

# Normal Distribution Numbers 
<a name="normal"></a> 

```r
# generate n random numbers from a normal distribution with given mean & st. dev.
rnorm(n, mean = 0, sd = 1)    

# generate CDF probabilities for value(s) in vector q 
pnorm(q, mean = 0, sd = 1)    

# generate quantile for probabilities in vector p
qnorm(p, mean = 0, sd = 1)    

# generate density function probabilites for value(s) in vector x
dnorm(x, mean = 0, sd = 1)    
```

For example, to generate 25 random numbers from a normal distribution with `mean = 100` and
`standard deviation = 15`:

```r
x <- rnorm(25, mean = 100, sd = 15) 
x
##  [1] 107.84214 101.10742  73.67151 113.94035 108.47938  77.48445  73.02016
##  [8]  81.02323 101.64169 112.67715 105.28478  92.35393  85.96284 108.83169
## [15]  88.71057 115.13657 141.69830  99.91198 118.69664 110.61667  83.20282
## [22] 113.91008 109.10879  93.45276 109.01996

summary(x)
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   73.02   88.71  105.30  101.10  110.60  141.70
```

You can also pass a vector of values.  For instance, say you want to know the CDF probabilities for each value in a vector:

```r
pnorm(x, mean = 100, sd = 15) 
##  [1] 0.69944664 0.52942643 0.03960976 0.82364789 0.71406244 0.06667308
##  [7] 0.03603657 0.10291447 0.54357552 0.80098468 0.63770038 0.30511760
## [13] 0.17468526 0.72199534 0.22583658 0.84353778 0.99728111 0.49765904
## [19] 0.89369904 0.76045844 0.13139693 0.82312464 0.72815841 0.33124331
## [25] 0.72619004
```

<br>

# Binomial Distribution Numbers 
<a name="binomial"></a> 
This is conventionally interpreted as the number of ‘successes’ in `size = x` trials and `prob = p` probability of success:

```r
# generate a vector of length n displaying the number of successes from a trial 
# size = 100 with a probabilty of success = 0.5
rbinom(n, size = 100, prob = 0.5)  

# generate CDF probabilities for value(s) in vector q
pbinom(q, size = 100, prob = 0.5) 

# generate quantile for probabilities in vector p
qbinom(p, size = 100, prob = 0.5) 

# generate density function probabilites for value(s) in vector x
dbinom(x, size = 100, prob = 0.5)  
```

<br>

# Poisson Distribution Numbers 
<a name="poisson"></a> 
A discrete probability distribution that expresses the probability of a given number of events occuring in a fixed interval of time and/or space if these events occur with a known average rate and independently of the time since the last event.

```r
# generate a vector of length n displaying the random number of events occuring 
# when lambda (mean rate) equals 4.
rpois(n, lambda = 4)  

# generate CDF probabilities for value(s) in vector q when lambda (mean rate) 
# equals 4.
ppois(q, lambda = 4)  

# generate quantile for probabilities in vector p when lambda (mean rate) 
# equals 4.
qpois(p, lambda = 4)  

# generate density function probabilites for value(s) in vector x when lambda 
# (mean rate) equals 4.
dpois(x, lambda = 4)  
```

<br>

# Exponential Distribution Numbers 
<a name="exponential"></a> 
A probability distribution that describes the time between events in a Poisson process.

```r
# generate a vector of length n with rate = 1
rexp(n, rate = 1)   

# generate CDF probabilities for value(s) in vector q when rate = 4.
pexp(q, rate = 1)   

# generate quantile for probabilities in vector p when rate = 4.
qexp(p, rate = 1)   

# generate density function probabilites for value(s) in vector x when rate = 4.
dexp(x, rate = 1)   
```

<br>

# Gamma Distribution Numbers 
<a name="gamma"></a> 
A probability distribution that is related to the beta distribution and arises naturally in processes for which the waiting times between Poisson distributed events are relevant.

```r
# generate a vector of length n with shape parameter = 1
rgamma(n, shape = 1)   

# generate CDF probabilities for value(s) in vector q when shape parameter = 1.
pgamma(q, shape = 1)   

# generate quantile for probabilities in vector p when shape parameter = 1.
qgamma(p, shape = 1)   

# generate density function probabilites for value(s) in vector x when shape 
# parameter = 1.
dgamma(x, shape = 1)   
```

<br>

<small><a href="#">Go to top</a></small>

