module Relations
using Spec

import ..DB: add! 
export Relation

abstract type Relation{K} end

"Set of tuples"   
struct UnTypedRelation{K} <: Relation{K}
  vals::Vector{NamedTuple{K}}
end

UnTypedRelation(xs::Vector{NamedTuple{K, T}}) where {K, T} = UnTypedRelation{K}(xs)
UnTypedRelation(x::NamedTuple) = UnTypedRelation([x])

"Relation with type information"
  struct TypedRelation{K, T<:NamedTuple{K}} <: Relation{K}
  vals::Vector{T}
end

TypedRelation(xs::Vector{NamedTuple{A, B}}) where {A, B} = TypedRelation{A,B}(xs)
TypedRelation(x::NamedTuple) = TypedRelation([x])

"Add entry to the relation"
function add!(rel::Relation{K}, nt::NamedTuple{K}) where {K}
  push!(rel.vals, nt)
end

end