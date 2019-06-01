include "vec2"

module = {}

function module:init()
	self.sizeCanvas = self.canvas:size()
	widget.focus(self.widgetName)
	self:updateMouse()
end

function module:update(dt)
	widget.focus(self.widgetName)
	self:updateMouse()
	if widget.hasFocus(self.widgetName) and self.mousePosition[1] ~= 0 and self.mousePosition[2] ~= 0 then
		pcall(openAt, self.mousePosition)
		pane.dismiss()
	end
end

function module:updateMouse()
	self.mousePosition = self.canvas:mousePosition()
end

function createTooltip(screenPosition)
	pcall(openAt, screenPosition)
	pane.dismiss()
	return nil
end

local imageSizeCache = {}
local function imageSize(img)
	if not img then return end
	if imageSizeCache[img] then return imageSizeCache[img] end
	imageSizeCache[img] = root.imageSize(img)
	return imageSizeCache[img]
end

--gets interface size from json config
function interfaceSize(config)
	for i,wid in pairs(config.gui or {}) do
		if wid.type and wid.type == "background" then
			local fileHeaderSize = imageSize(wid.fileHeader) or {0,0}
			local fileBodySize = imageSize(wid.fileBody) or {0,0}
			local fileFooterSize = imageSize(wid.fileFooter) or {0,0}
			return {math.max(fileHeaderSize[1], fileBodySize[1], fileFooterSize[1]), fileHeaderSize[2] + fileBodySize[2] + fileFooterSize[2]}
		end
	end
	return {0,0}
end

function openAt(screenPosition)
	local interfaceConfig = config.getParameter("interfaceConfig")
	local offset = config.getParameter("offset", {0,0}) or {0,0}
	local openInterface = {}

	if type(interfaceConfig) == "table" then
		openInterface = interfaceConfig
	elseif type(interfaceConfig) == "string" then
		openInterface = root.assetJson(interfaceConfig)
	else
		sb.logWarn("interfaceConfig is "..type(interfaceConfig))
		return
	end

	--gets interface size
	local size = interfaceSize(openInterface)

	--offsets here
	if openInterface.gui then
		openInterface.gui.panefeature = {
			type = "panefeature",
			anchor = "bottomLeft",
			positionLocked = true,
			offset = vec2.add(vec2.sub(screenPosition, vec2.mul(size, 0.5)), offset)
		}
	end

	player.interact("ScriptPane", openInterface)
end

--callbacks

function module:handleMouse(position, button, isdown)

end