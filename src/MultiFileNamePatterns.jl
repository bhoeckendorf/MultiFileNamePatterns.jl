module MultiFileNamePatterns

export get, set

function Base.get(
    filepath::String,
    tag::String,
    varargin...
    )
  found = match(Regex("$tag\\d+"), filepath)
  index = int( found.match[ 1+length(tag) : end ] )
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
    template::String,
    tag::String,
    index::Int,
    varargin...
    )
  found = match(Regex("$tag\\d+"), template)
  numdigits = length(found.match) - length(tag)
  idxstr = string(index)
  out = replace(template, found.match, string(tag, repeat("0", numdigits-length(idxstr)), idxstr))
  for i in 1:2:length(varargin)
    out = set(out, varargin[i], varargin[i+1])
  end
  return out
end

end # module
