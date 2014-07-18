--------------------------------------------------------------------------------
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2012 Corona Labs Inc. All Rights Reserved.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- The name of the ad provider.
-- Corona uses this value to construct the name of the plugin. Corona then asks
-- Lua to load a module with this name: "CoronaProvider.ads." .. provider
local provider = "myAdsProvider"

local appID = "myProviderSpecificApplicationID"

-- Load Corona 'ads' library
local ads = require "ads"

--------------------------------------------------------------------------------
-- Setup ad provider
--------------------------------------------------------------------------------

-- Create a text object to display ad status
local statusText = display.newRetinaText( "", 0, 0, native.systemFontBold, 22 )
statusText:setTextColor( 255 )
statusText:setReferencePoint( display.CenterReferencePoint )
statusText.x, statusText.y = display.contentWidth * 0.5, 160

-- Set up ad listener.
local function adListener( event )
	-- event table includes:
	-- 		event.provider
	--		event.isError (e.g. true/false )
	
	if event.isError then
		statusText:setTextColor( 255, 0, 0 )
		statusText.text = "Error Loading Ad"
		statusText.x = display.contentWidth * 0.5
	else
		statusText:setTextColor( 0, 255, 0 )
		statusText.text = "Successfully Loaded Ad"
		statusText.x = display.contentWidth * 0.5
	end
end

-- Initialize the 'ads' library with the provider you wish to use.
if appID then
	ads.init( provider, appID, adListener )
end

--------------------------------------------------------------------------------
-- UI
--------------------------------------------------------------------------------

-- initial variables
local sysModel = system.getInfo("model")
local sysEnv = system.getInfo("environment")

-- create a background for the app
local backgroundImg = display.newImageRect( "space.png", display.contentWidth, display.contentHeight )
backgroundImg:setReferencePoint( display.TopLeftReferencePoint )
backgroundImg.x, backgroundImg.y = 0, 0
statusText:toFront()

-- Shows a specific type of ad
local showAd = function( adType )
	local adX, adY = 0, 0
	statusText.text = ""
	ads.show( adType, { x=adX, y=adY, interval=60, testMode=true } )
end

-- if on simulator, let user know they must build for device
if sysEnv == "simulator" then
	local font, size = native.systemFontBold, 22
	local warningText = display.newRetinaText( "Please build for device or Xcode simulator to test this sample.", 0, 0, 290, 300, font, size )
	warningText:setTextColor( 255 )
	warningText:setReferencePoint( display.CenterReferencePoint )
	warningText.x, warningText.y = display.contentWidth * 0.5, display.contentHeight * 0.5
else
	-- start with banner ad
	showAd( "banner" )
end
