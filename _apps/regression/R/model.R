################################################################################
## Project: ECONXXXXX Econometrics I                                          ##
## Regression exhibits: the population, the sample, and the builders          ##
################################################################################

## Author:      Sam Deegan
## Affiliation: University College Dublin
## Email:       sam.deegan@ucdconnect.ie

## Usage:
##   Sourced by _apps/export_figures.R, which writes the PNGs into
##   _shared/figures/. Also sourceable on its own:
##
##     source("_apps/regression/R/toolkit.R")
##     source("_apps/regression/R/model.R")
##     D_01_01_residuals_fn()
##
## Inputs:
##   None. A population is simulated once, and every figure draws a sample
##   from it. The truth is therefore known and can be plotted beside the
##   estimate, which lecture 2.3 needs and no real dataset can supply.
##
## Outputs:
##   Ten ggplot objects, returned by the D_* builder functions.

## THE RUNNING EXAMPLE. Schooling and earnings: one more year of school, and
## what it is worth an hour. Students are in the middle of that decision
## themselves, so the scenario needs no explaining.
##
## A POPULATION AND A SAMPLE. C_01_01 builds a population of 200,000 people,
## once. Every figure then draws a sample from it, and every estimate is
## computed from the sample alone. We know the population because we wrote it;
## the class works as though they do not. That is the distinction 1.1 opens
## with, and it is the reason a sampling distribution in 2.3 is a picture of
## something real rather than a metaphor: it is what happens when you draw
## from this population five hundred times.
##
## THE FLAWS ARE ALREADY IN HERE, SWITCHED OFF. B_04 carries the violations
## and B_05 the controls, each defaulting to harmless. In block 2 every Gauss-
## Markov assumption therefore holds, which is what lets 2.3 show an estimator
## that is unbiased and a theorem that says it is best. Each later lecture
## turns exactly one thing on:
##
##    ability          unobserved, raises schooling and pay      -> 3.1, 4.2
##    parent_edu       observed confounder, the GOOD control     -> 3.1
##    occupation       mediator: schooling acts through it,
##                     so controlling for it is a BAD control    -> 3.1
##    promoted         COLLIDER: caused by schooling AND pay,
##                     so controlling for it invents a bias      -> 3.1
##    misreport        schooling recorded with error             -> 4.2
##    hetero_gain      the error fans out with schooling         -> 4.1
##    curvature        returns diminish                          -> 4.1
##    wage_floor       only those above a wage are observed       -> 4.2
##
## So 4.2 is not a new dataset and not a new story. It is this one with the
## curtain lifted: here is what was generating your data all term, and here is
## which of your estimates it quietly ruined. The reveal is the reason the
## block is simulated at all.

#-------------------------------- Script Begin --------------------------------#

################################################################################
## A: Table of Contents ########################################################
################################################################################
# Note: What is in this script.

##   A. Table of Contents
##   B. Setup
##      B_01 Packages
##      B_02 Options and Seed
##      B_03 The Population
##      B_04 The Violations, All Off
##      B_05 The Controls, All Inert
##      B_06 Drawing Conventions
##   C. Helpers
##      C_01 Population, Sample, Fit
##      C_02 Style
##   D. Figure Builders
##      D_01 Fitting a Line          (lecture 2.1)
##      D_02 Goodness of Fit         (lecture 2.2)
##      D_03 Bias and Precision      (lecture 2.3)
##      D_04 Reporting an Estimate   (lecture 2.4)

################################################################################
## B: Setup ####################################################################
################################################################################
# Note: Packages, options, the population, and the switches.

###### B_01_01: Load the Plotting Package ######################################
# Note: ggplot2, and nothing else. There are no composed panels here: every
#       builder returns one figure, the way the apps do it, so a deck can
#       place them singly or pair them with the theme's figpair.

library(ggplot2)

###### B_02_01: Global Options #################################################
# Note: No scientific notation, short printed numbers.

options(scipen = 999, digits = 3)

###### B_02_02: Seed ###########################################################
# Note: Fixed, so the exhibits are identical on every rebuild. Change it and
#       every figure in block 2 changes, which is why it is fixed.

set.seed(42)

###### B_03_01: The True Line ##################################################
# Note: Earnings per hour on years of schooling. Schooling is centred at
#       twelve, so the intercept is earnings at twelve years rather than an
#       extrapolation to no schooling at all.

B_03_01_true_intercept_dbl <- 9.50
B_03_02_true_slope_dbl     <- 1.30
B_03_03_centre_year_dbl    <- 12

###### B_03_02: The Schooling Distribution #####################################
# Note: Bounded, so nobody in the population has three years or thirty.

B_03_04_school_mean_dbl <- 13.5
B_03_05_school_sd_dbl   <- 2.4
B_03_06_school_min_int  <- 9L
B_03_07_school_max_int  <- 20L

###### B_03_03: The Error ######################################################
# Note: Everything earnings depends on other than schooling. Homoskedastic and
#       mean zero while the switches are off, which is precisely what the
#       Gauss-Markov assumptions claim.

B_03_08_error_sd_dbl <- 4.50

###### B_03_04: Population and Sample Sizes ####################################
# Note: The population is built once. The working sample is what the class
#       sees in 2.1 and 2.2; the repeat count is how many samples build the
#       sampling distribution in 2.3.

B_03_09_population_int <- 200000L
B_03_10_sample_int     <- 120L
B_03_11_repeats_int    <- 500L

###### B_04_01: The Violations, All Off ########################################
# Note: Defaults are inert, so block 2 sees a population in which every
#       assumption holds. Each later lecture turns exactly one on by passing a
#       non-zero value to C_01_01_population_fn.

B_04_01_ability_pay_dbl    <- 0.00
B_04_02_ability_school_dbl <- 0.00
B_04_03_misreport_sd_dbl   <- 0.00
B_04_04_hetero_gain_dbl    <- 0.00
B_04_05_curvature_dbl      <- 0.00
B_04_06_wage_floor_dbl     <- -Inf

###### B_05_01: The Controls, All Inert ########################################
# Note: Three observable variables that exist in every sample and do nothing
#       until 3.1 switches them on. parent_edu is a genuine confounder and the
#       good control; occupation is a mediator and promoted is a collider, and
#       both are bad controls for opposite reasons.

B_05_01_parent_school_dbl <- 0.00
B_05_02_parent_pay_dbl    <- 0.00
B_05_03_mediator_dbl      <- 0.00
B_05_04_collider_school_dbl <- 0.00
B_05_05_collider_pay_dbl    <- 0.00

###### B_06_01: Axis Labels ####################################################
# Note: Written once so every panel agrees. Kept short deliberately: a rotated
#       y-axis title is as long as the label, and on a 46mm figure that is
#       taller than the panel, so a wordy label overflows upward into the
#       subtitle.

B_06_01_x_label_chr <- "Years of schooling"
B_06_02_y_label_chr <- "Earnings (euro)"

###### B_06_02: Mark Sizes, Weights and Opacities ##############################
# Note: One named constant per visual role, and no builder sets a number of
#       its own. This block is why the nineteen exhibits read as one set: a
#       point means the same thing and looks the same everywhere, and changing
#       how the module looks is editing this list rather than hunting through
#       twenty functions.

B_06_03_point_size_dbl     <- 1.15
B_06_04_line_width_dbl     <- 0.90
B_06_05_thin_width_dbl     <- 0.45
B_06_06_point_alpha_dbl    <- 0.55
B_06_07_cloud_size_dbl     <- 0.50
B_06_08_cloud_alpha_dbl    <- 0.25
B_06_09_mark_size_dbl      <- 2.60
B_06_10_fill_alpha_dbl     <- 0.70
B_06_11_heavy_width_dbl    <- 1.10
B_06_12_density_adjust_dbl <- 1.20
B_06_13_legend_pos_chr     <- "bottom"

###### B_04_07: Outliers #######################################################
# Note: A small share of the population earn far more than their schooling
#       predicts - owners, commission, inheritance. Off by default so the
#       block 2 sample is clean and the theorem in 2.3 lands, then turned on
#       for the leverage figure in 2.1 and again in 4.1.

B_04_07_outlier_share_dbl <- 0.00
B_04_08_outlier_lift_dbl  <- 26.0

################################################################################
## C: Helpers ##################################################################
################################################################################
# Note: The population, the split, the fit, and the house style.

###### C_01_01: Build the Population ###########################################
# Note: Two hundred thousand people, generated once in causal order: ability
#       and parental schooling first, then schooling, then occupation, then
#       earnings, and promotion last because it is caused by two things that
#       already exist. Writing it in that order is what makes the collider a
#       collider rather than an assertion.

