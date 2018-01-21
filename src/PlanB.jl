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
import Base: *
using Base.Dates
using Spec
using Match
using DataFrames

export m,
       h,
       d,
       @o,
       @x,
       @g,
       @sd,
       addplanfile!,
       parseplans,
       Jan,
       Feb,
       Mar,
       May,
       Jun,
       Jul,
       Aug,
       Sep,
       Oct,
       Nov,
       Dec

## Convenience units
m = Minute
h = Hour
d = Day

## Config / IO
planfiles = Set{String}()

"Add plan files global directory"
function addplanfile!(path::String)
  global planfiles
  push!(planfiles, path)
end

"Parse a `planfile`"
function parseplan(planfile::String)
  println("Parsing Planfile, ", planfile)
  include(planfile)
end

"Parse all plans in `planfiles`"
parseplans() = foreach(parseplan, planfiles)

"""
Convenient syntax for creating durations

```jldoctest
julia> 1m
```
"""
(*)(dur::Integer, tp::Type{TP<:Dates.TimePeriod} where TP)  = TP(dur)

abstract type AbstractGoal end

"A Goal is a set of possible worlds"
struct Goal <: AbstractGoal
  name::Symbol
  desc::String
end

## Globals
global df = DataFrame(name = Symbol[],
                      ag = AbstractGoal[],
                      creation_date = [],
                      duration = [])
rowid(ag::AbstractGoal) = todo
rowid(name::Symbol) = todo

global goals = Dict{Symbol, AbstractGoal}()
goalnames() = keys(goals)
addgoal!(g::AbstractGoal) = (@pre name ∉ goalnames(); goals[g.name] = g)
addgoal!(g::AbstractGoal) = (@pre name ∉ goalnames(); push!(df, [g.name, g, missing, missing]))

# TODO: implement
addsubgoalrel!(g::AbstractGoal, ag::Goal) = true
addsubgoalrel!(g::Symbol, ag::Symbol) = true

set_creation_date!(g::AbstractGoal, dt::TimeType) = df[rowid(g), :creation_date] = dt

"Set the expected time period of `g` to `tp`"
addtag(g::AbstractGoal, tp::Period) = df[rowid(g), :duration] = tp

"Add `tp` as parent of `g`"
addtag(g::AbstractGoal, tp::Symbol) = true # TODO

function addtag(g::AbstractGoal, data::T) where T
  throw(ArgumentError("Don't know how to handle data of type $T"))
end

"""
Extract names from subgoal relation
"""
function matchsubgoal(e::Expr)
  @match e begin
      Expr(:call,      [:→, subgoal, supergoal], _)     => subgoal, supergoal
      Expr(expr_type,  _...)                => error("Can't extract name from ",
                                                      expr_type, " expression:\n",
                                                      "    $e\n")
  end
end

"""
Does `expr` express subgoal relation?

```jldoctest
julia> issubgoalexpr(:(subgoal < supergoal))
true

julia> issubgoalexpr(:(subgoal > supergoal))
false
```
"""
function issubgoalexpr(expr::Expr)
  (&)(expr.head == :call,
      expr.args[1] == :→,
      expr.args[2] isa Symbol,
      expr.args[3] isa Symbol)
end


# We want symbols to say symbols, e.g. :x
parseexpr(x::Symbol) = Meta.quot(x)

# But expressions are generally things like `5m` which we want to be computed
parseexpr(x::Expr) = esc(x)

function process(nm::Symbol, tagexpr::Expr, desc::String)
  tags = tagexpr.args
  quote
    @pre nm ∉ goalnames()
    $(esc(name)) = Task($(Meta.quot(name)), $desc)
    foreach(arg -> addtag($(esc(name)), arg), [$((map(parseexpr, tags))...)])
    addgoal!($(esc(name)))
    set_creation_date!($(esc(name)), curr_datetime())
  end
end

"""
Anonymous `Goal` with tags

```jldoctest
@o {writethesis, 1h} "Update chapter 4 with new figures"
```
"""
macro o(tagexpr::Expr, desc::String)
  name = gensym()
  process(nm, tagexpr, desc)
end

"""
Anonymous `Goal` with tags

```jldoctest
@o piicml → thesis {due:Date(2018, Feb, 8)} "Submit Parametric Inversion to ICML"

```
"""
macro o(goalrel::Expr, tagexpr::Expr, desc::String)
  name = gensym()
  process(nm, tagexpr, desc)
end

"""
`Goal` named `nm` without tags

```jldoctest
@o errand "Complete errands"
```
"""
macro o(nm::Symbol, desc::String)
  process(nm, tagexpr, desc)
end

"DateTime for section"
datetime = Base.Dates.now()
set_datetime!(datetime_::TimeType) = global datetime = datetime_
curr_datetime() = datetime

macro sd(datetimeexpr)
  quote
    set_datetime!($(esc(datetimeexpr)))
  end
end

## Util
"""
Concatenate Blocks

```jldoctest
julia> q1 = quote
         x = 3
         y = 4
       end
quote  # REPL[18], line 2:
    x = 3 # REPL[18], line 3:
    y = 4
end

julia> q2 = quote
         a = 3
         b = 4
       end
quote  # REPL[19], line 2:
    a = 3 # REPL[19], line 3:
    b = 4
end

julia> blockcat(q1, q2)
quote  # REPL[18], line 2:
    x = 3 # REPL[18], line 3:
    y = 4 # REPL[19], line 2:
    a = 3 # REPL[19], line 3:
    b = 4
end
```
"""
function blockcat(qs::Expr...)
  @pre all(q -> q.head == :block, qs)
  Expr(:block, vcat(map(q -> q.args, qs)...)...)
end

"Add `Goal` with subtype expression"
function subgoal(subgoal::Expr, desc::String)
  @pre issubgoalexpr(subgoal)
  @show subgoalnm, supergoalnm = matchsubgoal(subgoal)
  quote
    addsubgoalrel!($(Meta.quot(subgoalnm)), $(Meta.quot(supergoalnm)))
  end
end


end
