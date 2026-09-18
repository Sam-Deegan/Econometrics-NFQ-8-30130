################################################################################
## Project: ECONXXXXX Econometrics I                                          ##
## Export the registered figures to _shared/figures/                          ##
################################################################################

## Author:      Sam Deegan
## Affiliation: University College Dublin
## Email:       sam.deegan@ucdconnect.ie

## Usage:
##   Run from the repo root, not from inside _apps:
##
##     source("_apps/export_figures.R")
##
## Inputs:
##   _apps/regression/R/toolkit.R   the house theme and palette
##   _apps/regression/R/model.R     the population and the builders
##
## Outputs:
##   _shared/figures/<key>.png, one per entry in the register at B_03_04.
##
##   A deck reaches a figure by relative path, so 2-1_Fitting-a-Line puts
##   ../_shared/figures/2-1_residuals.png on the slide. Rebuild after any
##   change to the population and every slide follows on the next render.

#-------------------------------- Script Begin --------------------------------#

################################################################################
## A: Table of Contents ########################################################
################################################################################
# Note: What is in this script.

##   A. Table of Contents
##   B. Setup
##      B_01 Packages
##      B_02 Options and Seed
##      B_03 Sizes and the Register
##      B_04 Paths
##   C. Helpers
##      C_01 Size for a Shape, Build One Figure
##   D. Build Every Registered Figure
##   E. Write Them Out

################################################################################
## B: Setup ####################################################################
################################################################################
# Note: Sizes, the register, and where things land.

###### B_01_01: Load Plotting Packages #########################################
# Note: ggplot2 only. Nothing here composes panels - every builder returns a
#       single figure, as the apps do, so a deck can place one on a slide or
#       pair two with the theme's figpair.

library(ggplot2)

###### B_02_01: Global Options #################################################
# Note: No scientific notation, short printed numbers.

options(scipen = 999, digits = 3)

###### B_02_02: Seed ###########################################################
# Note: Set here as well as in model.R, so running this script alone gives the
#       same figures as running it after something else has drawn from the
#       random number stream.

set.seed(42)

###### B_03_01: Figure Widths #################################################
# Note: Millimetres. Wide is a single exhibit filling the slide; half is one
#       panel of a \figpair, which the deck draws at 0.48 of the line width.
#       An exhibit shown in a pair must be EXPORTED at half width too, or it
#       is squashed twice: once by the export and again by the pair.

B_03_01_wide_width_int <- 160L
B_03_02_half_width_int <- 100L

###### B_03_02: Figure Heights #################################################
# Note: Millimetres, and the same numbers as the macro module's own register -
#       Advanced-Macroeconomics/_apps/export_figures.R, B_03_03 and B_03_04.
#       The two sets of decks share a theme and should not read as two
#       different house styles.
#
#       CHANGED 18 September. These were 50mm and 46mm, flat, and the comment
#       here justified that by the deck using \figsmall, which capped an
#       exhibit at 0.34 of the text block: a letterboxed export filled the
#       width instead of sitting small and centred. \figsmall is gone - block
#       one was converted to the theme's own \fig, capped at 0.42 - so the
#       reason for the flat export went with it, and a 3.2:1 panel now just
#       reads as squashed beside the macro figures.

B_03_03_wide_height_int  <- 90L
B_03_04_panel_height_int <- 85L
B_03_05_tall_height_int  <- 110L
B_03_12_short_height_int <- 70L
B_03_13_half_height_int  <- 85L
# Note: One panel of a \figtriple, drawn at 0.32 of the line width.
B_03_14_third_width_int  <- 70L
B_03_15_third_height_int <- 70L

###### B_03_03: Resolution and Units ###########################################
# Note: Three hundred dots per inch, because these are printed as well as
#       projected.

B_03_06_figure_dpi_int   <- 300L
B_03_07_figure_units_chr <- "mm"

###### B_03_04: The Figure Register ############################################
# Note: Every exhibit in block 2. The key becomes the file name, so a slide
#       citing ../_shared/figures/2-3_sampling.png is citing this line. Add a
#       figure by adding an entry, not by calling ggsave somewhere.

