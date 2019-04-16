"Program for planning"
module PlanB

using Dates
using Spec

include("mmap.jl")
using .MMAP

include("core.jl")
using .Core
export add!, globalrel

include("rand.jl")
using .RandomRelation

include("record.jl")
using .Records

include("syntax.jl")
using .Syntax
export m, mo, d, w, ±, @o, @x

include("files.jl")
using .Files
export processplans

include("Time/time.jl")
using .Time
export isintersect

include("queries.jl")
using .Queries
export scheduled, summary 

end # module
