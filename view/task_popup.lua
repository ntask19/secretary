--[[
@
@ Project  : SpaceSecretary
@
@ Filename : task_popup.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 
@
]]--
local tasklist_model = require('tasklist_model')
local task_model = require('task_model')
local task = task_model.new()
local tasklist = tasklist_model.new()

module( ..., package.seeall )

function createTask()
	local taskContents = ""

	local createGroup = display.newGroup()
	local popupBackground = display.newRect( createGroup, 0, 0, _W, _H )
	popupBackground:setFillColor( 0 )
	popupBackground.alpha = 0.8
	popupBackground:addEventListener( "tap", returnTrue )
	popupBackground:addEventListener( "touch", returnTrue )

	local createTaskText = display.newText( createGroup, "ADD TASK", 0, 100, nil, 36 )
	createTaskText.x = _W*0.5

	local popup = display.newRect( createGroup, 0, 0, 500, 400 )
	popup.x, popup.y = _W*0.5, _H*0.3

	local popupCloseBtn = display.newRect( createGroup, 0, _H*0.3+100, 150, 80 )
	popupCloseBtn.x = _W*0.5-100
	colorScheme.Func( 'tsBlue', popupCloseBtn )
	popupCloseBtn:addEventListener( "tap", function() display.remove( createGroup ); createGroup = nil; end )

	local popupCompleteBtn = display.newRect( createGroup, 0, _H*0.3+100, 150, 80 )
	popupCompleteBtn.x = _W*0.5+100
	colorScheme.Func( 'tsRed', popupCompleteBtn )
	popupCompleteBtn:addEventListener( "tap", function() task.addTask( taskContents, os.date( "%Y-%m-%d %H:%M:%S" ) ); local tasklistData = tasklist.getList(); display.remove( createGroup ); createGroup = nil;  end )

	local function popupTextFieldListener( event )
	    if event.phase == "began" then

	    elseif event.phase == "ended" then
	    	taskContents = event.target.text
	    	print( taskContents )

	    elseif event.phase == "editing" then
	    	taskContents = event.text
	    	print( taskContents )

	    end
	end
	
	local popupTextField = native.newTextBox( _W*0.5-200, _H*0.3-180, 400, 250 )
	popupTextField.isEditable = true
	popupTextField:addEventListener( "userInput", popupTextFieldListener )
	popupTextField.hasBackground = false
	createGroup:insert( popupTextField )
	native.setKeyboardFocus( popupTextField )

	local fakePopupTextField = display.newRect( createGroup, _W*0.5-200, _H*0.3-180, 400, 250 )
	colorScheme.Func( 'tsYellow', fakePopupTextField )
	fakePopupTextField.alpha = 0.3

end

function editTask( task )
	local taskContents = task

	local createGroup = display.newGroup()
	local popupBackground = display.newRect( createGroup, 0, 0, _W, _H )
	popupBackground:setFillColor( 0 )
	popupBackground.alpha = 0.8
	popupBackground:addEventListener( "tap", returnTrue )
	popupBackground:addEventListener( "touch", returnTrue )

	local createTaskText = display.newText( createGroup, "EDIT TASK", 0, 100, nil, 36 )
	createTaskText.x = _W*0.5

	local popup = display.newRect( createGroup, 0, 0, 500, 400 )
	popup.x, popup.y = _W*0.5, _H*0.3

	local popupCloseBtn = display.newRect( createGroup, 0, _H*0.3+100, 150, 80 )
	popupCloseBtn.x = _W*0.5-100
	colorScheme.Func( 'tsBlue', popupCloseBtn )
	popupCloseBtn:addEventListener( "tap", function() display.remove( createGroup ); createGroup = nil; end )

	local popupCompleteBtn = display.newRect( createGroup, 0, _H*0.3+100, 150, 80 )
	popupCompleteBtn.x = _W*0.5+100
	colorScheme.Func( 'tsRed', popupCompleteBtn )
	popupCompleteBtn:addEventListener( "tap", function()  end )

	local function popupTextFieldListener( event )
	    if event.phase == "began" then

	    elseif event.phase == "ended" then
	    	taskContents = event.target.text
	    	print( taskContents )

	    elseif event.phase == "editing" then
	    	taskContents = event.text
	    	print( taskContents )

	    end
	end
	
	local popupTextField = native.newTextBox( _W*0.5-200, _H*0.3-180, 400, 250 )
	popupTextField.isEditable = true
	popupTextField:addEventListener( "userInput", popupTextFieldListener )
	popupTextField.hasBackground = false
	popupTextField.text = taskContents
	createGroup:insert( popupTextField )
	native.setKeyboardFocus( popupTextField )

	local fakePopupTextField = display.newRect( createGroup, _W*0.5-200, _H*0.3-180, 400, 250 )
	colorScheme.Func( 'tsYellow', fakePopupTextField )
	fakePopupTextField.alpha = 0.3

end