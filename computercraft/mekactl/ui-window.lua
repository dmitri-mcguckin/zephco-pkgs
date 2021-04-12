Window = {
  parent = nil,
  window = nil,
  title = nil,
  is_closed = false,
  fg = colors.gray,
  bg = colors.lightGray
}

function Window:new(o, parent, title, x, y, w, h)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o

  -- self.is_closed = false
  -- self.window = window.create(parent, x, y, w, h, true)
  -- self.title = title
  --
  -- -- Draw basic window
  -- self.window.setBackgroundColor(self.bg)
  -- self.window.setTextColor(self.fg)
  -- self.window.clear()
  --
  -- -- Draw title bar
  -- self.window.setBackgroundColor(colors.blue)
  -- self.window.setTextColor(colors.white)
  -- self.window.clearLine(1)
  -- self.window.write(self.title)
  --
  -- -- Draw mini-buttons
  -- self.window.setCursorPos(w, 1)
  -- self.window.setBackgroundColor(colors.red)
  -- self.window.write('X')
  --
  -- -- Reset the draw status
  -- self.window.setBackgroundColor(self.bg)
  -- self.window.setTextColor(self.fg)
  -- self.window.setCursorPos(2, 1)
  --
  -- return o
end

function Window:write(text)
  print(text)
end

function Window:handle_touch_event()
  local event, side, x, y = os.pull_event('monitor_touch')
end

-- Start sim
term.clear()
stdout = term.current()
sw, sh = stdout.getSize()

ww = 20
wh = 20
wx = math.floor((sw - ww) / 2) - math.floor(ww / 2)
wy = math.floor((sh - wh) / 2) - math.floor(wh / 2)
win = Window.new{stdout, 'Mekanism Monitor', wx, wy, ww, wh}
win:write('a')

-- End sim
os.sleep(3)
term.setCursorPos(1,1)
