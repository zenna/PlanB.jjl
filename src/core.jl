module Core

"Stores an element that exists in several relations"
struct Record{T <: NamedTuple}
  rel::T
end

"Collection of records"
struct Records
  data::Set{Record}
end
Records() = Records(Set{Record}())
Base.push!(xs::Records, x) = push!(xs.data, x)

"Memory mapped structure"
struct MMAP{T}
  data::T
  path::String
end

"Load the structure from file"
function load(mmap::MMAP)
end

"Backup the structure to file"
function backup()
end

"Register the a fact mmap"
function register!(nt::Record, mmap = loadmmap())
  push!(mmap, nt)
end

const data = Records()
loadmmap() = data

export register!

end