B_03_08_register_lst <- list(

  list(key_chr = "2-1_residuals",
       builder_chr = "D_01_01_residuals_fn",
       shape_chr = "wide"),

  list(key_chr = "2-1_candidates",
       builder_chr = "D_01_02_candidates_fn",
       shape_chr = "wide"),

  list(key_chr = "2-1_leverage",
       builder_chr = "D_01_03_leverage_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_split",
       builder_chr = "D_02_01_split_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_bars",
       builder_chr = "D_02_02_bars_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_tss",
       builder_chr = "D_02_03_tss_fn",
       shape_chr = "short"),

  list(key_chr = "2-2_ess",
       builder_chr = "D_02_04_ess_fn",
       shape_chr = "short"),

  list(key_chr = "2-2_rss",
       builder_chr = "D_02_05_rss_fn",
       shape_chr = "short"),

  list(key_chr = "2-2_rsq-tight",
       builder_chr = "D_02_06_tight_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_rsq-loose",
       builder_chr = "D_02_07_loose_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_rsq-curved",
       builder_chr = "D_02_08_curved_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_fit-sample",
       builder_chr = "D_02_09_sample_fn",
       shape_chr = "wide"),

  list(key_chr = "2-2_fit-holdout",
       builder_chr = "D_02_10_holdout_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_onesample",
       builder_chr = "D_03_01_onesample_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_sampling",
       builder_chr = "D_03_02_sampling_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_precision-n",
       builder_chr = "D_03_03_bigger_n_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_precision-spread",
       builder_chr = "D_03_04_wider_x_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_precision-noise",
       builder_chr = "D_03_05_less_noise_fn",
       shape_chr = "wide"),

  list(key_chr = "2-3_blue",
       builder_chr = "D_03_06_blue_fn",
       shape_chr = "wide"),

  list(key_chr = "2-4_interval",
       builder_chr = "D_04_01_interval_fn",
       shape_chr = "wide"),

  list(key_chr = "2-4_studies",
       builder_chr = "D_04_02_studies_fn",
       shape_chr = "wide"),

  list(key_chr = "1-1_mean",
       builder_chr = "D_05_01_mean_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_variance",
       builder_chr = "D_05_02_variance_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_skew-negative",
       builder_chr = "D_05_03_skew_negative_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_skew-symmetric",
       builder_chr = "D_05_04_skew_symmetric_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_skew-positive",
       builder_chr = "D_05_05_skew_positive_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_kurtosis-light",
       builder_chr = "D_05_06_kurtosis_light_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_kurtosis-normal",
       builder_chr = "D_05_07_kurtosis_normal_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_kurtosis-heavy",
       builder_chr = "D_05_08_kurtosis_heavy_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_centre-skewed",
       builder_chr = "D_05_09_skewed_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_centre-normal",
       builder_chr = "D_05_09b_symmetric_fn",
       shape_chr = "half"),

  list(key_chr = "1-1_cohen-weak",
       builder_chr = "D_05_10_cohen_weak_fn",
       shape_chr = "third"),

  list(key_chr = "1-1_cohen-medium",
       builder_chr = "D_05_11_cohen_medium_fn",
       shape_chr = "third"),

  list(key_chr = "1-1_cohen-strong",
       builder_chr = "D_05_12_cohen_strong_fn",
       shape_chr = "third"),

  list(key_chr = "1-2_cef-weights",
       builder_chr = "D_06_01b_cef_fn",
       shape_chr = "wide")
)

###### B_04_01: The App Folder #################################################
# Note: Where the toolkit and the builders live.

B_04_01_app_dir <- file.path("_apps", "regression", "R")

###### B_04_02: The Figure Folder ##############################################
# Note: Shared, because a figure may appear in more than one deck and should
#       not be stored twice.

B_04_02_figures_dir <- file.path("_shared", "figures")

################################################################################
## C: Helpers ##################################################################
################################################################################
# Note: Sizes, and building one registered figure.

###### C_01_01: Figure Dimensions for a Shape ##################################
# Note: One place that turns a shape name into millimetres, so no builder
#       carries its own size.

