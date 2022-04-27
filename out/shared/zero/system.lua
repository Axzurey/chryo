-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local protocols = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "define", "protocols")
local system = {}
do
	local _container = system
	local remote = {}
	do
		local _container_1 = remote
		local server = {}
		do
			local _container_2 = server
			local function fireClient(protocol, client, args)
				if RunService:IsServer() then
					protocols[protocol].protocol:fireClient(client, args)
				else
					error("this method can not be called from the client")
				end
			end
			_container_2.fireClient = fireClient
			local function on(protocol, callback)
				if RunService:IsServer() then
					return protocols[protocol].protocol:listenServer(callback)
				else
					error("this method can not be called from the client")
				end
			end
			_container_2.on = on
		end
		_container_1.server = server
		local client = {}
		do
			local _container_2 = client
			local function fireServer(protocol, client, args)
				if RunService:IsServer() then
					protocols[protocol].protocol:fireClient(client, args)
				else
					error("this method can not be called from the client")
				end
			end
			_container_2.fireServer = fireServer
			local function on(protocol, callback)
				if RunService:IsClient() then
					return protocols[protocol].protocol:listenClient(callback)
				else
					error("this method can not be called from the server")
				end
			end
			_container_2.on = on
		end
		_container_1.client = client
	end
	_container.remote = remote
end
return system
