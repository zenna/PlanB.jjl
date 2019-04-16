"Related to Time and Dates"
module Time
using IntervalSets

export isintersect

# Make time continuous for differentiability

include("continuous.jl")  # Continuous time representation (for differentiability)

left(i::Interval) = i.left
right(i::Interval) = i.right

"Does interval `a` intersect with interval `b`"
function isintersect(i1, i2)
  a, b = left(i1), right(i1)
  x, y = left(i2), right(i2)
  (x < b) & (a < y)
end

end   