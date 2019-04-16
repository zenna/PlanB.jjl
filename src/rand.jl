"Random Variable over Relations"
module RandomRelation

import ..Core: Relation
import Omega

"Random Variable over relations.  Interprets `RandVar` in field as "
struct RandRel{REL} <: Omega.RandVar
  id::Omega.ID
  rel ::REL
end

RandRel(relation::T) where {T<:Relation} = RandRel{T}(Omega.uid(), relation)

maybeapl(x, ω) = x
maybeapl(x::Tuple, ω) = map(x_ -> maybeapl(x_, ω), x)
maybeapl(x::Omega.RandVar, ω) = Omega.apl(x, ω)
Omega.ppapl(r::RandRel{T}, ω::Omega.Ω) where T =
  T(map(v -> maybeapl(v, ω), r.rel.vals)) 

end