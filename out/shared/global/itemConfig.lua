-- Compiled with roblox-ts v1.3.3
local TS = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local hk416_config = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "itemConfig", "hk416")
local holographic_config = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "itemConfig", "holographic")
local m870_config = TS.import(script, game:GetService("ReplicatedStorage"), "TS", "itemConfig", "m870")
local itemConfig = {}
do
	local _container = itemConfig
	local gunData = {
		holographic = holographic_config,
		hk416 = hk416_config,
		m870 = m870_config,
	}
	local cleanables = { "path" }
	local function getItemConfig(itemName, property)
		return gunData[itemName][property]
	end
	_container.getItemConfig = getItemConfig
	local function getProperties(itemName)
		return gunData[itemName]
	end
	_container.getProperties = getProperties
	local function itemClean(d)
		local _arg0 = function(v)
			local _value = d[v]
			if _value ~= 0 and (_value == _value and (_value ~= "" and _value)) then
				d[v] = nil
			end
		end
		for _k, _v in ipairs(cleanables) do
			_arg0(_v, _k - 1, cleanables)
		end
		return d
	end
	_container.itemClean = itemClean
end
return itemConfig
