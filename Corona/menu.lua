module(..., package.seeall)

local function Listener()
	local func = {}
	local group

	-- ページを生成
	--
	--
	function func.show()
		
		group = display.newGroup()

		--スクロール
		local scrollView = widget.newScrollView({
			top = 380,
			height = _H,
			width = _W,
			scrollHeight = _H,
			scrollWidth = _W,
			listener = scrollViewListener,
			hideBackground = true,
			hideScrollBar = true,
			horizontalScrollDisabled = true 
		})

		local bg = display.newRect(group, 0, 330, _W, _H)

		-- ヘッダー
		local topBg = display.newImage(group, 'images/header.jpg', 0, 0)
		local title = display.newText(group, 'Connect', 0, 0, _family, 70)
		title.x = topBg.x; title.y = topBg.y-26

		--　main contents
		group:insert(scrollView)

		local underGroup = display.newGroup()
		scrollView:insert(underGroup)
		

		return group
	end


	return func
end


function new()
	local listener = Listener()

	return listener
end