C_01_01_population_fn <- function(
    n_int               = B_03_09_population_int,
    slope_dbl           = B_03_02_true_slope_dbl,
    error_sd_dbl        = B_03_08_error_sd_dbl,
    spread_dbl          = B_03_05_school_sd_dbl,
    ability_pay_dbl     = B_04_01_ability_pay_dbl,
    ability_school_dbl  = B_04_02_ability_school_dbl,
    misreport_sd_dbl    = B_04_03_misreport_sd_dbl,
    hetero_gain_dbl     = B_04_04_hetero_gain_dbl,
    curvature_dbl       = B_04_05_curvature_dbl,
    wage_floor_dbl      = B_04_06_wage_floor_dbl,
    outlier_share_dbl   = B_04_07_outlier_share_dbl,
    parent_school_dbl   = B_05_01_parent_school_dbl,
    parent_pay_dbl      = B_05_02_parent_pay_dbl,
    mediator_dbl        = B_05_03_mediator_dbl,
    collider_school_dbl = B_05_04_collider_school_dbl,
    collider_pay_dbl    = B_05_05_collider_pay_dbl) {

  ability_dbl    <- rnorm(n_int, 0, 1)
  parent_edu_dbl <- rnorm(n_int, 12, 3) + 0.6 * ability_dbl

  school_dbl <- rnorm(n_int, B_03_04_school_mean_dbl, spread_dbl) +
    ability_school_dbl * ability_dbl +
    parent_school_dbl * (parent_edu_dbl - 12)
  school_dbl <- pmin(pmax(school_dbl, B_03_06_school_min_int),
                     B_03_07_school_max_int)

  centred_dbl <- school_dbl - B_03_03_centre_year_dbl

  occupation_dbl <- 0.8 * centred_dbl + rnorm(n_int, 0, 1)

  error_scale_dbl <- error_sd_dbl * (1 + hetero_gain_dbl * centred_dbl)
  error_scale_dbl <- pmax(error_scale_dbl, 0.05 * error_sd_dbl)

  earnings_dbl <- B_03_01_true_intercept_dbl +
    slope_dbl * centred_dbl +
    curvature_dbl * centred_dbl ^ 2 +
    ability_pay_dbl * ability_dbl +
    parent_pay_dbl * (parent_edu_dbl - 12) +
    mediator_dbl * occupation_dbl +
    rnorm(n_int, 0, error_scale_dbl)

  outlier_lgl <- runif(n_int) < outlier_share_dbl
  earnings_dbl <- earnings_dbl +
    outlier_lgl * B_04_08_outlier_lift_dbl * abs(rnorm(n_int, 1, 0.4))

  promoted_dbl <- collider_school_dbl * centred_dbl +
    collider_pay_dbl * (earnings_dbl - B_03_01_true_intercept_dbl) +
    rnorm(n_int, 0, 1)

  reported_dbl <- school_dbl + rnorm(n_int, 0, misreport_sd_dbl)

  population_df <- data.frame(
    schooling_yrs  = reported_dbl,
    actual_yrs     = school_dbl,
    earnings_eur   = earnings_dbl,
    ability_idx    = ability_dbl,
    parent_edu_yrs = parent_edu_dbl,
    occupation_idx = occupation_dbl,
    promoted_idx   = promoted_dbl,
    outlier_lgl    = outlier_lgl
  )

  population_df[population_df$earnings_eur >= wage_floor_dbl, ]
}

###### C_01_02: Split the Population Into a Sample and a Hold-Out ##############
# Note: A training and test split, and it is worth calling it that in class.
#       The sample is what the analyst has. The hold-out is data the fitted
#       line has never seen, which is how 2.2 shows that a good R-squared in-
#       sample is not the same as a line that predicts.

C_01_02_split_fn <- function(population_df,
                             n_train_int = B_03_10_sample_int,
                             n_test_int  = B_03_10_sample_int) {

  drawn_int <- sample(seq_len(nrow(population_df)),
                      n_train_int + n_test_int)

  list(
    sample_df  = population_df[drawn_int[seq_len(n_train_int)], ],
    holdout_df = population_df[drawn_int[-seq_len(n_train_int)], ]
  )
}

###### C_01_03: Fit a Line and Return Its Pieces ###############################
# Note: The one place lm() is called, so every figure reports the same
#       quantities in the same way.

C_01_03_fit_fn <- function(data_df) {

  centred_dbl <- data_df$schooling_yrs - B_03_03_centre_year_dbl
  model_lm    <- lm(data_df$earnings_eur ~ centred_dbl)
  summary_lst <- summary(model_lm)

  list(
    intercept_dbl = unname(coef(model_lm)[1]),
    slope_dbl     = unname(coef(model_lm)[2]),
    slope_se_dbl  = unname(summary_lst$coefficients[2, 2]),
    r_squared_dbl = summary_lst$r.squared,
    fitted_dbl    = unname(fitted(model_lm)),
    resid_dbl     = unname(resid(model_lm))
  )
}

###### C_01_04: Sum of Squared Residuals for Any Line ##########################
# Note: For the candidate-lines figure, where the point is that least squares
#       is a criterion somebody chose rather than a law of nature.

C_01_04_ssr_fn <- function(data_df, intercept_dbl, slope_dbl) {

  predicted_dbl <- intercept_dbl +
    slope_dbl * (data_df$schooling_yrs - B_03_03_centre_year_dbl)

  sum((data_df$earnings_eur - predicted_dbl) ^ 2)
}

###### C_01_05: Slopes From Many Samples #######################################
# Note: Repeated draws from the same population, one slope kept from each.
#       This is the sampling distribution, and it is the only figure in the
#       module that could not be drawn from real data.

C_01_05_repeat_fn <- function(population_df,
                              repeats_int = B_03_11_repeats_int,
                              n_int       = B_03_10_sample_int) {

  vapply(seq_len(repeats_int), function(draw_int) {
    drawn_int <- sample(seq_len(nrow(population_df)), n_int)
    C_01_03_fit_fn(population_df[drawn_int, ])$slope_dbl
  }, numeric(1))
}

###### C_01_06: The Two-Point Estimator ########################################
# Note: A linear unbiased estimator that is not least squares: the slope
#       through the lowest and highest schooling in the sample. Unbiased, and
#       far noisier, which is what makes the Gauss-Markov theorem in 2.3 worth
#       stating rather than asserting.

C_01_06_two_point_fn <- function(data_df) {

  low_int  <- which.min(data_df$schooling_yrs)
  high_int <- which.max(data_df$schooling_yrs)
  run_dbl  <- data_df$schooling_yrs[high_int] - data_df$schooling_yrs[low_int]

  if (run_dbl == 0) return(NA_real_)

  (data_df$earnings_eur[high_int] - data_df$earnings_eur[low_int]) / run_dbl
}

###### C_01_07: Slopes From Many Samples, Both Estimators ######################
# Note: Least squares against the two-point estimator on the same draws, so
#       the comparison in 2.3 is like for like.

C_01_07_compare_fn <- function(population_df,
                               repeats_int = B_03_11_repeats_int,
                               n_int       = B_03_10_sample_int) {

  result_mat <- vapply(seq_len(repeats_int), function(draw_int) {
    drawn_int <- sample(seq_len(nrow(population_df)), n_int)
    sample_df <- population_df[drawn_int, ]
    c(C_01_03_fit_fn(sample_df)$slope_dbl, C_01_06_two_point_fn(sample_df))
  }, numeric(2))

  data.frame(estimator_chr = rep(c("Least squares", "Two-point"),
                                 each = repeats_int),
             slope_dbl     = c(result_mat[1, ], result_mat[2, ]))
}

###### C_02_01: The House Theme ################################################
# Note: Taken from the toolkit, so a slide and the app cannot drift apart.
#       Base size drops from the app's 14 to 9, and the title is pulled back
#       to roughly the base size rather than ggplot's enlarged default. A
#       figure here is 58mm tall and carries a note underneath, so an
#       oversized heading eats the panel and repeats what the slide already
#       says. Small type at 300dpi projects perfectly well; the thing that
#       fails on a projector is thin strokes and low contrast, not point size.
#       The four levels, largest first: the frame title on the slide, the
#       figure title, an A/B/C panel label, then the axes.

C_02_01_theme_fn <- function() {
  T_02_01_theme_fn(base_size = 9) +
    theme(
      plot.title.position = "plot",
      plot.title    = element_text(size = rel(0.95)),
      plot.subtitle = element_text(size = rel(0.85),
                                   colour = T_01_01_palette_vec[["blue"]]),
      axis.title    = element_text(size = rel(0.78)),
      axis.text     = element_text(size = rel(0.72))
    )
}

