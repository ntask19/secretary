-- tasklist_view
-- 

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
	scrollView = widget.newScrollView({
		id = 1,
		top = 0,
		height = _H*0.5,
		width = _W,
		scrollHeight = 700,
		scrollWidth = _W,	    
		listener = scrollViewListener,
		hideBackground = true,
		hideScrollBar = true
	})
	group:insert(scrollView)

	if #data == 0 then
		local non_tasks = display.newText(scrollView, "今日のタスクはないよ", 0, 0, nil, 34)
		non_tasks:setFillColor( 80 )
	else
		for k, v in pairs(data) do
			plprint( v )
			local title = display.newText(scrollView, v.title, 0, k*50 + 10, nil, 30)
			title:setFillColor( 80 )

			local date = display.newText(scrollView, v.create_date, 0, k*50 + 10, nil, 30)
			date:setFillColor( 80 )
		end
	end

	return group
end