using Query

"Total amount of time allocated "
function totalallocated(day=Dates.today())
  total = @from i in df begin
    @where i.typeof == PlanB.Goal && i.assigned_date == day
    @select {i.time_est}
    @collect DataFrame
  end
  Dates.canonicalize(sum(collect(skipmissing(Array(total)))))
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
    Dates.canonicalize(sum(times))
  end
end

"Total amount of time allocated "
function totaltodo(day=Dates.today())
  total = @from i in df begin
    @where i.typeof == PlanB.Goal && i.assigned_date == day && !i.isdone
    @select {i.time_est}
    @collect DataFrame
  end
  Dates.canonicalize(sum(collect(skipmissing(Array(total)))))
end

function showstats()
  println("""Total allocated time for today $(totalallocated())
  Total done so far: $(totaltimes(true))
  Still to do: $(totaltimes(false))
  """)
end
