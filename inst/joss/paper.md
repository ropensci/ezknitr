---
title: "ezknitr: Avoid the Typical Working Directory Pain When Using 'knitr'"
tags:
  - reproducible research
  - R
authors:
 - name: Dean Attali
   orcid: 0000-0002-5645-3493
   affiliation: UBC
date: 7 August 2016
bibliography: paper.bib
---

# Summary

The 'ezknitr' package [@ezknitr-archive] is an R package [@R-base] that enhances the functionality and flexibility of the 'knitr' package [@R-knitr]. 'knitr' is a popular package for generating dynamic reorts in R using the concept of litrate programming [@knuth1984literate]. One common source of frustration with 'knitr' is that it makes important assumptions about the directory structure of the input files and does not offer much flexibility in deciding where the different output files are generated. The 'ezknitr' package adresses these problem by providing the user with complete control over where all the inputs and outputs are, and adds several other convenient features to make the process of generating dynamic documents more streamlined.

# References