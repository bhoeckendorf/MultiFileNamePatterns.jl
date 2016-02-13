module MultiFilePatterns

import Base.get, Base.start, Base.next, Base.done

export MultiFilePattern, get, set, start, next, done


immutable MultiFilePattern
    template::AbstractString
    indextag::AbstractString
    indexes::Range{Int}
end


function start(pattern::MultiFilePattern)
    return 1
end


function next(pattern::MultiFilePattern, state)
    ( set(pattern, state), state+1 )
end


function done(pattern::MultiFilePattern, state)
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

end # module
