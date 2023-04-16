do
	local c = root.assetJson("/quickbar/icons.json")
	local i = c.items["patman:duplicate"]

	--old quickbar
	if not metagui then
		local function action(_, script, ...)
			if type(script) ~= "string" then return nil end
			params = {...}
			_SBLOADED[script] = nil require(script)
			params = nil
		end

		local l = "scroll.list." .. widget.addListItem("scroll.list")
		widget.setText(l .. ".label", i.label)
		local bc = l .. ".buttonContainer"

		widget.registerMemberCallback(bc, "click", function()
			action(table.unpack(i.action))
			if i.dismissQuickbar then pane.dismiss() end
		end)
		local btn = bc .. "." .. widget.addListItem(bc) .. ".button"
		widget.setButtonOverlayImage(btn, i.icon or "/items/currency/essence.png")

		if config.getParameter("compacted") and compactLabels then
			compactLabels[btn] = i.label
		end

	--new quickbar
	else
		local function action(id, ...) return (qbActions[id] or function() end)(...) end
		local function menuClick(w, btn)
			local i = w.data
			if i.condition and not condition(table.unpack(i.condition)) then return nil end
			action(table.unpack(i.action))
		end
		
		local width = 128
		local itmHeight = 20
		
		local cum = itemField:addChild({
			type = "menuItem", size = {width, itmHeight}, data = i, padding = 0,
			children = { { scissoring = false },
				{ type = "label", align = "right", text = i.label },
				{ type = "image", size = {itmHeight, itmHeight}, file = i.icon or "/items/currency/essence.png" },
			}
		})
    
    metagui.startEvent(function()
      util.wait(0.05)
      itemField:scrollBy({0, 20})
    end)
		
		cum.onClick = menuClick
	end

	pane.playSound("/quickbar/pat_duplicate.ogg")
end