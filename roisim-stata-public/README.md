# roisim

Monte Carlo return-on-investment simulation for Stata, with tornado export.

`roisim` answers the money question with a range a board can plan against,
not a single ratio that quietly hinges on one shaky input. You give it an
effect estimate with its standard error, plausible bounds on the program
cost, and a discount rate and horizon. It draws every uncertain input
thousands of times, computes the return on investment for each draw, and
reports the percentile distribution alongside the number a board actually
wants: the break-even probability, Pr(ROI > 0). A median ROI of 1.5 with a
tenth percentile of 0.4 says even a pessimistic draw still returns forty
cents net on the dollar — which the bare 1.5 never could.

It also tells stakeholders what to argue about. A one-way sensitivity sweep
holds every input at its central value, swings one input at a time from the
low to the high end of its plausible range, and records how far the ROI
moves. The `saving()` option writes that table to a CSV file, sorted longest
swing first, ready for a tornado bar chart. Boards that see the tornado stop
litigating the discount rate and concentrate on the one or two inputs that
actually drive the result.

The command touches no data in memory, ships no datasets, and makes no
network calls. Everything is left in `r()` for programmatic use.

## Install

From GitHub:

```stata
net install roisim, from("https://raw.githubusercontent.com/ericabooth/roisim-stata-public/main/") replace
```

From a local folder (a clone or download of this repository):

```stata
net install roisim, from("/path/to/roisim-stata-public/") replace
```

## Quick start

A job-training program: an estimated earnings gain of $3,000 per participant
per year (SE $900), a total cost between $3,800 and $4,600 per seat cohort,
benefits persisting 3 to 5 years, discounted at 2 to 7 percent:

```stata
roisim, effect(3000) se(900) costlow(3800) costhigh(4600) ///
    discountrange(0.02 0.07) horizonrange(3 5)            ///
    reps(10000) seed(20260706)                            ///
    saving(tornado.csv, replace)

display "median ROI  = " r(p50)
display "Pr(ROI > 0) = " r(prpos)

* tornado chart, longest bar at the top
import delimited using tornado.csv, clear
graph hbar (asis) swing, over(input, sort(1) descending) ///
    title("Tornado: what moves the ROI")
```

The model each replication: effect ~ Normal(effect, se); cost ~
Uniform(costlow, costhigh); annual benefit = njoiners x value x effect draw;
PV of benefits discounts that benefit over the horizon; ROI = (PV − cost) /
cost. ROI is a net return per dollar: 0 means the program exactly pays for
itself. With `discountrange()` or `horizonrange()`, the rate or the number
of years is drawn each replication too; otherwise they stay fixed and are
omitted from the tornado sweep (`r(n_swept)` records how many inputs were
swept).

See `help roisim` for the full model, all options, and more examples.

## Stored results

| Result | Meaning |
| --- | --- |
| `r(p1)` ... `r(p99)` | percentiles 1, 5, 10, 25, 50, 75, 90, 95, 99 of simulated ROI |
| `r(mean)`, `r(sd)`, `r(min)`, `r(max)` | moments and extremes of simulated ROI |
| `r(prpos)` | Pr(ROI > 0), the break-even probability |
| `r(roi_central)` | ROI with every input at its central value |
| `r(pv_central)`, `r(pvfactor)` | present value of benefits and annuity factor at central values |
| `r(reps)` | number of replications |
| `r(n_swept)` | number of inputs in the tornado sweep |
| `r(effect)`, `r(se)`, `r(costlow)`, `r(costhigh)`, `r(njoiners)`, `r(value)` | inputs as given |
| `r(pct)` | 1 x 9 matrix of the nine percentiles |
| `r(tornado)` | n_swept x 6 matrix: low, central, high, roi_low, roi_high, swing |
| `r(cmd)`, `r(saving)` | command name; CSV path when `saving()` was given |

## Limitations (v0.1.0)

The effect is Normal, the cost is Uniform, and draws are independent across
inputs; correlated draws and other distribution families are not supported.
Fix the accounting perspective (whose costs, whose benefits) before reaching
for the command, and consider reporting results at more than one discount
rate.

## License

MIT. See [LICENSE](LICENSE). Copyright (c) 2026 Eric A. Booth.

## Authors

Eric A. Booth, Sr Researcher, Texas 2036
Support: eric.a.booth@gmail.com
