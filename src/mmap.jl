"Memory Mapped Data Structures"
module MMAP

"Memory mapped structure"
struct MemoryMapped{T}
  data::T
  path::String
end

"Load the structure from file"
function load(mmap::MemoryMapped)
end

"Backup the structure to file"
function backup()
end

end