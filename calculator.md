# R as a Calculator

At its most basic function R can be used as a calculator.  When applying basic arithmetic, the PEMBDAS order of operations applies: **p**arentheses first followed by **e**xponentiation, **m**ultiplication and **d**ivision, and final **a**ddition and **s**ubtraction.


```r
8 + 9 / 5 ^ 2
## [1] 8.36

8 + 9 / (5 ^ 2)
## [1] 8.36

8 + (9 / 5) ^ 2
## [1] 11.24

(8 + 9) / 5 ^ 2
## [1] 0.68
```

By default R will display seven digits but this can be changed using `options()` as previously outlined.


```r
1 / 7
## [1] 0.1428571

options(digits = 3)
1 / 7
## [1] 0.143
```

Also, large numbers will be expressed in scientific notation which can also be adjusted using `options()`.


```r
888888 * 888888
## [1] 7.9e+11

options(digits = 10)
888888 * 888888
## [1] 790121876544
```

Note that the largest number of digits that can be displayed is 22.  Requesting any larger number of digits will result in an error message.


```r
pi
## [1] 3.141592654

options(digits = 22)
pi
## [1] 3.141592653589793115998

options(digits = 23)
## Error in options(digits = 23): invalid 'digits' parameter, allowed 0...22
pi
## [1] 3.141592653589793115998
```

When performing undefined calculations R will produce `Inf` and `NaN` outputs.


```r
1 / 0           # infinity
## [1] Inf

Inf - Inf       # infinity minus infinity
## [1] NaN

-1 / 0          # negative infinity
## [1] -Inf

0 / 0           # not a number
## [1] NaN

sqrt(-9)        # square root of -9
## Warning in sqrt(-9): NaNs produced
## [1] NaN
```

The last two functions to mention are the integer divide (`%/%`) and modulo (`%%`) functions.  The integer divide function will give the integer part of a fraction while the modulo will provide the remainder.


```r
42 / 4          # regular division
## [1] 10.5

42 %/% 4        # integer division
## [1] 10

42 %% 4         # modulo (remainder)
## [1] 2
```



