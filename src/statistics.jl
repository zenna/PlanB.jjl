using Query

canonicalizeifneed(h) = h
canonicalizeifneed(cp::Dates.CompoundPeriod) = Dates.canonicalize(cp)

"Total amount of time allocated "
function totalallocated(day=Dates.today())
  total = @from i in df begin
    @where i.typeof == PlanB.Goal && i.assigned_date == day
    @select {i.time_est}
    @collect DataFrame
  end
  canonicalizeifneed(sum(collect(skipmissing(Array(total)))))
end

"Total amount of time allocated "
function totaltimes(isdone::Bool, day=Dates.today())
  total = @from i in df begin
    @where i.isdone == isdone && i.assigned_date == day
    @select {i.time_est, i.isdone}
    @collect DataFrame
  end
  times = collect(skipmissing(Array(total[:time_est])))
  if isempty(times)
    return Hour(0)
  else
    canonicalizeifneed(sum(times))
  end
end

function showstats()
  println("""Total allocated time for today $(totalallocated())
  Total done so far: $(totaltimes(true))
  Still to do: $(totaltimes(false))
  """)
end
