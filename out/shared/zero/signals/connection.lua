-- Compiled with roblox-ts v1.3.3
local connection
do
	connection = setmetatable({}, {
		__tostring = function()
			return "connection"
		end,
	})
	connection.__index = connection
	function connection.new(...)
		local self = setmetatable({}, connection)
		return self:constructor(...) or self
	end
	function connection:constructor()
		self.connections = {}
	end
	function connection:fire(...)
		local args = { ... }
		local _connections = self.connections
		local _arg0 = function(v)
			coroutine.wrap(function()
				if v.callback then
					v.callback(unpack(args))
				end
				v.passedArgs = args
				v.called = true
				if v.once then
					v.disconnect()
				end
			end)()
		end
		for _k, _v in ipairs(_connections) do
			_arg0(_v, _k - 1, _connections)
		end
	end
	function connection:disconnectSomething(d)
		local index = (table.find(self.connections, d) or 0) - 1
		if d.disconnected then
			error("unable to disconnect a connection that has already been disconnected")
		end
		if index ~= -1 then
			d.disconnected = true
			local _connections = self.connections
			local _index = index
			table.remove(_connections, _index + 1)
		end
	end
	function connection:connect(callback)
		local l
		l = {
			callback = callback,
			disconnect = function()
				self:disconnectSomething(l)
			end,
			disconnected = false,
		}
		local _connections = self.connections
		local _l = l
		table.insert(_connections, _l)
		return l
	end
end
return {
	default = connection,
}
