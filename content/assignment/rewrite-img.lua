-- rewrite-img.lua
-- Convert Hugo root-relative /img/... paths into paths Pandoc can resolve.

function Image(el)
if el.src:sub(1,5) == "/img/" then
el.src = "img/" .. el.src:sub(6)  -- "/img/foo.png" -> "stata-img/foo.png"
end
return el
end
