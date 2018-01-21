<<<<<<< HEAD
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

>>>>>>> 1c7d22abbaaaf4b37670de6544524e687d50111b
"""
module PlanB
import Base: *
using Base.Dates
using Spec
using Match

"What"


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

## Config

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
Conveniece function for creating time duratiom

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

global goals = Dict{Symbol, Goal}()
goalnames() = keys(goals)
addgoal!(g::Goal) = (@pre name ∉ goalnames(); goals[g.name] = g)

# TODO: implement
addsubgoalrel!(g::AbstractGoal, ag::Goal) = true
addsubgoalrel!(g::Symbol, ag::Symbol) = true

global duration_ = Dict{AbstractGoal, Dates.Period}()

global creation_date = Dict{AbstractGoal, TimeType}()
set_creation_date!(g::AbstractGoal, dt::TimeType) = creation_date[g] = dt

"Set the expected time period of `g` to `tp`"
addtag(g::AbstractGoal, tp::TimePeriod) = duration_[Goal] = tp

"Add `tp` as parent of `g`"
# TODO
addtag(g::AbstractGoal, tp::Symbol) = true

function addtag(g::AbstractGoal, hmm::Expr)
  @show hmm
  @assert false
end


"""
Extract names from subgoal relation

```jldoctest
ok
```
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
      expr.args[1] == :→,
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
  @show subgoalnm, supergoalnm = matchsubgoal(subgoal)
  quote
    @pre nm ∉ goalnames()
    addgoal!(Goal($(Meta.quot(subgoalnm)), $desc))
    addsubgoalrel!($(Meta.quot(subgoalnm)), $(Meta.quot(supergoalnm)))
  end
end

ok(x::Symbol) = x
ok(x::Expr) = esc(x)

function process(nm::Symbol, tagexpr::Expr, desc::String)
  @show tags = tagexpr.args
  @show tagsprocessed = Expr(:vect, map(ok, tags))
  quote
    @pre nm ∉ goalnames()
    $(esc(name)) = Goal($(Meta.quot(name)), $desc)
    foreach(arg -> addtag($(esc(name)), arg), $tagsprocessed...)
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

# comment!(g::Goal, cmt::String) = global comments_[g] = cmt
# comments(g::Goal) = comments_[g]
duration!(g::Goal, dur::Dates.Period) = global duration_[g] = dur
# due_!(g::Goal, time::Dates.)

end
