# __precompile__()
"""A lightweight package for making (and sticking to) plans

## TODO
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
       w,
       mo,
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

"Work day"
wd = 8h
d = Day
w = Week

"Work week"
ww = 6wd
mo = Month

"""
Conveniece function for creating time duratiom

```jldoctest
julia> 1m
```
"""
(*)(dur::Integer, tp::Type{P})  where P <: Base.Dates.Period = P(dur)

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

abstract type AbstractGoal end

"A Goal: something to achieve"
struct Task <: AbstractGoal
  name::Symbol
  desc::String
end

"A Goal is a set of tasks"
struct Goal <: AbstractGoal
  name::Symbol
  desc::String
end

## Globals
global df = DataFrame(name = Symbol[],
                      ag = AbstractGoal[],
                      creation_date = [],
                      duration = [])
rowid(ag::AbstractGoal) =
rowid(name::Symbol) =

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
# TODO
addtag(g::AbstractGoal, tp::Symbol) = true

function addtag(g::AbstractGoal, hmm::Expr)
  @assert false
end


"""
Extract names from subgoal relation

```jldoctest
```
"""
function matchsubgoal(e::Expr)
  @match e begin
      Expr(:call,      [:<, subgoal, supergoal], _)     => subgoal, supergoal
      Expr(expr_type,  _...)                => error("Can't extract name from ",
                                                      expr_type, " expression:\n",
                                                      "    $e\n")
  end
end

"""
Does `expr` express subgoal relation

```jldoctest
julia> issubgoalexpr(:(subgoal < supergoal))
true

julia> issubgoalexpr(:(subgoal > supergoal))
false
```
"""
function issubgoalexpr(expr::Expr)
  (&)(expr.head == :call,
      expr.args[1] == :<,
      expr.args[2] isa Symbol,
      expr.args[3] isa Symbol)
end

"Add a `Goal` to global store"
macro g(name::Symbol, desc::String)
  addgoal!(Goal(name, desc))
end

"Add `Goal` with subtype expression"
macro g(subgoal::Expr, desc::String)
  @pre issubgoalexpr(subgoal)
  subgoalnm, supergoalnm = matchsubgoal(subgoal)
  quote
    @pre nm ∉ goalnames()
    addgoal!(Goal($(Meta.quot(subgoalnm)), $desc))
    addsubgoalrel!($(Meta.quot(subgoalnm)), $(Meta.quot(supergoalnm)))
  end
end

# We want symbols to say symbols, e.g. :x
parseexpr(x::Symbol) = Meta.quot(x)

# But expressions are generally things like `5m` which we want to be computed
parseexpr(x::Expr) = esc(x)

macro o(tagexpr::Expr, desc::String)
  name = gensym()
  tags = tagexpr.args
  quote
    $(esc(name)) = Task($(Meta.quot(name)), $desc)
    foreach(arg -> addtag($(esc(name)), arg), [$((map(parseexpr, tags))...)])
    addgoal!($(esc(name)))
    set_creation_date!($(esc(name)), curr_datetime())
  end
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

end
