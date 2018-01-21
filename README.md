# PlanB.jl

[![Build Status](https://travis-ci.org/zenna/PlanB.jl.svg?branch=master)](https://travis-ci.org/zenna/PlanB.jl)

[![codecov.io](http://codecov.io/github/zenna/PlanB.jl/coverage.svg?branch=master)](http://codecov.io/github/zenna/PlanB.jl?branch=master)

PlanB.jl is a simple, but powerful tool for managing ones goals and todos, build in Julia.

The objective is to have a todo list which is as simple to maintain as a simple
text file

It (ab)uses Julia's macro system

# Installation

First, install `PlanB.jl` in Julia

```julia
Pkg.clone("https://github.com/zenna/PlanB.jl.git")
```

Then make a some planfiles.  A planfile is just a julia file which contains goals.

```julia
using PlanB

@o thesis {due:Date(2019, 2, 8)} "Submit my Thesis"
```
This creates a goal with the name `thesis` (which must be unique).
Elements within the {cuirly brackets} are tags associated with this goal

`name:tag`

The string "Submit my Thesis" is a mandatory description of the goal.

### Recommendations
Goals should be precise as possible.  They should be predicates that are satisfied or not satisfied.
A bad version would be

```
@o thesis "Thesis"
```
