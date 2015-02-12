local JSON  = require('json')
local fs    = require('fs')
local timer = require('timer')
local http  = require('http')
local mysql = require("mysql/mysql")


local __pgk = "BOUNDARY MYSQL"

function error(err)
  if err then print(string.format("%s ERROR: %s", __pgk, tostring(err))) return err end
end

-- get the natural difference between a and b
function diff(a, b)
    if a == nil or b == nil then return 0 end
    return math.max(a - b, 0)
end

--  If you want to return a float from Lua you should return it as a string,
function float(x)
  n = tonumber(x)
  if n == nil then return 0 end
  return tostring(n / 10.0)
end

-- to number
function parse(x)
  n = tonumber(x)
  if n == nil then return 0 else return n end
end

-- get the natural sum of the passed in values
function sum(...)
  if arg == nil then return 0 end
  for i,v in ipairs(arg) do
    s = s + tonumber(v)
  end
  return math.max(s, 0)
end

-- concat two tables
function concat(t1, t2)
   for k,v in ipairs(t2) do
      table.insert(t1, v)
   end
   return t1
end


fs.readFile("param.json", function (err, data)
  if err then return end
  value = JSON.parse(data)

  poll = value['poll'] or 1000
  host = value['host'] or "localhost"
  port = value['port'] or 3306
  user = value['user']
  pass = value['pass']

  if not pass or not user then return error("User and password required") end

  local client = mysql.createClient({
     port     = port,
     host     = host,
     user     = user,
     password = pass
  })

  print("_bevent:Mysql plugin up : version 1.0|t:info|tags:mysql,lua,plugin")

  local _previous = {}
  timer.setInterval(poll, function ()

    client:query("SHOW GLOBAL STATUS", function(err, status, _)
      if error(err) then return end

      client:query("SHOW GLOBAL VARIABLES", function(err2, vars, _)
        if error(err2) then return end

        local adjusted = {}
        local current = {}

        concat(status, vars)

        for i, row in ipairs(status) do
          local c = parse(row.Value)
          current[row.Variable_name] = c
          adjusted[row.Variable_name] = diff(c, _previous[row.Variable_name])
        end

        print(string.format('MYSQL_CONNECTIONS %d', adjusted.Connections))
        print(string.format('MYSQL_ABORTED_CONNECTIONS %d', sum(adjusted.Aborted_connects, adjusted.Aborted_clients)))
        print(string.format('MYSQL_BYTES_IN %d', adjusted.Bytes_received))
        print(string.format('MYSQL_BYTES_OUT %d', adjusted.Bytes_sent))
        print(string.format('MYSQL_SLOW_QUERIES %d', adjusted.Slow_queries))
        print(string.format('MYSQL_ROW_MODIFICATIONS %d', sum(adjusted.Handler_write, adjusted.Handler_update, adjusted.Handler_delete)))
        print(string.format('MYSQL_ROW_READS %d', sum(adjusted.Handler_read_first, adjusted.Handler_read_key, adjusted.Handler_read_next,adjusted.Handler_read_prev, adjusted.Handler_read_rnd, adjusted.Handler_read_rnd_next)))
        print(string.format('MYSQL_TABLE_LOCKS %d', adjusted.Table_locks_immediate))
        print(string.format('MYSQL_TABLE_LOCKS_WAIT %d', adjusted.Table_locks_waited))
        print(string.format('MYSQL_COMMITS %d', adjusted.Handler_commit))
        print(string.format('MYSQL_ROLLBACKS %d', adjusted.Handler_rollback))
        print(string.format('MYSQL_QCACHE_PRUNES %d', adjusted.Qcache_lowmem_prunes))
        _previous = current

      end)
    end)
  end)



end)


