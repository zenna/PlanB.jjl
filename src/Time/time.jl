"Related to Time and Dates"
module Time
using IntervalSets
export isintersect
using Dates

# Make time continuous for differentiability

include("continuous.jl")  # Continuous time representation (for differentiability)

lb(i::Interval) = i.left
ub(i::Interval) = i.right
lb(d::Date) = DateTime(d)
ub(d::Date) = lb(d + Day(1))

"Does interval `a` intersect with interval `b`"
function isintersect(i1, i2)
  a, b = lb(i1), ub(i1)
  x, y = lb(i2), ub(i2)
  (x < b) & (a < y)
end

end   