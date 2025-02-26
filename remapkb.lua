mykeyboardlayout = [[
1234567890-=
yclmkzfu,'[]\
isrtgpneao;
qvwdjbh/.x

!@#$%^&*()_+
YCLMKZFU<"{}|
ISRTGPNEAO:
QVWDJBH?>X
]]


function remapkb()
  local qwerty    = '1234567890-=qwertyuiop[]\\asdfghjkl;\'zxcvbnm,./'
                 .. '!@#$%^&*()_+QWERTYUIOP{}|ASDFGHJKL:"ZXCVBNM<>?'
  local newlayout = string.gsub(mykeyboardlayout, '\n', '')
  local keytable  = createkeytable(newlayout, qwerty)
  commandkeymap(keytable)
  operatorkeymap(keytable, newlayout)
end
--}}}

-- Create a table of keypresses                                {{{
function createkeytable(newlayout, qwerty)
  local keytable = {}
  if testlayoutsize(newlayout) then
    for i=1, string.len(newlayout) do
      keytable[i] = {
        qwerty = string.sub(qwerty, i, i),
        new    = string.sub(newlayout, i, i),
      }
    end
  end
  return keytable
end
--}}}

--[[ Map normal mode commands                                 {{{

According to the nvim documentation, leaving the "mode" of
`vim.keymap.set` blank is equivalent to `:map`. That's not
*exactly* true, because in the optional {opts} table, you have
the ability to set `{ remap = true }` (default is `false`). I
tried setting remap to true and I think it broke something, so I
don't set it at all here.

--]]
function commandkeymap(keytable)
  for i, map in ipairs(keytable) do
    vim.keymap.set('', map.new, map.qwerty)
  end
end
--}}}

--[[ Map operator-pending mode text object selections         {{{

The `textobjects` string below is ripped from the vim
documentation on text objects that can be selected in
operator-pending mode. `selectall` and `selectin` are substrings
of the new layout that occur where `a` and `i` are in qwerty.

This breaks the text object into its two component parts: `a` or
`i` and the selected object (`w` or `W` or `(` or ...)

Then the default mappings are removed and subsituted for their
equivalents in the keytable.

--]]
function operatorkeymap(keytable, newlayout)
  local textobjects = 'wWsp][)(b><t}{B"\'`'
  local selectall = string.sub(newlayout, 26, 26)
  local selectin  = string.sub(newlayout, 20, 20)
  for i, obj in ipairs(keytable) do
    if string.find(textobjects, '[[' .. obj.qwerty .. ']]') ~= nil then
      vim.keymap.set('o', selectall .. obj.new, 'a' .. obj.qwerty)
      vim.keymap.set('o', 'a' .. obj.qwerty, '')
      vim.keymap.set('o', selectin .. obj.new, 'i' .. obj.qwerty)
      vim.keymap.set('o', 'i' .. obj.qwerty, '')
    end
  end
end
--}}}

-- Ensure newlayout and qwerty are the same length             {{{
function testlayoutsize(layout)
  if string.len(layout) > 92 then
    print('There are too many characters in your keyboard layout!')
    return false
  elseif string.len(layout) < 92 then
    print('There are not enough characters in your keyboard layout!')
    return false
  else return true
  end
end
--}}}

