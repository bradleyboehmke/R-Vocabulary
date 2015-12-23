# Scraping Text and Data (book)

## Scraping HTML text {#scraping_HTML_text}

Vast amount of information exists across the interminable webpages that exist online.  Much of this information are "unstructured" text that may be useful in our analyses.  This section covers the basics of scraping these texts from online sources.  Throughout this section I will illustrate how to extract different text components of webpages by dissecting the [Wikipedia page on web scraping](https://en.wikipedia.org/wiki/Web_scraping).  However, its important to first cover one of the basic components of HTML elements as we will leverage this information to pull desired information. I offer only enough insight required to begin scraping; I highly recommend [*XML and Web Technologies for Data Sciences with R*](http://www.amazon.com/XML-Web-Technologies-Data-Sciences/dp/1461478995) and [*Automated Data Collection with R*](http://www.amazon.com/Automated-Data-Collection-Practical-Scraping/dp/111883481X/ref=pd_sim_14_1?ie=UTF8&dpID=51Tm7FHxWBL&dpSrc=sims&preST=_AC_UL160_SR108%2C160_&refRID=1VJ1GQEY0VCPZW7VKANX) to learn more about HTML and XML element structures.

HTML elements are written with a start tag, an end tag, and with the content in between: `<tagname>content</tagname>`. The tags which typically contain the textual content we wish to scrape, and the tags we will leverage in the next two sections, include:

- `<h1>`, `<h2>`,...,`<h6>`: Largest heading, second largest heading, etc.
- `<p>`: Paragraph elements
- `<ul>`: Unordered bulleted list
- `<ol>`: Ordered list
- `<li>`: Individual List item
- `<div>`: Division or section
- `<table>`: Table

For example, text in paragraph form that you see online is wrapped with the HTML paragraph tag `<p>` as in:

{linenos=off}

```r
<p>
This paragraph represents
a typical text paragraph
in HTML form
</p>
```

It is through these tags that we can start to extract textual components (also referred to as nodes) of HTML webpages.

### Scraping HTML Nodes
To scrape online text we'll make use of the relatively newer [`rvest`](https://cran.r-project.org/web/packages/rvest/index.html) package. `rvest` was created by the RStudio team inspired by libraries such as [beautiful soup](http://www.crummy.com/software/BeautifulSoup/) which has greatly simplified web scraping. `rvest` provides multiple functionalities; however, in this section we will focus only on extracting HTML text with `rvest`. Its important to note that `rvest` makes use of of the pipe operator (`%>%`) developed through the [`magrittr` package](https://cran.r-project.org/web/packages/magrittr/index.html). If you are not familiar with the functionality of `%>%` I recommend you jump to the chapter on [Simplifying Your Code with `%>%`](#pipe) so that you have a better understanding of what's going on with the code.

To extract text from a webpage of interest, we specify what HTML elements we want to select by using `html_nodes()`.  For instance, if we want to scrape the primary heading for the [Web Scraping Wikipedia webpage](https://en.wikipedia.org/wiki/Web_scraping) we simply identify the `<h1>` node as the node we want to select.  `html_nodes()` will identify all `<h1>` nodes on the webpage and return the HTML element.  In our example we see there is only one `<h1>` node on this webpage.



{linenos=off}

```r
library(rvest)

scraping_wiki <- read_html("https://en.wikipedia.org/wiki/Web_scraping")

scraping_wiki %>%
        html_nodes("h1")
## {xml_nodeset (1)}
## [1] <h1 id="firstHeading" class="firstHeading" lang="en">Web scraping</h1>
```

To extract only the heading text for this `<h1>` node, and not include all the HTML syntax we use `html_text()` which returns the heading text we see at the top of the [Web Scraping Wikipedia page](https://en.wikipedia.org/wiki/Web_scraping).

{linenos=off}

```r
scraping_wiki %>%
        html_nodes("h1") %>%
        html_text()
## [1] "Web scraping"
```

If we want to identify all the second level headings on the webpage we follow the same process but instead select the `<h2>` nodes.  In this example we see there are 10 second level headings on the [Web Scraping Wikipedia page](https://en.wikipedia.org/wiki/Web_scraping).

{linenos=off}

```r
scraping_wiki %>%
        html_nodes("h2") %>%
        html_text()
##  [1] "Contents"                             
##  [2] "Techniques[edit]"                     
##  [3] "Legal issues[edit]"                   
##  [4] "Notable tools[edit]"                  
##  [5] "See also[edit]"                       
##  [6] "Technical measures to stop bots[edit]"
##  [7] "Articles[edit]"                       
##  [8] "References[edit]"                     
##  [9] "See also[edit]"                       
## [10] "Navigation menu"
```

Next, we can move on to extracting much of the text on this webpage which is in paragraph form.  We can follow the same process illustrated above but instead we'll select all `<p>`  nodes.  This selects the 17 paragraph elements from the web page; which we can examine by subsetting the list `p_nodes` to see the first line of each paragraph along with the HTML syntax. Just as before, to extract the text from these nodes and coerce them to a character string we simply apply `html_text()`.

{linenos=off}

```r
p_nodes <- scraping_wiki %>% 
        html_nodes("p")

length(p_nodes)
## [1] 17

p_nodes[1:6]
## {xml_nodeset (6)}
## [1] <p><b>Web scraping</b> (<b>web harvesting</b> or <b>web data extract ...
## [2] <p>Web scraping is closely related to <a href="/wiki/Web_indexing" t ...
## [3] <p/>
## [4] <p/>
## [5] <p>Web scraping is the process of automatically collecting informati ...
## [6] <p>Web scraping may be against the <a href="/wiki/Terms_of_use" titl ...


p_text <- scraping_wiki %>%
        html_nodes("p") %>%
        html_text()

p_text[1]
## [1] "Web scraping (web harvesting or web data extraction) is a computer software technique of extracting information from websites. Usually, such software programs simulate human exploration of the World Wide Web by either implementing low-level Hypertext Transfer Protocol (HTTP), or embedding a fully-fledged web browser, such as Mozilla Firefox."
```

Not too bad; however, we may not have captured all the text that we were hoping for.  Since we extracted text for all `<p>` nodes, we collected all identified paragraph text; however, this does not capture the text in the bulleted lists.  For example, when you look at the [Web Scraping Wikipedia page](https://en.wikipedia.org/wiki/Web_scraping) you will notice a significant amount of text in bulleted list format following the third paragraph under the **[Techniques](https://en.wikipedia.org/wiki/Web_scraping#Techniques)** heading.  If we look at our data we'll see that that the text in this list format are not capture between the two paragraphs:

{linenos=off}

```r
p_text[5]
## [1] "Web scraping is the process of automatically collecting information from the World Wide Web. It is a field with active developments sharing a common goal with the semantic web vision, an ambitious initiative that still requires breakthroughs in text processing, semantic understanding, artificial intelligence and human-computer interactions. Current web scraping solutions range from the ad-hoc, requiring human effort, to fully automated systems that are able to convert entire web sites into structured information, with limitations."

p_text[6]
## [1] "Web scraping may be against the terms of use of some websites. The enforceability of these terms is unclear.[4] While outright duplication of original expression will in many cases be illegal, in the United States the courts ruled in Feist Publications v. Rural Telephone Service that duplication of facts is allowable. U.S. courts have acknowledged that users of \"scrapers\" or \"robots\" may be held liable for committing trespass to chattels,[5][6] which involves a computer system itself being considered personal property upon which the user of a scraper is trespassing. The best known of these cases, eBay v. Bidder's Edge, resulted in an injunction ordering Bidder's Edge to stop accessing, collecting, and indexing auctions from the eBay web site. This case involved automatic placing of bids, known as auction sniping. However, in order to succeed on a claim of trespass to chattels, the plaintiff must demonstrate that the defendant intentionally and without authorization interfered with the plaintiff's possessory interest in the computer system and that the defendant's unauthorized use caused damage to the plaintiff. Not all cases of web spidering brought before the courts have been considered trespass to chattels.[7]"
```

This is because the text in this list format are contained in `<ul>` nodes. To capture the text in lists, we can use the same steps as above but we select specific nodes which represent HTML lists components. We can approach extracting list text two ways.  

First, we can pull all list elements (`<ul>`).  When scraping all `<ul>` text, the resulting data structure will be a character string vector with each element representing a single list consisting of all list items in that list.  In our running example there are 21 list elements as shown in the example that follows.  You can see the first list scraped is the table of contents and the second list scraped is the list in the [Techniques](https://en.wikipedia.org/wiki/Web_scraping#Techniques) section.

{linenos=off}

```r
ul_text <- scraping_wiki %>%
        html_nodes("ul") %>%
        html_text()

length(ul_text)
## [1] 21

ul_text[1]
## [1] "\n1 Techniques\n2 Legal issues\n3 Notable tools\n4 See also\n5 Technical measures to stop bots\n6 Articles\n7 References\n8 See also\n"

# read the first 200 characters of the second list
substr(ul_text[2], start = 1, stop = 200)
## [1] "\nHuman copy-and-paste: Sometimes even the best web-scraping technology cannot replace a human’s manual examination and copy-and-paste, and sometimes this may be the only workable solution when the web"
```

An alternative approach is to pull all `<li>` nodes.  This will pull the text contained in each list item for all the lists.  In our running example there's 146 list items that we can extract from this Wikipedia page.  The first eight list items are the list of contents we see towards the top of the page. List items 9-17 are the list elements contained in the "[Techniques](https://en.wikipedia.org/wiki/Web_scraping#Techniques)" section, list items 18-44 are the items listed under the "[Notable Tools](https://en.wikipedia.org/wiki/Web_scraping#Notable_tools)" section, and so on.  

{linenos=off}

```r
li_text <- scraping_wiki %>%
        html_nodes("li") %>%
        html_text()

length(li_text)
## [1] 147

li_text[1:8]
## [1] "1 Techniques"                      "2 Legal issues"                   
## [3] "3 Notable tools"                   "4 See also"                       
## [5] "5 Technical measures to stop bots" "6 Articles"                       
## [7] "7 References"                      "8 See also"
```

At this point we may believe we have all the text desired and proceed with joining the paragraph (`p_text`) and list (`ul_text` or `li_text`) character strings and then perform the desired textual analysis.  However, we may now have captured *more* text than we were hoping for.  For example, by scraping all lists we are also capturing the listed links in the left margin of the webpage. If we look at the 104-136 list items that we scraped, we'll see that these texts correspond to the left margin text. 

{linenos=off}

```r
li_text[104:136]
##  [1] "Main page"           "Contents"            "Featured content"   
##  [4] "Current events"      "Random article"      "Donate to Wikipedia"
##  [7] "Wikipedia store"     "Help"                "About Wikipedia"    
## [10] "Community portal"    "Recent changes"      "Contact page"       
## [13] "What links here"     "Related changes"     "Upload file"        
## [16] "Special pages"       "Permanent link"      "Page information"   
## [19] "Wikidata item"       "Cite this page"      "Create a book"      
## [22] "Download as PDF"     "Printable version"   "Català"             
## [25] "Deutsch"             "Español"             "Français"           
## [28] "Íslenska"            "Italiano"            "Latviešu"           
## [31] "Nederlands"          "日本語"              "Српски / srpski"
```

If we desire to scrape every piece of text on the webpage than this won't be of concern.  In fact, if we want to scrape all the text regardless of the content they represent there is an easier approach.  We can capture all the content to include text in paragraph (`<p>`), lists (`<ul>`, `<ol>`, and `<li>`), and even data in tables (`<table>`) by using `<div>`.  This is because these other elements are usually a subsidiary of an HTML division or section so pulling all `<div>` nodes will extract all text contained in that division or section regardless if it is also contained in a paragraph or list.

{linenos=off}

```r
all_text <- scraping_wiki %>%
        html_nodes("div") %>% 
        html_text()
```

### Scraping Specific HTML Nodes {#scraping_specific_nodes}
However, if we are concerned only with specific content on the webpage then we need to make our HTML node selection process a little more focused.  To do this we, we can use our browser's developer tools to examine the webpage we are scraping and get more details on specific nodes of interest.  If you are using Chrome or Firefox you can open the developer tools by clicking F12 (Cmd + Opt + I for Mac) or for Safari you would use Command-Option-I. An additional option which is recommended by Hadley Wickham is to use [selectorgadget.com](http://selectorgadget.com/), a Chrome extension, to help identify the web page elements you need[^selector]. 

Once the developers tools are opened your primary concern is with the element selector. This is located in the top lefthand corner of the developers tools window. 

<center>
<img src="images/element_selector.jpg" alt="Element Selector Tool">
</center> 
<br>

Once you've selected the element selector you can now scroll over the elements of the webpage which will cause each element you scroll over to be highlighted.  Once you've identified the element you want to focus on, select it. This will cause the element to be identified in the developer tools window. For example, if I am only interested in the main body of the Web Scraping content on the Wikipedia page then I would select the element that highlights the entire center component of the webpage.  This highlights the corresponding element `<div id="bodyContent" class="mw-body-content">` in the developer tools window as the following illustrates.

<center>
<img src="images/body_content_selected.png" alt="Body Content Selected">
</center>  
<br>

I can now use this information to select and scrape all the text from this specific `<div>` node by calling the ID name ("#mw-content-text") in `html_nodes()`[^selector2].  As you can see below, the text that is scraped begins with the first line in the main body of the Web Scraping content and ends with the text in the [See Also](https://en.wikipedia.org/wiki/Web_scraping#See_also_2) section which is the last bit of text directly pertaining to Web Scraping on the webpage. Explicitly, we have pulled the specific text associated with the web content we desire.

{linenos=off}

```r
body_text <- scraping_wiki %>%
        html_nodes("#mw-content-text") %>% 
        html_text()

# read the first 207 characters
substr(body_text, start = 1, stop = 207)
## [1] "Web scraping (web harvesting or web data extraction) is a computer software technique of extracting information from websites. Usually, such software programs simulate human exploration of the World Wide Web"

# read the last 73 characters
substr(body_text, start = nchar(body_text)-73, stop = nchar(body_text))
## [1] "See also[edit]\n\nData scraping\nData wrangling\nKnowledge extraction\n\n\n\n\n\n\n\n\n"
```

Using the developer tools approach allows us to be as specific as we desire.  We can identify the class name for a specific HTML element and scrape the text for only that node rather than all the other elements with similar tags. This allows us to scrape the main body of content as we just illustrated or we can also identify specific headings, paragraphs, lists, and list components if we desire to scrape only these specific pieces of text: 

{linenos=off}

```r
# Scraping a specific heading
scraping_wiki %>%
        html_nodes("#Techniques") %>% 
        html_text()
## [1] "Techniques"

# Scraping a specific paragraph
scraping_wiki %>%
        html_nodes("#mw-content-text > p:nth-child(20)") %>% 
        html_text()
## [1] "In Australia, the Spam Act 2003 outlaws some forms of web harvesting, although this only applies to email addresses.[20][21]"

# Scraping a specific list
scraping_wiki %>%
        html_nodes("#mw-content-text > div:nth-child(22)") %>% 
        html_text()
## [1] "\n\nApache Camel\nArchive.is\nAutomation Anywhere\nConvertigo\ncURL\nData Toolbar\nDiffbot\nFirebug\nGreasemonkey\nHeritrix\nHtmlUnit\nHTTrack\niMacros\nImport.io\nJaxer\nNode.js\nnokogiri\nPhantomJS\nScraperWiki\nScrapy\nSelenium\nSimpleTest\nwatir\nWget\nWireshark\nWSO2 Mashup Server\nYahoo! Query Language (YQL)\n\n"

# Scraping a specific reference list item
scraping_wiki %>%
        html_nodes("#cite_note-22") %>% 
        html_text()
## [1] "^ \"Web Scraping: Everything You Wanted to Know (but were afraid to ask)\". Distil Networks. 2015-07-22. Retrieved 2015-11-04. "
```

### Cleaning up
With any webscraping activity, especially involving text, there is likely to be some clean-up involved. For example, in the previous example we saw that we can specifically pull the list of [**Notable Tools**](https://en.wikipedia.org/wiki/Web_scraping#Notable_tools); however, you can see that in between each list item rather than a space there contains one or more `\n` which is used in HTML to specify a new line. We can clean this up quickly with a little [character string manipulation](#string_manipulation).


```r
library(magrittr)

scraping_wiki %>%
        html_nodes("#mw-content-text > div:nth-child(22)") %>% 
        html_text()
## [1] "\n\nApache Camel\nArchive.is\nAutomation Anywhere\nConvertigo\ncURL\nData Toolbar\nDiffbot\nFirebug\nGreasemonkey\nHeritrix\nHtmlUnit\nHTTrack\niMacros\nImport.io\nJaxer\nNode.js\nnokogiri\nPhantomJS\nScraperWiki\nScrapy\nSelenium\nSimpleTest\nwatir\nWget\nWireshark\nWSO2 Mashup Server\nYahoo! Query Language (YQL)\n\n"

scraping_wiki %>%
        html_nodes("#mw-content-text > div:nth-child(22)") %>% 
        html_text() %>% 
        strsplit(split = "\n") %>%
        unlist() %>%
        .[. != ""]
##  [1] "Apache Camel"                "Archive.is"                 
##  [3] "Automation Anywhere"         "Convertigo"                 
##  [5] "cURL"                        "Data Toolbar"               
##  [7] "Diffbot"                     "Firebug"                    
##  [9] "Greasemonkey"                "Heritrix"                   
## [11] "HtmlUnit"                    "HTTrack"                    
## [13] "iMacros"                     "Import.io"                  
## [15] "Jaxer"                       "Node.js"                    
## [17] "nokogiri"                    "PhantomJS"                  
## [19] "ScraperWiki"                 "Scrapy"                     
## [21] "Selenium"                    "SimpleTest"                 
## [23] "watir"                       "Wget"                       
## [25] "Wireshark"                   "WSO2 Mashup Server"         
## [27] "Yahoo! Query Language (YQL)"
```


Similarly, as we saw in our example above with scraping the main body content (`body_text`), there are extra characters (i.e. `\n`, `\`, `^`) in the text that we may not want.  Using a [little regex](#regex) we can clean this up so that our character string consists of only text that we see on the screen and no additional HTML code embedded throughout the text.


```r
library(stringr)

# read the last 700 characters
substr(body_text, start = nchar(body_text)-700, stop = nchar(body_text))
## [1] " 2010). \"Intellectual Property: Website Terms of Use\". Issue 26: June 2010. LK Shields Solicitors Update. p. 03. Retrieved 2012-04-19. \n^ National Office for the Information Economy (February 2004). \"Spam Act 2003: An overview for business\" (PDF). Australian Communications Authority. p. 6. Retrieved 2009-03-09. \n^ National Office for the Information Economy (February 2004). \"Spam Act 2003: A practical guide for business\" (PDF). Australian Communications Authority. p. 20. Retrieved 2009-03-09. \n^ \"Web Scraping: Everything You Wanted to Know (but were afraid to ask)\". Distil Networks. 2015-07-22. Retrieved 2015-11-04. \n\n\nSee also[edit]\n\nData scraping\nData wrangling\nKnowledge extraction\n\n\n\n\n\n\n\n\n"

# clean up text
body_text %>%
        str_replace_all(pattern = "\n", replacement = " ") %>%
        str_replace_all(pattern = "[\\^]", replacement = " ") %>%
        str_replace_all(pattern = "\"", replacement = " ") %>%
        str_replace_all(pattern = "\\s+", replacement = " ") %>%
        str_trim(side = "both") %>%
        substr(start = nchar(body_text)-700, stop = nchar(body_text))
## [1] "012-04-19. National Office for the Information Economy (February 2004). Spam Act 2003: An overview for business (PDF). Australian Communications Authority. p. 6. Retrieved 2009-03-09. National Office for the Information Economy (February 2004). Spam Act 2003: A practical guide for business (PDF). Australian Communications Authority. p. 20. Retrieved 2009-03-09. Web Scraping: Everything You Wanted to Know (but were afraid to ask) . Distil Networks. 2015-07-22. Retrieved 2015-11-04. See also[edit] Data scraping Data wrangling Knowledge extraction"
```


So there we have it, text scraping in a nutshell.  Although not all encompassing, this section covered the basics of scraping text from HTML documents. Whether you want to scrape text from all common text-containing nodes such as `<div>`, `<p>`, `<ul>` and the like or you want to scrape from a specific node using the specific ID, this section provides you the basic fundamentals of using `rvest` to scrape the text you need. In the next section we move on to scraping data from HTML tables.



## Scraping HTML table data {#scraping_HTML_tables}
Another common structure of information storage on the Web is in the form of HTML tables. This section reiterates some of the information from the [previous section](#scraping_HTML_text); however, we focus solely on scraping data from HTML tables. The simplest approach to scraping HTML table data directly into R is by using either the [`rvest` package](#scraping_tables_rvest)  or the [`XML` package](#scraping_tables_xml).  To illustrate, I will focus on the [BLS employment statistics webpage](http://www.bls.gov/web/empsit/cesbmart.htm) which contains multiple HTML tables from which we can scrape data.

### Scraping HTML tables with rvest {#scraping_tables_rvest}
Recall that HTML elements are written with a start tag, an end tag, and with the content in between: `<tagname>content</tagname>`. HTML tables are contained within `<table>` tags; therefore, to extract the tables from the BLS employment statistics webpage we first use the `html_nodes()` function to select the `<table>` nodes.  In this case we are interested in all table nodes that exist on the webpage. In this example, `html_nodes` captures 15 HTML tables. This includes data from the 10 data tables seen on the webpage but also includes data from a few additional tables used to format parts of the page (i.e. table of contents, table of figures, advertisements).


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

Remember that `html_nodes()` does not parse the data; rather, it acts as a CSS selector. To parse the HTML table data we use `html_table()`, which would create a list containing 15 data frames.  However, rarely do we need to scrape *every* HTML table from a page, especially since some HTML tables don't catch any information we are likely interested in (i.e. table of contents, table of figures, footers). 

More often than not we want to parse specific tables. Lets assume we want to parse the second and third tables on the webpage:

1. Table 2. Nonfarm employment benchmarks by industry, March 2014 (in thousands) and
2. Table 3. Net birth/death estimates by industry supersector, April – December 2014 (in thousands) 

This can be accomplished two ways. First, we can assess the previous `tbls` list and try to identify the table(s) of interest. In this example it appears that `tbls` list items 3 and 4 correspond with Table 2 and Table 3, respectively. We can then subset the list of table nodes prior to parsing the data with `html_table()`. This results in a list of two data frames containing the data of interest.


```r
library(rvest)

webpage <- read_html("http://www.bls.gov/web/empsit/cesbmart.htm")

# subset list of table nodes for items 3 & 4
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

An alternative approach, which is more explicit, is to use the [element selector process described in the previous section](#scraping_specific_nodes) to call the table ID name. 


```r
# empty list to add table data to
tbls2_ls <- list()

# scrape Table 2. Nonfarm employment...
tbls2_ls$Table1 <- webpage %>%
        html_nodes("#Table2") %>% 
        html_table(fill = TRUE) %>%
        .[[1]]

# Table 3. Net birth/death...
tbls2_ls$Table2 <- webpage %>%
        html_nodes("#Table3") %>% 
        html_table() %>%
        .[[1]]

str(tbls2_ls)
## List of 2
##  $ Table1:'data.frame':	147 obs. of  6 variables:
##   ..$ CES Industry Code : chr [1:147] "Amount" "00-000000" "05-000000" "06-000000" ...
##   ..$ CES Industry Title: chr [1:147] "Percent" "Total nonfarm" "Total private" "Goods-producing" ...
##   ..$ Benchmark         : chr [1:147] NA "137,214" "114,989" "18,675" ...
##   ..$ Estimate          : chr [1:147] NA "137,147" "114,884" "18,558" ...
##   ..$ Differences       : num [1:147] NA 67 105 117 -50 -12 -16 -2.8 -13.2 -13.5 ...
##   ..$ NA                : chr [1:147] NA "(1)" "0.1" "0.6" ...
##  $ Table2:'data.frame':	11 obs. of  12 variables:
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

One issue to note is when using `rvest`'s `html_table()` to read a table with split column headings as in *Table 2. Nonfarm employment...*.  `html_table` will cause split headings to be included and can cause the first row to include parts of the headings.  We can see this with Table 2.  This requires a little clean up.


```r

head(tbls2_ls[[1]], 4)
##   CES Industry Code CES Industry Title Benchmark Estimate Differences   NA
## 1            Amount            Percent      <NA>     <NA>          NA <NA>
## 2         00-000000      Total nonfarm   137,214  137,147          67  (1)
## 3         05-000000      Total private   114,989  114,884         105  0.1
## 4         06-000000    Goods-producing    18,675   18,558         117  0.6

# remove row 1 that includes part of the headings
tbls2_ls[[1]] <- tbls2_ls[[1]][-1,]

# rename table headings
colnames(tbls2_ls[[1]]) <- c("CES_Code", "Ind_Title", "Benchmark",
                            "Estimate", "Amt_Diff", "Pct_Diff")

head(tbls2_ls[[1]], 4)
##    CES_Code         Ind_Title Benchmark Estimate Amt_Diff Pct_Diff
## 2 00-000000     Total nonfarm   137,214  137,147       67      (1)
## 3 05-000000     Total private   114,989  114,884      105      0.1
## 4 06-000000   Goods-producing    18,675   18,558      117      0.6
## 5 07-000000 Service-providing   118,539  118,589      -50      (1)
```


### Scraping HTML tables with XML {#scraping_tables_xml}
An alternative to `rvest` for table scraping is to use the [`XML`](https://cran.r-project.org/web/packages/XML/index.html) package. The XML package provides a convenient `readHTMLTable()` function to extract data from HTML tables in HTML documents.  By passing the URL to `readHTMLTable()`, the data in each table is read and stored as a data frame.  In a situation like our running provides where multiple tables exists, the data frames will be stored in a list similar to `rvest`'s `html_table`.


```r
library(XML)

url <- "http://www.bls.gov/web/empsit/cesbmart.htm"

# read in HTML data
tbls_xml <- readHTMLTable(url)

typeof(tbls_xml)
## [1] "list"

length(tbls_xml)
## [1] 15
```

`tbls_xml` captures the same 15 `<table>` nodes that `html_nodes` captured. To capture the same tables of interest we previously discussed (*Table 2. Nonfarm employment...* and *Table 3. Net birth/death...*) we can use a couple approaches. First, we can assess `str(tbls_xml)` to identify the tables of interest and perform normal [list subsetting](#lists_subset).


```r
head(tbls_xml[[3]])
##          V1                        V2      V3      V4  V5   V6
## 1 00-000000             Total nonfarm 137,214 137,147  67  (1)
## 2 05-000000             Total private 114,989 114,884 105  0.1
## 3 06-000000           Goods-producing  18,675  18,558 117  0.6
## 4 07-000000         Service-providing 118,539 118,589 -50  (1)
## 5 08-000000 Private service-providing  96,314  96,326 -12  (1)
## 6 10-000000        Mining and logging     868     884 -16 -1.8

head(tbls_xml[[4]], 3)
##   CES Industry Code CES Industry Title Apr May Jun Jul Aug Sep Oct Nov Dec
## 1         10-000000 Mining and logging   2   2   2   2   1   1   1   1   0
## 2         20-000000       Construction  35  37  24  12  12   7  12 -10 -21
## 3         30-000000      Manufacturing   0   6   4  -3   4   1   3   2   0
##   CumulativeTotal
## 1              12
## 2             108
## 3              17
```

Second, we can use the `which` argument in `readHTMLTable()` which restricts the data importing to only those tables specified numerically.


```r
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



[^selector]: You can learn more about selectors at [flukeout.github.io](http://flukeout.github.io/)

[^selector2]: You can simply assess the name of the ID in the highlighted element or you can  right click the highlighted element in the developer tools window and select *Copy selector*.  You can then paste directly into `html_nodes() as it will paste the exact ID name that you need for that element.


