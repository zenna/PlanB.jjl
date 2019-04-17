"Global objects"
module Global

using Rand: RandRel
using Core: Rel

export globalrel, globalrandrel

const rel = Rel()
globalrel() = rel
globalrandrel() = RandRel(globalrel())

"Register"
register!(x; rel = globalrel()) = (add!(rel, x); x)
end