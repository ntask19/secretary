--[[
@
@ Project  : SpaceSecretary
@
@ Filename : tasklist_view.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : タスクのリストを表示
@
]]--
local task_popup = require( viewDir .. 'task_popup' )
local task_model = require('task_model')
local task = task_model.new()

module(..., package.seeall)

local custome = {
	width = _W,
	height = _H*0.5
}

-- チェックボックスを変化させる
local function checkTasks( isChecked, obj1, obj2 )
	if isChecked == 0 then
		obj1.alpha = 1
		obj2.alpha = 0
		obj1:toFront()
	else
		obj1.alpha = 0
		obj2.alpha = 1
		obj2:toFront()
	end
end


function show(data, option)
	local group = display.newGroup()
	if scrollView ~= nil then
		display.remove( scrollView )
		scrollView = nil
	end


	local status = option or custome
	local height = status.height or 100
	local width  = status.width or _W

	local function scrollViewListener( event )
		local s = event.target    -- reference to scrollView object
		print( event.type )
		
		if event.type == "movingToBottomLimit" then
		end
	end

	--スペース一覧を入れるためのスクロール
	scrollView = widget.newScrollView(
		{
			id = 1,
			top = _H*0.5,
			left = 0,
			height = _H*0.5,
			width = _W,
			scrollHeight = _H*0.5,
			scrollWidth = _W,	    
			listener = scrollViewListener,
			horizontalScrollDisabled = true,
			hideBackground = true,
			hideScrollBar = true
		}
	)
	group:insert(scrollView)

	local taskCellGroup = display.newGroup()
	scrollView:insert( taskCellGroup )
	print( data )
	if #data == 0 or data[1]['tasks'] == nil then
		local non_tasks = display.newText(taskCellGroup, "今日のタスクはないよ", 100, _H*0.5, nil, 34)
		colorScheme.Func('tsBlack', non_tasks)
	else
		local taskCount = 1
	
		for key = 1, #data do
			local value = data[key]

			if key == 1 then
				_datetime = value.date
			end

			for k = 1, #value['tasks'] do
				local v = value['tasks'][k]
				print( k, v )

				local checkedBtn, unCheckedBtn

				checkedBtn = btn.newRect( 
					{
						group = taskCellGroup, 
						x = 40, 
						y = taskCount*100+100, 
						width = 60, 
						height = 60, 
						round = 10,
						str = '',
						action = function()
							if v.is_checked == 0 then
								v.is_checked = 1
								task.completed( v.id )
								checkTasks( 1, checkedBtn, unCheckedBtn )
							end
						end
					}
				)

				unCheckedBtn = btn.newRect( 
					{
						group = taskCellGroup, 
						x = 40, 
						y = taskCount*100+100, 
						width = 60, 
						height = 60, 
						round = 10,
						str = '',
						color = {255, 0, 0},
						action = function()
							if v.is_checked == 1 then
								v.is_checked = 0
								task.notYet( v.id )
								checkTasks( 0, checkedBtn, unCheckedBtn )
							end
						end
					}
				)
				checkTasks( v.is_checked, checkedBtn, unCheckedBtn )

				local taskBackground = display.newRect( taskCellGroup, 100, taskCount*100+100, _W-200, 80 )
				colorScheme.Func( 'tsGreen', taskBackground )
				taskBackground.alpha = 0.5

				local taskTitle = display.newText(taskCellGroup, v.title, _W*0.5, taskCount*100+100, nil, 30)
				colorScheme.Func( 'tsBlack', taskTitle )

				local date = display.newText(taskCellGroup, datetime_cast( v.datetime ), 150, taskCount*100+100, nil, 30)
				colorScheme.Func( 'tsBlack', date )
				taskCount = taskCount + 1

				taskBackground:addEventListener( "tap", function() task_popup.editTask( v.id, v.title ); print( v.id, v.title ) end )
			end

		end

		local taskListBackground = display.newRect( group, 50, _H*0.5, _W-100, 80 )
		colorScheme.Func( 'tsGreen', taskListBackground )


		local datetime = os.date( "%Y-%m-%d %H:%M:%S" ) or '2014-01-01 00:00:00'
		local dateTitle = display.newText(group, date_cast( datetime ), _W*0.5, _H*0.5, nil, 30)
		colorScheme.Func( 'tsBlack', dateTitle )

	end

	return group
end

