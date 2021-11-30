<!-- README.md is generated from README.Rmd. Please edit that file -->

# tidymass <img src="man/figures/logo.png" align="right" alt="" width="120" />

[![](https://www.r-pkg.org/badges/version/tidymass?color=green)](https://cran.r-project.org/package=tidymass)
[![](https://img.shields.io/github/languages/code-size/tidymass/tidymass.svg)](https://github.com/tidymass/tidymass)
[![Dependencies](https://tinyverse.netlify.com/badge/tidymass)](https://cran.r-project.org/package=tidymass)
[![](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

## About

`tidymass` is a collections of R packages for Mass Spectrometry data
processing, analysis.

## Installation

You can install `tidymass` from
[Github](https://github.com/tidymass/tidymass).

``` r
if(!require(devtools)){
install.packages("devtools")
}
devtools::install_github("tidymass/tidymass")
```

Then you can use `install_tidymass()` to install all the packages in
`tidymass`.

``` r
library(tidymass)
```

``` r
tidymass::install_tidymass(from = "github", force = FALSE)
```

## Usage

Now, `tidymass` contains several packages listed below:

### massdataset <a href="https://tidymass.github.io/massdataset/" target="_blank"><img src="man/figures/massdataset_logo.png" align="left" alt="" width="120" /></a>

<br>

`massdataset` is a R package which is used organize metabolomics data to a `tidymass-class` object which can be processed by all the `tidymass` packages.

<br>

### massprocesser <a href="https://tidymass.github.io/massprocesser/" target="_blank"><img src="man/figures/massprocesser_logo.png" align="left" alt="" width="120" /></a>

<br>

`massprocesser` is a R package which is used for mass spectrometry based untargeted metabolomics raw data processing.

<br>

### masscleaner <a href="https://tidymass.github.io/masscleaner/" target="_blank"><img src="man/figures/masscleaner_logo.png" align="left" alt="" width="120" /></a>

<br>

`masscleaner` is a R package which is used for metabolomics data cleaning.

<br>

### metnormalizer <a href="https://tidymass.github.io/MetNormalizer/" target="_blank"><img src="man/figures/metnormalizer_logo.png" align="left" alt="" width="120" /></a>

<br>

`metnormalizer` is used for metabolomics data normalization and integration based on SVM. Now it is integrated into `masscleaner`.

<br>

### metid <a href="https://tidymass.github.io/metid/" target="_blank"><img src="man/figures/lipidflow_logo.png" align="left" alt="" width="120" /></a>

<br>

`metid` is used for metabolite database construction and metabolite annotation.

<br>

### lipidflow <a href="https://tidymass.github.io/lipidflow/" target="_blank"><img src="man/figures/lipidflow_logo.png" align="left" alt="" width="120" /></a>

<br>

`lipidflow` is used absolute quantification for lipidomics data.

<br>

### metpath <a href="https://tidymass.github.io/metPath/" target="_blank"><img src="man/figures/metpath_logo.png" align="left" alt="" width="120" /></a>

<br>

`metpath` is used for pathway enrichment analysis.

<br>

### featuremsea <a href="https://tidymass.github.io/featuremsea/" target="_blank"><img src="man/figures/featuremsea.png" align="left" alt="" width="120" /></a>

<br>

`featuremsea` is used for GSEA from metabolic feature without annotation.

<br>

### tinytools <a href="https://tidymass.github.io/tinytools/" target="_blank"><img src="man/figures/tinytools_logo.png" align="left" alt="" width="120" /></a>

<br>

`tinytools` is a collection of useful tiny tools for mass spectrometry data processing.

<br>

## Need help?

If you have any questions about `tidymass`, please don’t hesitate to
email me (<shenxt@stanford.edu>) or reach out me via the social medias below.

<i class="fa fa-weixin"></i>
[shenxt1990](https://www.shenxt.info/files/wechat_QR.jpg)

<i class="fa fa-envelope"></i> <shenxt@stanford.edu>

<i class="fa fa-twitter"></i>
[Twitter](https://twitter.com/JasperShen1990)

<i class="fa fa-map-marker-alt"></i> [M339, Alway Buidling, Cooper Lane,
Palo Alto, CA
94304](https://www.google.com/maps/place/Alway+Building/@37.4322345,-122.1770883,17z/data=!3m1!4b1!4m5!3m4!1s0x808fa4d335c3be37:0x9057931f3b312c29!8m2!3d37.4322345!4d-122.1748996)

## Citation

If you use tidymass in you publication, please cite this publication:

X. Shen, R. Wang, X. Xiong, Y. Yin, Y. Cai, Z. Ma, N. Liu, and Z.-J.
Zhu\* (Corresponding Author), Metabolic Reaction Network-based Recursive
Metabolite Annotation for Untargeted Metabolomics, Nature
Communications, 2019, 10: 1516.  
[Web Link](https://www.nature.com/articles/s41467-019-09550-x).

Thanks very much!
