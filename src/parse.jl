AbstractPeriod = Union{Dates.CompoundPeriod, Dates.Period}

"""
Convenient syntax for creating time_ests

```jldoctest
julia> 1m
```
"""
(*)(dur::Integer, tp::Type{TP}) where {TP<:Dates.Period} = TP(dur)

"Lift missing, `lm(Int) == Union{Int, Missing}`"
lm(T::Type) = Union{T, Missing}

## Globals
global df = DataFrame(name = Symbol[],    # Name of thing
                      typeof = Type[],    # Type of thing, e.g Goal, Tag, Comment
                      desc = String[],    # Description
                      assigned_date = lm(Date)[], # Date that the thing was assigned
                      due_date = lm(Date)[],      # Estimate of time
                      time_est = lm(AbstractPeriod)[],      # Estimate of time
                      time_took = lm(AbstractPeriod)[],     # Tiem it actually took
                      tags = lm(Set{Symbol})[],
                      subgoals = lm(Set{Symbol})[],
                      isdone = lm(Bool)[])     # Is the goal done)

# What;s the point of having both a row in the dataframe and these
# Really you want a kind of graph database, but there's no good query language
# I can emulate it with a very large table and missing values, theres dat tables aren't going to be huge

rowid(nm::Symbol) = findfirst(df.columns[1], nm) # HACK: Why is there no api for this?

"Add a new column to df with name `field` and type `fieldtype`"
function newcol!(df::DataFrame, field::Symbol, fieldtype::Type)
  @pre field ∉ names(df)
  if field ∉ names(df)
    df[field] = [missing for i = 1:n]
  end
end

"Set the value of `t` to value"
function set!(nm::Symbol, field::Symbol, value)
  @pre(field ∉ names(df) || ismissing(df[field][rowid(nm)]),
       "$field on $nm already set value: $value")
  df[field][rowid(nm)] = value
end

"Set the value of `t` to value"
function set!(name::Symbol, field::Symbol, fieldtype::Type, value)
  field ∉ names(df) && newcol(df, field, fieldtype) # Create the field if needed
  set!(name, field, value)
end

"Set the value of `t` to value"
function push!(nm::Symbol, field::Symbol, value)
  if ismissing(df[field][rowid(nm)])
    df[field][rowid(nm)] = Set([value])
  else
    push!(df[field][rowid(nm)], value)
  end
end

"Push the value into a collection"
function push!(name::Symbol, field::Symbol, fieldtype::Type, value)
  field ∉ names(df) && newcol(df, field, Vector{fieldtype}) # Create the field if needed
  push!(name, field, value)
end

"All names of all things"
allnames(df::DataFrame=df)::Set{Symbol} = Set{Symbol}(df[:name])
const NMANDATORYCOLS = 3 # name typeof desc
fillmissing(df::DataFrame) = [missing for i = 1:(length(df) - NMANDATORYCOLS)]
addthing!(nm::Symbol, desc::String, typ::Type) =
  (@pre nm ∉ allnames(); push!(df, [[nm, typ, desc]; fillmissing(df)]))
# thingisa(nm::Symbol, typ::Type) = getfield() == typ #TODO

## Particular fields
"Declare `supnm` as a subgoal of `supnm`"
function addsubgoalrel!(subnm::Symbol, supnm::Symbol)
  # @pre thingisa(subnm, Goal)
  # @pre thingisa(supnm, Goal)
  push!(subnm, :subgoal, supnm)
end

addtag!(nm::Symbol, tag::Symbol) = push!(nm, :tags, tag)

abstract type Tag end
(::Base.Colon)(::Type{T}, value) where {T<:Tag} = T(value)

addtag!(nm::Symbol, tag::Tag) = set!(nm, field_name(tag), tag.value)
addtag!(nm::Symbol, tag) = addtag!(nm, default(tag))

## Some creating hacking

struct est <: Tag
  value
end
field_name(::est) = :time_est
default(period::AbstractPeriod) = est(period)

struct took <: Tag
  value::AbstractPeriod
end
field_name(::took) = :time_took

struct due <: Tag
  value
end
field_name(::Type{due}) = :due_date
field_name(::due) = :due_date

# We want symbols to say symbols, e.g. :x
parseexpr(x::Symbol) = Meta.quot(x)

# But expressions are generally things like `5m` which we want to be computed
parseexpr(x::Expr) = esc(x)

struct Goal end

function process(nm::Symbol, tagexpr::Expr, desc::String, isdone=false,
                 verbose=false) # HACK
  verbose && println("Parsing ", nm, tagexpr, desc, isdone) 
  tags = tagexpr.args
  typ = Goal
  quote
    @pre $(Meta.quot(nm)) ∉ allnames() "wally"
    # $(esc(nm)) = Task($(Meta.quot(nm)), $desc)
    addthing!($(Meta.quot(nm)), $desc, $typ)
    foreach(arg -> addtag!($(Meta.quot(nm)), arg), [$((map(parseexpr, tags))...)])
    set!($(Meta.quot(nm)), :assigned_date, curr_datetime())
    set!($(Meta.quot(nm)), :isdone, $isdone)
  end
end

"""
Anonymous `Goal` with tags

```jldoctest
@o {writethesis, 1h} "Update chapter 4 with new figures"
```
"""
macro o(tagexpr::Expr, desc::String)
  nm = gensym()
  process(nm, tagexpr, desc)
end

"""
Anonymous `Goal` with tags

```jldoctest
@o piicml → thesis {due:Date(2018, Feb, 8)} "Submit Parametric Inversion to ICML"

```
"""
macro o(nm::Symbol, tagexpr::Expr, desc::String)
  process(nm, tagexpr, desc)
end

"""
`Goal` named `nm` without tags

```jldoctest
@o errand "Complete errands"
```
"""
macro o(nm::Symbol, desc::String)
  process(nm, :({}), desc)
end

macro o(desc::String)
  nm = gensym()
  process(nm, :({}), desc)
end

# Done Macros
macro x(tagexpr::Expr, desc::String)
  nm = gensym()
  process(nm, tagexpr, desc, true)
end

macro x(nm::Symbol, tagexpr::Expr, desc::String)
  process(nm, tagexpr, desc, true)
end

macro x(nm::Symbol, desc::String)
  process(nm, :({}), desc, true)
end

macro x(desc::String)
  nm = gensym()
  process(nm, :({}), desc, true)
end


"DateTime for section"
datetime = Dates.now()
set_datetime!(datetime_::lm(TimeType)) = global datetime = datetime_
curr_datetime() = datetime

"Set date"
macro sd(datetimeexpr)
  quote
    set_datetime!($(esc(datetimeexpr)))
  end
end

"No date"
macro nd()
  quote
    set_datetime!(DataFrames.missing)
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
