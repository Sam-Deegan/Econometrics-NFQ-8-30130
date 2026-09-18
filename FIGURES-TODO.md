# Econometrics I — Figure Build List

Thirty-two exhibits are specified but not yet drawn. Every one sits in a deck
as `\figsmall{../_shared/placeholder.pdf}{...}` with an HTML `<!-- FIGURE -->`
comment underneath carrying the specification reproduced below.

The rule this list assumes: **no figure is drawn by hand.** Each one is a
builder function in `_apps/regression/R/model.R` (or a sibling app), registered
in `_apps/export_figures.R`, exported to `_shared/figures/` at 160 mm wide and
300 dpi. Editing a PNG is never the fix; editing the builder is.

Shapes available in the register: `wide` 160x50, `panel` 160x46, `tall` 160x70,
`short` 160x46 mm. Decks call `\figsmall` (0.34\textheight) so a `.takeaway`
callout fits underneath.

Colour convention, from `T_01_02_series_vec` — realised series navy solid,
comparison green dashed, bands light blue, reference lines grey dashed. Two of
the specifications below were written before that convention settled and say
"green is the truth": in those, truth is the *comparison* series, so green
dashed is correct.

Block 2 (2.1-2.4) is already built: seventeen exported figures, no placeholders.

---

## Lecture 1.1  (2 exhibits)

- **`1-1_population.png`** — schooling on the horizontal, hourly earnings on the vertical. Population of 200,000 as a light grey point cloud, thinned or hexbinned so it renders. Sample of 120 in dgGreen, hold-out of 120 in dgNavy, both at full opacity. No fitted line - week 1 has no line yet. Needs the generator at its default settings with every flaw switched off, and the two draws at the module seed.
- **`1-1_same-correlation.png`** — a 2x2 panel of scatterplots, schooling against earnings, each n = 120 and each with r = 0.60 to two decimals. Panel A a plain linear draw; panel B a strong curve that turns over; panel C a flat cloud plus four high-leverage points; panel D two separate clusters with no relationship inside either. Print the correlation on each panel so the equality is visible. Needs the generator's shape switch plus a tuning loop to match r across panels.

## Lecture 1.2  (4 exhibits)

- **`1-2_expectation.png`** — the population earnings density in grey with a vertical rule at the population mean, overlaid with the histogram of the sample of 120 and a second, dashed vertical rule at the sample mean. Needs the full population and the standing sample of 120.
- **`1-2_conditional-distributions.png`** — three overlaid or small-multiple densities of earnings at x = 10, 12, 16, each with a vertical rule at its conditional mean (6.90, 9.50, 14.70) and a shared x axis. Needs the population only.
- **`1-2_cef.png`** — schooling on the horizontal axis, earnings on the vertical. Population scatter greyed out behind, one point per schooling bin at the mean of earnings in that bin, and the straight line E[y|x] = 9.50 + 1.30(x - 12) drawn through. Needs the population; the binned means must be computed, not smoothed.
- **`1-2_mse.png`** — horizontal axis a candidate constant guess c running from about 4 to 15, vertical axis E[(y - c)^2 | x = 12], one convex curve with its minimum marked at 9.50. Needs the population subset at x = 12.

## Lecture 1.3  (4 exhibits)

- **`1-3_sampling.png`** — histogram of 500 sample means, n = 120, drawn from the earnings population. Vertical rule at the true mean in green, and at our one sample's mean in dashed navy. Needs the generator and a replicate() loop; export from _apps/. This is the deck's central exhibit and 2-3 builds the same picture for the slope, so keep the geometry and the colours identical between the two.
- **`1-3_samplesize.png`** — three histograms of 500 sample means at n = 30, 120, 480, on a SHARED horizontal axis or the comparison is lost. Truth marked on each.
- **`1-3_clt.png`** — two panels. Left, the population density of earnings, visibly right-skewed. Right, the sampling distribution of the mean at n = 120 with a normal curve overlaid. The point only lands if the left panel is obviously not normal.
- **`1-3_intervals.png`** — 100 horizontal intervals stacked vertically, vertical rule at the true mean 11.52, misses in a contrasting colour with a heavier stroke. Around five should miss. Do NOT reuse the 2-4_interval.png geometry - that one shades a density, this one is a caterpillar plot.

## Lecture 3.1  (5 exhibits)

- **`3-1_anatomy.png`** — two panels side by side, a sample of 120. Left panel is the raw scatter with the simple fit (slope 1.57). Right panel plots earnings against the residual from schooling-on-parent, x-axis centred on zero, with its fit (slope 1.30). Needs B_05_01 = 0.50 and B_05_02 = 0.45. Annotate both slopes on the panels. Use figpair if both fit.
- **`3-1_diagram.png`** — a causal diagram, drawn not simulated. Schooling on the left, earnings on the right, arrow between them. Parent above with arrows down into both. Occupation on the arrow between schooling and earnings. Promotion below with arrows into it from both. Colour the three controls differently and label them confounder, mediator, collider. No model.R switch needed.
- **`3-1_collider.png`** — scatter of earnings on schooling for a sample of 120, points shaded by promotion, with the overall fit in green and separate fits within the promoted and the not-promoted in navy. The within-group lines should visibly tilt the other way. Needs B_05_04 = 0.50 and B_05_05 = 0.15. This is the figure students will remember, so give the within-group slopes on the panel.
- **`3-1_shortlong.png`** — sweep B_05_02 (parent -> pay) from 0 to 0.60 with B_05_01 fixed at 0.50, and plot two lines: the short coefficient, which climbs from 1.30 to about 1.67, and the long coefficient, which stays flat at 1.30. Mark the module's headline 1.30 with a reference line.
- **`3-1_ability.png`** — sweep B_04_01 (ability -> pay) across a plausible range with B_04_02 = 0.80, plotting the short coefficient against the truth at 1.30. Shade the region where the estimate exceeds 1.50, which is roughly what the module's block 2 sample reported.

