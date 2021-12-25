function GetFileName(fullpath)
  extension = fullpath:match("[^.]*$")
  file = string.gsub(fullpath,"." .. extension,"_orig." .. extension)
  return file
end

-- Generate correct html syntax with path to image
function make_lightbox (path)
 return '<img tabindex=1 src="' .. path .. '"/><img class="f" src="' .. GetFileName(path) .. '" onerror="this.onerror=null;this.src=\'' .. path .. '\'" />'
end

-- Identify all images and change format
function Image (elem)
 return pandoc.RawInline('html', make_lightbox(elem.src))
end
