using Query

"Total amount of time allocated "
function totalallocated(day=Dates.today())
  total = @from i in df begin
    @where i.name == 1, i.creation_date == day
    @select i.duration
  end
  total = +(PlanB.duration.(collect(filter(PlanB.hasduration, values(PlanB.goals))))...)
  Dates.canonicalize(total)
end
