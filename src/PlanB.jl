"Program for planning"
module PlanB

include("DB/DB.jl") # Database
using .DB
export add!, globalrel, globalrandrel, Rel, Relation

include("mmap.jl")  # Memory mapped data structure
using .MMAP

include("syntax.jl")  # Syntax for interacting with Database
using .Syntax
export m, mo, d, w, ±, @o, @x, withtags

include("files.jl")   # File IO
using .Files
export processplans

include("Time/time.jl") # Time data structures
using .Time
export isintersect

include("queries.jl")   # Queries
using .Queries
export scheduled, summarize

include("dataframe.jl")   # Interop with dataframes
using .DF
export dataframe 

end # module
