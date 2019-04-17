"Database"
module DB

# function
export add!
function add! end

include("relations.jl")
using .Relations
export Relation

include("core.jl")
using .Core
export Rel

include("rand.jl")
using .RandomRelation 
export RandRel, RandomRelation

include("record.jl")
using .Records
export Record

include("global.jl")
using .Global
export globalrel, globalrandrel

end