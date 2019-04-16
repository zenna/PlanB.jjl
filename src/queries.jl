"Useful queries to ask"
module Queries
using Query
import ..Core: globalrel
using ..Time: isintersect
import Dates


# Problem 1
# How to use random variables 


export scheduled, summary

"""
Schedule for `duration`

```julia
scheduled(today(), 3.0)
```
"""
function scheduled(duration; rel = globalrel())
  # Select ids that are scheduled for today
    filter(x -> isintersect(duration, x[2]), rel.relations[:duration].vals)
end

function summary(; rel  = globalrel())
  println("Scheduled for today:")
  display(scheduled(Dates.today(), rel = rel))
  println("\n")
end


end