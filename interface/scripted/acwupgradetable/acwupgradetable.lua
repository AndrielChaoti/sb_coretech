
function init()
	local li = widget.addListItem("itemList")
	widget.setItemSlotItem(widget.getChildAt(screenPosition), { name = "durasteelbar"})
	widget.setData(li, {itemName = "Durasteel Bar"})
	--widget.setListSelected("itemList", li)
	--widget.setItemSlotItem(li .. ".itemIcon", {name="durasteelbar"});
	--widget.setText(li .. ".itemName", "Durasteel Bar")
end

function update()

end

function uninit()
end


function upgradeBtn()
	sb.logInfo("boop")
end
