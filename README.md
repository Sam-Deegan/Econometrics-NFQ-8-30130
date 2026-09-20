# ECON30130 Econometrics I

First undergraduate econometrics module. Twelve weeks, one deck each, plus the
syllabus. Laid out to match ECON42550 so the two modules share a workflow, a
theme and a set of slide rules.

UCD's own title for the module is *Econometrics: Applying Statistics to
Economic Data*; "Econometrics I" is the working name here, against a planned
Part II. Live descriptor:
<https://hub.ucd.ie/usis/!W_HU_MENU.P_PUBLISH?MODULE=ECON30130&p_tag=MODULE> —
5 credits, level 3, 22 lecture hours plus 10 computer-lab hours, assessed
80% final examination and 20% on four in-class quizzes with the best three
counting. Coordinator: Dr Enda Hargaden.

**Both placeholders are now filled in.** `ECON30130` replaced `ECONXXXXX` in
every filename and header on 20 September 2026, and the term is set in the
`\date{}` line at the foot of `_shared/econometrics-roadmap.tex` — **check it
reads the trimester you are actually teaching**, since the module runs in both
Autumn and Spring.

## What this module is

OLS taught thoroughly, in scalar algebra. Research designs — instrumental
variables, difference-in-differences, regression discontinuity — are deferred
to Part II. Matrix notation is deferred to postgraduate. The causal caution is
carried by a standing question asked in the same slot every week rather than by
a dedicated block.

Decisions are in the project note `econometrics-part1-design.md`; the term
skeleton is the artifact *Twelve Weeks of OLS*.

## The twelve weeks

    1.1   Data and Variation       Data and Variation
    1.2   Conditional Means        Expectation and Conditional Means
    1.3   Sampling Variation       Estimators and Sampling Variation
    2.1   Fitting a Line           Fitting a Line
    2.2   Goodness of Fit          Goodness of Fit
    2.3   Bias and Precision       Bias and Precision
    2.4   Reporting an Estimate    Reporting an Estimate
    3.1   Adding Controls          Adding Controls
    3.2   Functional Form          Functional Form and Dummies
    3.3   Joint Tests              Joint Tests and Model Choice
    4.1   Diagnosing Violations    Diagnosing Violations
    4.2   Limits of Regression     What Regression Cannot Do

## Layout

    _quarto.yml                  makes this a Quarto project
    _extensions/deegan/dublin/   the Dublin theme, copied from ECON42550
    _shared/                     roadmap, bibliography, cover photo, crest, QR
    _apps/                       one folder per Shiny app, none built yet
    00_Syllabus-and-Introduction/
    1-1_… through 4-2_…          one folder per week

Shared assets live in `_shared/`, reached from a deck as `../_shared/…`, so a
deck renders from inside its own folder but not if it is moved up a level.

## Rendering

From inside a week's folder:

    quarto render ECON30130_Lecture_2-1.qmd

Or every deck at once, from here:

    quarto render

Render from inside the repo — Quarto finds `_extensions/` by walking up from
the file, so a copy in Downloads fails.

## Slide rules

Carried over from ECON42550 and repeated in the comment block at the head of
every deck:

1. **First appearance of an equation gets its notation**, terse, one symbol per
   line. No asides in the list; an argument about a symbol is a separate
   callout.
2. **Every equation states its objective first** — what question it answers, in
   one line.
3. **Notation conventions are taught as callouts where they first bite**, not
   collected on one reference slide. In this module the one that matters is the
   hat: a student who reads `beta-hat` and `beta` as the same object cannot be
   taught sampling variation.
4. **Scalar algebra only.** Matrix notation is postgraduate. Where the scalar
   expression stops being writable, regression anatomy does the work.
5. **Nothing is derived in the room.** Derivations live in the appendix and are
   set as homework; class time goes on the shape of the proof.
6. **Sections are named by content, never by ordinal**, and the same three
   names appear in the roadmap, the dividers and the closing summary.
7. **Sentence headlines**, title case.

## How each deck is built

    Where We Are          the roadmap, this week marked
    <retrieval>           last week's question, answered back
    Where This Lecture Goes
    # Section 1           goal line, content, ConcepTest
    Pause
    # Section 2           goal line, content, ConcepTest
    Pause
    # Section 3           goal line, content, ConcepTest
    What Would Have To Be True?      the standing question
    Application           predict before you run anything
    <summary>             .contributions, names matching the sections
    Before Week n+1       read / do / try
    ---- thanks ----
    ---- appendix ----    everything past here is numbered I, II, III
    Derivation            the week's proof, set as homework
    Notes and Tools
    References

Three ideas per session is the cap. Four ConcepTests per session: three are
drafted in each deck, the fourth is the prediction taken before the app runs.
Peer discussion is the active ingredient, so the revote is not optional.

The appendix divider is `::: {.appendix} :::` on a `## {.plain}` frame, not a
`# Appendix` heading — the div calls `\appendixcontent`, which is what switches
the frame counter to Roman. One list per appendix frame: a long list plus
sub-headings overruns a frame and breaks the render.

## The roadmap

`_shared/econometrics-roadmap.tex` defines the map. On a slide:

    \roadmap{2.1}    the map, with week 2.1 marked as today
    \roadmap{}       the map with nothing marked (used in Lecture 0)

Four columns rather than ECON42550's three, so the columns are narrower. Every
box is set `\raggedright`, because a `\parbox` justifies by default and a
wrapped label then stretches across its column.

To change a week's title, edit its `\rmitem` line once — and change the lecture
title and the closing summary to match, since the three names have to agree.

## Still to settle

- Module code, credits, learning outcomes, assessment weights and dates
- The term, in the roadmap file
- The hook for Lecture 0 and the question opening each week
- Which datasets carry the term — prefer two or three recurring over twelve
- Whether there is a paper-reading strand
- Prerequisite audit: what the incoming statistics module actually delivers