###### C_02_07: The Theme for a Panel Inside a Multi-Panel Figure ##############
# Note: One step further down again. The frame title is the slide's heading,
#       the figure title sits below it, and an A/B/C panel label sits below
#       that. Three levels, each visibly smaller than the one above, so
#       nothing on the slide competes with the frame title for the eye.

C_02_07_panel_theme_fn <- function() {
  C_02_01_theme_fn() +
    theme(plot.title = element_text(size = rel(0.80)))
}

###### C_02_02: Series Colours #################################################
# Note: Taken from the toolkit's own series vector rather than picked per
#       call, so these figures read the same way as the macro ones. The
#       convention it states: the realised series in navy, the comparison
#       dashed in green, bands in light blue, reference lines grey dashed.
#       Applied here that means navy is whatever the slide is about - the
#       distribution, or the fitted line - green is the thing it is being
#       compared against, light blue is raw data sitting behind, and grey is
#       context.

C_02_02_colour_lst <- list(
  main      = T_01_02_series_vec[["main"]],
  compare   = T_01_02_series_vec[["compare"]],
  band      = T_01_02_series_vec[["band"]],
  reference = T_01_02_series_vec[["reference"]],
  rule      = T_01_01_palette_vec[["rule"]],
  ink       = T_01_01_palette_vec[["ink"]]
)

###### C_02_03: The Population and the Working Split ###########################
# Note: Built once when this script is sourced. Every builder below takes its
#       data from here, so the same hundred and twenty people appear in every
#       figure of block 2 and students come to recognise them. C_02_07 is the
#       panel theme rather than a fourth data object: these four keys were
#       here first and the builders all reference them by name.

C_02_03_population_df <- C_01_01_population_fn()
C_02_04_split_lst     <- C_01_02_split_fn(C_02_03_population_df)
C_02_05_sample_df     <- C_02_04_split_lst$sample_df
C_02_06_holdout_df    <- C_02_04_split_lst$holdout_df

################################################################################
## D: Figure Builders ##########################################################
################################################################################
# Note: One function, one figure. Nothing here composes panels: the apps keep
#       each exhibit separate so a deck can put one on a slide, two side by
#       side with the theme's figpair, or one in a handout and the rest
#       nowhere, and the figures follow the same rule. Every builder returns a
#       ggplot and writes nothing; export_figures.R decides where it lands and
#       at what size.

###### D_00_01: The Base Scatter ###############################################
# Note: The sample, the fitted line, and the axes, with nothing marked on it.
#       Every scatter in block 2 starts from this, so they cannot drift apart.

D_00_01_base_fn <- function(data_df, fit_lst, title_chr,
                            subtitle_chr = NULL) {

  ggplot(data_df, aes(schooling_yrs, earnings_eur)) +
    geom_abline(intercept = fit_lst$intercept_dbl -
                  fit_lst$slope_dbl * B_03_03_centre_year_dbl,
                slope = fit_lst$slope_dbl,
                colour = C_02_02_colour_lst$main,
                linewidth = B_06_04_line_width_dbl) +
    labs(x = B_06_01_x_label_chr, y = B_06_02_y_label_chr,
         title = title_chr, subtitle = subtitle_chr) +
    C_02_01_theme_fn()
}

###### D_01_01: Lecture 2.1: The Line and What It Misses #######################
# Note: The fitted line with every residual drawn as a vertical segment. The
#       segments are the figure: least squares is about them, and a scatter
#       with a line through it does not show that.

D_01_01_residuals_fn <- function(data_df = C_02_05_sample_df) {

  fit_lst <- C_01_03_fit_fn(data_df)
  plot_df <- data.frame(schooling_yrs = data_df$schooling_yrs,
                        earnings_eur  = data_df$earnings_eur,
                        fitted_eur    = fit_lst$fitted_dbl)

  D_00_01_base_fn(plot_df, fit_lst,
                  "Each Grey Line Is What the Fit Gets Wrong for One Person",
                  sprintf("Fitted slope %.2f euro per year",
                          fit_lst$slope_dbl)) +
    geom_segment(aes(xend = schooling_yrs, yend = fitted_eur),
                 colour = C_02_02_colour_lst$reference,
                 linewidth = B_06_05_thin_width_dbl) +
    geom_point(colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl)
}

###### D_01_02: Lecture 2.1: Why This Line and Not Another #####################
# Note: Three lines through the same sample with their sums of squared
#       residuals printed. The least-squares line wins on a criterion that was
#       chosen, and seeing the runners-up is what makes that a choice.

D_01_02_candidates_fn <- function(data_df = C_02_05_sample_df) {

  fit_lst <- C_01_03_fit_fn(data_df)

  candidate_df <- data.frame(
    label_chr     = c("Too flat", "Least squares", "Too steep"),
    intercept_dbl = c(fit_lst$intercept_dbl + 1.4,
                      fit_lst$intercept_dbl,
                      fit_lst$intercept_dbl - 1.4),
    slope_dbl     = c(fit_lst$slope_dbl - 0.75,
                      fit_lst$slope_dbl,
                      fit_lst$slope_dbl + 0.75)
  )

  candidate_df$ssr_dbl <- mapply(C_01_04_ssr_fn,
                                 candidate_df$intercept_dbl,
                                 candidate_df$slope_dbl,
                                 MoreArgs = list(data_df = data_df))

  candidate_df$legend_chr <- sprintf("%s  (SSR %s)",
                                     candidate_df$label_chr,
                                     format(round(candidate_df$ssr_dbl),
                                            big.mark = ","))

  ggplot(data_df, aes(schooling_yrs, earnings_eur)) +
    geom_point(colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl) +
    geom_abline(data = candidate_df,
                aes(intercept = intercept_dbl -
                      slope_dbl * B_03_03_centre_year_dbl,
                    slope = slope_dbl,
                    colour = legend_chr),
                linewidth = B_06_04_line_width_dbl) +
    scale_colour_manual(values = stats::setNames(
      c(C_02_02_colour_lst$reference,
        C_02_02_colour_lst$main,
        C_02_02_colour_lst$reference),
      candidate_df$legend_chr)) +
    labs(x = B_06_01_x_label_chr, y = B_06_02_y_label_chr, colour = NULL,
         title = "Least Squares Is the Line With the Smallest SSR") +
    C_02_01_theme_fn() +
    theme(legend.position = B_06_13_legend_pos_chr)
}

###### D_01_03: Lecture 2.1: One Person Can Move the Line ######################
# Note: The same sample with a handful of very high earners switched on.
#       Leverage and influence, shown rather than defined, and the first
#       appearance of the outlier switch that 4.1 turns back on.

D_01_03_leverage_fn <- function() {

  clean_df <- C_02_05_sample_df
  dirty_df <- C_01_02_split_fn(
    C_01_01_population_fn(outlier_share_dbl = 0.04))$sample_df

  clean_lst <- C_01_03_fit_fn(clean_df)
  dirty_lst <- C_01_03_fit_fn(dirty_df)

  dirty_df$flag_chr <- ifelse(dirty_df$outlier_lgl, "Outlier", "Typical")

  ggplot(dirty_df, aes(schooling_yrs, earnings_eur)) +
    geom_point(aes(colour = flag_chr, size = flag_chr),
               alpha = B_06_06_point_alpha_dbl) +
    geom_abline(intercept = dirty_lst$intercept_dbl -
                  dirty_lst$slope_dbl * B_03_03_centre_year_dbl,
                slope = dirty_lst$slope_dbl,
                colour = C_02_02_colour_lst$main,
                linewidth = B_06_04_line_width_dbl) +
    geom_abline(intercept = clean_lst$intercept_dbl -
                  clean_lst$slope_dbl * B_03_03_centre_year_dbl,
                slope = clean_lst$slope_dbl,
                colour = C_02_02_colour_lst$compare,
                linewidth = B_06_04_line_width_dbl,
                linetype = "dashed") +
    scale_colour_manual(values = c(Outlier = C_02_02_colour_lst$ink,
                                   Typical = C_02_02_colour_lst$band)) +
    scale_size_manual(values = c(Outlier = B_06_09_mark_size_dbl,
                                 Typical = B_06_03_point_size_dbl)) +
    labs(x = B_06_01_x_label_chr, y = B_06_02_y_label_chr,
         colour = NULL, size = NULL,
         title = sprintf("A Few Large Earners Move the Slope From %.2f to %.2f",
                         clean_lst$slope_dbl, dirty_lst$slope_dbl)) +
    C_02_01_theme_fn() +
    theme(legend.position = B_06_13_legend_pos_chr)
}

