## Config / IO
planfiles = Set{String}()

"Add plan files global directory"
function addplanfile!(path::String)
  global planfiles
  push!(planfiles, path)
end

"Parse a `planfile`"
function parseplan(planfile::String)
  include(planfile)
end

"Parse all plans in `planfiles`"
function parseplans()
  for plan in planfiles
    set_datetime!(DataFrames.missing)
    parseplan(plan)
  end
  println("\nParsed plan files $planfiles")
  showstats()
end
