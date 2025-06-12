local socket = require 'socket'

local function receive (connection)
  return connection:receive(128)
end


local function download (host, file)
  local c = assert(socket.connect(host, 80))
  local count = 0    -- counts number of bytes read
  c:send("GET " .. file .. " HTTP/1.0\r\n\r\n")
	local str = ''
  while true do
    local s, status, partial = receive(c)
    if status == "closed" then
			str = str .. partial
			break
		end
    if s then
      count = count + string.len(s)
			str = str .. s
    end
  end
  c:close()
  print(str)
end

local host = "lunarmodules.github.io"
local file = "/luasocket/socket.html"

download(host, file)
