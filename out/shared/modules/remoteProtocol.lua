-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local Players = _services.Players
local RunService = _services.RunService
local getSharedEnvironment = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "environment").getSharedEnvironment
local verifyRemoteArgs = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "entities", "space").verifyRemoteArgs
local dev = true
--[[
	*
	* the parameters of the generic are what the component recieves: FireServer would send Parameters<Server>
]]
local remoteProtocol
do
	remoteProtocol = setmetatable({}, {
		__tostring = function()
			return "remoteProtocol"
		end,
	})
	remoteProtocol.__index = remoteProtocol
	function remoteProtocol.new(...)
		local self = setmetatable({}, remoteProtocol)
		return self:constructor(...) or self
	end
	function remoteProtocol:constructor(uniqueAlias, expected)
		self.listeners = {}
		if RunService:IsServer() then
			self.remote = Instance.new("RemoteEvent")
			self.remote.Name = "protocol:" .. uniqueAlias
			self.remote.Parent = getSharedEnvironment().Remotes
			self.remote.OnServerEvent:Connect(function(client, ...)
				local args = { ... }
				local _listeners = self.listeners
				local _arg0 = function(v)
					task.spawn(function()
						if v.callback then
							local _array = { client }
							local _length = #_array
							table.move(args, 1, #args, _length + 1, _array)
							local t = verifyRemoteArgs(_array, expected)
							if not t and dev then
								error("args for remote " .. (uniqueAlias .. " do not comply!"))
							elseif not t then
								return nil
							end
							local callback = v.callback
							local a = args
							callback(client, unpack(a))
						end
					end)
				end
				for _k, _v in ipairs(_listeners) do
					_arg0(_v, _k - 1, _listeners)
				end
			end)
		else
			self.remote = getSharedEnvironment().Remotes:WaitForChild("protocol:" .. uniqueAlias)
			self.remote.OnClientEvent:Connect(function(...)
				local args = { ... }
				local _listeners = self.listeners
				local _arg0 = function(v)
					task.spawn(function()
						if v.callback then
							local callback = v.callback
							local a = args
							callback(unpack(a))
						end
					end)
				end
				for _k, _v in ipairs(_listeners) do
					_arg0(_v, _k - 1, _listeners)
				end
			end)
		end
	end
	function remoteProtocol:disconnectSomething(d)
		local index = (table.find(self.listeners, d) or 0) - 1
		if d.disconnected then
			error("unable to disconnect a connection that has already been disconnected")
		end
		if index ~= -1 then
			d.disconnected = true
			local _listeners = self.listeners
			local _index = index
			table.remove(_listeners, _index + 1)
		end
	end
	function remoteProtocol:addListener(constructed)
		local _listeners = self.listeners
		table.insert(_listeners, constructed)
	end
	function remoteProtocol:listenServer(callback)
		local c
		c = {
			callback = callback,
			disconnected = false,
			disconnect = function()
				self:disconnectSomething(c)
			end,
		}
		self:addListener(c)
		return c
	end
	function remoteProtocol:listenClient(callback)
		local c
		c = {
			callback = callback,
			disconnected = false,
			disconnect = function()
				self:disconnectSomething(c)
			end,
		}
		self:addListener(c)
		return c
	end
	function remoteProtocol:fireClient(client, args)
		if RunService:IsClient() then
			error("this method may not be called from the client!")
		end
		self.remote:FireClient(client, unpack(args))
	end
	function remoteProtocol:fireClients(clients, args)
		if RunService:IsClient() then
			error("this method may not be called from the client!")
		end
		local _arg0 = function(client)
			self.remote:FireClient(client, unpack(args))
		end
		for _k, _v in ipairs(clients) do
			_arg0(_v, _k - 1, clients)
		end
	end
	function remoteProtocol:fireAllClientsExcept(blacklist, args)
		if RunService:IsClient() then
			error("this method may not be called from the client!")
		end
		local _exp = Players:GetPlayers()
		local _arg0 = function(client)
			if (table.find(blacklist, client) or 0) - 1 ~= -1 then
				return nil
			end
			self.remote:FireClient(client, unpack(args))
		end
		for _k, _v in ipairs(_exp) do
			_arg0(_v, _k - 1, _exp)
		end
	end
	function remoteProtocol:fireServer(args)
		if RunService:IsServer() then
			error("this method may not be called from the client!")
		end
		self.remote:FireServer(unpack(args))
	end
	function remoteProtocol:destroy()
		if RunService:IsClient() then
			error("this method may not be called from the client!")
		end
		local _listeners = self.listeners
		local _arg0 = function(v)
			v.disconnect()
		end
		for _k, _v in ipairs(_listeners) do
			_arg0(_v, _k - 1, _listeners)
		end
		self.remote:Destroy()
	end
end
return {
	default = remoteProtocol,
}
