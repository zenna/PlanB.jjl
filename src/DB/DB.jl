"A Database"
module DB

include("relations.jl")
using .Relations

include("core.jl")
using .Core
export add!

include("rand.jl")
using .RandomRelation 

include("record.jl")
using .Records

include("global.jl")
export globalrel, globalrandrel

end