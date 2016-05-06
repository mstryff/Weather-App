local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local json = require( "json" )


local params
local postInput
local response

local function displayResponse(event)
    if not event.isError then
        local httpResponse = json.decode(event.response)
        response.text = httpResponse.args.string .. " " .. httpResponse.origin
    else
        print("error")
    end
end

local function handlePostButtonEvent( event )
    if ( "ended" == event.phase ) then
        local requestString = "http://httpbin.org/post?string=" .. postInput.text
        network.request(requestString, "POST", displayResponse)
    end
end

local function handleBackButtonEvent( event )
    if ( "ended" == event.phase ) then
        if postInput ~= nil then
            postInput:removeSelf()
        end
        composer.removeHidden()
        composer.removeScene("post")
        composer.gotoScene("menu", { effect = "crossFade", time = 333 })
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

    local title = display.newText("POST", 100, 32, native.systemFontBold, 32 )
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    local postLegend = display.newText("Enter a string", 100, 24, native.systemFontBold, 20)
    postLegend.x = display.contentCenterX
    postLegend.y = display.contentHeight * .2
    postLegend:setFillColor( 0 )
    sceneGroup:insert( postLegend )

    postInput = native.newTextField(display.contentCenterX, display.contentHeight * .3, 180, 32)
    sceneGroup:insert( postInput )

    local postButton = widget.newButton({
        id = "button1",
        label = "POST IT!",
        width = 160,
        height = 32,
        onEvent = handlePostButtonEvent
    })
    postButton.x = display.contentCenterX
    postButton.y = display.contentHeight * .4
    sceneGroup:insert( postButton )

    local responseLegend = display.newText("Response:", 100, 24, native.systemFontBold, 24)
    responseLegend.x = display.contentCenterX
    responseLegend.y = display.contentHeight * .5
    responseLegend:setFillColor( 0 )
    sceneGroup:insert( responseLegend )

    response = display.newText("--", 100, 24, native.systemFontBold, 20)
    response.x = display.contentCenterX
    response.y = display.contentHeight * .7
    response:setFillColor( 0 )
    sceneGroup:insert( response )

    local backButton = widget.newButton({
        id = "button2",
        label = "Back",
        width = 160,
        height = 32,
        onEvent = handleBackButtonEvent
    })
    backButton.x = display.contentCenterX
    backButton.y = display.contentHeight * .9
    sceneGroup:insert( backButton )
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
        if postInput ~= nil then
            postInput:removeSelf()
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
