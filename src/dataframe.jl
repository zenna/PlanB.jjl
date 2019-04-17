"Conversion to and from dataframes"
module DF
using DataFrames
using ..DB: Relation, globalrel

export dataframe

"Construct a `DataFrame` from a `Relation`"
function dataframe(relation::Relation{K}) where K
  vals = [[getfield(val, k) for val in relation.vals] for k in K]
  DataFrame(vals, [K...])
end

dataframe(relation::Symbol; rel = globalrel()) = dataframe(rel.relations[relation])

end