function showList(data, option)
	local group = display.newGroup()

	local background = display.newRect(group, 0, 0, _W, _H)
	background:addEventListener( 'tap', returnTrue )
	background:addEventListener( 'touch', returnTrue )

	local background = display.newRect(group, 0, 0, _W, _H)
	colorScheme.Func( 'tsYellow', background )
	background.alpha = 0.5


	local backBtn = display.newRect(group, _W-90, 60, 80, 80)
	colorScheme.Func( 'tsRed', backBtn )
	backBtn:addEventListener( "tap", 
		function()
			display.remove(group)
			group = nil
			local now = _nowPage
			now = 'home'
			print( _nowPage )
			homeReplace( now )
			print( _nowPage )
			return true
		end
	)
	local backBtnText = display.newText( group, "Exit", 0, 0, nil, 36 )
	backBtnText.x, backBtnText.y = backBtn.x, backBtn.y

	local status = option or custome
	local height = status.height or 100
	local width  = status.width or _W

	local function scrollViewListener( event )
		local s = event.target    -- reference to scrollView object
		
		if event.type == "movingToBottomLimit" then
		end
	end

	--スペース一覧を入れるためのスクロール
	scrollView = widget.newScrollView(
		{
			id = 1,
			top = 100,
			left = 0,
			height = _H,
			width = _W,
			scrollHeight = _H*0.5,
			scrollWidth = _W,	    
			listener = scrollViewListener,
			horizontalScrollDisabled = true,
			hideBackground = true,
			hideScrollBar = true
		}
	)
	group:insert(scrollView)

	local taskCellGroup = display.newGroup()
	scrollView:insert( taskCellGroup )
	if #data == 0 then
		local non_tasks = display.newText(taskCellGroup, "今日のタスクはないよ", 100, 100, nil, 34)
		colorScheme.Func('tsBlack', non_tasks)
	else
		local taskCount = 1
		
		for key = 1, #data do
			local value = data[key]
			print( key, value )

			local taskListBackground = display.newRect( taskCellGroup, 50, (taskCount-1)*100+40, _W-100, 80 )
			colorScheme.Func( 'tsGreen', taskListBackground )

			local datetime = value.date or '2014-01-01 00:00:00'
			local dateTitle = display.newText(taskCellGroup, date_cast( datetime ), 100, (taskCount-1)*100+40, nil, 30)
			colorScheme.Func( 'tsBlack', dateTitle )

			if value ~= nil and value['tasks'] ~= nil then
				for k = 1, #value['tasks'] do
					local v = value['tasks'][k]
					print( k, v )

					local checkedBtn, unCheckedBtn

					checkedBtn = btn.newRect( 
						{
							group = taskCellGroup, 
							x = 40, 
							y = (taskCount-1)*100+100+40, 
							width = 60, 
							height = 60, 
							round = 10,
							str = '',
							action = function()
								if v.is_checked == 0 then
									v.is_checked = 1
									task.completed( v.id )
									checkTasks( 1, checkedBtn, unCheckedBtn )
								end
							end
						}
					)

					unCheckedBtn = btn.newRect( 
						{
							group = taskCellGroup, 
							x = 40, 
							y = (taskCount-1)*100+100+40, 
							width = 60, 
							height = 60, 
							round = 10,
							str = '',
							color = {255, 0, 0},
							action = function()
								if v.is_checked == 1 then
									v.is_checked = 0
									task.notYet( v.id )
									checkTasks( 0, checkedBtn, unCheckedBtn )
								end
							end
						}
					)
					checkTasks( v.is_checked, checkedBtn, unCheckedBtn )

					local taskBackground = display.newRect( taskCellGroup, 100, (taskCount-1)*100+100+40, _W-200, 80 )
					colorScheme.Func( 'tsGreen', taskBackground )
					taskBackground.alpha = 0.8

					local taskTitle = display.newText(taskCellGroup, v.title, _W*0.5, (taskCount-1)*100+100+40, nil, 30)
					colorScheme.Func( 'tsBlack', taskTitle )

					local date = display.newText(taskCellGroup, datetime_cast( v.datetime ), 100, (taskCount-1)*100+100+40, nil, 30)
					colorScheme.Func( 'tsBlack', date )
					taskCount = taskCount + 1

					taskBackground:addEventListener( "tap", function() task_popup.editTask( v.id, v.title ) end )
				end
				taskCount = taskCount + 1
			else

			end


		end

	end

	return group
end