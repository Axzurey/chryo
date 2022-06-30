-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local remoteProtocol = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "modules", "remoteProtocol").default
local t = TS.import(script, TS.getModule(script, "@rbxts", "t").lib.ts).t
local protocols = {
	updateMovement = {
		protocol = remoteProtocol.new("update_client_cframe", { t.Instance, t.CFrame }),
	},
	equipContext = {
		protocol = remoteProtocol.new("item_equip_context", { t.Instance, t.string }),
	},
	reloadFeedSingleContext = {
		protocol = remoteProtocol.new("item_reload_single_context", { t.Instance, t.string }),
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
	clientFlingBasepart = {
		protocol = remoteProtocol.new("client_fling_basepart_context", { t.Instance, t.Instance, t.Vector3, t.Vector3 }),
	},
	startReinforcement = {
		protocol = remoteProtocol.new("start_reinforcement_context", { t.Instance, t.CFrame }),
	},
	cancelReinforcement = {
		protocol = remoteProtocol.new("cancel_reinforcement_context", { t.Instance }),
	},
	throwDrone = {
		protocol = remoteProtocol.new("throw_drone", { t.Instance }),
	},
	updateDroneRotation = {
		protocol = remoteProtocol.new("update_drone_rotation", { t.Instance, t.string, t.CFrame }),
	},
	moveDrone = {
		protocol = remoteProtocol.new("update_drone_position", { t.Instance, t.string, t.Vector3 }),
	},
	observeCamera = {
		protocol = remoteProtocol.new("observe_drone", { t.Instance, t.string, t.boolean }),
	},
	cameraControllerChanged = {
		protocol = remoteProtocol.new("camera_controller_changed", { t.Instance, t.string, t.boolean }),
	},
}
return protocols
