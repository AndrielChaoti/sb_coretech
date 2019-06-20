```lua
function init()
	self.upgradeIncrement = 0.4
	self.minLevel = 1
	self.maxLevel = 10
	if fuExists then
		self.maxLevel = 7
	end
	
	self.tierConfigs = {
		-- tier 1
		{
			material = "tungstenbar",
			minTime = 3,
			maxTime = 4,
			minMaterialCost = 4,
			minMaterialCost = 8
		},
		-- tier 2
		{
			material = "titaniumbar",
			minTime = 4,
			maxTime = 5,
			minMaterialCost = 6,
			minMaterialCost = 10
		},
		-- tier 3
		{
			material = "durasteelbar",
			minTime = 6,
			maxTime = 8,
			minMaterialCost = 8,
			minMaterialCost = 12
		},
		-- tier 4
		{
			materials = {
				"ranged" : "durasteelbar",
				"melee" : "refinedferozium",
				"magic" : "refinedviolium"
			},
			minTime = 10,
			maxTime = 12,
			minMaterialCost = 10,
			minMaterialCost = 14
		},
		-- tier 5
		{
			material = "solariumstar",
			minTime = 20,
			maxTime = 25,
			minMaterialCost = 12,
			minMaterialCost = 16,
			minCurrencyCost = 200,
			maxCurrencyCost = 500
		},
		-- tier 6
		{
			material = "solariumstar",
			minTime = 30,
			maxTime = 40,
			minMaterialCost = 20,
			minMaterialCost = 24,
			minCurrencyCost = 750,
			maxCurrencyCost = 1500
		},
		-- tier 7
		{
			material = "solariumstar",
			minTime = 50,
			maxTime = 60,
			minMaterialCost = 26,
			minMaterialCost = 30,
			minCurrencyCost = 2000,
			maxCurrencyCost = 4500
		},
		-- tier 8
		{
			material = "solariumstar",
			minTime = 321,
			maxTime = 666,
			minMaterialCost = 32,
			minMaterialCost = 36,
			minCurrencyCost = 6500,
			maxCurrencyCost = 14000
		},
		-- tier 9
		{
			material = "solariumstar",
			minTime = 958,
			maxTime = 1987,
			minMaterialCost = 38,
			minMaterialCost = 42,
			minCurrencyCost = 20000,
			maxCurrencyCost = 40000
		}
	}
end

function CalculateCosts(item)
	local currentLevel = math.max(self.minLevel, math.min(item.parameter.level, self.maxLevel))
	local newLevel = math.min(self.maxLevel, currentLevel + self.upgradeIncrement)
		
	local tierConfig = self.tierConfigs[math.floor(currentLevel)]
	
	local levelProgress = item.parameter.level % 1
	local timeNeeded = tierConfig.minTime + levelProgress * (tierConfig.maxTime - tierConfig.minTime))
	local materialAmount = tierConfig.minMaterialCost + levelProgress * (tierConfig.maxMaterialCost - tierConfig.minMaterialCost))
	local currencyCost = 0
	if tierConfig.minCurrencyCost ~= nil then
		currencyCost = tierConfig.minCurrencyCost + levelProgress * (tierConfig.maxCurrencyCost - tierConfig.minCurrencyCost))
	end
	
	local material = tierConfig.material
	// You already have that logic for the three functions in here I expect
	if type(material) == "table" then
		if isRanged(item) then
			material = material.ranged
		elseif isMelee(item) then
			material = material.melee
		elseif isMagic(item) then
			material = material.magic
		end
	end

	return {
		newLevel = newLevel,
		currencyCost = currencyCost,
		timeNeeded = timeNeeded,
		materialAmount = materialAmount,
		material = material
	}
end
```