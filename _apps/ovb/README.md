# Omitted variable bias

Lecture 3.1. **Not built.**

Two sliders: the effect of the omitted variable on $y$, and its correlation with $x$. Show the short and long coefficients moving apart with the bias arithmetic live. Highest-value app in the module — nothing interactive exists for this anywhere, and it is the organising formula of the whole course.

## Pattern

Follow the ECON42550 apps: `app.R` at the top, model code in `R/model.R`, shared chrome in
`R/toolkit.R` copied from `_apps/_toolkit/dublin_app.R`.

If a figure from this app ends up on a slide, export it with a script in `_apps/` so the slide
and the app cannot drift apart — ECON42550 does this with `export_figures.R`.

For embedding in a deck, `shinylive::export()` gives a serverless copy that runs from a static
directory. `quarto-live` with `format: live-revealjs` is the other route, and lets an Observable
slider drive a real R cell.
