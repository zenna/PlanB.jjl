"Random Variable over Relations"
module RandomRelation

import ..Core: Relation, Rel
import Omega

struct RandRel <: Omega.RandVar
  id::Omega.ID
  rel::Rel
end

RandRel(rel::Rel) = RandRel(Omega.uid(), rel)

"Reconstruct entire databse for sample"
function Omega.ppapl(rel::RandRel, ω::Omega.Ω)
  Rel(Dict(k => maybeapl(v, ω) for (k, v) in rel.rel.relations))
end

"Random Variable over relations.  Interprets `RandVar` in field as "
struct RandRelation{REL} <: Omega.RandVar
  id::Omega.ID
  rel ::REL
end

RandRelation(relation::T) where {T<:Relation} = RandRel{T}(Omega.uid(), relation)

maybeapl(x, ω) = x
maybeapl(x::Tuple, ω) = map(x_ -> maybeapl(x_, ω), x)
maybeapl(x::NamedTuple, ω) = map(x_ -> maybeapl(x_, ω), x)
maybeapl(x::Omega.RandVar, ω) = Omega.apl(x, ω)
maybeapl(r::T, ω) where {T <: Relation} = T(map(v -> maybeapl(v, ω), r.vals)) 
Omega.ppapl(r::RandRelation{T}, ω::Omega.Ω) where T = maybeapl(r.rel, ω)

end