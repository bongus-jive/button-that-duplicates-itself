local icon = root.assetJson("/quickbar/icons.json:items.patman:duplicate")

local function addIcon()
	pane.playSound(icon.sound)

	-- Classic Quickbar
	if addQuickbarButton then
		addQuickbarButton(icon)
		return
	end

	-- Stardust Core
	if metagui then
		local newItem = itemField:addChild({
			type = "menuItem", size = {128, 20}, data = icon, padding = 0,
			children = { { scissoring = false },
				{ type = "label", align = "right", text = icon.label },
				{ type = "image", size = {20, 20}, file = icon.icon },
			}
		})
		newItem.onClick = addIcon

		metagui.startEvent(function()
			coroutine.yield()
			itemField:scrollBy({0, 20})
		end)

		return
	end

	-- Quickbar Mini
	local listItem = string.format("scroll.list.%s", widget.addListItem("scroll.list"))
	widget.setText(listItem .. ".label", icon.label)

	local container = listItem .. ".buttonContainer"
	widget.registerMemberCallback(container, "click", addIcon)

	local button = string.format("%s.%s.button", container, widget.addListItem(container))
	widget.setButtonOverlayImage(button, icon.icon)

	if compactLabels then
		compactLabels[button] = icon.label
	end
end

addIcon()
