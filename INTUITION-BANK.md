# Intuition Bank — ECON30130 Econometrics I

Teaching devices for the places where the mathematics is standard and the
intuition is not supplied by any source on the shelf. Written for this module;
each one is checked against Wooldridge for correctness but is our own
exposition, not a paraphrase of anyone's.

Lambert's playlists are a reliability check — if a device contradicts how he
sequences a topic, look again — not a source. The video map is in
`claude/lambert-video-concordance.md`.

---

## Block 1, in the decks as of 17 September

**The moments are one construction at three powers.** Sam's, and the best
device in the module. Same deviation from the mean, raised to two, three or
four. An odd power keeps the sign, so the cube says which tail runs longer; an
even power makes every term positive, so deviations can never cancel. Raising
the power makes a far-out person count for more, which is why the fourth power
measures tails and the second measures ordinary spread. Board example: three
deviations of +2, −2 and +4. At k = 2 the far one already counts four times as
much; at k = 4 it counts sixteen times as much and decides the answer alone.
*Lecture 1.1, "Why the Power Changes What You Measure".*

**The CEF is a local average.** Sam's. Split the sample by the other variable
and average inside each group. Physical version first: measure everyone's
height, sort them into weight bands, average the heights inside each band. The
sequence of averages is a CEF. Add the nuance that the binned version is the
*sample* object and the CEF is the population one — the same Roman-and-Greek
rule from week one, applied to a whole function.
*Lecture 1.2.*

**Where the root comes from.** Variances add; standard deviations do not. One
person far above the mean is usually offset by someone below, and more people
means more offsetting — but the offsetting is partial, so the spread shrinks at
the root rather than vanishing. The practical form is the one to say out loud:
to halve your uncertainty you need four times the data.
*Lecture 1.3.*

**An extreme average needs a conspiracy.** Why averaging forgets the shape of
the population. One barrister among 120 barely moves the average; an average of
40 euro an hour would take a room full of them. Landing near the middle can
happen in enormously more ways than landing at the edge, and that imbalance
thins the tails of the average until they match the same bell whatever the
population underneath looked like. This is why one formula serves every
population in the module.
*Lecture 1.3.*

**The ring and the peg.** For coverage. The peg is hammered in before anyone
arrives — the population mean is 11.52 whether or not we ever draw a sample.
What varies is the throw. Ninety-five per cent is a fact about your arm,
knowable before a single ring is thrown, and it says nothing about the ring now
lying on the grass. That one covers the peg or it does not; we cannot say which
because we cannot see the peg. Ask the room where the randomness went once the
ring has landed: it was all in the throwing, and the throwing is over.
*Lecture 1.3.*

**A p-value measures embarrassment, not probability.** It says how badly the
data embarrasses the claim, not how likely the claim is to be false.
*Lecture 1.3.*

---

## Block 3, for 3.1 Adding Controls — not yet in the deck

Lambert has no video on good and bad controls; neither playlist contains a
confounder, mediator or collider anywhere. Wooldridge covers omitted variable
bias but not the three-way distinction. So this section has no second voice and
needs its own devices.

**The one rule that organises all three: ask where the arrows point.**

| Arrows | What it is | What to do |
|---|---|---|
| Into both schooling and earnings | Confounder | Control for it |
| Out of schooling, into earnings | Mediator | Do not |
| Into it, from both | Collider | Definitely do not |

That table is the frame. The three examples below are what makes each row land.

**Confounder — the common cause.** Ice cream sales and drownings rise and fall
together, and neither causes the other: hot weather drives both. Control for
temperature and the association goes. In the module's population, parental
education raises both how long you stay in school and what you earn, so
schooling looks more valuable than it is until you hold parental education
fixed. The test a student can apply: *is there something that moved both?*

**Mediator — the channel.** Does exercise improve heart health? Compare people
with the same cholesterol and you will find it barely does — because lowering
cholesterol is one of the ways exercise works, and you have just closed it. You
have not measured the effect of exercise; you have measured the part of it that
does not run through cholesterol. In the module's population, schooling raises
earnings partly by changing the job you end up in, so controlling for occupation
asks "does schooling pay, among people doing the same job?" — a narrower
question, and usually not the one anyone wanted. The test: *is this a
consequence of the thing I am studying?*

**Collider — the common effect, and the hard one.** A university admits you if
you are strong academically *or* strong at sport. Among the students it admits,
the two are negatively related — the weak athletes are the ones who got in on
grades, and the weak students are the ones who got in on sport. In the
applicant pool the two had nothing to do with each other. Nobody created that
relationship; selecting on the outcome manufactured it.

The same shape, in a form students recognise: among restaurants still open
after five years, food quality and location quality trade off. Bad food in a
superb location survives; bad food in a poor location closed and is not in the
data. In the module's population, promotion depends on both schooling and
earnings, so among the promoted the two look negatively related.

The test: *is this thing caused by both of the things I care about?* If it is,
controlling for it invents a relationship rather than removing one — and that
is the one case where adding a control makes the answer worse than leaving it
out.

**Why the collider matters more than it looks.** A confounder and a mediator
both produce a wrong number for a reason a student can see in the story. A
collider produces a wrong number that looks like a finding, from a control that
looked responsible, and nothing in the regression output says so. That is the
argument for 4.2, and 3.1 should plant it.

---

## Standing rules for anything added here

- Checked against Wooldridge before it reaches a slide; the locator goes in the
  frame's provenance comment.
- Original exposition. Standard definitions and formulae are common property;
  the words around them are ours.
- A device that needs more than two sentences on the slide belongs in
  `::: {.notes}`, which costs no frame height.
