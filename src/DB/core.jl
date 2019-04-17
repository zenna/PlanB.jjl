"Rel"
module Core
using Spec

import ..Relations: Relation, UnTypedRelation
import ..DB: add!
export Rel

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
  values
end

export add!

end