###### D_02_01: Lecture 2.2: One Person, Split in Two ##########################
# Note: The person furthest from the line, with the part the line explains and
#       the part it does not drawn as two segments against the sample mean.

D_02_01_split_fn <- function(data_df = C_02_05_sample_df) {

  fit_lst  <- C_01_03_fit_fn(data_df)
  mean_dbl <- mean(data_df$earnings_eur)
  pick_int <- which.max(abs(fit_lst$resid_dbl))

  point_df <- data.frame(
    schooling_yrs = data_df$schooling_yrs[pick_int],
    earnings_eur  = data_df$earnings_eur[pick_int],
    fitted_eur    = fit_lst$fitted_dbl[pick_int]
  )

  D_00_01_base_fn(data_df, fit_lst, "One Person, Split in Two") +
    geom_hline(yintercept = mean_dbl,
               colour = C_02_02_colour_lst$reference,
               linetype = "dashed",
               linewidth = B_06_05_thin_width_dbl) +
    geom_point(colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl) +
    geom_segment(data = point_df,
                 aes(xend = schooling_yrs, y = mean_dbl, yend = fitted_eur),
                 colour = C_02_02_colour_lst$main,
                 linewidth = B_06_11_heavy_width_dbl) +
    geom_segment(data = point_df,
                 aes(xend = schooling_yrs, y = fitted_eur, yend = earnings_eur),
                 colour = C_02_02_colour_lst$reference,
                 linewidth = B_06_11_heavy_width_dbl) +
    geom_point(data = point_df, size = B_06_09_mark_size_dbl,
               colour = C_02_02_colour_lst$ink)
}

###### D_02_02: Lecture 2.2: The Three Totals as Bars ##########################
# Note: Total, explained and residual side by side. The identity is the first
#       bar being the height of the other two, which a bar chart shows and
#       three scatters do not.

D_02_02_bars_fn <- function(data_df = C_02_05_sample_df) {

  fit_lst  <- C_01_03_fit_fn(data_df)
  mean_dbl <- mean(data_df$earnings_eur)

  bar_df <- data.frame(
    part_chr  = factor(c("Total", "Explained", "Residual"),
                       levels = c("Total", "Explained", "Residual")),
    value_dbl = c(sum((data_df$earnings_eur - mean_dbl) ^ 2),
                  sum((fit_lst$fitted_dbl - mean_dbl) ^ 2),
                  sum(fit_lst$resid_dbl ^ 2))
  )

  ggplot(bar_df, aes(part_chr, value_dbl)) +
    geom_col(fill = C_02_02_colour_lst$main, width = 0.6) +
    labs(x = NULL, y = "Sum of squares",
         title = "Total Equals Explained Plus Residual",
         subtitle = sprintf("R-squared %.2f", fit_lst$r_squared_dbl)) +
    C_02_01_theme_fn()
}

###### D_02_03: Lecture 2.2: The Three Sums of Squares, One at a Time ##########
# Note: One helper, three figures. The y-axis is identical in all three so the
#       slides can be compared and the identity is visible rather than
#       asserted. Forty people rather than the full sample, because at 120 the
#       segments become a solid block.

D_02_03_ss_data_fn <- function() {

  show_df <- C_02_05_sample_df[seq_len(40), ]
  fit_lst <- C_01_03_fit_fn(show_df)

  show_df$fitted_eur <- fit_lst$fitted_dbl
  show_df$mean_eur   <- mean(show_df$earnings_eur)

  list(show_df  = show_df,
       fit_lst  = fit_lst,
       mean_dbl = mean(show_df$earnings_eur),
       tss_dbl  = sum((show_df$earnings_eur - mean(show_df$earnings_eur))^2),
       ess_dbl  = sum((show_df$fitted_eur - mean(show_df$earnings_eur))^2),
       rss_dbl  = sum(fit_lst$resid_dbl ^ 2))
}

D_02_03_ss_fn <- function(which_chr, title_chr) {

  parts_lst <- D_02_03_ss_data_fn()
  show_df   <- parts_lst$show_df
  mean_dbl  <- parts_lst$mean_dbl

  y_min_dbl <- min(show_df$earnings_eur, show_df$fitted_eur, mean_dbl)
  y_max_dbl <- max(show_df$earnings_eur, show_df$fitted_eur, mean_dbl)

  total_dbl <- switch(which_chr,
                      tss = parts_lst$tss_dbl,
                      ess = parts_lst$ess_dbl,
                      rss = parts_lst$rss_dbl)

  plot_plt <- ggplot(show_df, aes(schooling_yrs, earnings_eur)) +
    geom_hline(yintercept = mean_dbl,
               colour = C_02_02_colour_lst$reference,
               linetype = "dashed",
               linewidth = B_06_05_thin_width_dbl) +
    geom_abline(intercept = parts_lst$fit_lst$intercept_dbl -
                  parts_lst$fit_lst$slope_dbl * B_03_03_centre_year_dbl,
                slope = parts_lst$fit_lst$slope_dbl,
                colour = C_02_02_colour_lst$main,
                linewidth = B_06_04_line_width_dbl)

  if (which_chr == "tss") {
    plot_plt <- plot_plt +
      geom_segment(aes(xend = schooling_yrs, y = mean_eur,
                       yend = earnings_eur),
                   colour = C_02_02_colour_lst$band,
                   linewidth = B_06_05_thin_width_dbl) +
      geom_point(colour = C_02_02_colour_lst$band,
                 size = B_06_03_point_size_dbl)
  } else if (which_chr == "ess") {
    plot_plt <- plot_plt +
      geom_segment(aes(xend = schooling_yrs, y = mean_eur,
                       yend = fitted_eur),
                   colour = C_02_02_colour_lst$main,
                   linewidth = B_06_05_thin_width_dbl) +
      geom_point(aes(y = fitted_eur), colour = C_02_02_colour_lst$main,
                 size = B_06_03_point_size_dbl)
  } else {
    plot_plt <- plot_plt +
      geom_segment(aes(xend = schooling_yrs, y = fitted_eur,
                       yend = earnings_eur),
                   colour = C_02_02_colour_lst$reference,
                   linewidth = B_06_05_thin_width_dbl) +
      geom_point(colour = C_02_02_colour_lst$band,
                 size = B_06_03_point_size_dbl)
  }

  plot_plt +
    coord_cartesian(ylim = c(y_min_dbl, y_max_dbl)) +
    labs(x = B_06_01_x_label_chr, y = NULL, title = title_chr,
         subtitle = format(round(total_dbl), big.mark = ",")) +
    C_02_01_theme_fn()
}

D_02_03_tss_fn <- function() D_02_03_ss_fn("tss", "Total Sum of Squares")

D_02_04_ess_fn <- function() D_02_03_ss_fn("ess", "Explained Sum of Squares")

D_02_05_rss_fn <- function() D_02_03_ss_fn("rss", "Residual Sum of Squares")

###### D_02_06: Lecture 2.2: What R-Squared Does Not Tell You ##################
# Note: Three separate populations, three separate figures. Shown one at a
#       time the number on each is the argument; shown together they become a
#       puzzle to decode. Each carries its own R-squared and slope in the
#       subtitle.

D_02_06_rsq_fn <- function(data_df, title_chr) {

  fit_lst <- C_01_03_fit_fn(data_df)

  D_00_01_base_fn(data_df, fit_lst, title_chr,
                  sprintf("R-squared %.2f, slope %.2f",
                          fit_lst$r_squared_dbl, fit_lst$slope_dbl)) +
    geom_point(colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl)
}

D_02_06_tight_fn <- function() {
  D_02_06_rsq_fn(
    C_01_02_split_fn(C_01_01_population_fn(slope_dbl = 0.06,
                                           error_sd_dbl = 0.06))$sample_df,
    "A Tight Fit Around a Trivial Slope")
}

D_02_07_loose_fn <- function() {
  D_02_06_rsq_fn(
    C_01_02_split_fn(C_01_01_population_fn(slope_dbl = 2.40,
                                           error_sd_dbl = 14.8))$sample_df,
    "A Loose Fit Around a Large One")
}

D_02_08_curved_fn <- function() {
  D_02_06_rsq_fn(
    C_01_02_split_fn(C_01_01_population_fn(slope_dbl = 3.00,
                                           curvature_dbl = -0.50,
                                           error_sd_dbl = 1.20))$sample_df,
    "A Respectable Number, the Wrong Shape")
}

