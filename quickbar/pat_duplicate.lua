-- peeing

local actions = { }
local function nullfunc() end
local function action(id, ...) return (actions[id] or nullfunc)(...) end
function actions.exec(script, ...)
  if type(script) ~= "string" then return nil end
  params = {...} -- pass any given parameters to the script
  _SBLOADED[script] = nil require(script) -- force execute every time
  params = nil -- clear afterwards for cleanliness
end

local function funny()
	local c = root.assetJson("/quickbar/icons.json")
	
	local i = c.items["patman:duplicate"]
	local l = "scroll.list." .. widget.addListItem("scroll.list")
	widget.setText(l .. ".label", i.label)
	local bc = l .. ".buttonContainer"
	
	widget.registerMemberCallback(bc, "click", function()
		action(table.unpack(i.action))
		if i.dismissQuickbar then pane.dismiss() end
	end)
	local btn = bc .. "." .. widget.addListItem(bc) .. ".button"
	widget.setButtonOverlayImage(btn, i.icon or "/items/currency/essence.png")

	if config.getParameter("compacted") and labels then
		labels[btn] = i.label
	end
end

pane.playSound("/quickbar/pat_duplicate.ogg")
funny()