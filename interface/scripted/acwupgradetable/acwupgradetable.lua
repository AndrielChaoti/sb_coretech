--[[
	Project:		acwupgradetable
	Friendly Name:	Weapon Upgrade Table
	Author:			AndrielChaoti


	File:			acwupgradetable.lua
	Purpose:		The main script file for the mod

	Copyright (c) Donald Granger. All Rights Reserved
	Licensed under the MIT License. See LICENSE file in the project root
	for full license information.
]]

local rarityEnum = {
  ["common"] = 1,
  ["uncommon"] = 2,
  ["rare"] = 3,
  ["legendary"] = 4
}

function init()
	-- hide unused ui elements
	widget.setText("upgradeCost.itemName", "")
	widget.setText("upgradeCost.itemCount", "")

	--widget.setVisible("stopBtn", false)
	--widget.setVisible("baseStats", false)
	--widget.setVisible("upgradeStats", false)
	--widget.setVisible("upgradeCost.currencyCost", false)
	--widget.setButtonEnabled("upgradeBtn", false)

	-- init variables
	if not self.upgradeState then
		self.upgradeState = {
			upgrading = false,
			startTime = 0,
			endTime = 0,
		}

		self.config = root.assetJson("/interface/scripted/acwupgradetable/acwupgrade.config")
		toggleInterface()

		self.itemStorage = {}
		self.upgradeConfig = {}
	end

	self._id = pane.containerEntityId()
end

function update(dt)

	if self.upgradeState.upgrading == true then
		if os.time() >= self.upgradeState.endTime then
			-- HOLY SHIT UPGRADE THE ITEM
			sb.logInfo("item upgraded")
			local newItem = self.itemStorage[1]
			newItem.parameters.level = self.upgradeConfig.newLevel
			-- Fixes a spawned item's rarity
			if newItem.parameters.rarity == nil then
				for k, _ in pairs(rarityEnum) do
					if string.find(newItem.name, k) then
						newItem.parameters.rarity = k
					end
				end
			end
			-- updates the rarity of the item
			if newItem.parameters.level >= 6 and rarityEnum[newItem.parameters.rarity] <= rarityEnum["legendary"] then
				newItem.parameters.rarity = "legendary"
			elseif newItem.parameters.level >= 4 and rarityEnum[newItem.parameters.rarity] <= rarityEnum["rare"] then
				newItem.parameters.rarity = "rare"
			elseif newItem.parameters.level >= 2 and rarityEnum[newItem.parameters.rarity] <= rarityEnum["uncommon"] then
				newItem.parameters.rarity = "uncommon"
			end

			world.containerTakeAll(self._id)
			world.containerAddItems(self._id, newItem)
			self.upgradeState.upgrading = false

			-- restore the itemgrid:
			widget.setVisible("lockeditemGrid", false)
			widget.setItemSlotItem("lockeditemGrid", {name = ""})
			widget.setVisible("padlock", false)
			widget.setVisible("itemGrid", true)
		end
	end

	self.itemStorage = widget.itemGridItems("itemGrid")


	-- check if item in slot
	if not self.itemStorage[1] then
		toggleInterface()
		self.hasValidItem = false
	else
		-- check the item type among other things.
		local name = self.itemStorage[1].name
		for _,v in pairs(self.config.validItems.base) do
			if string.find(name, v) then
				-- valid item inserted switch flag.
				self.hasValidItem = true
				toggleInterface(self.itemStorage[1])

				-- some debuggering
				script.setUpdateDelta(1)
				local pos = world.entityPosition(self._id)
				world.debugText("itemlevel: %s", self.itemStorage[1].parameters.level, pos, "red")
				world.debugText("itemRarity: %s", self.itemStorage[1].parameters.rarity, {pos[1],pos[2]+1.5}, "red")
				world.debugText("upstate: %s", self.upgradeState.upgrading, {pos[1],pos[2]+1}, "red")
				world.debugText("hasitem: %s", self.hasValidItem, {pos[1],pos[2]+0.5}, "red")

				return
			end
		end
		-- the item actually isn't valid, clear the interface
		toggleInterface()
	end
end


function uninit()
	-- give the player back their item if we're not upgrading it.
	if self.upgradeState.upgrading == false and self.itemStorage[1] then
		local item = self.itemStorage[1]
		world.containerTakeAll(self._id)
		player.giveItem(item)
	end
end

