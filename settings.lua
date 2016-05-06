local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )

local latitudeInput
local longitudeInput

local verifyInput

local params

local function handleMenuButtonEvent( event )
    if ( "ended" == event.phase ) then
        if latitudeInput ~= nil then
            latitudeInput:removeSelf()
        end
        if longitudeInput ~= nil then
            longitudeInput:removeSelf()
        end
        composer.removeHidden()
        composer.removeScene("settings")
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
    end
end

verifyInput = function(lat, lon)
    local latitude = tonumber(lat)
    local longitude = tonumber(lon)
    if latitude == nil or longitude == nil then
        native.showAlert("Invalid Coordinates", "Latitude and longitude must be numbers.")
        return false
    elseif latitude < -90 or latitude > 90 then
        native.showAlert("Invalid Latitude", "Latitude must be between -90 and 90.")
        return false
    elseif longitude < -180 or longitude > 180 then
        native.showAlert("Invalid Longitude", "Longitude must be between -180 and 180.")
        return false
    else
        return true
    end
end

local function handleLocalButtonEvent( event )
    if( "ended" == event.phase ) then
        myData.longitude = myData.localLongitude
        myData.latitude = myData.localLatitude

        if latitudeInput ~= nil then
            latitudeInput:removeSelf()
        end
        if longitudeInput ~= nil then
            longitudeInput:removeSelf()
        end        
        composer.removeHidden()
        composer.removeScene("settings")
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })

    end
end

local function handleSaveButtonEvent( event )
    if ( "ended" == event.phase ) then
        local lat = latitudeInput.text
        local lon = longitudeInput.text
        if verifyInput(lat, lon) then
            myData.latitude = lat
            myData.longitude = lon

            if latitudeInput ~= nil then
                latitudeInput:removeSelf()
            end
            if longitudeInput ~= nil then
                longitudeInput:removeSelf()
            end
            composer.removeHidden()
            composer.removeScene("settings")
            composer.gotoScene("menu", { effect = "crossFade", time = 333 })
        end
    end
end
--
-- Start the composer event handlers
--
function scene:create( event )
    local sceneGroup = self.view

    params = event.params
        
    --
    -- setup a page background, really not that important though composer
    -- crashes out if there isn't a display object in the view.
    --
    local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert( background )

    local title = display.newText("Settings", 100, 32, native.systemFontBold, 32 )
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local cityLegend = display.newText("Enter coordinates", 100, 24, native.systemFontBold, 20)
    cityLegend.x = display.contentCenterX
    cityLegend.y = display.contentHeight * .2
    cityLegend:setFillColor( 0 )
    sceneGroup:insert( cityLegend )

    local latLegend = display.newText("Latitude", 100, 18, native.systemFontBold, 18)
    latLegend.x = display.contentCenterX
    latLegend.y = display.contentHeight * .25
    latLegend:setFillColor( 0 )
    sceneGroup:insert( latLegend )

    latitudeInput = native.newTextField(display.contentCenterX, display.contentHeight * .3, 180, 32)
    sceneGroup:insert( latitudeInput )

    local lonLegend = display.newText("Longitude", 100, 18, native.systemFontBold, 18)
    lonLegend.x = display.contentCenterX
    lonLegend.y = display.contentHeight * .35
    lonLegend:setFillColor( 0 )
    sceneGroup:insert( lonLegend )

    longitudeInput = native.newTextField(display.contentCenterX, display.contentHeight * .4, 180, 32)
    sceneGroup:insert( longitudeInput )

    local menuButton = widget.newButton({
        id = "button1",
        label = "Back",
        width = 100,
        height = 32,
        onEvent = handleMenuButtonEvent
    })
    menuButton.x = display.contentCenterX
    menuButton.y = display.contentHeight * .9
    sceneGroup:insert( menuButton )

    local saveButton = widget.newButton({
        id = "button2",
        label = "Get Weather",
        width = 160,
        height = 32,
        onEvent = handleSaveButtonEvent
    })
    saveButton.x = display.contentCenterX
    saveButton.y = display.contentHeight * .5
    sceneGroup:insert( saveButton )

    local localButton = widget.newButton({
        id = "button3",
        label = "Get Local Weather",
        width = 160,
        height = 32,
        onEvent = handleLocalButtonEvent
    })
    localButton.x = display.contentCenterX
    localButton.y = display.contentHeight * .7
    sceneGroup:insert( localButton )
end

function scene:show( event )
    local sceneGroup = self.view

    params = event.params

    if event.phase == "did" then
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
        if latitudeInput ~= nil then
            latitudeInput:removeSelf()
        end
        if longitudeInput ~= nil then
            longitudeInput:removeSelf()
        end
        composer.removeHidden()
        composer.removeScene("settings")
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
