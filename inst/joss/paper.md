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

'knitr' [@R-knitr] is a popular R package [@R-base] that implements the concept of literate programming [@knuth1984literate] in R. It has been widely adopted in the R community as a means of generating dynamic reports. Despite its popularity, one common source of frustration with 'knitr' is that it makes important assumptions about the directory structure of the input files and does not offer much flexibility in deciding where the different output files are generated. The 'ezknitr' package [@ezknitr-archive] is an R package that addresses these problems and enhances the functionality of 'knitr'. 'ezknitr' provides the user with complete control over where all the inputs and outputs are, and adds several other convenient features to make the process of generating dynamic documents more streamlined and efficient.

# References