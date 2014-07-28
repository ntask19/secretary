-- tasklist_view
-- 

module(..., package.seeall)

local custome = {
	width = _W,
	height = _H/2
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
	scrollView = widget.newScrollView({
		id = 1,
		top = 0,
		height = _H/2,
		width = _W,
		scrollHeight = 700,
		scrollWidth = _W+20,	    
		listener = scrollViewListener,
		hideBackground = true,
		hideScrollBar = true
	})
	group:insert(scrollView)

	if #data == 0 then
		local non_tasks = display.newText(scrollView, "今日のタスクはないよ", 0, 0, nil, 34)
		non_tasks:setTextColor( 80 )
	else
		for k, v in pairs(data) do
			local title = display.newText(scrollView, v.title, 30, k*50 + 10, nil, 30)
			title:setTextColor( 80 )

			local date = display.newText(scrollView, v.create_date, 120, k*50 + 10, nil, 30)
			date:setTextColor( 80 )
		end
	end

	return group
end