
<!-- README.md is generated from README.Rmd. Please edit that file -->
R FAQ 7.31
----------

is probably the most [famous FAQ](https://cran.r-project.org/doc/FAQ/R-FAQ.html#Why-doesn_0027t-R-think-these-numbers-are-equal_003f), so it deserves its own 📦 to help you 🕵️ the confusion of

``` r
0.3 + 0.6 == 0.9
#> [1] FALSE
sqrt(2)^2 == 2
#> [1] FALSE
```

This [wikipedia article](https://en.wikipedia.org/wiki/Double-precision_floating-point_format) is a good introduction to the Double-precision floating-point format.

Installation
------------

From github:

``` r
devtools::install_github( "ThinkRstat/seven31" )
```

Show the bits of one number
---------------------------

`double` (what we call `numeric` in R) are encoded in 64 bits:

-   the first bit is the sign bit
-   the 11 following bits are the exponent
-   the remaining 52 bits are the fraction

`reveal` 🔍 the binary representation of a number

``` r
seven31::reveal( 0 )
#> 0 00000000000 (-1023) 0000000000000000000000000000000000000000000000000000
seven31::reveal( -0 )
#> 1 00000000000 (-1023) 0000000000000000000000000000000000000000000000000000
seven31::reveal( pi )
#> 0 10000000000 (    1) 1001001000011111101101010100010001000010110100011000
seven31::reveal( NA )
#> 0 11111111111 ( 1024) 0000000000000000000000000000000000000000011110100010
seven31::reveal( NaN )
#> 0 11111111111 ( 1024) 1000000000000000000000000000000000000000000000000000
```

On a 🖍 compatible environment, you get colors:

![](img/reveal.png)

Compare two numbers
-------------------

`compare` shows the differences.

``` r
seven31::compare( 2, sqrt(2)^2 )
#> 0 10000000000 (    1) 0000000000000000000000000000000000000000000000000000 : 2         
#> 0 10000000000 (    1) 0000000000000000000000000000000000000000000000000001 : sqrt(2)^2
seven31::compare( 0.3 + 0.6, 0.9 )
#> 0 01111111110 (   -1) 1100110011001100110011001100110011001100110011001100 : 0.3 + 0.6 
#> 0 01111111110 (   -1) 1100110011001100110011001100110011001100110011001101 : 0.9
```

On 🖍 compatible environments, the bits that differ between the two numbers are highlighted with 🔴 background.

![](img/compare.png)
