module MultiFileNamePatterns

export set

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
    out = get(out, varargin[i], varargin[i+1])
  end
  return out
end

end # module
