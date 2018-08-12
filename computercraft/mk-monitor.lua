-- Const Configs
local CONFIG_DIR = '/etc/'
local CONFIG_PATH = CONFIG_DIR..'mk-utils.json'
local IM_TYPE = 'mekanism:induction_port'


-- A macro for clearing the screen and reseting the cursor
function reset_term()
  term.clear()
  term.setCursorPos(1, 1)
end

function set_rs(state)
  rs.setOutput(SIG_OUT, state)
end

-- Takes a path to a JSON file and returns an unserialized table
function load_config(filepath)
  if(fs.exists(filepath)) then
    local file = fs.open(filepath, 'r')
    raw_data = file.readAll()
    file.close()

    return textutils.unserializeJSON(raw_data)
  else
    return {}
  end
end

-- Takes a table and saves it as a JSON file
function save_config(t, filepath)
  local file = fs.open(filepath, 'w')
  file.write(textutils.serializeJSON(t))
  file.close()
end

-- Search for a device by type, if one is found the name of the device and
-- wrapped peripheral is returned, else (nil, nil) is returned
function discover_network_device(dev_type, modem)
  local device_names = modem.getNamesRemote()

  for _, dev_name in ipairs(device_names) do
    local type = peripheral.getType(dev_name)
    if(type == dev_type) then
      return dev_name, peripheral.wrap(dev_name)
    end
  end

  return nil, nil
end

function get_data(mk_device)
  local ret = {}
  ret['energy'] = mk_device.getEnergy()
  ret['capacity'] = mk_device.getEnergyCapacity()
  ret['list'] = mk_device.list()
  ret['internal_size'] = mk_device.size()
  ret['tanks'] = mk_device.tanks()

  input = mk_device.getItemDetail(1)
  if(input ~= nil) then
    ret['input_slot'] = mk_device.getItemDetail(1)
  else
    ret['input_slot'] = 'Empty'
  end

  output = mk_device.getItemDetail(2)
  if(input ~= nil) then
    ret['output_slot'] = mk_device.getItemDetail(2)
  else
    ret['output_slot'] = 'Empty'
  end

  return ret
end

function status_routine(mk_name, mk_device)
  while(true) do
    data = get_data(mk_device)
    perc_cap = math.ceil((data['energy'] / data['capacity']) * 100)

    print('Mekanism Device:', mk_name)
    term.setCursorPos(3, 3)
    energy = math.ceil(data['energy'] / 1000)
    capacity = math.ceil(data['capacity'] / 1000)
    print('['..perc_cap..'%]:',energy..'/'..capacity,'kFE')

    term.setCursorPos(1, height - 4)
    print('List:',data['list'])
    print('Internal Size:',data['internal_size'])
    print('Tanks:',data['tanks'])
    print('Inventory: [in:', data['input_slot']..'] [out:',data['output_slot']..']')

    sleep(1)
    reset_term()
  end
end

function setup()
  if(not fs.exists(CONFIG_DIR)) then
    fs.makeDir(CONFIG_DIR)
  end
end

-- Runtime
function main()
  setup()
  local config = load_config(CONFIG_PATH)

  reset_term()
  if(config['netport'] ~= nil) then
    local side = config['netport']
    local lowwater_mark = config['thresholds']['low']
    local highwater_mark = config['thresholds']['high']

    print('Ethernet Port:', side)
    print('Thresholds:\n\tLow:',lowwater_mark,'\n\tHigh:', highwater_mark)

    local modem = peripheral.wrap(side)
    local mk_name, mk_device = discover_network_device(IM_TYPE, modem)

    print('Name:',mk_name..', Dev:',mk_device)

    os.sleep(3)
    status_routine(mk_name, mk_device)
  else
    print('Config not found:', CONFIG_PATH)
  end
end

main()
