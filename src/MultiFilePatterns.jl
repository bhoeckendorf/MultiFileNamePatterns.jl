module MultiFilePatterns

export MultiFilePattern, set

immutable MultiFilePattern
    template::AbstractString
    indextag::AbstractString
    indexes::Range{Int}
end

Base.length( files::MultiFilePattern ) = length(files.indexes)
Base.getindex( files::MultiFilePattern, i::Int ) = set(files, i)
Base.endof( files::MultiFilePattern ) = length(files)
Base.start( ::MultiFilePattern ) = 1
Base.next( files::MultiFilePattern, state ) = ( set(files, state), state+1 )
Base.done( files::MultiFilePattern, state ) = state > length(files)
set( files::MultiFilePattern, i::Int ) = set(files.template, files.indextag, files.indexes[i])


function set(
    template::AbstractString,
    tag::AbstractString,
    index::Int,
    varargin...
    )
  found = match(Regex("$tag\\d+"), template)
  numdigits = length(found.match) - length(tag)

  idxstr = string(index)
  if length(idxstr) < numdigits
    idxstr = string(repeat("0", numdigits-length(idxstr)), idxstr)
  end

  out = replace(template, found.match, string(tag, idxstr))
  for i in 1:2:length(varargin)
    out = set(out, varargin[i], varargin[i+1])
  end
  return out
end


function Base.get(
    filepath::AbstractString,
    tag::AbstractString,
    varargin...
    )
  found = match(Regex("$tag\\d+"), filepath)
  index = parse( Int, found.match[ 1+length(tag) : end ] )
  if isempty(varargin)
    return index
  else
    out = Array(Int, 1+length(varargin))
    out[1] = index
    for i in 1:length(varargin)
      out[1+i] = get(filepath, varargin[i])
    end
    return out
  end
end

end # module
