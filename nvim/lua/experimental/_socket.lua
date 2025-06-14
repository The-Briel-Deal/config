local socket = require 'socket'
local inspect = require 'inspect'

local function receive(connection)
  return connection:receive(128)
end

local function download(host, file)
  local c = assert(socket.connect(host, 80))
  local count = 0 -- counts number of bytes read
  c:send('GET ' .. file .. ' HTTP/1.0\r\n\r\n')
  local str = ''
  while true do
    local s, status, partial = receive(c)
    if status == 'closed' then
      str = str .. partial
      break
    end
    if s then
      count = count + string.len(s)
      str = str .. s
    end
  end
  c:close()
  return str
end
local function downloadn(host, file, n)
  for i = 1, n do
    download(host, file)
  end
end

local function async_download(c, host, file)
  c:timeout(0)
  local count = 0 -- counts number of bytes read
  c:send('GET ' .. file .. ' HTTP/1.0\r\n\r\n')
  local str = ''
  while true do
    local s, status, partial = receive(c)
    if status == 'timeout' then
      coroutine.yield(nil)
    elseif status == 'closed' then
      str = str .. partial
      c:close()
      coroutine.yield(str)
      break
    end
    if s then
      count = count + string.len(s)
      str = str .. s
    end
  end
end
local function async_downloadn(host, file, n)
  local threads = {}
  for i = 1, n do
    local c = assert(socket.connect(host, 80))
    table.insert(threads, {
			closed = false,
      cor = coroutine.create(function()
        async_download(c, host, file)
      end),
      con = c,
      getfd = function(t)
        return t.con:getfd()
      end,
      dirty = function(t)
        return t.con:dirty()
      end,
    })
  end
  local check_threads = function(to_check)
    for i = 1, #to_check do
      local cor_status, str = coroutine.resume(to_check[i].cor)
      if str ~= nil then
				to_check[i].closed = true
      end
    end
  end
  while #threads > 0 do
    local to_read, to_write, select_status = socket.select(threads, threads, 0)
		print(inspect(to_read, to_write))
    check_threads(to_read)
    check_threads(to_write)
		for i, thread in ipairs(threads) do
			if thread.closed then
				table.remove(threads, i)
			end
		end
  end
end

local host = 'lunarmodules.github.io'
local file = '/luasocket/socket.html'

local start_time = socket.gettime()
async_downloadn(host, file, 20)
local end_time = socket.gettime()

print('async', (end_time - start_time))

start_time = socket.gettime()
downloadn(host, file, 20)
end_time = socket.gettime()

print('sync', (end_time - start_time))
