module Core
using Spec


# TODO
# Should a relation be typed?
# (dur = 3m, nm = 1 2.0)  
# Should the fields be sorted? No, not alphabetically anyway

abstract type Relation{K} end

"Set of tuples"   
struct UnTypedRelation{K} <: Relation{K}
  vals::Vector{NamedTuple{K}}
end

UnTypedRelation(xs::Vector{NamedTuple{K, T}}) where {K, T} = UnTypedRelation{K}(xs)
UnTypedRelation(x::NamedTuple) = UnTypedRelation([x])

"Set of tuples"
struct TypedRelation{K, T<:NamedTuple{K}} <: Relation{K}
  vals::Vector{T}
end

TypedRelation(xs::Vector{NamedTuple{A, B}}) where {A, B} = TypedRelation{A,B}(xs)
TypedRelation(x::NamedTuple) = TypedRelation([x])

"Add entry to the relation"
function add!(rel::Relation{K1}, nt::NamedTuple{K2}) where {K1, K2}
  @pre K1 == K2 "Keys don't match, i.e.: $K1 != $K2"
  push!(rel.vals, nt)
end

"Set of relations"
struct Rel
  relations::Dict{Symbol, Relation}
end

"Empty Rel"
Rel() = Rel(Dict{Symbol, Relation}())

"""
Add to `relation` the entry `values`.
Create the relation if it does not already exist in `rel`

  ```julia
rel = Rel()
add!(rel, :duration, (thing = "some work", duration = 4.0))
```
"""
function add!(rel::Rel, relation::Symbol, values::NamedTuple; RelT::Type{RT} = UnTypedRelation) where {RT <: Relation}
  if !(relation in keys(rel.relations))
    rel.relations[relation] = RT(values)
  else
    add!(rel.relations[relation], values)
  end
end

const rel = Rel()
globalrel() = rel

register!(x; rel = globalrel()) = (add!(rel, x); x)

export add!, globalrel

end