###### D_02_09: Lecture 2.2: The Line on Data It Has and Has Not Seen ##########
# Note: The fit computed on the sample, then drawn over the hold-out. Two
#       figures rather than a facet, so a deck can show the first, ask what
#       the second will look like, and only then show it.

D_02_09_fit_fn <- function(data_df, title_chr) {

  fit_lst <- C_01_03_fit_fn(C_02_05_sample_df)

  y_min_dbl <- min(C_02_05_sample_df$earnings_eur,
                   C_02_06_holdout_df$earnings_eur)
  y_max_dbl <- max(C_02_05_sample_df$earnings_eur,
                   C_02_06_holdout_df$earnings_eur)

  D_00_01_base_fn(data_df, fit_lst, title_chr) +
    geom_point(colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl) +
    coord_cartesian(ylim = c(y_min_dbl, y_max_dbl))
}

D_02_09_sample_fn <- function() {
  D_02_09_fit_fn(C_02_05_sample_df, "The Sample the Line Was Fitted On")
}

D_02_10_holdout_fn <- function() {
  D_02_09_fit_fn(C_02_06_holdout_df, "A Hold-Out It Has Never Seen")
}

###### D_03_01: Lecture 2.3: One Sample, and the Truth Behind It ###############
# Note: The population in grey, the sample we drew in colour, our estimate
#       navy and solid because it is what we computed, the truth green and
#       dashed because it is what we are comparing against.

D_03_01_onesample_fn <- function() {

  show_int <- sample(seq_len(nrow(C_02_03_population_df)), 4000)
  fit_lst  <- C_01_03_fit_fn(C_02_05_sample_df)

  D_00_01_base_fn(C_02_03_population_df[show_int, ], fit_lst,
                  sprintf("Truth %.2f, This Sample Says %.2f",
                          B_03_02_true_slope_dbl, fit_lst$slope_dbl)) +
    geom_point(colour = C_02_02_colour_lst$rule,
               size = B_06_07_cloud_size_dbl,
               alpha = B_06_08_cloud_alpha_dbl) +
    geom_point(data = C_02_05_sample_df,
               colour = C_02_02_colour_lst$band,
               size = B_06_03_point_size_dbl,
               alpha = B_06_06_point_alpha_dbl) +
    geom_abline(intercept = B_03_01_true_intercept_dbl -
                  B_03_02_true_slope_dbl * B_03_03_centre_year_dbl,
                slope = B_03_02_true_slope_dbl,
                colour = C_02_02_colour_lst$compare,
                linewidth = B_06_04_line_width_dbl,
                linetype = "dashed")
}

###### D_03_02: Lecture 2.3: Five Hundred Samples ##############################
# Note: Draw another hundred and twenty people, fit again, keep the slope,
#       repeat. The histogram is the sampling distribution and it is centred
#       on the truth, which is what unbiasedness claims.

D_03_02_sampling_fn <- function() {

  slope_dbl <- C_01_05_repeat_fn(C_02_03_population_df)
  one_dbl   <- C_01_03_fit_fn(C_02_05_sample_df)$slope_dbl

  ggplot(data.frame(slope_dbl = slope_dbl), aes(slope_dbl)) +
    geom_histogram(bins = 40, fill = C_02_02_colour_lst$main,
                   colour = NA, alpha = B_06_10_fill_alpha_dbl) +
    geom_vline(xintercept = B_03_02_true_slope_dbl,
               colour = C_02_02_colour_lst$compare,
               linewidth = B_06_04_line_width_dbl,
               linetype = "dashed") +
    geom_vline(xintercept = one_dbl,
               colour = C_02_02_colour_lst$ink,
               linewidth = B_06_04_line_width_dbl) +
    labs(x = "Estimated return to a year of schooling (euro)",
         y = "Samples",
         title = sprintf("500 Samples, Mean Estimate %.2f, Truth %.2f",
                         mean(slope_dbl), B_03_02_true_slope_dbl)) +
    C_02_01_theme_fn()
}

###### D_03_03: Lecture 2.3: What Makes an Estimate Precise ####################
# Note: Three separate figures, one per ingredient of the variance formula.
#       Shown one at a time each one is a claim; the x-axis is fixed across
#       all three so the narrowing is comparable from slide to slide.

D_03_03_precision_fn <- function(compare_dbl, title_chr) {

  panel_df <- rbind(
    data.frame(slope_dbl = C_01_05_repeat_fn(C_02_03_population_df),
               which_chr = "Baseline"),
    data.frame(slope_dbl = compare_dbl, which_chr = "Changed")
  )

  ggplot(panel_df, aes(slope_dbl, fill = which_chr)) +
    geom_density(alpha = B_06_10_fill_alpha_dbl, colour = NA,
                 adjust = B_06_12_density_adjust_dbl) +
    geom_vline(xintercept = B_03_02_true_slope_dbl,
               colour = C_02_02_colour_lst$compare,
               linewidth = B_06_05_thin_width_dbl,
               linetype = "dashed") +
    scale_fill_manual(values = c(Baseline = C_02_02_colour_lst$rule,
                                 Changed  = C_02_02_colour_lst$main)) +
    coord_cartesian(xlim = c(0.75, 1.85)) +
    labs(x = "Estimated return to a year of schooling (euro)",
         y = "Density", fill = NULL, title = title_chr) +
    C_02_01_theme_fn() +
    theme(legend.position = "none")
}

D_03_03_bigger_n_fn <- function() {
  D_03_03_precision_fn(
    C_01_05_repeat_fn(C_02_03_population_df, n_int = 480L),
    "Four Times the Sample")
}

D_03_04_wider_x_fn <- function() {
  D_03_03_precision_fn(
    C_01_05_repeat_fn(C_01_01_population_fn(n_int = 60000L,
                                            spread_dbl = 4.5)),
    "More Spread in Schooling")
}

D_03_05_less_noise_fn <- function() {
  D_03_03_precision_fn(
    C_01_05_repeat_fn(C_01_01_population_fn(n_int = 60000L,
                                            error_sd_dbl = 2.2)),
    "A Smaller Error")
}

###### D_03_06: Lecture 2.3: Best, Among Linear Unbiased Estimators ############
# Note: Least squares against an estimator that uses only the two extreme
#       observations. Both are linear, both unbiased, and one is obviously
#       worse. That gap is what the Gauss-Markov theorem claims.

D_03_06_blue_fn <- function() {

  compare_df <- C_01_07_compare_fn(C_02_03_population_df)
  compare_df <- compare_df[is.finite(compare_df$slope_dbl), ]
  spread_dbl <- tapply(compare_df$slope_dbl, compare_df$estimator_chr, sd)

  ggplot(compare_df, aes(slope_dbl, fill = estimator_chr)) +
    geom_density(alpha = B_06_10_fill_alpha_dbl, colour = NA,
                 adjust = B_06_12_density_adjust_dbl) +
    geom_vline(xintercept = B_03_02_true_slope_dbl,
               colour = C_02_02_colour_lst$compare,
               linewidth = B_06_04_line_width_dbl,
               linetype = "dashed") +
    scale_fill_manual(values = c(
      "Least squares" = C_02_02_colour_lst$main,
      "Two-point"     = C_02_02_colour_lst$reference)) +
    labs(x = "Estimated return to a year of schooling (euro)",
         y = "Density", fill = NULL,
         title = "Both Unbiased. One Is Much Less Use.",
         subtitle = sprintf("Standard deviation %.2f against %.2f",
                            spread_dbl[["Least squares"]],
                            spread_dbl[["Two-point"]])) +
    C_02_01_theme_fn() +
    theme(legend.position = B_06_13_legend_pos_chr)
}

###### D_04_01: Lecture 2.4: The Estimate, Its Interval, and the Null ##########
# Note: One estimate with its confidence interval shaded, and the null at
#       zero. Rejecting is a statement about where the interval sits.

