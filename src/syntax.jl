module Syntax

using Dates
using Spec
import Omega
using ..Core: register!, add!
using Global: globalrel
using ..Records: Record

export ±,
       m,
       mo,
       d,
       w,
       @o,
       @x,
       withtags

"Simple Wrapper over `Dates.Period`"
struct PlanBDur{T} end

# Shorthands for time durations
const m = PlanBDur{Minute}
const h = PlanBDur{Hour}
const d = PlanBDur{Day}
const w = PlanBDur{Week}
const mo = PlanBDur{Month}

# Default distribution #
defaultdist(μ, σ) = Omega.normal(μ, σ)
defaultdist(μ::T, σ::T) where {T <: Dates.Period} =
  Omega.ciid(ω -> T(Int(round(Omega.normal(ω, μ.value, σ.value)))))
defaultdist(μ::Dates.Period, σ::Dates.Period) = defaultdist(promote(μ, σ)...)
μ ± σ = defaultdist(μ, σ)

"Syntax hack to support 4m, 12h"
Base.:*(dur, tp::Type{T}) where {X, T <: PlanBDur{X}} = X(dur)

"defaultkey(::T) is the default key type of some type T"
function defaultkey end

defaultkey(::Union{Dates.Period, Type{<:Dates.Period}}) = :duration
defaultkey(::Union{Dates.TimeType, Type{<:Dates.TimeType}}) = :due
defaultkey(::Union{AbstractString, Type{<:AbstractString}}) = :desc
defaultkey(::Union{Real, Type{<:Real}}) = :completed
defaultkey(::Union{Symbol, Type{<:Symbol}}) = :id
defaultkey(x::Omega.RandVar) = defaultkey(Omega.elemtype(x))

function handle_(x)
  k = defaultkey(x)
  NamedTuple{(k,)}((x,))
end
handle_(x::NamedTuple) = x
handle(args...) = merge(map(handle_, args)...)

macro o(id::Symbol, args...)
  :(register!(Record($(Meta.quot(id)), handle(0.0, $(args...)))))
end

macro o(args...)
  :(register!(Record(handle(0.0, $(args...)))))
end

macro x(args...)
  :(register!(Record(handle(1.0, $(args...)))))
end

"""
```julia
PlanB.Syntax.withtags((scheduled = Date(2019, April, 16),), (
  @o(mnist),
  @o(sometask, 30m ± 5m, "Do some task")
))
```
"""
function withtags(tags::NamedTuple, records; rel = globalrel())
  @pre :id ∉ keys(tags) "Tags should not contain ids"
  for record in records
    @show Record(record.id, tags)
    add!(rel, Record(record.id, tags))
  end
end

end