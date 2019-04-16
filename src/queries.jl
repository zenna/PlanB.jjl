"Useful queries to ask"
module Queries
using Query
using UnicodePlots
using Omega

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
function scheduled(rel, duration)
  # Select ids that are scheduled for today
  filter(x -> isintersect(duration, x.scheduled), rel.relations[:scheduled].vals)
end

function summarize(randrel  = globalrandrel())
  println("Scheduled for today:")
  sched = lift(scheduled)(randrel, Dates.today())
  rand(sched)
end

end