# Reshaping Your Data with `tidyr`

[Jenny Bryan](https://twitter.com/JennyBryan) stated that "classroom data are like teddy bears and real data are like a grizzley bear with salmon blood dripping out its mouth." In essence, she was getting to the point that often when we learn how to perform a modeling approach in the classroom, the data used is provided in a format that appropriately feeds into the modeling tool of choice. In reality, datasets are messy and "every messy dataset is messy in its own way."[^tidy1] The concept of "tidy data" was established by Hadley Wickham and represents "standardized way to link the structure of a dataset (its physical layout) with its semantics (its meaning)."[^tidy2]  The objective should always to be to get a dataset into a tidy form which consists of:

1. Each variable forms a column
2. Each observation forms a row
3. Each type of observational unit forms a table

To create tidy data you need to be able to reshape your data; preferably via efficient and simple code.  To help with this process Hadley created the [`tidyr`](https://cran.r-project.org/web/packages/tidyr/index.html) package. This chapter covers the basics of `tidyr` to help you reshape your data as necessary. I demonstrate how to turn wide data to long, long data to wide, splitting and combining variables, and finally I will cover some lesser known functions in `tidyr` that are useful.  Note that throughout I use the `%>%` operator we covered in the [last chapter](). Although not required, the `tidyr` package has the `%>%` operator baked in to its functionality, which allows you to sequence multiple tidy functions together.  

## Making wide data long
There are times when our data is considered "wide" or "unstacked" and a common attribute/variable of concern is spread out across columns.  To reformat the data such that these common attributes are *gathered* together as a single variable, the `gather()` function will take multiple columns and collapse them into key-value pairs, duplicating all other columns as needed.

For example, let's say we have the given data frame.

{linenos=off}

```r
library(dplyr) # I'm using dplyr just to create the data frame with tbl_df()

wide <- tbl_df(read.table(header = TRUE, text = "
   Group   Year   Qtr.1  Qtr.2  Qtr.3  Qtr.4
    1      2006   15     16     19     17
    1      2007   12     13     27     23
    1      2008   22     22     24     20
    1      2009   10     14     20     16
    2      2006   12     13     25     18
    2      2007   16     14     21     19
    2      2008   13     11     29     15
    2      2009   23     20     26     20
    3      2006   11     12     22     16
    3      2007   13     11     27     21
    3      2008   17     12     23     19
    3      2009   14     9      31     24
"))
```

This data is considered wide since the *<u>time</u>* variable (represented as quarters) is structured such that each quarter represents a variable. To re-structure the time component as an individual variable, we can *gather* each quarter within one column variable and also *gather* the values associated with each quarter in a second column variable.

{linenos=off}

```r
library(tidyr)

long <- wide %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)

head(long, 15) # note, for brevity, I only show the first 15 observations
## Source: local data frame [15 x 4]
## 
##    Group  Year Quarter Revenue
##    (int) (int)  (fctr)   (int)
## 1      1  2006   Qtr.1      15
## 2      1  2007   Qtr.1      12
## 3      1  2008   Qtr.1      22
## 4      1  2009   Qtr.1      10
## 5      2  2006   Qtr.1      12
## 6      2  2007   Qtr.1      16
## 7      2  2008   Qtr.1      13
## 8      2  2009   Qtr.1      23
## 9      3  2006   Qtr.1      11
## 10     3  2007   Qtr.1      13
## 11     3  2008   Qtr.1      17
## 12     3  2009   Qtr.1      14
## 13     1  2006   Qtr.2      16
## 14     1  2007   Qtr.2      13
## 15     1  2008   Qtr.2      22
```

It's important to note that there is flexibility in how you specify the columns you would like to gather. These all produce the same results:

{linenos=off}

```r
wide %>% gather(Quarter, Revenue, Qtr.1:Qtr.4)
wide %>% gather(Quarter, Revenue, -Group, -Year)
wide %>% gather(Quarter, Revenue, 3:6)
wide %>% gather(Quarter, Revenue, Qtr.1, Qtr.2, Qtr.3, Qtr.4)
```


## Making long data wide
There are also times when we are required to turn long formatted data into wide formatted data.  As a complement to `gather()`, the `spread()` function spreads a key-value pair across multiple columns. So now let's take our `long` data frame from above and and turn the `Quarter` variable into column headings and spread the `Revenue` values across the quarters they are related to.

{linenos=off}

```r
back2wide <- long %>% spread(Quarter, Revenue)
back2wide
## Source: local data frame [12 x 6]
## 
##    Group  Year Qtr.1 Qtr.2 Qtr.3 Qtr.4
##    (int) (int) (int) (int) (int) (int)
## 1      1  2006    15    16    19    17
## 2      1  2007    12    13    27    23
## 3      1  2008    22    22    24    20
## 4      1  2009    10    14    20    16
## 5      2  2006    12    13    25    18
## 6      2  2007    16    14    21    19
## 7      2  2008    13    11    29    15
## 8      2  2009    23    20    26    20
## 9      3  2006    11    12    22    16
## 10     3  2007    13    11    27    21
## 11     3  2008    17    12    23    19
## 12     3  2009    14     9    31    24
```


## Split single column into multiple columns
Many times a single column variable will capture multiple variables, or even parts of a variable you just don't care about.  Some examples follow.  Here, the `Grp_Ind` variable combines an individual variable (a, b, c) with the group variable (1, 2, 3), the `Yr_Mo` variable combines a year variable with a month variable, etc. In each case there may be a purpose for separating parts of these columns into *separate* variables. This can be accomplished using the `separate()` function which turns a single character column into multiple columns.

{linenos=off}


{linenos=off}

```r
messy_df
##   Grp_Ind    Yr_Mo       City_State Extra_variable
## 1     1.a 2006_Jan      Dayton (OH)   XX01person_1
## 2     1.b 2006_Feb Grand Forks (ND)   XX02person_2
## 3     1.c 2006_Mar       Fargo (ND)   XX03person_3
## 4     2.a 2007_Jan   Rochester (MN)   XX04person_4
```

This can be accomplished using the `separate()` function which turns a single character column into multiple columns. Additional arguments provide some flexibility with separating columns.

{linenos=off}

```r
# separate Grp_Ind column into two variables named "Grp" & "Ind"
messy_df %>% separate(col = Grp_Ind, into = c("Grp", "Ind"))
##   Grp Ind    Yr_Mo       City_State Extra_variable
## 1   1   a 2006_Jan      Dayton (OH)   XX01person_1
## 2   1   b 2006_Feb Grand Forks (ND)   XX02person_2
## 3   1   c 2006_Mar       Fargo (ND)   XX03person_3
## 4   2   a 2007_Jan   Rochester (MN)   XX04person_4

# default separater is any non alpha-numeric character but you can 
# specify the specific character to separate at
messy_df %>% separate(col = Extra_variable, into = c("X", "Y"), sep = "_")
##   Grp_Ind    Yr_Mo       City_State          X Y
## 1     1.a 2006_Jan      Dayton (OH) XX01person 1
## 2     1.b 2006_Feb Grand Forks (ND) XX02person 2
## 3     1.c 2006_Mar       Fargo (ND) XX03person 3
## 4     2.a 2007_Jan   Rochester (MN) XX04person 4

# you can keep the original column that you are separating
messy_df %>% separate(col = Grp_Ind, into = c("Grp", "Ind"), remove = FALSE)
##   Grp_Ind Grp Ind    Yr_Mo       City_State Extra_variable
## 1     1.a   1   a 2006_Jan      Dayton (OH)   XX01person_1
## 2     1.b   1   b 2006_Feb Grand Forks (ND)   XX02person_2
## 3     1.c   1   c 2006_Mar       Fargo (ND)   XX03person_3
## 4     2.a   2   a 2007_Jan   Rochester (MN)   XX04person_4
```

## Combine multiple columns into a single column
Similarly, there are times when we would like to combine the values of two variables.  As a compliment to `separate()`, the `unite()` function is a convenient function to paste together multiple variable values into one. Consider the following data frame that has separate date variables. To perform time series analysis or for visualizations we may desire to have a single date column.

{linenos=off}

```r
expenses <- tbl_df(read.table(header = TRUE, text = "
        Year   Month   Day   Expense
        2015      01    01       500
        2015      02    05        90
        2015      02    22       250
        2015      03    10       325
"))
```

To perform time series analysis or for visualizations we may desire to have a single date column. We can accomplish this by *uniting* these columns into one variable with `unite()`.

{linenos=off}

```r
# default separator when uniting is "_"
expenses %>% unite(col = "Date", c(Year, Month, Day))
## Source: local data frame [4 x 2]
## 
##        Date Expense
##       (chr)   (int)
## 1  2015_1_1     500
## 2  2015_2_5      90
## 3 2015_2_22     250
## 4 2015_3_10     325

# specify sep argument to change separater
expenses %>% unite(col = "Date", c(Year, Month, Day), sep = "-")
## Source: local data frame [4 x 2]
## 
##        Date Expense
##       (chr)   (int)
## 1  2015-1-1     500
## 2  2015-2-5      90
## 3 2015-2-22     250
## 4 2015-3-10     325
```

## Additional `tidyr` functions
The previous four functions (`gather`, `spread`, `separate` and `unite`) are the primary functions you will find yourself using on a continuous basis; however, there are some handy functions that are lesser known with the `tidyr` package.

{linenos=off}

```r
expenses <- tbl_df(read.table(header = TRUE, text = "
        Dept    Year   Month   Day         Cost
           A    2015      01    01      $500.00
          NA      NA      02    05       $90.00
          NA      NA      02    22    $1,250.45
          NA      NA      03    NA      $325.10
           B      NA      01    02      $260.00
          NA      NA      02    05       $90.00
", stringsAsFactors = FALSE))
```

Often Excel reports will not repeat certain variables. When we read these reports in, the empty cells are typically filled in with `NA` such as in the `Dept` and `Year` columns of our `expense` data frame. We can fill these values in with the previous entry using `fill()`.

{linenos=off}

```r
expenses %>% fill(Dept, Year)
## Source: local data frame [6 x 5]
## 
##    Dept  Year Month   Day      Cost
##   (chr) (int) (int) (int)     (chr)
## 1     A  2015     1     1   $500.00
## 2     A  2015     2     5    $90.00
## 3     A  2015     2    22 $1,250.45
## 4     A  2015     3    NA   $325.10
## 5     B  2015     1     2   $260.00
## 6     B  2015     2     5    $90.00
```

Also, sometimes accounting values in Excel spreadsheet get read in as a character value, which is the case for the `Cost` variable. We may wish to extract only the numeric part of this regular expression, which can be done with `extract_numeric()`. Note that `extract_numeric` works on a single variable so when you pipe the `expense` data frame into the function you need to use `%$%` operator as discussed in the last chapter.

{linenos=off}

```r
library(magrittr)

expenses %$% extract_numeric(Cost)
## [1]  500.00   90.00 1250.45  325.10  260.00   90.00

# you can use this to convert and save the Cost column to a
# numeric variable
expenses$Cost <- expenses %$% extract_numeric(Cost)
expenses
## Source: local data frame [6 x 5]
## 
##    Dept  Year Month   Day    Cost
##   (chr) (int) (int) (int)   (dbl)
## 1     A  2015     1     1  500.00
## 2    NA    NA     2     5   90.00
## 3    NA    NA     2    22 1250.45
## 4    NA    NA     3    NA  325.10
## 5     B    NA     1     2  260.00
## 6    NA    NA     2     5   90.00
```

You can also easily replace missing (or `NA`) values with a specified value:

{linenos=off}

```r
library(magrittr)

# replace the missing Day value
expenses %>% replace_na(replace = list(Day = "unknown"))
## Source: local data frame [6 x 5]
## 
##    Dept  Year Month     Day    Cost
##   (chr) (int) (int)   (chr)   (dbl)
## 1     A  2015     1       1  500.00
## 2    NA    NA     2       5   90.00
## 3    NA    NA     2      22 1250.45
## 4    NA    NA     3 unknown  325.10
## 5     B    NA     1       2  260.00
## 6    NA    NA     2       5   90.00

# replace both the missing Day and Year values
expenses %>% replace_na(replace = list(Year = 2015, Day = "unknown"))
## Source: local data frame [6 x 5]
## 
##    Dept  Year Month     Day    Cost
##   (chr) (dbl) (int)   (chr)   (dbl)
## 1     A  2015     1       1  500.00
## 2    NA  2015     2       5   90.00
## 3    NA  2015     2      22 1250.45
## 4    NA  2015     3 unknown  325.10
## 5     B  2015     1       2  260.00
## 6    NA  2015     2       5   90.00
```

## Sequencing your `tidyr` operations
Since the `%>%` operator is embedded in `tidyr`, we can string multiple operations together to efficiently tidy data *and* make the process easy to read and follow.  To illustrate, let's use the following data, which has multiple *messy* attributes.  

{linenos=off}

```r
a_mess <- tbl_df(read.table(header = TRUE, text = "
   Dep_Unt   Year     Q1     Q2     Q3     Q4
    A.1      2006     15     NA     19     17
    B.1        NA     12     13     27     23
    A.2        NA     22     22     24     20
    B.2        NA     12     13     25     18
    A.1      2007     16     14     21     19
    B.2        NA     13     11     16     15
    A.2        NA     23     20     26     20
    B.2        NA     11     12     22     16
"))
```

In this case, a tidy dataset should result in columns of Dept, Unit, Year, Quarter, and Cost.  Furthermore, we want to fill in the year column where `NA`s currently exist.  And we'll assume that we know the missing value that exists in the Q2 column, and we'd like to update it.

{linenos=off}

```r
a_mess %>%
        fill(Year) %>%
        gather(Quarter, Cost, Q1:Q4) %>%
        separate(Dep_Unt, into = c("Dept", "Unit")) %>%
        replace_na(replace = list(Cost = 17))
## Source: local data frame [32 x 5]
## 
##     Dept  Unit  Year Quarter  Cost
##    (chr) (chr) (int)  (fctr) (dbl)
## 1      A     1  2006      Q1    15
## 2      B     1  2006      Q1    12
## 3      A     2  2006      Q1    22
## 4      B     2  2006      Q1    12
## 5      A     1  2007      Q1    16
## 6      B     2  2007      Q1    13
## 7      A     2  2007      Q1    23
## 8      B     2  2007      Q1    11
## 9      A     1  2006      Q2    17
## 10     B     1  2006      Q2    13
## ..   ...   ...   ...     ...   ...
```


## Additional resources
This chapter covers most, but not all, of what `tidyr` provides. There are several other resources you can check out to learn more. 

- [Data wrangling presentation](http://bradleyboehmke.github.io/2015/10/data-wrangling-presentation.html) I gave at Miami University
- Hadley Wickham's [tidy data paper](http://jstatsoft.org/v59/i10)
- [`tidyr` reference manual](https://cran.r-project.org/web/packages/tidyr/tidyr.pdf)
- R Studio's [Data wrangling with R and RStudio webinar](http://www.rstudio.com/resources/webinars/)
- R Studio's [Data wrangling GitHub repository](https://github.com/rstudio/webinars/blob/master/2015-01/wrangling-webinar.pdf)
- R Studio's [Data wrangling cheat sheet](http://www.rstudio.com/resources/cheatsheets/)








[^tidy1]: Wickham, H. (2014). "Tidy data." Journal of Statistical Software, 59(10). [[document](http://jstatsoft.org/v59/i10)]
[^tidy2]: Ibid
