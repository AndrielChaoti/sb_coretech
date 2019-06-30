function init(...)
	if storage and not storage.upgradeState then
		storage.upgradeState = {
			upgrading = false,
			startTime = 0,
			endTime = 0
		}
	end

	message.setHandler("ct_UpgradeSet", function(...)
		--sb.logInfo("%s", {...})
		storage.upgradeState, storage.upgradeConfig = select(3,...)
	end)

	message.setHandler("ct_UpgradeGet", function(...)
		return {storage.upgradeState or {}, storage.upgradeConfig or {}};
	end)
end
