function init(...)
    if not self.upgradeState then
        self.upgradeState = {
            upgrading = false,
            startTime = 0,
            endTime = 0,
        }
    end

    message.setHandler("ct_UpgradeSet", function(...)
        --sb.logInfo("%s", {...})
        self.upgradeState, self.upgradeConfig = select(3,...)
    end)

    message.setHandler("ct_UpgradeGet", function(...)
        return {self.upgradeState, self.upgradeConfig or {}};
     end)
end