D_04_01_interval_fn <- function(data_df = C_02_05_sample_df) {

  fit_lst  <- C_01_03_fit_fn(data_df)
  grid_dbl <- seq(fit_lst$slope_dbl - 4 * fit_lst$slope_se_dbl,
                  fit_lst$slope_dbl + 4 * fit_lst$slope_se_dbl,
                  length.out = 400)

  curve_df <- data.frame(
    slope_dbl   = grid_dbl,
    density_dbl = dnorm(grid_dbl, fit_lst$slope_dbl, fit_lst$slope_se_dbl)
  )

  lower_dbl <- fit_lst$slope_dbl - 1.96 * fit_lst$slope_se_dbl
  upper_dbl <- fit_lst$slope_dbl + 1.96 * fit_lst$slope_se_dbl
  inside_df <- curve_df[curve_df$slope_dbl >= lower_dbl &
                          curve_df$slope_dbl <= upper_dbl, ]

  ggplot(curve_df, aes(slope_dbl, density_dbl)) +
    geom_area(data = inside_df, fill = C_02_02_colour_lst$band,
              alpha = B_06_10_fill_alpha_dbl) +
    geom_line(colour = C_02_02_colour_lst$main,
              linewidth = B_06_04_line_width_dbl) +
    geom_vline(xintercept = 0, colour = C_02_02_colour_lst$reference,
               linetype = "dashed",
               linewidth = B_06_05_thin_width_dbl) +
    labs(x = "Return to a year of schooling (euro)", y = "Density",
         title = sprintf("Estimate %.2f, Interval %.2f to %.2f",
                         fit_lst$slope_dbl, lower_dbl, upper_dbl)) +
    C_02_01_theme_fn()
}

###### D_04_02: Lecture 2.4: Significance Is Not Size ##########################
# Note: Four studies reporting the same return on samples of different sizes.
#       Two are significant and two are not, and the effect is identical in
#       all four. The week's standing question, as a picture.

D_04_02_studies_fn <- function() {

  study_df <- data.frame(
    study_chr = factor(c("n = 60", "n = 240", "n = 960", "n = 3,840"),
                       levels = c("n = 3,840", "n = 960",
                                  "n = 240", "n = 60")),
    slope_dbl = rep(B_03_02_true_slope_dbl, 4),
    se_dbl    = c(0.92, 0.46, 0.23, 0.115)
  )

  study_df$lower_dbl <- study_df$slope_dbl - 1.96 * study_df$se_dbl
  study_df$upper_dbl <- study_df$slope_dbl + 1.96 * study_df$se_dbl
  study_df$verdict_chr <- ifelse(study_df$lower_dbl > 0,
                                 "Rejects the Null", "Does Not Reject")

  ggplot(study_df, aes(slope_dbl, study_chr, colour = verdict_chr)) +
    geom_vline(xintercept = 0, colour = C_02_02_colour_lst$reference,
               linetype = "dashed",
               linewidth = B_06_05_thin_width_dbl) +
    geom_errorbarh(aes(xmin = lower_dbl, xmax = upper_dbl),
                   height = 0.18, linewidth = B_06_04_line_width_dbl) +
    geom_point(size = B_06_09_mark_size_dbl) +
    scale_colour_manual(values = c(
      "Rejects the Null" = C_02_02_colour_lst$main,
      "Does Not Reject"  = C_02_02_colour_lst$reference)) +
    labs(x = "Estimated return to a year of schooling (euro)",
         y = NULL, colour = NULL,
         title = "The Same Effect, Four Times Over") +
    C_02_01_theme_fn() +
    theme(legend.position = B_06_13_legend_pos_chr)
}

###### D_05_00: Shared Machinery for the Moment Figures ########################
# Note: One standardiser and two builders, so the moment exhibits are the same
#       plot with different draws. Every one is standardised to the reference
#       mean and spread, which is the teaching point for skewness and
#       kurtosis: the mean and the variance cannot tell those distributions
#       apart.
#
#       REVISED 18 September, three changes Sam asked for.
#
#       THE STANDARD NORMAL IS A GHOST IN EVERY SHAPE FIGURE. The mean,
#       variance and kurtosis exhibits already carried a reference normal.
#       The three skewness exhibits carried none, so the room was shown a
#       lopsided curve with nothing to see it as lopsided against.
#
#       THE COMPARATOR IS THE BRIGHTER BLUE, not a grey. These figures had
#       been drawn in navy and grey throughout, which wastes the palette: the
#       house ramp is dark navy, a brighter blue and the one green, and a
#       comparator is a SERIES, not panel furniture. The rule colour is the
#       gridline colour and a distribution drawn in it vanishes into the
#       panel.
#
#       NO SUBTITLES. What each exhibit shows belongs in the .tablenotes
#       under it in the deck, where it can be re-wrapped and re-sized. A
#       sentence baked into a PNG cannot be. This also retires the kurtosis
#       subtitle "A sharper peak, and far more in the tails", which the deck
#       corrected months ago - Wooldridge B-3h p.697 supports the tails and
#       not the peak - and which had survived here.

D_05_00_draws_int <- 200000L

# Note: ONE Y CEILING FOR EVERY SHAPE EXHIBIT, and one x range per pair. The
#   standard normal behind each of these peaks at 0.397 every time, so on a
#   free y axis the ghost is drawn at a different height in every figure and a
#   room comparing them cannot see it is the same curve. 0.60 clears the
#   tallest curve in the set - the skewed gamma at 0.569 and the lognormal at
#   0.582 - which is why those two carry the parameters they do. An exhibit
#   whose peak would exceed 0.60 changes its distribution, not this number.
D_05_00_ymax_dbl <- 0.60

D_05_00_centre_fn <- function(x_dbl) (x_dbl - mean(x_dbl)) / sd(x_dbl)

D_05_00a_ghost_fn <- function(lo_dbl = -6, hi_dbl = 6) {
  stat_function(fun = stats::dnorm, xlim = c(lo_dbl, hi_dbl),
                geom = "area", fill = T_01_01_palette_vec[["blue"]],
                colour = NA, alpha = 0.22, n = 512L)
}

D_05_00_against_fn <- function(other_dbl, title_chr, lo_dbl, hi_dbl,
                               ymax_dbl = D_05_00_ymax_dbl) {

  ggplot(data.frame(value_dbl = other_dbl), aes(value_dbl)) +
    D_05_00a_ghost_fn(lo_dbl - 2, hi_dbl + 2) +
    geom_density(fill = C_02_02_colour_lst$main, colour = NA,
                 alpha = B_06_10_fill_alpha_dbl,
                 adjust = B_06_12_density_adjust_dbl) +
    coord_cartesian(xlim = c(lo_dbl, hi_dbl), ylim = c(0, ymax_dbl)) +
    labs(x = "Standard deviations from the mean", y = "Density",
         title = title_chr) +
    C_02_01_theme_fn()
}

D_05_00_shape_fn <- function(value_dbl, title_chr,
                             lo_dbl = -3.6, hi_dbl = 3.6,
                             ymax_dbl = D_05_00_ymax_dbl) {

  ggplot(data.frame(value_dbl = value_dbl), aes(value_dbl)) +
    D_05_00a_ghost_fn(lo_dbl - 2, hi_dbl + 2) +
    geom_density(fill = C_02_02_colour_lst$main, colour = NA,
                 alpha = B_06_10_fill_alpha_dbl,
                 adjust = B_06_12_density_adjust_dbl) +
    geom_vline(xintercept = median(value_dbl),
               colour = T_01_01_palette_vec[["blue"]],
               linewidth = B_06_04_line_width_dbl) +
    geom_vline(xintercept = mean(value_dbl),
               colour = C_02_02_colour_lst$compare,
               linewidth = B_06_04_line_width_dbl, linetype = "dashed") +
    coord_cartesian(xlim = c(lo_dbl, hi_dbl), ylim = c(0, ymax_dbl)) +
    labs(x = "Standard deviations from the mean", y = "Density",
         title = title_chr) +
    C_02_01_theme_fn()
}

###### D_05_01: Lecture 1.1: The Mean ##########################################
# Note: Same spread, different centre. The first moment on its own.

D_05_01_mean_fn <- function() {
  D_05_00_against_fn(rnorm(D_05_00_draws_int, 1.5),
                     "The Mean Is Where a Distribution Sits", -6.5, 6.5)
}

###### D_05_02: Lecture 1.1: The Variance ######################################
# Note: Same centre, different spread. The second moment on its own.

D_05_02_variance_fn <- function() {
  D_05_00_against_fn(rnorm(D_05_00_draws_int, 0, 2.2),
                     "The Variance Is How Wide It Is", -6.5, 6.5)
}

###### D_05_03: Lecture 1.1: Skewness, Three Figures ###########################
# Note: Blue solid is the median, green dashed the mean; the gap between them
#       is what skewness does to a summary statistic. The pale blue behind is
#       the standard normal, where the two coincide.

D_05_03_skew_negative_fn <- function() {
  D_05_00_shape_fn(
    -D_05_00_centre_fn(rgamma(D_05_00_draws_int, shape = 1.6, rate = 1)),
    "Negative Skew")
}

