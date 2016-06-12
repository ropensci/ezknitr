# ezknitr 0.4 2016-06-12

- added `...` argument to `ezspin` that passes any additional arguments to `knitr::spin` (#6)
- add param `move_intermediate_file` to `ezspin` that controls whether the intermediate Rmd file stays with the source R script or moves to the output folder (thanks @klmr)  

# ezknitr 0.3.0

2015-12-07

- add section about `rmarkdown::render` in vignette/readme

# ezknitr 0.2.0

2015-12-07

- add unit tests
- documentation additions, getting ready for CRAN release

# ezknitr 0.1.0

2015-12-05

- add `setup_ezknit_test` function
- add `open_output_dir` function

# ezknitr 0.0.0.9002

2015-11-06

- rename `ezrender` to `ezknitr`
- many internal changes and code improvements
- no longer need to delete an empty wrong figures folder because knitr fixed its bug #942 

# ezknitr 0.0.0.9001

2015-10-23

- `ezspin()` gains new arguments `keepRmd` (default: `FALSE`) and `keepMd` (default: `TRUE`) (#1)

# ezknitr 0.0.0.9000

- Import from `rsalad` package
