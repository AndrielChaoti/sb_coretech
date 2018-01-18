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
	self.upgradeState = false

	self.config = root.assetJson("/interface/scripted/acwupgradetable/acwupgrade.config")
	self.itemStorage = {}
end

function update(dt)
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
				break
			end
		end
	end
end

function uninit()
	-- give the player back their item if we're not upgrading it.
	if self.upgradeState == false and self.itemStorage[1] then
		local item = self.itemStorage[1]
		world.containerTakeAll(pane.containerEntityId())
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
		return
	else
		if not item.parameters.level then
			item.parameters.level = 1
		end
		if item.parameters.level >= 5 then
			widget.setVisible("upgradeCost.currencyCost", true)
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

function calculateUpgrade(item, type)
	sb.logInfo("OMG FUCK OFF I DON'T WANT TO.")
end

function upgradeBtn()
	if not self.hasValidItem then return end
	sb.logInfo("boop")
end