## Lecture 3.2  (4 exhibits)

- **`3-2_levels-logs.png`** — two panels, same sample. Left, earnings on schooling with the fitted line. Right, log earnings on schooling with its fitted line. Needs identical point identities across panels so a student can follow one person from one panel to the other.
- **`3-2_dummy.png`** — one scatter, points coloured by the dummy, two parallel fitted lines. Needs the vertical gap annotated as delta, drawn at the sample mean of schooling rather than at zero.
- **`3-2_interaction.png`** — same scatter and colours as 3-2_dummy so the two slides read as one argument. Two non-parallel fitted lines. Needs the slope difference annotated, and the two lines extended back to zero schooling in a lighter weight so the intercept gap is visible.
- **`3-2_four-fits.png`** — one scatter, four fitted curves in the theme palette, all on the level scale so they are comparable. Needs the schooling range where eighty percent of the sample sits shaded, so the point lands: they agree where you have data and disagree where you do not.

## Lecture 3.3  (4 exhibits)

- **`3-3_restricted-unrestricted.png`** — two panels sharing a y-axis. Left, the unrestricted fit with residual segments drawn; right, the restricted fit with the region dummies forced to zero and its residual segments drawn. Underneath, two bars giving RSS_u and RSS_r on a common scale, with the gap between them shaded and labelled. The point to see is that the gap is small, not that it exists. Needs: the same sample and the same vertical scale in both panels, or the comparison is theatre.
- **`3-3_joint-region.png`** — axes are the two coefficient estimates. Draw the joint confidence region as a tilted ellipse, the origin plainly outside it, and the two marginal intervals as a horizontal and a vertical band that each straddle zero. Shade where the bands cross so the box-versus-ellipse difference is visible. Needs: enough tilt that the correlation between the two estimates is obvious - this figure is also the visual for section 3, and it should be recognisably the same picture when it comes back.
- **`3-3_minp.png`** — histogram of the MINIMUM p-value across twenty specifications, over a thousand searches, with a dashed vertical rule at 0.05 and the mass below it shaded. Beside it, faint, the uniform histogram of a single pre-specified p-value on the same axes, so the shift is the story rather than the shape. Annotate the shaded share - it is about two thirds. Needs: the true effect set to zero in the generator, and the caption to say so, or the figure proves nothing.
- **`3-3_collinear-se.png`** — x-axis the correlation between the two regressors, from 0 to 0.98. Two panels sharing that axis. Top, the standard error on the coefficient of interest, rising steeply at the right-hand end. Bottom, R-squared and the point estimate, both close to flat, with the estimate's confidence band widening around an unmoving centre. Needs: the same true coefficient throughout, stated in the caption, so that the flat centre line reads as unbiasedness rather than as an accident.

## Lecture 4.1  (4 exhibits)

- **`4-1_hetero-fan.png`** — residuals against schooling for one sample of 120, drawn from C_01_01_population_fn(hetero_gain_dbl = 0.18). Zero line in grey. Needs the hetero_gain switch in B_04 and nothing else.
- **`4-1_robust-vs-classical.png`** — classical SE and robust SE for the slope, plotted against hetero_gain_dbl running 0 to 0.30, one sample of 120 at each setting, with the point estimate on a second panel or as a flat reference line so students see it does not move. Needs the hetero_gain switch.
- **`4-1_runs.png`** — residuals from the straight-line fit, plotted in order of schooling, sample of 120 from C_01_01_population_fn(curvature_dbl = -0.09). Shade the runs of one sign. Needs the curvature switch. The point of drawing it from the curvature population rather than a time series is that the two faults produce the same picture.
- **`4-1_resid-fitted.png`** — two panels. Left, residuals against fitted values from a sample of 120 drawn with curvature_dbl = -0.09. Right, the same plot from a sample drawn with outlier_share_dbl = 0.04 and curvature off. Same axes on both so the shapes are comparable. Needs the curvature and outlier_share switches.

## Lecture 4.2  (5 exhibits)

- **`4-2_dgp.png`** — the causal diagram of C_01_01_population_fn, drawn rather than simulated. Boxes for A, S, S*, Y; solid arrows for the measured paths, a dashed pair from A to S and A to Y, an arrow from S to S* labelled with m, and a gate on Y labelled with the floor. Needs B_04_01 ability_pay, B_04_02 ability_school, B_04_03 misreport_sd and B_04_06 wage_floor all non-inert so the caption and the code agree.
- **`4-2_ability.png`** — sweep B_04_01 ability_pay and B_04_02 ability_school together from 0 to about 1.6, rebuild the population at each value, draw the usual sample, fit, plot the slope. Green dashed reference at B_03_02_true_slope_dbl. Mark the value used in the diagram on the previous slide so the two figures agree.
- **`4-2_floor.png`** — the population thinned to a few thousand points in grey, a horizontal rule at B_04_06 wage_floor set somewhere near the 25th percentile of earnings, the surviving points in light blue, and two fitted lines - the full-population line and the line through the survivors. Subtitle carries both slopes.
- **`4-2_attenuation.png`** — sweep B_04_03 misreport_sd from 0 to about 3.5 years, draw the population once per value, fit, and plot the slope. Green dashed reference at B_03_02_true_slope_dbl. One extra series in light blue: the estimate from the same draws using actual_yrs, which stays flat on the truth.
- **`4-2_reversed.png`** — scatter of the working sample, the y-on-x fit, and the x-on-y fit inverted onto the same axes. Subtitle carries both implied returns so the room sees two numbers, not two lines.