C_01_01_dims_fn <- function(shape_chr) {
  switch(shape_chr,
    wide  = list(width_int  = B_03_01_wide_width_int,
                 height_int = B_03_03_wide_height_int),
    panel = list(width_int  = B_03_01_wide_width_int,
                 height_int = B_03_04_panel_height_int),
    tall  = list(width_int  = B_03_01_wide_width_int,
                 height_int = B_03_05_tall_height_int),
    short = list(width_int  = B_03_01_wide_width_int,
                 height_int = B_03_12_short_height_int),
    half  = list(width_int  = B_03_02_half_width_int,
                 height_int = B_03_13_half_height_int),
    third = list(width_int  = B_03_14_third_width_int,
                 height_int = B_03_15_third_height_int),
    stop("C_01_01: unknown shape ", shape_chr)
  )
}

###### C_01_02: Build One Registered Figure ####################################
# Note: Calls the builder named in the register and returns the plot with its
#       dimensions attached. A failure is reported and skipped rather than
#       stopping the run, so one broken builder does not cost the other eleven
#       figures.

C_01_02_build_fn <- function(entry_lst) {

  tryCatch({
    builder_fn <- get(entry_lst$builder_chr)
    plot_plt   <- builder_fn()
    message("  built  ", entry_lst$key_chr)
    c(entry_lst, list(plot_plt = plot_plt))
  }, error = function(e) {
    message("  FAILED ", entry_lst$key_chr, ": ", conditionMessage(e))
    NULL
  })
}

################################################################################
## D: Build Every Registered Figure ############################################
################################################################################
# Note: Source the code, then build.

###### D_01_01: Load the Toolkit and the Builders ##############################
# Note: The toolkit first, because model.R reaches into its palette and theme
#       while it is being sourced.

tryCatch({
  source(file.path(B_04_01_app_dir, "toolkit.R"))
  source(file.path(B_04_01_app_dir, "model.R"))
  message("D_01_01: toolkit and builders loaded")
}, error = function(e) {
  message("D_01_01: could not load the app code")
  message("   ", conditionMessage(e))
  stop(conditionMessage(e))
})

###### D_01_02: Build Them #####################################################
# Note: In register order, so the console log reads like the block.

message("D_01_02: building ", length(B_03_08_register_lst), " figures")

D_01_02_figures_lst <- lapply(B_03_08_register_lst, C_01_02_build_fn)
D_01_03_figures_lst <- Filter(Negate(is.null), D_01_02_figures_lst)

################################################################################
## E: Write Them Out ###########################################################
################################################################################
# Note: Create the folder, save each PNG, report.

###### E_01_01: Create the Output Folder #######################################
# Note: Harmless if it is already there.

tryCatch({
  dir.create(B_04_02_figures_dir, showWarnings = FALSE, recursive = TRUE)
}, error = function(e) {
  message("E_01_01: could not create ", B_04_02_figures_dir)
  stop(conditionMessage(e))
})

###### E_01_02: Write Every Figure #############################################
# Note: One PNG per register entry, at the size its shape asks for.

E_01_02_written_int <- 0L

for (figure_lst in D_01_03_figures_lst) {

  dims_lst <- C_01_01_dims_fn(figure_lst$shape_chr)
  path_chr <- file.path(B_04_02_figures_dir,
                        paste0(figure_lst$key_chr, ".png"))

  tryCatch({
    ggsave(path_chr, figure_lst$plot_plt,
           width  = dims_lst$width_int,
           height = dims_lst$height_int,
           units  = B_03_07_figure_units_chr,
           dpi    = B_03_06_figure_dpi_int)
    E_01_02_written_int <- E_01_02_written_int + 1L
  }, error = function(e) {
    message("  FAILED writing ", path_chr, ": ", conditionMessage(e))
  })
}

###### E_01_03: Summary ########################################################
# Note: What was asked for, what was written, and where it went.

message("E_01_03: ", E_01_02_written_int, " of ",
        length(B_03_08_register_lst), " figures written to ",
        B_04_02_figures_dir)

#--------------------------------- Script End ---------------------------------#
