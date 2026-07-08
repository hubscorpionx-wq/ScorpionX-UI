local Library = {}

Library.Theme = require(script.Theme)
Library.Window = require(script.Window)
Library.Tabs = require(script.Tabs)
Library.Elements = require(script.Elements)
Library.Notifications = require(script.Notifications)
Library.Utils = require(script.Utils)

function Library:CreateWindow(options)
    return self.Window.new(options)
end

return Library
