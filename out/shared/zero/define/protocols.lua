-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remoteProtocol = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "zero", "signals", "remoteProtocol").default
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local protocols = {
	updateMovement = {
		protocol = remoteProtocol.new("update_client_cframe", { t.Instance, t.CFrame }),
	},
	equipContext = {
		protocol = remoteProtocol.new("item_equip_context", { t.Instance, t.string }),
	},
	reloadStartContext = {
		protocol = remoteProtocol.new("item_reload_start_context", { t.Instance, t.string }),
	},
	reloadEndContext = {
		protocol = remoteProtocol.new("item_reload_end_context", { t.Instance, t.string }),
	},
	reloadCancelContext = {
		protocol = remoteProtocol.new("item_reload_cancel_context", { t.Instance, t.string }),
	},
	fireContext = {
		protocol = remoteProtocol.new("item_fire_context", { t.Instance, t.string, t.CFrame }),
	},
	fireMultiContext = {
		protocol = remoteProtocol.new("item_fireMulti_context", { t.Instance, t.string, t.array(t.CFrame) }),
	},
	nextFireModeContext = {
		protocol = remoteProtocol.new("next_fire_mode_context", { t.Instance, t.string }),
	},
	changeStanceContext = {
		protocol = remoteProtocol.new("change_stance_context", { t.Instance, t.string, t.literal(-1, 0, 1) }),
	},
}
return protocols
