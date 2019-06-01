--[[
    USAGE:
    void openInterfaceAtCursor(Variant<String, Json> interfaceConfig, [vec2 offset])

    interfaceConfig: Interface to open can be a path of a config or the Json Config
    offset: The api guesses the interface size to make it centered, use this to offset from center

    NOTE: this may be buggy or laggy due to limitations as trying to get screen position
]]

function openInterfaceAtCursor(interfaceConfig, offset)
    local openInterface = {}
    openInterface = root.assetJson("/openInterfaceAtCursor/opener/main.window")

    openInterface.interfaceConfig = interfaceConfig
    openInterface.offset = offset

    player.interact("ScriptPane", openInterface)
end