function toggleInterface(item)
	if not item then
		widget.setVisible("stopBtn", false)
		widget.setVisible("baseStats", false)
		widget.setVisible("upgradeStats", false)
		widget.setVisible("upgradeCost.currencyCost", false)
		widget.setButtonEnabled("upgradeBtn", false)
		widget.setText("upgradeCost.itemName", "")
		widget.setText("upgradeCost.itemCount", "")
		widget.setItemSlotItem("upgradeCost.itemSlot", {name=""})
		widget.setVisible("lockeditemGrid", false)
		widget.setVisible("padlock", false)
		return
	else
		if not item.parameters.level then
			item.parameters.level = 1
		end
		if item.parameters.level >= 5 then
			widget.setVisible("upgradeCost.currencyCost", true)
		end
		if item.parameters.level == 10 then
			-- handle this more gracefully
			return
		end
		widget.setVisible("baseStats", true)
		widget.setVisible("upgradeStats", true)
		widget.setButtonEnabled("upgradeBtn", true)
		local weapontype = ""

		for _,v1 in pairs({"melee", "ranged", "magic"}) do
			for _, v2 in pairs(self.config.validItems[v1]) do
				if string.find(item.name, v2) then
					calculateUpgrade(item, v1)
				end
			end
		end
	end
end

function calculateUpgrade(item, wepType)
	--sb.logInfo("%s\t%s\t%s", item.name, item.parameters.level, wepType)
	if not self.hasValidItem then return end

	-- get item params for upgrading
	local itemLvl = item.parameters.level
	self.upgradeConfig = {}

	-- find our pos in the upgrade chart
	for _,v in pairs(self.config.upgradeCosts) do
		if (v.level >= itemLvl) and
		   (v.weaponType == "any" or v.weaponType == wepType) then
			self.upgradeConfig = v;
			break
		end
	end

	-- sanity checking:
	if (not self.upgradeConfig.material) and (not self.upgradeConfig.materialAmount) then error("missing upgrade material or amount.") end

	-- cache important thingers.
	local upgradeItemDesc = root.itemConfig({name = self.upgradeConfig.material})
	local playerItemCount = player.hasCountOfItem({name = self.upgradeConfig.material})
	local playerCurrencyCount = player.currency("essence")

	-- populate UI
	widget.setItemSlotItem("upgradeCost.itemSlot", {name = self.upgradeConfig.material})
	widget.setText("upgradeCost.itemName", upgradeItemDesc.config.shortdescription)
	widget.setText("upgradeCost.itemCount", playerItemCount .. "/" .. self.upgradeConfig.materialAmount)
	if playerItemCount < self.upgradeConfig.materialAmount then
		widget.setFontColor("upgradeCost.itemCount", "red")
		if not player.isAdmin() then
			widget.setButtonEnabled("upgradeBtn", false)
		end
	else
		widget.setFontColor("upgradeCost.itemCount", "white")
	end

	-- populate currency UI if needed:
	if self.upgradeConfig.currencyNeeded > 0 then
		widget.setText("upgradeCost.currencyCost.text", self.upgradeConfig.currencyNeeded)
		if playerCurrencyCount < self.upgradeConfig.currencyNeeded then
			widget.setFontColor("upgradeCost.currencyCost.text", "red")
			if not player.isAdmin() then
				widget.setButtonEnabled("upgradeBtn", false)
			end
		else
			widget.setFontColor("upgradeCost.currencyCost.text", "white")
		end
	end
end

function upgradeBtn()
	if not self.hasValidItem then return end
	if not self.upgradeConfig then return end

	-- take items from player's inventory:
	local consumed = false
	if not player.isAdmin() then
		consumed = player.consumeItem({name = self.upgradeConfig.material, count = self.upgradeConfig.materialAmount})
		-- consume currency
		if self.upgradeConfig.currencyNeeded > 0 then
			consumed = player.consumeCurrency("essence", self.upgradeInfo.currencyNeeded)
		end
		-- couldn't consume items, don't upgrade
		if consumed == false then return end
	end
	-- mark upgrade as started
	self.upgradeState.startTime = os.time()
	self.upgradeState.endTime = self.upgradeState.startTime + self.upgradeConfig.timeNeeded

	-- lock the upgrade slot
	widget.setVisible("lockeditemGrid", true)
	widget.setItemSlotItem("lockeditemGrid", self.itemStorage[1])
	widget.setVisible("padlock", true)
	widget.setVisible("itemGrid", false)

	-- skip timer in admin mode
	if player.isAdmin() then
		self.upgradeState.endTime = os.time()
	end

	self.upgradeState.upgrading = true
	--self.upgradeStart = os.
end
