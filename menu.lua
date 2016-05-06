local composer = require( "composer" )
local scene = composer.newScene()

local widget = require( "widget" )
local utility = require( "utility" )
local myData = require( "mydata" )
local json = require( "json" )

local params

local cityName
local humidity
local windSpeed
local currentTemp
local description

local displayWeather
local makeRequest

local locationHandler = function(event)
    Runtime:removeEventListener("location", locationHandler)
    if(event.errorCode) then
        print(tostring(event.errorMessage))
    else
        local latText = string.format('%.2f', event.latitude)
        local lonText = string.format('%.2f', event.longitude)
        myData.latitude = latText
        myData.longitude = lonText
        myData.localLatitude = latText
        myData.localLongitude = lonText
        makeRequest()
    end
end

makeRequest = function()
    local requestString = "http://api.openweathermap.org/data/2.5/weather?lat=" .. myData.latitude .. "&lon=" .. myData.longitude .. "&units=imperial&APPID=" .. myData.key
    network.request(requestString, "GET", displayWeather)
end

displayWeather = function(event)
    if not event.isError then
        local response = json.decode(event.response)
        --print(response.name)
        cityName.text = response.name
        description.text = response.weather[1].main
        currentTemp.text = response.main.temp .. " F"
        humidity.text = response.main.humidity .. "%"
        windSpeed.text = response.wind.speed .. " mph"
        --utility.print_r(response.weather[1].description)
    else
        print("error")
    end
end

local function handleSettingsButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene("menu")
        composer.gotoScene("settings", { effect = "crossFade", time = 333 })
    end
end

local function handlePostButtonEvent( event )
    if ( "ended" == event.phase ) then
        composer.removeScene("menu")
        composer.gotoScene("post", { effect = "crossFade", time = 333 })
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

    local title = display.newText("Weather App", 100, 32, native.systemFontBold, 32 )
    title.x = display.contentCenterX
    title.y = 40
    title:setFillColor( 0 )
    sceneGroup:insert( title )

    cityName = display.newText("--", 100, 24, native.systemFontBold, 24)
    cityName.x = display.contentCenterX
    cityName.y = display.contentHeight * .3
    cityName:setFillColor( 0 )
    sceneGroup:insert( cityName )

    local legendCurrentTemp = display.newText("Current Temp:", 100, 18, native.systemFontBold, 18)
    legendCurrentTemp.x = display.contentWidth * .3
    legendCurrentTemp.y = display.contentHeight * .45
    legendCurrentTemp:setFillColor(0)
    sceneGroup:insert(legendCurrentTemp)

    currentTemp = display.newText("--", 100, 18, native.systemFontBold, 18)
    currentTemp.x = display.contentWidth * .7
    currentTemp.y = display.contentHeight * .45
    currentTemp:setFillColor( 0 )
    sceneGroup:insert( currentTemp )

    description = display.newText("--", 100, 18, native.systemFontBold, 18)
    description.x = display.contentWidth * .5
    description.y = display.contentHeight * .4
    description:setFillColor( 0 )
    sceneGroup:insert( description )

    local legendHumidity = display.newText("Humidity:", 100, 18, native.systemFontBold, 18)
    legendHumidity.x = display.contentWidth * .3
    legendHumidity.y = display.contentHeight * .5
    legendHumidity:setFillColor(0)
    sceneGroup:insert(legendHumidity)

    humidity = display.newText("--", 100, 18, native.systemFontBold, 18)
    humidity.x = display.contentWidth * .7
    humidity.y = display.contentHeight * .5
    humidity:setFillColor( 0 )
    sceneGroup:insert( humidity )

    local legendWindSpeed = display.newText("Wind Speed:", 100, 18, native.systemFontBold, 18)
    legendWindSpeed.x = display.contentWidth * .3
    legendWindSpeed.y = display.contentHeight * .55
    legendWindSpeed:setFillColor(0)
    sceneGroup:insert(legendWindSpeed)

    windSpeed = display.newText("--", 100, 18, native.systemFontBold, 18)
    windSpeed.x = display.contentWidth * .7
    windSpeed.y = display.contentHeight * .55
    windSpeed:setFillColor( 0 )
    sceneGroup:insert( windSpeed )

    -- Create the widget
    local settingsButton = widget.newButton({
        id = "button1",
        label = "Location Settings",
        width = 140,
        height = 32,
        onEvent = handleSettingsButtonEvent
    })
    settingsButton.x = display.contentCenterX
    settingsButton.y = display.contentHeight * .8
    sceneGroup:insert( settingsButton )

    local settingsButton = widget.newButton({
        id = "button2",
        label = "Post",
        width = 140,
        height = 32,
        onEvent = handlePostButtonEvent
    })
    settingsButton.x = display.contentCenterX
    settingsButton.y = display.contentHeight * .9
    sceneGroup:insert( settingsButton )
end

function scene:show( event )
    local sceneGroup = self.view
    params = event.params

    if event.phase == "did" and cityName.text == "--" then
        makeRequest()
    end
end

function scene:hide( event )
    local sceneGroup = self.view
    
    if event.phase == "will" then
    end

end

function scene:destroy( event )
    local sceneGroup = self.view
    Runtime:removeEventListener("location", locationHandler)
end

if myData.latitude == 0 and myData.longitude == 0 then
    Runtime:addEventListener("location", locationHandler)
end
---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene
