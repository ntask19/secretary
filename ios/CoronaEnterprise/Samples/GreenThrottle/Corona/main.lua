-- Abstract: Pong sample project
--
-- Demonstrates multitouch and draggable phyics objects 
--
-- Main -- final version
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- History
--  1.0		10/16/12		Initial version
-------------------------------------------------------------------------------------
local physics = require("physics")
physics.start()
physics.setGravity( 0, 0 ) -- no gravity in any direction

local greenthrottle = require('plugin.greenthrottle')

display.setStatusBar( display.HiddenStatusBar )

local popSound = audio.loadSound ("pop.wav")
local wallSound = audio.loadSound( "keyClick.wav" )
local missedSound = audio.loadSound( "downSFX.mp3" )

local _W = display.contentWidth
local _H = display.contentHeight

local radius = 15			-- radius of the ball
local paddleHeight = 65		-- height of the paddles
local velocity = 200		-- Determines speed of ball

-- Add background image and table net
local bkg = display.newImage( "paper_bkg.png", true )
bkg.x = display.contentCenterX
bkg.y = display.contentCenterY

local tableNet = display.newImage( "tableNet.png", true )
tableNet.x = display.contentCenterX
tableNet.y = display.contentCenterY

-- Create two paddles and place them on the screen
local paddle1 = display.newRect( 40, 20, 15, paddleHeight )
local paddle2 = display.newRect( 440, 20, 15, paddleHeight )

-- Create new ball in center of the table
local function newBall()
	ball = display.newImage( "puck_yellow.png" )
	ball.x = _W/2		-- center it
	ball.y = _H/2
	ball:scale( 0.2, 0.2 )

	physics.addBody( ball, { density = 0.3, friction = 0.6, radius = radius} )

	-- Initialize the ball movement at start of game
	-- TBD: add code to make starting direction random
	xVelocity = velocity
	yVelocity = 0

	ball:setLinearVelocity( xVelocity, yVelocity )


end

-- Remove the ball from the table
local function removeBall()
	ball:removeSelf()
end

newBall()		-- create new ball and start game

--transition.to( ball, {time = 1000, x = 440, y = 300} )

system.activate( "multitouch" )

-- A basic function for dragging paddle objects up and down
local function startDrag( event )
	local t = event.target
	local phase = event.phase
	
	if "began" == phase then
		display.getCurrentStage():setFocus( t, event.id )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif t.isFocus then
		if "moved" == phase then
			-- check to make sure the paddle stays on the screen
			if event.y - t.y0 > 20 and event.y - t.y0 < _H-20 then 
				t.y = event.y - t.y0
			end

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false

		end
	end

	-- Stop further propagation of touch event!
	return true
end

paddle1:addEventListener( "touch", startDrag ) -- make object draggable
paddle2:addEventListener( "touch", startDrag ) -- make object draggable

-- Make paddles a physics object and don't allow them to rotate
physics.addBody( paddle1, { density=0.3, friction=0.6 } )
paddle1.isFixedRotation = true
paddle1.isPlatform = true
paddle1.bodyType = "kinematic"

physics.addBody( paddle2, { density=0.3, friction=0.6 } )
paddle2.isFixedRotation = true
paddle2.isPlatform = true
paddle2.bodyType = "kinematic"

speedIncreasePerHit = 1.05

-- Collision listener paddles
local function paddleCollision( self, event )
	
	if( event.phase == "began" ) then
		
		-- Determine where the paddle hit the ball
		-- and use it to change the angle of the ball coming off the paddle
		local offset = self.y - event.other.y
		
		local totalSize = (radius + paddleHeight) / 2
		local percent
		
		if offset > 0 then
			percent = math.abs( offset / totalSize )
			xVelocity = xVelocity * -speedIncreasePerHit
			yVelocity = (velocity*percent) * -speedIncreasePerHit

		else
			percent = math.abs( offset / totalSize )
			xVelocity = xVelocity * -speedIncreasePerHit
			yVelocity = (velocity*percent) * speedIncreasePerHit

		end

		ball:setLinearVelocity( xVelocity, yVelocity )
		audio.play( popSound )
	end
	
	return true
