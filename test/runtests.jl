using PlanB
using Base.Test

@o errand "Complete errands"

@o thesis {due:Date(2018, Apr, 4)} "Submit my PhD thesis"
@o {thesis, 500h} "Write thesis"
@o piicml → thesis {due:Date(2018, Feb, 8)} "Submit Parametric Inversion to ICML"

@o coremodels → piicml "Implement core models"
@o_ raytrace {60m} "Finish the implementation of the primitive raytracer"
@o_ physics {5wd} "Implement physics simulation"

@o benchmark → piicml "Benchmark Core Models"
@o_ aliozoo {1wd} "Restructure Solver"

@o prp → thesis {5d} "Implement the new solver framework"
"""
