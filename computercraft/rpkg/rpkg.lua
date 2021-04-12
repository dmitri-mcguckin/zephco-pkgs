-- Imports

-- Vars
local args = { ... }
local target = '/usr/bin/rpkg/'

-- Install sequence
if(args[1] == 'install') then
  local filename = args[2]
  if(~fs.exists(target)) then
    fs.makeDir(target)
  end
  fs.move(filename, target .. filename)
else if(args[1] == 'uninstall') then
  local filename = target .. args[2]
  fs.remove(filename)
end
