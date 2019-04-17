"Global objects"
module Global

using ..RandomRelation: RandRel
using ..Core: Rel

export globalrel, globalrandrel

const rel = Rel()
globalrel() = rel
globalrandrel() = RandRel(globalrel())

end