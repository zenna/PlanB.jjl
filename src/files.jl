module Files

import TOML
export processplans

"Parse a `planfile`"
function parseplan(planfile; rethrow_ = false)
  try
    include(planfile)
    println("Successfully parsed $planfile")
  catch e
    rethrow_ && rethrow(e)
    println("Could not parse planfile $planfile due to error:")
    display(e)
  end
end

findplanconfig() = joinpath(ENV["HOME"], ".planb.toml")

allplanfiles(planconfig = findplanconfig()) = values(TOML.parsefile(planconfig)["planfiles"])

"Read all parse plans"
processplans(planfiles = allplanfiles(); rethrow_ = false) =
  foreach(p -> parseplan(p, rethrow_ = rethrow_), planfiles )

end
