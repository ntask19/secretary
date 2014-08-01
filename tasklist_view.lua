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

module(..., package.seeall)

local custome = {
	width = _W,
	height = _H*0.5
}


function show(data, option)
	local group = display.newGroup()

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
			top = 0,
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
	if #data == 0 or data['tasks'] == nil then
		local non_tasks = display.newText(taskCellGroup, "今日のタスクはないよ", _W*0.5, 100, nil, 34)
		non_tasks:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )
	else
		local taskCount = 1
	
		for key = 1, #data do
			local value = data[key]
			ssprint( key, value )
			ssprint(value)
			ssprint(value['tasks'])

			if key == 1 then
				_datetime = value.date
			end

			for k = 1, #value['tasks'] do
				local v = value['tasks'][k]
				ssprint( k, v )

				local taskBackground = display.newRect( taskCellGroup, _W*0.5, (taskCount-1)*100+100, _W-200, 80 )
				taskBackground:setFillColor( colorScheme.Func('tsGreen')[1], colorScheme.Func('tsGreen')[2], colorScheme.Func('tsGreen')[3] )
				taskBackground.alpha = 0.8

				local taskTitle = display.newText(taskCellGroup, v.title, _W*0.6, (taskCount-1)*100+100, nil, 30)
				taskTitle:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )

				local date = display.newText(taskCellGroup, datetime_cast( v.datetime ), _W*0.5-150, (taskCount-1)*100+100, nil, 30)
				date:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )
				taskCount = taskCount + 1
			end

		end

		local taskListBackground = display.newRect( group, _W*0.5, -40, _W-100, 80 )
		taskListBackground:setFillColor( colorScheme.Func('tsGreen')[1], colorScheme.Func('tsGreen')[2], colorScheme.Func('tsGreen')[3] )

		local datetime = _datetime or '2014-01-01 00:00:00'
		local dateTitle = display.newText(group, date_cast( datetime ), _W*0.5, -40, nil, 30)
		dateTitle:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )

	end

	return group
end

function showList(data, option)
	local group = display.newGroup()

	local background = display.newRect(group, _W*0.5, _H*0.5, _W, _H)
	background:setFillColor( colorScheme.Func(0)[1], colorScheme.Func(0)[2], colorScheme.Func(0)[3] )

	local background = display.newRect(group, _W*0.5, _H*0.5, _W, _H)
	background:setFillColor( colorScheme.Func('tsYellow')[1], colorScheme.Func('tsYellow')[2], colorScheme.Func('tsYellow')[3] )
	background.alpha = 0.5


	local backBtn = display.newRect(group, _W-60, 60, 80, 80)
	backBtn:setFillColor( colorScheme.Func('tsRed')[1], colorScheme.Func('tsRed')[2], colorScheme.Func('tsRed')[3] )
	backBtn:addEventListener( "tap", function() display.remove(group); group = nil  end )

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
		local non_tasks = display.newText(taskCellGroup, "今日のタスクはないよ", 0, 0, nil, 34)
		non_tasks:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )
	else
		local taskCount = 1
		
		for key = 1, #data do
			local value = data[key]
			ssprint( key, value )

			local taskListBackground = display.newRect( taskCellGroup, _W*0.5, (taskCount-1)*100+40, _W-100, 80 )
			taskListBackground:setFillColor( colorScheme.Func('tsGreen')[1], colorScheme.Func('tsGreen')[2], colorScheme.Func('tsGreen')[3] )

			local datetime = value.date or '2014-01-01 00:00:00'
			local dateTitle = display.newText(taskCellGroup, date_cast( datetime ), _W*0.5, (taskCount-1)*100+40, nil, 30)
			dateTitle:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )

			if value ~= nil and value['tasks'] ~= nil then
				for k = 1, #value['tasks'] do
					local v = value['tasks'][k]
					ssprint( k, v )

					local taskBackground = display.newRect( taskCellGroup, _W*0.5, (taskCount-1)*100+100+40, _W-200, 80 )
					taskBackground:setFillColor( colorScheme.Func('tsGreen')[1], colorScheme.Func('tsGreen')[2], colorScheme.Func('tsGreen')[3] )
					taskBackground.alpha = 0.8

					local taskTitle = display.newText(taskCellGroup, v.title, _W*0.6, (taskCount-1)*100+100+40, nil, 30)
					taskTitle:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )

					local date = display.newText(taskCellGroup, datetime_cast( v.datetime ), _W*0.5-150, (taskCount-1)*100+100+40, nil, 30)
					date:setFillColor( colorScheme.Func('tsBlack')[1], colorScheme.Func('tsBlack')[2], colorScheme.Func('tsBlack')[3] )
					taskCount = taskCount + 1
				end
				taskCount = taskCount + 1
			else

			end


		end

	end

	return group
end