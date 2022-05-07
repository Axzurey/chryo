-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local Workspace = _services.Workspace
local protocols = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "define", "protocols")
local system = {}
do
	local _container = system
	local poly = {}
	do
		local _container_1 = poly
		local function drawLine(p1, p2)
			local bin = Workspace:FindFirstChild("debug_system")
			if not bin then
				bin = Instance.new("Folder")
				bin.Name = "debug_system"
				bin.Parent = Workspace
			end
			local p = Instance.new("Beam")
			local a1 = Instance.new("Attachment")
			local a2 = Instance.new("Attachment")
			local a = Instance.new("Part")
			a.CanCollide = false
			a.Anchored = true
			a.CanTouch = false
			a.CanQuery = false
			a.Transparency = 1
			a.Parent = Workspace
			p.Width0 = .005
			p.Width1 = .005
			p.Color = ColorSequence.new(Color3.new(1, 0, 0))
			p.Brightness = 60
			p.Attachment0 = a1
			p.Attachment1 = a2
			a1.WorldPosition = p1
			a2.WorldPosition = p2
			p.Parent = a
			a1.Parent = a
			a2.Parent = a
		end
		_container_1.drawLine = drawLine
	end
	_container.poly = poly
	local remote = {}
	do
		local _container_1 = remote
		local server = {}
		do
			local _container_2 = server
			local function fireClient(protocol, client, ...)
				local args = { ... }
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
			local function fireServer(protocol, ...)
				local args = { ... }
				if RunService:IsClient() then
					protocols[protocol].protocol:fireServer(args)
				else
					error("this method can not be called from the server")
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
