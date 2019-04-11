module Syntax

using Dates
using Spec
import Omega
import ..Core: register!, Record

export ±,
       m,
       mo,
       d,
       w,
       @o,
       @x

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

defaultkey(::Dates.TimeType) = :due
defaultkey(::Dates.Period) = :dur
defaultkey(::AbstractString) = :desc
defaultkey(::Bool) = :done
defaultkey(::Symbol) = :id

function handle_(x)
  k = defaultkey(x)
  NamedTuple{(k,)}((x,))
end
handle_(x::NamedTuple) = x
handle(args...) = merge(map(handle_, args)...)

macro o(args...)
  :(register!(Record(handle(false, $(args...)))))
end

macro x(args...)
  :(register!(handle(true, $(args...))))
end


end