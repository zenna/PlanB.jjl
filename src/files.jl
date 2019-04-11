module Files

import TOML
export processplans

"Parse a `planfile`"
function parseplan(planfile)
  try
    include(planfile)
    parsed("Parsed $planfile")
  catch e
    println("Could not parse planfile $planfile due to error:")
    display(e)
  end
end

findplanconfig() = joinpath(ENV["HOME"], ".planb.toml")

allplanfile(planconfig = findplanconfig()) = values(TOML.parsefile(planconfig)["planfiles"])

"Read all parse plans"
processplans(planfiles = allplanfiles()) = foreach(parseplan, planfiles )

end
