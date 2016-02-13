module MultiFilePatterns

import Base.get, Base.length, Base.start, Base.next, Base.done

export AbstractMultiFilePattern, MultiFilePattern, LoadingMultiFilePattern
export get, set, start, next, done


abstract AbstractMultiFilePattern

immutable MultiFilePattern <: AbstractMultiFilePattern
    template::AbstractString
    indextag::AbstractString
    indexes::Range{Int}
end

immutable LoadingMultiFilePattern <: AbstractMultiFilePattern
    template::AbstractString
    indextag::AbstractString
    indexes::Range{Int}
    loadfun::Function
end


function length(pattern::AbstractMultiFilePattern)
    length(pattern.indexes)
end


function start(pattern::AbstractMultiFilePattern)
    return 1
end


function next(pattern::AbstractMultiFilePattern, state)
    ( set(pattern, state), state+1 )
end


function done(pattern::AbstractMultiFilePattern, state)
    return state > length(pattern.indexes)
end


function get(
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


function set(
    template::AbstractString,
    tag::AbstractString,
    index::Integer,
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


function set(pattern::MultiFilePattern, index)
    set(pattern.template, pattern.indextag, pattern.indexes[index])
end


function set(pattern::LoadingMultiFilePattern, index)
    pattern.loadfun(set(pattern.template, pattern.indextag, pattern.indexes[index]))
end

end # module
