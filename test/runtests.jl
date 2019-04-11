using PlanB
using Test



@testset "PlanB.jl" begin
  register!((group = :rcd, dur = 30m, desc = "Fix introduction"))
  register!((group = :rcd, dur = 2h, desc = "Add code snippets to appendix"))
  register!((group = :rcd, dur = 5h ± 1h))
end
