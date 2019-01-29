"""A lightweight package for making (and sticking to) plans

# Semantics

- There is a set of possible worlds: S
- A goal `A` is either:
  (i) a set of desired worlds  `A ⊆ Ω`, e.g. 'become president' or
  (ii) a set of trajectories where a trajcetory is a sequence of states
       (s_i, ..., s_k), e.g. 'go shopping'
- e.g. becoming a senator ``S_g`` is a subgoal of becoming president `S_p`
- Given a goal `G`, and the current state `s`, a subgoal
  Note: a subgoal is not a subset of `G`
=======


Integrate with dataframes
support tags in goals (as well as tasks)
support colon syntax
add reminder
support @g_ (maybe)

What I want it to tell me:

You need to finish this today
You're on track to reach your goal


Theory
- Goals: Desired state you want to be in

How to express?

- A is a subgoal of B
- A might be necessary to achieve B

that one goal has subgoals
- There are different logical things we want to express
- Doing A is necessary for B
- Doing A or B are necesary
Doing A is one way to achieve B

Things like Duration or probability of success aren't properties of Goals
They are properties of actions, or abstract actiosn
Might want to say:
- What's the probability this action will lead to this state
- Whats probability can actually do this action


"""
module PlanB
import Base: *, push!
using Dates
using Spec
using Match
using DataFrames
using Query

export m,
       h,
       d,
       @o,
       @x,
       @sd,
       @nd,
       addplanfile!,
       parseplans,
       Jan,
       Feb,
       Mar,
       Apr,
       May,
       Jun,
       Jul,
       Aug,
       Sep,
       Oct,
       Nov,
       Dec,

       # Tags
       due,
       took,
       est

## Convenience units
m = Minute
h = Hour
d = Day

include("io.jl")
include("parse.jl")
include("statistics.jl")
end
