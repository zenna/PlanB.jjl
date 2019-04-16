"Useful queries to ask"
module Queries
using Query
import ..Core: globalrel
using ..Time: isintersect
using ..RandomRelation:RandRel
import Dates

export scheduled, summarize, globalrandrel

globalrandrel() = RandRel(globalrel())

"""
Schedule for `duration`

```julia
scheduled(today(), 3.0)
```
"""
function scheduled(duration; rel = globalrel())
  # Select ids that are scheduled for today
  filter(x -> isintersect(duration, x.duration), rel.relations[:duration].vals)
end

function summarize(rel  = globalrel())
  println("Scheduled for today:")
  display(scheduled(Dates.today(), rel = rel))
  println("\n")
end


end