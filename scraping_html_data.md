# Scraping HTML Tables

The next common structure of data storage on the Web is in the form of HTML tables. The simplest approach to scraping HTML table data directly into R is by using either the XML package or the `rvest` package.  We can illustrate with this [BLS employment statistics webpage](http://www.bls.gov/web/empsit/cesbmart.htm) which contains multiple HTML tables.  

### Scraping HTML tables with XML 
The XML package provides a convenient `readHTMLTable()` function to extract data from HTML tables in HTML documents.  By passing the URL to `readHTMLTable()`, the data in each table is read and stored as a data frame.  In a case like this where multiple tables exists, the data frames will be stored in a list as illustrated.


```r
library(XML)

url <- "http://www.bls.gov/web/empsit/cesbmart.htm"

# read in HTML data
tbls <- readHTMLTable(url)

typeof(tbls)
## [1] "list"

length(tbls)
## [1] 15
```

The list `tbl` contains 15 items.  This includes data from the 10 data tables seen on the webpage but also includes data from a few additional tables used to format parts of the page (i.e. table of contents, table of figures, advertisements). Using `str(tbl)`, you can investigate the data frames in the list to help identify the data you are interested in pulling.  Lets assume we are interested in pulling data from the second and third tables on the webpage (i) *Table 2. Nonfarm employment benchmarks by industry, March 2014 (in thousands)* and (ii) *Table 3. Net birth/death estimates by industry supersector, April – December 2014 (in thousands)*.  By assessing `str(tbl)` you will see that these data are captured as the third and fourth items in `tbl` with the convenient titles `Table2` and `Table3` respectively. 

You can access these two data frames via normal list [subsetting](LINK TO SECTION) or by using the `which` argument in `readHTMLTable()` which restricts the data importing to only those tables specified.  Also, note that the variables in Table 2 have variable names: `V1`, `V2`,...,`V8`.  When HTML tables have split headers as is the case with Table 2, the variable names are stripped and replaced with generic names because R does not know which variable names should align with each column.


```r
head(tbls[[3]])
##          V1                        V2      V3      V4  V5   V6
## 1 00-000000             Total nonfarm 137,214 137,147  67  (1)
## 2 05-000000             Total private 114,989 114,884 105  0.1
## 3 06-000000           Goods-producing  18,675  18,558 117  0.6
## 4 07-000000         Service-providing 118,539 118,589 -50  (1)
## 5 08-000000 Private service-providing  96,314  96,326 -12  (1)
## 6 10-000000        Mining and logging     868     884 -16 -1.8

head(tbls[[4]], 3)
##   CES Industry Code CES Industry Title Apr May Jun Jul Aug Sep Oct Nov Dec
## 1         10-000000 Mining and logging   2   2   2   2   1   1   1   1   0
## 2         20-000000       Construction  35  37  24  12  12   7  12 -10 -21
## 3         30-000000      Manufacturing   0   6   4  -3   4   1   3   2   0
##   CumulativeTotal
## 1              12
## 2             108
## 3              17

# an alternative is to explicitly state which 
# table(s) to download
emp_ls <- readHTMLTable(url, which = c(3,4))

str(emp_ls)
## List of 2
##  $ Table2:'data.frame':	145 obs. of  6 variables:
##   ..$ V1: Factor w/ 145 levels "00-000000","05-000000",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ V2: Factor w/ 143 levels "Accommodation",..: 130 131 52 116 102 74 67 73 90 75 ...
##   ..$ V3: Factor w/ 145 levels "1,010.3","1,048.3",..: 40 35 48 37 145 140 109 135 51 65 ...
##   ..$ V4: Factor w/ 145 levels "1,008.4","1,052.3",..: 41 34 48 36 144 142 109 136 66 65 ...
##   ..$ V5: Factor w/ 123 levels "-0.3","-0.4",..: 113 68 71 48 9 19 29 11 12 43 ...
##   ..$ V6: Factor w/ 56 levels "-0.1","-0.2",..: 30 31 36 30 30 16 28 14 29 22 ...
##  $ Table3:'data.frame':	11 obs. of  12 variables:
##   ..$ CES Industry Code : Factor w/ 11 levels "10-000000","20-000000",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ CES Industry Title: Factor w/ 11 levels "263","Construction",..: 8 2 7 11 5 4 10 3 6 9 ...
##   ..$ Apr               : Factor w/ 10 levels "0","12","2","204",..: 3 7 1 5 1 8 9 6 10 2 ...
##   ..$ May               : Factor w/ 10 levels "129","13","2",..: 3 6 8 5 7 9 4 2 10 8 ...
##   ..$ Jun               : Factor w/ 10 levels "-14","0","12",..: 5 6 7 3 2 7 8 1 10 9 ...
##   ..$ Jul               : Factor w/ 10 levels "-1","-2","-3",..: 6 5 3 10 1 7 8 10 9 2 ...
##   ..$ Aug               : Factor w/ 9 levels "-19","1","12",..: 2 3 9 4 8 9 5 6 7 8 ...
##   ..$ Sep               : Factor w/ 9 levels "-1","-12","-2",..: 5 8 5 9 1 1 2 6 4 3 ...
##   ..$ Oct               : Factor w/ 10 levels "-17","1","12",..: 2 3 6 5 9 4 10 7 1 8 ...
##   ..$ Nov               : Factor w/ 8 levels "-10","-15","-22",..: 4 1 7 5 8 8 6 6 3 4 ...
##   ..$ Dec               : Factor w/ 8 levels "-10","-21","-3",..: 4 2 4 7 4 6 1 3 7 5 ...
##   ..$ CumulativeTotal   : Factor w/ 10 levels "107","108","12",..: 3 2 6 4 5 10 7 1 8 9 ...
```

### Scraping HTML tables with rvest



[`rvest`](https://cran.r-project.org/web/packages/rvest/index.html) is a relatively newer package created by the RStudio team inspired by libraries such as [beautiful soup](http://www.crummy.com/software/BeautifulSoup/). `rvest` provides multiple functionalities such as extracting tag names, text, data, and attributes; detecting and repairing encoding issues; navigating around a website and more.  However, this section focuses only on extracting HTML table data with `rvest`.

To extract the table(s) of interest we first use the `html_nodes()` function to select the CSS nodes of interest.  In this case we are interested in all table nodes that exist in the webpage. `html_nodes` will capture all 15 HTML tables similar to `XML`'s `readHTMLTable()`. However, `html_nodes` does not parse the data; rather, it acts as a CSS selector.


```r
library(rvest)

webpage <- read_html("http://www.bls.gov/web/empsit/cesbmart.htm")

tbls <- html_nodes(webpage, "table")

head(tbls)
## {xml_nodeset (6)}
## [1] <table id="main-content-table">&#13;\n\t<tr>&#13;\n\t\t<td id="secon ...
## [2] <table id="Table1" class="regular" cellspacing="0" cellpadding="0" x ...
## [3] <table id="Table2" class="regular" cellspacing="0" cellpadding="0" x ...
## [4] <table id="Table3" class="regular" cellspacing="0" cellpadding="0" x ...
## [5] <table id="Table4" class="regular" cellspacing="0" cellpadding="0" x ...
## [6] <table id="Exhibit1" class="regular" cellspacing="0" cellpadding="0" ...
```

Looking through `tbls` we can see that the two tables of interest ("Table2" & "Table3") are captured as list items 3 & 4 above. We can now use `html_table()` to parse the HTML tables into data frames.  Since we are extracting two tables `html_table()` will create a list containing two data frames for the HTML tables parsed. Also, note that `rvest` makes use of the pipe operator (`%>%`) developed through the `magrittr` package.  The functionality of this operator is discussed in more detail in [Chapter XX]().


```r
webpage <- read_html("http://www.bls.gov/web/empsit/cesbmart.htm")

tbls_ls <- webpage %>%
        html_nodes("table") %>%
        .[3:4] %>%
        html_table(fill = TRUE)

str(tbls_ls)
## List of 2
##  $ :'data.frame':	147 obs. of  6 variables:
##   ..$ CES Industry Code : chr [1:147] "Amount" "00-000000" "05-000000" "06-000000" ...
##   ..$ CES Industry Title: chr [1:147] "Percent" "Total nonfarm" "Total private" "Goods-producing" ...
##   ..$ Benchmark         : chr [1:147] NA "137,214" "114,989" "18,675" ...
##   ..$ Estimate          : chr [1:147] NA "137,147" "114,884" "18,558" ...
##   ..$ Differences       : num [1:147] NA 67 105 117 -50 -12 -16 -2.8 -13.2 -13.5 ...
##   ..$ NA                : chr [1:147] NA "(1)" "0.1" "0.6" ...
##  $ :'data.frame':	11 obs. of  12 variables:
##   ..$ CES Industry Code : chr [1:11] "10-000000" "20-000000" "30-000000" "40-000000" ...
##   ..$ CES Industry Title: chr [1:11] "Mining and logging" "Construction" "Manufacturing" "Trade, transportation, and utilities" ...
##   ..$ Apr               : int [1:11] 2 35 0 21 0 8 81 22 82 12 ...
##   ..$ May               : int [1:11] 2 37 6 24 5 8 22 13 81 6 ...
##   ..$ Jun               : int [1:11] 2 24 4 12 0 4 5 -14 86 6 ...
##   ..$ Jul               : int [1:11] 2 12 -3 7 -1 3 35 7 62 -2 ...
##   ..$ Aug               : int [1:11] 1 12 4 14 3 4 19 21 23 3 ...
##   ..$ Sep               : int [1:11] 1 7 1 9 -1 -1 -12 12 -33 -2 ...
##   ..$ Oct               : int [1:11] 1 12 3 28 6 16 76 35 -17 4 ...
##   ..$ Nov               : int [1:11] 1 -10 2 10 3 3 14 14 -22 1 ...
##   ..$ Dec               : int [1:11] 0 -21 0 4 0 10 -10 -3 4 1 ...
##   ..$ CumulativeTotal   : int [1:11] 12 108 17 129 15 55 230 107 266 29 ...
```

One difference to note when using `rvest`'s `html_table` versus using `XML`'s `readHTMLTable` is when reading split column headings.  As we saw earlier in this chapter, `readHTMLTable` will cause split headings to be stripped and replaced with generic "VX" titles.  `html_table` , on other hand, will cause split headings to be included and can cause the first row to include parts of the headings.  We can see this with Table 2.  This may require some data clean up.


```r

head(tbls_ls[[1]], 4)
##   CES Industry Code CES Industry Title Benchmark Estimate Differences   NA
## 1            Amount            Percent      <NA>     <NA>          NA <NA>
## 2         00-000000      Total nonfarm   137,214  137,147          67  (1)
## 3         05-000000      Total private   114,989  114,884         105  0.1
## 4         06-000000    Goods-producing    18,675   18,558         117  0.6

# remove row 1 that includes part of the headings
tbls_ls[[1]] <- tbls_ls[[1]][-1,]

# rename table headings
colnames(tbls_ls[[1]]) <- c("CES_Code", "Ind_Title", "Benchmark",
                            "Estimate", "Amt_Diff", "Pct_Diff")

head(tbls_ls[[1]], 4)
##    CES_Code         Ind_Title Benchmark Estimate Amt_Diff Pct_Diff
## 2 00-000000     Total nonfarm   137,214  137,147       67      (1)
## 3 05-000000     Total private   114,989  114,884      105      0.1
## 4 06-000000   Goods-producing    18,675   18,558      117      0.6
## 5 07-000000 Service-providing   118,539  118,589      -50      (1)
```





