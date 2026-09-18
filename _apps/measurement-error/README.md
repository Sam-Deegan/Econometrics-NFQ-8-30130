# Measurement error and reverse causality

Lecture 4.2. **Not built.**

Noise slider on $x$ showing attenuation, then a switch that reverses the causal direction in the data-generating process while the regression output barely changes.

## Pattern

Follow the ECON42550 apps: `app.R` at the top, model code in `R/model.R`, shared chrome in
`R/toolkit.R` copied from `_apps/_toolkit/dublin_app.R`.

If a figure from this app ends up on a slide, export it with a script in `_apps/` so the slide
and the app cannot drift apart — ECON42550 does this with `export_figures.R`.

For embedding in a deck, `shinylive::export()` gives a serverless copy that runs from a static
directory. `quarto-live` with `format: live-revealjs` is the other route, and lets an Observable
slider drive a real R cell.