D_05_04_skew_symmetric_fn <- function() {
  D_05_00_shape_fn(rnorm(D_05_00_draws_int), "Symmetric")
}

D_05_05_skew_positive_fn <- function() {
  D_05_00_shape_fn(
    D_05_00_centre_fn(rgamma(D_05_00_draws_int, shape = 1.6, rate = 1)),
    "Positive Skew")
}

###### D_05_06: Lecture 1.1: Kurtosis, Three Figures ###########################
# Note: Light, normal and heavy tails against the same standard normal. All
#       three share its mean and variance, so what differs is only how often
#       something turns up a long way from the middle.

D_05_06_kurtosis_light_fn <- function() {
  D_05_00_against_fn(D_05_00_centre_fn(runif(D_05_00_draws_int)),
                     "Light Tails", -4, 4)
}

D_05_07_kurtosis_normal_fn <- function() {
  D_05_00_against_fn(rnorm(D_05_00_draws_int), "Normal Tails", -4, 4)
}

D_05_08_kurtosis_heavy_fn <- function() {
  D_05_00_against_fn(D_05_00_centre_fn(rt(D_05_00_draws_int, df = 4)),
                     "Heavy Tails", -4, 4)
}

###### D_05_09: Lecture 1.1: Mean, Median and Mode, Two Figures ################
# Note: A pair, not an overlay. Drawing a skewed curve on top of a normal and
#       marking three centres on it put five things in one panel and the room
#       could not tell which line belonged to which curve. Side by side, each
#       panel answers one question: where do the three sit when the tail is
#       long, and where do they sit when it is not.
#
#       THE GHOST NORMAL SITS BEHIND BOTH PANELS, as it does behind every
#       other shape exhibit in this lecture. On the symmetric panel it is the
#       same curve drawn twice, which is the point: the room sees the
#       reference and the data coincide.
#
#       LOGNORMAL, NOT POISSON. Sam asked for a Poisson. It cannot do this
#       job: it is discrete, so its median and mode are both integers and its
#       mean is lambda, and they collide at every lambda worth drawing -
#       checked at 0.8, 1.5, 2.5, 3, 3.4, 4.5, 6 and 10, and at every one of
#       them either mode = median or median = mean. The lognormal separates
#       all three by construction, mode = exp(mu - sigma^2) < median =
#       exp(mu) < mean = exp(mu + sigma^2 / 2), and it is the standard model
#       of an earnings distribution, which is what this module is about.
#
#       The three positions are computed from the closed forms and then put
#       on the same standardised scale as the curve, so they are exact rather
#       than read off a kernel density.

D_05_09_lo_dbl   <- -3.0
D_05_09_hi_dbl   <-  4.2
D_05_09_sigma_dbl <- 0.55

D_05_09_panel_fn <- function(value_dbl, at_dbl, lab_chr, title_chr) {

  ggplot(data.frame(value_dbl = value_dbl), aes(value_dbl)) +
    D_05_00a_ghost_fn(D_05_09_lo_dbl - 2, D_05_09_hi_dbl + 2) +
    geom_density(fill = C_02_02_colour_lst$main, colour = NA,
                 alpha = B_06_10_fill_alpha_dbl,
                 adjust = B_06_12_density_adjust_dbl) +
    geom_vline(xintercept = at_dbl,
               colour = c(T_01_01_palette_vec[["navy"]],
                          T_01_01_palette_vec[["blue"]],
                          T_01_01_palette_vec[["green"]])[seq_along(at_dbl)],
               linewidth = B_06_04_line_width_dbl) +
    T_02_02_mark_x_fn(at = at_dbl, lab = lab_chr) +
    coord_cartesian(xlim = c(D_05_09_lo_dbl, D_05_09_hi_dbl),
                    ylim = c(0, D_05_00_ymax_dbl)) +
    labs(x = "Standard deviations from the mean", y = "Density",
         title = title_chr) +
    C_02_01_theme_fn()
}

D_05_09_skewed_fn <- function() {

  s_dbl <- D_05_09_sigma_dbl
  raw_dbl <- rlnorm(D_05_00_draws_int, meanlog = 0, sdlog = s_dbl)

  mean_raw   <- exp(s_dbl^2 / 2)
  sd_raw     <- sqrt((exp(s_dbl^2) - 1) * exp(s_dbl^2))
  std_fn     <- function(v) (v - mean_raw) / sd_raw

  D_05_09_panel_fn(
    value_dbl = std_fn(raw_dbl),
    at_dbl    = std_fn(c(exp(-s_dbl^2), 1, mean_raw)),
    lab_chr   = c("Mode", "Median\n", "\nMean"),
    title_chr = "Right-Skewed Distribution")
}

D_05_09b_symmetric_fn <- function() {
  D_05_09_panel_fn(
    value_dbl = rnorm(D_05_00_draws_int),
    at_dbl    = 0,
    lab_chr   = "Mode = Median = Mean",
    title_chr = "Symmetric Distribution")
}

###### D_05_10: Lecture 1.1: Weak, Medium and Strong Co-movement ###############
# Note: THREE SEPARATE FIGURES, not one faceted one. Faceted, the three panels
#       shared a y axis and a strip band, and \fig caps the whole thing at
#       0.42\textheight - so three scatters arrived on the slide too small to
#       read. Three files drawn side by side with \figtriple each get a third
#       of the line width and their own axes.
#
#       Cohen's own 0.1, 0.3 and 0.5, so the bands on the correlation frame
#       stop being abstract, and all three on ONE pair of scales.
#
#       THE CORRELATION IS EXACT, not drawn and then measured. The second
#       variable is built from the part of a fresh draw orthogonal to the
#       first, so each panel realises the number in its title to the digit
#       shown. A panel labelled 0.50 that had come out 0.43 would undercut the
#       frame it is there to support.

D_05_10_n_int    <- 160L
D_05_10_lim_dbl  <- 2.8

D_05_10_exact_fn <- function(x_dbl, rho_dbl) {
  e_dbl <- rnorm(length(x_dbl))
  e_dbl <- scale(e_dbl - x_dbl * sum(x_dbl * e_dbl) / sum(x_dbl^2))[, 1]
  rho_dbl * x_dbl + sqrt(1 - rho_dbl^2) * e_dbl
}

D_05_10_panel_fn <- function(rho_dbl, title_chr) {

  x_dbl <- scale(rnorm(D_05_10_n_int))[, 1]

  ggplot(data.frame(x_dbl = x_dbl, y_dbl = D_05_10_exact_fn(x_dbl, rho_dbl)),
         aes(x_dbl, y_dbl)) +
    T_02_02_zero_fn() +
    geom_point(colour = C_02_02_colour_lst$main, alpha = 0.55, size = 1.3) +
    coord_cartesian(xlim = c(-D_05_10_lim_dbl, D_05_10_lim_dbl),
                    ylim = c(-D_05_10_lim_dbl, D_05_10_lim_dbl)) +
    labs(x = "Schooling", y = "Earnings", title = title_chr) +
    C_02_07_panel_theme_fn()
}

D_05_10_cohen_weak_fn   <- function() D_05_10_panel_fn(0.10, "Weak Correlation, r = 0.10")
D_05_11_cohen_medium_fn <- function() D_05_10_panel_fn(0.30, "Medium Correlation, r = 0.30")
D_05_12_cohen_strong_fn <- function() D_05_10_panel_fn(0.50, "Strong Correlation, r = 0.50")

################################################################################
## D_06_01: Lecture 1.2: The CEF as a Column of Averages                      ##
################################################################################
# Note: Drafted 18 September, for the frame "The Conditional Expectation
#   Function in This Population". It replaces a spec that asked for 200,000
#   greyed-out points behind ten binned means. Those points cannot be counted,
#   and counting is the whole content of this figure.
#
#   ONE HUNDRED PEOPLE, TEN SCHOOLING LEVELS, UNEVENLY SPREAD. The count in a
#   column is the weight on that column, drawn as dots rather than written as
#   a number. Three things are then readable off one panel:
#
#     1. WITHIN a column the dots carry equal weight, so the column mean is a
#        plain average. That is the conditional expectation, and it needs no
#        machinery beyond Lecture 1.1.
#     2. ACROSS columns the counts differ, so the pooled average of all one
#        hundred is NOT the plain average of the ten column means. The two
#        horizontal rules are exactly that difference.
#     3. A thin column's mean sits further off the line than a fat column's.
#        Lecture 1.3 is that observation with a standard error attached.
#
#   THE SEED IS CHOSEN, AND THE RULE IS STATED. Searching 1200-1400, this is
#   the draw whose worst column mean sits closest to the population line in
#   standard errors - no column further off than 0.87 of its own standard
#   error. The criterion is "the least freakish draw", fixed before looking,
#   not "the draw that tells the best story": a seed picked for its picture
#   would have to be defended every time a student asked why the figure looks
#   tidier than their own tutorial output. The point of the rule is that the
#   binned means look like the line they came from, which is what the frame's
#   tablenotes claim, and an unlucky two-sigma column would flatly contradict
#   it on the one slide where the claim is made.
#
#   THE COUNTS ARE FIXED, NOT DRAWN. A sampled schooling distribution comes
#   back near-symmetric, and a symmetric set of weights puts the two rules on
#   top of each other - the figure would then show that weighting changes
#   nothing, which is the opposite of the point. These counts are the module's
#   own: clustered at twelve and thinning to the right, which is also closer to
#   an Irish schooling distribution than the generator's normal.

