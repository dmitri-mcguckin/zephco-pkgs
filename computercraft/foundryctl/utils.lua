function split(str, delimeter)

end

function getMaterialPairs(filename)
  local materials = {}

  local file = fs.open(filename, 'r')
  while(true) do
    local line = file.readLine()
    if(line == nil) then
      break
    end
    table.insert(materials, split(line, ','))
  end
  file.close()

  return materials
end
