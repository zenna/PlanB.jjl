"Records are a convenient way of creating relational entries"
module Records
import ..DB: add! 
using ..Core: Relation, Rel
using Spec
import ..Core
export Record


"An element that exists in several relations"
struct Record{K, T <: NamedTuple}
  id::K
  entries::T
  function Record(k::K, nt::T) where {K, T <: NamedTuple}
    @pre :id ∉ keys(nt) "key id not allowed in tuple"
    new{K, T}(k, nt)
  end
end

"Automatially generated id"
autoid(nt) = Symbol(rand(Int))

Record(nt::T) where {K, T <: NamedTuple} = Record(autoid(nt), nt)

"""
Add record to relation

```julia
rel = Rel()
add!(rel, Record(:zenna, (dur = 10, height = 20)))
```
"""
function add!(rel::Rel, record::Record)
  for k in keys(record.entries)
    nt = NamedTuple{(:id, k)}((record.id, record.entries[k]))
    Core.add!(rel, k, nt)
  end
  record
end

end