D_06_01_level_int <- 9:18

D_06_01_count_int <- c(4L, 9L, 16L, 20L, 17L, 13L, 9L, 6L, 4L, 2L)

###### D_06_01a: The Hundred #################################################
# Note: Earnings are drawn from the module's own generator - the population
#   line at B_03_01 and B_03_02, the error at B_03_08 - so this figure and
#   every figure in block 2 describe the same world. The seed is fixed here
#   rather than globally: this builder must return the same hundred people
#   every time the deck renders, or the numbers in the frame's tablenotes go
#   stale without anyone touching the slide.

D_06_01a_draw_fn <- function(seed_int = 1300L) {

  stopifnot(sum(D_06_01_count_int) == 100L,
            length(D_06_01_count_int) == length(D_06_01_level_int))

  old_lst <- .Random.seed
  on.exit({ if (!is.null(old_lst)) .Random.seed <<- old_lst }, add = TRUE)
  set.seed(seed_int)

  school_dbl <- rep(D_06_01_level_int, times = D_06_01_count_int)

  data.frame(
    schooling_yrs = school_dbl,
    earnings_eur  = B_03_01_true_intercept_dbl +
      B_03_02_true_slope_dbl * (school_dbl - B_03_03_centre_year_dbl) +
      rnorm(length(school_dbl), 0, B_03_08_error_sd_dbl)
  )
}

###### D_06_01b: The Figure ###################################################
# Note: Colour carries the argument, so it follows the house ramp rather than
#   being picked here. The hundred are BAND, light blue, because they are the
#   raw data sitting behind. The ten column means are MAIN, navy, because they
#   are what the slide is about. The population line is BLUE, the brighter one,
#   because it is a second series and not panel furniture. The pooled average
#   is COMPARE, green dashed, because it is the thing the column means are
#   being measured against.
#
#   The naive rule - average the ten column means and ignore the counts - is
#   NAVY DOTTED, not grey, because it is computed from the navy points and
#   nothing else. Grey was tried and is wrong twice over: it is the gridline
#   colour, so the line vanished into the panel, and it implied the figure's
#   second subject was panel furniture. Dotted rather than solid marks it as
#   the arithmetic a student is being warned off, and the gap between it and
#   the green rule is the size of that mistake in euro.
#
#   THE TWO RULES ARE NAMED ON THE RIGHT-HAND AXIS, which is the house
#   treatment for a reference level: a number floating mid-panel is debris,
#   the same number on an axis is a landmark, and here the whole argument is
#   the distance between two landmarks.
#
#   THE COUNTS ARE IN THE PANEL AND CARRY THEIR OWN "n = ". They were on the
#   top axis first and read as a broken second x scale - ten bare numbers with
#   ticks under them, which is what an axis looks like. A count is not a
#   reference level and does not belong on an axis; it is an annotation on a
#   column and belongs under that column, saying what it is.
#
#   NO LINE JOINS THE TEN COLUMN MEANS. One was drawn and removed: connecting
#   them asserts a jagged CEF, when the CEF is the smooth blue line and the
#   navy points are ten noisy estimates of it. The zigzag was an artefact of
#   the sample being read as an object.
#
#   THE BOX IS THE CONDITIONAL SPREAD AND ITS BAR IS THE MEDIAN, NOT THE MEAN.
#   Those are two different centres and the frame two back in this section is
#   about the difference, so the mean keeps its own mark - the navy dot - and
#   the box keeps its own colour. Say it out loud when the figure goes up: the
#   bar in the box is the median from Lecture 1.1, the navy dot is the mean,
#   and they part company wherever the column is skewed. A figure that let the
#   median bar stand in for the conditional mean would quietly undo the one
#   distinction the previous section spent a slide on.
#
#   THE BOX IS DRAWN THIN ON PURPOSE - 0.22, below the toolkit's own thin
#   width, and fatten 1.3 so the median bar is not three times the weight of
#   the box around it. Ten boxes at the normal line weight take over the panel:
#   the navy means and the two horizontal rules are the argument, and the boxes
#   are context behind them. Lightening the COLOUR was tried first and is the
#   wrong lever - it pushes a series towards the greys, which is the standing
#   palette failure. Thin the line and keep the colour.
#
#   KNOWN WEAKNESS, LEFT IN DELIBERATELY. The eighteen-year column has two
#   people in it and the nine- and seventeen-year columns have four, and a box
#   drawn from two points asserts quartiles that do not exist. It is left
#   because the thin columns are half the argument: their boxes are absurd for
#   the same reason their means are unreliable, which is that almost nobody is
#   in them. If it reads as sloppiness rather than as the point, drop the box
#   below n = 5 and leave the dots.

D_06_01b_cef_fn <- function() {

  data_df <- D_06_01a_draw_fn()

  mean_df <- stats::aggregate(earnings_eur ~ schooling_yrs,
                              data = data_df, FUN = mean)
  mean_df$count_int <- D_06_01_count_int

  pooled_dbl <- mean(data_df$earnings_eur)
  naive_dbl  <- mean(mean_df$earnings_eur)

  jitter_df <- data_df
  set.seed(1203L)
  offset_dbl <- stats::runif(nrow(jitter_df), -0.17, 0.17)
  offset_dbl <- offset_dbl -
    ave(offset_dbl, jitter_df$schooling_yrs, FUN = mean)
  jitter_df$jitter_dbl <- jitter_df$schooling_yrs + offset_dbl

  mean_df$label_chr <- paste0("n = ", mean_df$count_int)
  floor_dbl <- min(data_df$earnings_eur) - 1.5

  ggplot(data_df, aes(schooling_yrs, earnings_eur)) +

    geom_hline(yintercept = naive_dbl,
               colour = C_02_02_colour_lst$main,
               linewidth = B_06_05_thin_width_dbl, linetype = "dotted") +
    geom_hline(yintercept = pooled_dbl,
               colour = C_02_02_colour_lst$compare,
               linewidth = B_06_04_line_width_dbl, linetype = "dashed") +

    geom_abline(intercept = B_03_01_true_intercept_dbl -
                  B_03_02_true_slope_dbl * B_03_03_centre_year_dbl,
                slope = B_03_02_true_slope_dbl,
                colour = T_01_01_palette_vec[["blue"]],
                linewidth = B_06_05_thin_width_dbl) +

    geom_boxplot(aes(group = schooling_yrs),
                 width = 0.55, fill = NA,
                 colour = T_01_01_palette_vec[["bluedk"]],
                 linewidth = 0.22, fatten = 1.3,
                 outlier.shape = NA, coef = 1.5) +

    geom_point(data = jitter_df, aes(jitter_dbl, earnings_eur),
               colour = C_02_02_colour_lst$band,
               size = B_06_07_cloud_size_dbl + 0.45,
               alpha = 0.95) +

    geom_point(data = mean_df, aes(schooling_yrs, earnings_eur),
               colour = C_02_02_colour_lst$main,
               size = B_06_09_mark_size_dbl) +

    geom_text(data = mean_df,
              aes(schooling_yrs, floor_dbl, label = label_chr),
              colour = C_02_02_colour_lst$ink, size = 2.35) +

    T_02_02_mark_y_fn(
      at  = c(pooled_dbl, naive_dbl),
      lab = c("Pooled", "Unweighted")) +

    scale_x_continuous(breaks = D_06_01_level_int) +
    coord_cartesian(ylim = c(floor_dbl - 0.6, NA)) +
    labs(x = B_06_01_x_label_chr, y = B_06_02_y_label_chr,
         title = "Each Navy Point Is the Average of the Column Beneath It") +
    C_02_01_theme_fn()
}

#--------------------------------- Script End ---------------------------------#