end

-- Add the collision detectors
paddle1.collision = paddleCollision
paddle1:addEventListener( "collision", paddle1 )

paddle2.collision = paddleCollision
paddle2:addEventListener( "collision", paddle2 )

-- Create invisible sensor walls on both sides of table
local leftWall = display.newRect( 10, 0, 2, _H)
leftWall.isVisible = false
physics.addBody( leftWall )
leftWall.bodyType = "kinematic"
leftWall.myName = "leftWall"

local rightWall = display.newRect( 470, 0, 2, _H )
rightWall.isVisible = false
physics.addBody( rightWall )
rightWall.bodyType = "kinematic"
rightWall.myName = "rightWall"

-- Create invisible sensor walls on both sides of table
local topWall = display.newRect( 0, 0, _W, 2)
topWall.isVisible = false
physics.addBody( topWall )
topWall.bodyType = "kinematic"

local bottomWall = display.newRect( 0, _H-2, _W, 2 )
bottomWall.isVisible = false
physics.addBody( bottomWall )
bottomWall.bodyType = "kinematic"

-- Collision listener for top and bottom walls
local function topBottomCollision( self, event )
	
	if( event.phase == "began" ) then
	
		yVelocity = yVelocity * -1		-- reverse the Y direction
		ball:setLinearVelocity( xVelocity, yVelocity )
		audio.play( wallSound )
		
		return true
	end
end

topWall.collision = topBottomCollision
topWall:addEventListener( "collision", topWall )

bottomWall.collision = topBottomCollision
bottomWall:addEventListener( "collision", bottomWall )

-- Collision listener for side walls

local restartDelay =  2000		-- time (in milliseconds) to wait before restarting
local player1Score = 0
local player2Score = 0

local maxScore = 5			-- determines when the game is over

-- Add scoring text
local score1 = display.newText( "0", 140, 0, native.systemFontBold, 48 )
local score2 = display.newText( "0", 290, 0, native.systemFontBold, 48 )

local function sideCollision( self, event )

	-- Check for ball hitting left or right side and adjust score
	if ( event.phase == "began" ) then

		if self.myName == "leftWall" then
			player2Score = player2Score + 1
			score2.text = player2Score
		else
			player1Score = player1Score	+ 1
			score1.text = player1Score
		end

		audio.play( missedSound )

		-- remove ball after a short delay
		timer.performWithDelay( 33, removeBall )

		-- Check for game over
		if player1Score >= maxScore or player2Score >= maxScore then
			physics.pause()
			local gameOver = display.newText( "Game Over!", 0, 0, native.systemFontBold, 48 )
			gameOver:setTextColor( 255, 0, 0 )
			gameOver.x = _W/2
			gameOver.y = _H/2
		else
			timer.performWithDelay( restartDelay, newBall )
		end

	end

	return true

end

leftWall.collision = sideCollision
leftWall:addEventListener( "collision", leftWall )

rightWall.collision = sideCollision
rightWall:addEventListener( "collision", rightWall )


moveSpeed = 5

function movePaddle(paddle, controller)
	if(greenthrottle.getConnectedState(controller) == false or paddle == nil) then
		return
	end

	if(greenthrottle.getButtonState(greenthrottle.BUTTON_STATE_HELD, controller, greenthrottle.BUTTON_DOWN)) then
		paddle.y = paddle.y + moveSpeed
		if(paddle.y > (_H-20))then
			paddlel.y = _H-20 
		end
	elseif(greenthrottle.getButtonState(greenthrottle.BUTTON_STATE_HELD, controller, greenthrottle.BUTTON_UP)) then
		paddle.y = paddle.y - moveSpeed
		if(paddle.y < (20))then
			paddle.y = 20
		end
	end
end

function onFrame()
	greenthrottle.startFrame()

	movePaddle(paddle1, greenthrottle.CONTROLLER_1)
	movePaddle(paddle2, greenthrottle.CONTROLLER_2)
end

Runtime:addEventListener("enterFrame", onFrame)
