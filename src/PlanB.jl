"A lightweight package for making plans"
module PlanB

global comments = Dict{Goal, Vector{String}}
global due = Dict{Goal, Date}
global duration = Dict{Goal, Dates.Period}

"A Task! Something to achieve"
struct Goal
  name::Symbol
  desc::String
end

macro o(name::Symbol, description::String)
  :(name = Goal(name, description))
end

"Create goal with relation"
macro o(name::Expr, description::String)
  :(name = Goal(name, description))
end

# To add properties either I need a global store
# Or a local global store
# Or each goal has stuff in it
# Or each value is its own type

comment!(g::Goal, cmt::String) = comments[g] = cmt
comments(g::Goal) = comments[g]
duration!(g::Goal, dur::Dates.Period) = duration[g] = dur
# due!(g::Goal, time::Dates.)

# Relations
"Assert that `g1` depends on `g2`"
depends!(g1::Goal, g2::Goal)

# Q1. What kind of relations, - a goal depends on another goal. - 
# Q2. How to deal with uncertainty
# Q3. 


# Example
sand = Goal(:makesand, "Make a sandwich")
comment!(sand, "I want it to be a juicy sandwich")
duration!(sand, 60m)

piicml = Goal(:piicml, "Parametric Inversion of Non-Invertible Functions")
theory = Goal(:theory, "Complete theoretical analysis of advantages of parametric inversion")
comment!(theory, "is it correct to decompose theorical advantages into two parts")
comment!(theory, "what does it mean to solve pi constraints")

whypi = Goal(:whypi, "Answer: under what conditions is parametric inversion better than unconstrained neural network for finding right-inverse")
due!(whypi, )
. {whypi} determine what is correct comparison of pi and unconstrained neural network
. {whypi, maybe} Write up edgar decomposition
. {whypi, maybe} Formalize constraint decomposition


@o :piicml "Parametric Inversion of Non-Invertible Functions"
@o :theory < piicml "Complete theoretical analysis of advantages of parametric inversion"
end