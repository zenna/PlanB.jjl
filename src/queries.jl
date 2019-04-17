"Useful queries to ask"
module Queries
using Query
using UnicodePlots
using Omega: lift

import ..DB: globalrel, globalrandrel
using ..Time: isintersect
import Dates

export scheduled, summarize

"""
Schedule for `duration`

```julia
scheduled(today())
```
"""
function scheduled(rel, duration)
  filter(x -> isintersect(duration, x.scheduled), rel.relations[:scheduled].vals)
end

function summarize(randrel  = globalrandrel())
  println("Scheduled for today:")
  sched = lift(scheduled)(randrel, Dates.today())
  rand(sched)
end

end