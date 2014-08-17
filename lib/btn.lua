--[[
@
@ Project  : SpaceSecretary
@
@ Filename : btn.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 
@
]]--

-- 
-- *strokeWidth  線の太さ 1.5
-- *文字の色 0
-- *pushed
-- 画像あり　setFillcolor(180)
-- 画像なし　元のカラー×0.8
-- *timer 230
-- *fontsize 24
--------------------------------------------------
-- androidのバックボタンに対応させる
-- local backLibrary  = require(libDir.."backLibrary")
local btn = {}
-------------------------------------------------------
-- btn.newRect
--
-- 画像なしでボタンを作るパターン
--------------------------------------------------------

function btn.newRect(option)
	----------------------------------
	-- option.group    	   : 
	-- option.x        	   :
	-- option.y        	   :
	-- option.width    	   :
	-- option.height   	   :
	-- option.str      	   :
	-- option.font     	   :
	-- option.fontSize 	   :
	-- option.fontColor	   :
	-- option.color    	   :
	-- option.colorStroke  :	
	-- option.action       : 
	-- option.stroke       :
	-- option.edgeColor    :
	-- option.shadowColor  :
	----------------------------------
	local o = option
	local group = display.newGroup()

	local x = o.x
	local y = o.y

	--文字
	local fontSize = o.fontSize or 18
	local textColor = o.fontColor or 0
	local font = o.font or nil
	local str = o.str or "ボタン１"

	local text
	if o.strLine then -- 複数行の文字ボタン
		if o.strLine[3] ~= nil and o.strLine[4] ~= nil then
			text = display.newText(str, 0, 0, o.strLine[3], o.strLine[4],font, fontSize)
		else
			text = display.newText(str, 0, 0, font, fontSize)
		end
	else
		text = display.newText(str, 0, 0, font, fontSize)
	end

	if o.fontColor then
		text:setTextColor(o.fontColor[1],o.fontColor[2],o.fontColor[3], o.fontColor[4] or 255)
	else
		text:setTextColor(0)
	end

	--背景
	local width = o.width or text.width + 20
	local height = o.height or text.height + 20
	local rounded = o.rounded or 0

	local colorStroke = o.colorStroke or 255
	local pushedFontColor = o.pushedFontColor or 255

	--影をつける
	local edgeGroup = display.newGroup()
	group:insert(edgeGroup)

	local mainRect = display.newRoundedRect(0, 0, width, height, rounded)
	if o.colorStroke then
		mainRect:setStrokeColor(o.colorStroke[1] or 145,o.colorStroke[2] or 208,o.colorStroke[3] or 95,o.colorStroke[4] or 255)
		mainRect.strokeWidth = 1.5
	else
		--mainRect:setStrokeColor(230)
	end

	if o.edgeColor then
		--影をつける
		local function edge()
			mainRect:setStrokeColor(o.edgeColor[1], o.edgeColor[2], o.edgeColor[3], o.edgeColor[4] or 255)
			mainRect.strokeWidth = 1.5
			if o.edge ~= false then
				local edgeRect = display.newRoundedRect(0, 0, width, height+3, rounded)
				edgeRect:setFillColor(o.edgeColor[1], o.edgeColor[2], o.edgeColor[3], o.edgeColor[4] or 255)
				group:insert(edgeRect)
			end
		end
		edge()
	end
	if o.shadowColor then
		local edgeRect = display.newRoundedRect(0, 0, width, height+3, rounded)
		edgeRect:setFillColor(o.shadowColor[1], o.shadowColor[2], o.shadowColor[3], o.shadowColor[4] or 255)
		group:insert(edgeRect)
	end

	local color = o.color or 255
	local noPushedColor = {} -- push色が指定されていない場合
	if o.color then
		mainRect:setFillColor(o.color[1],o.color[2],o.color[3], o.color[4] or 255)
		if o.pushedColor == nil then
			if o.color[1] ~= nil then
				noPushedColor[1] = math.floor(o.color[1]*0.8)
			end
			if o.color[2] ~= nil then
				noPushedColor[2] = math.floor(o.color[2]*0.8)
			end
			if o.color[3] ~= nil then
				noPushedColor[3] = math.floor(o.color[3]*0.8)
			end
			if o.color[4] ~= nil then
				noPushedColor[4] = math.floor(o.color[4]*0.8)
			end
		end
	else
		mainRect:setFillColor(255)
		if o.pushedColor == nil then 
			noPushedColor = {math.floor(255*0.8),math.floor(255*0.8),math.floor(255*0.8),math.floor(255*0.8)}
		end
	end

	if o.strLine then
		text.x = o.strLine[1]
		text.y = o.strLine[2]
	else
		text.x = mainRect.width*0.5
		text.y = mainRect.height*0.5
	end
	if o.strPoint == "center" then
		text:setReferencePoint( display.CenterReferencePoint )
		text.x = mainRect.x
	end

	group:insert(mainRect)
	group:insert(text)

	-- ボタンを押し始めた状態
	local function beganBtn()
		if o.pushedColor then
			mainRect:setFillColor(o.pushedColor[1],o.pushedColor[2],o.pushedColor[3], o.pushedColor[4] or 255)
			if o.pushedFontColor then
				text:setTextColor(o.pushedFontColor[1], o.pushedFontColor[2], o.pushedFontColor[3], o.pushedFontColor[4] or 255)
			else
				text:setTextColor(255)
			end
			timer.performWithDelay(230, 
			    function()
					if pcall(function ()
							if mainRect then
								if o.color then
									mainRect:setFillColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
								else
									mainRect:setFillColor(255)
								end
								if o.fontColor then
									text:setTextColor(o.fontColor[1],o.fontColor[2],o.fontColor[3], o.fontColor[4] or 255)
								else
									text:setTextColor(0)
								end
							else
								display.remove(mainRect)
								mainRect = nil
							end
						end) then
					else
						tsprint("btn.lua: btn.newRect()  pcall        exception handling")
						display.remove(mainRect)
						mainRect = nil
					end	

				-- if mainRect then
				-- 	if o.color then
				-- 		mainRect:setFillColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
				-- 	else
				-- 		mainRect:setFillColor(255)
				-- 	end
				-- 	if o.fontColor then
				-- 		text:setTextColor(o.fontColor[1],o.fontColor[2],o.fontColor[3], o.fontColor[4] or 255)
				-- 	else
				-- 		text:setTextColor(0)
				-- 	end
				-- end	
				end
			)
		else
			mainRect:setFillColor(noPushedColor[1], noPushedColor[2], noPushedColor[3], noPushedColor[4] or 255)
			timer.performWithDelay(230, 
				function()
					-- if o.color then
					-- 	mainRect:setFillColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
					-- else
					-- 	mainRect:setFillColor(255)
					-- end
					if pcall(function ()
						if o.color then
							mainRect:setFillColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
						else
							mainRect:setFillColor(255)
						end
						end) then
					else
						tsprint("btn.lua: btn.newRect()  pcall        exception handling")
						display.remove(mainRect)
						mainRect = nil
					end
				end
			)
		end
	end
	-- ボタンを離した状態
	local function endedBtn()
		if o.pushedColor then
			if o.color then
				mainRect:setFillColor(o.color[1],o.color[2],o.color[3], o.color[4] or 255)
			else
				mainRect:setFillColor(255)
			end					
			if o.fontColor then
				text:setTextColor(o.fontColor[1],o.fontColor[2],o.fontColor[3], o.fontColor[4] or 255)
			else
				text:setTextColor(0)
			end
		else
			-- 	mainRect.alpha = 1.0
			if o.color then
				mainRect:setFillColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
			end
		end
	end

	if o.filter ~= nil then
		local filter = display.newRect(group,o.filter[1] or mainRect.x,o.filter[2] or mainRect.y,o.filter[3] or mainRect.width, o.filter[4] or mainRect.height)
		filter.alpha = _G["btnAlpha"]
		filter:addEventListener("touch",
			function(event)
				if event.phase == "began" then
					beganBtn()
				else
					endedBtn()
				end	
			end
		)
		if o.action then
			filter:addEventListener("tap", o.action)
		end
	else
		mainRect:addEventListener("touch",
			function(event)
				if event.phase == "began" then
					beganBtn()
				else
					endedBtn()
				end	
			end
		)
		if o.action then
			mainRect:addEventListener("tap", o.action)
		end
	end

	group.x = o.x
	group.y = o.y

	if o.group then
		o.group:insert(group)
		o.group:insert(edgeGroup)
	end

	return group
end

-------------------------------------------------------
-- btn.newPushImage
--
-- ボタンを押している状態に画像を変化させる
--------------------------------------------------------
function btn.newPushImage(option)
	----------------------------------
	-- option.group    	   : 
	-- option.image    	   :
	-- option.str          :
	-- option.x        	   :
	-- option.y        	   :
	-- option.fillter      :
	-- option.action       : 
	----------------------------------
	local o = option
	local group = display.newGroup()

	--local action = option.action or nil
	local dir = o.dir or system.ResourceDirectory

	local image = display.newImage(group, o.image, dir, o.x or 0, o.y or 0 )
	image.alpha = 1.0

	local focusW, focusH = nil, nil
	if o.focusX then
		-- image:setReferencePoint( display.CenterReferencePoint )
		image.x = o.focusX
		focusW = o.focusX-image.width*0.5
	end
	if o.focusY then
		-- image:setReferencePoint( display.CenterReferencePoint )
		image.y = o.focusY
		focusH = o.focusY-image.height*0.5
	end

	if o.str ~= nil then
		local text = display.newText(group,o.str, 0, 0, o.font or native.systemFont, o.fontSize or 25)
		if o.strX ~= nil then
			text.x =  o.strX
		else
			text.x = image.x
		end

		if o.strY ~= nil then
			text.y =  o.strY
		else
			text.y = image.y
		end
		-- text.x, text.y = image.x, image.y

		if o.fontColor then
			text:setTextColor(o.fontColor[1],o.fontColor[2],o.fontColor[3], o.fontColor[4] or 255)
		end

	end

	-- focusを設定した関係上必要な変数
	if focusW == nil then
		focusW = 0
	end
	if focusH == nil then
		focusH = 0
	end
	
	--ボタンを押すときの反応範囲
	local imageFilter
	if o.fillter ~= nil or o.filter ~= nil then
		if o.fillter ~= nil then
			imageFilter = display.newRect(group,o.fillter[1],o.fillter[2],o.fillter[3],o.fillter[4])
		elseif o.filter ~= nil then
			imageFilter = display.newRect(group,o.filter[1],o.filter[2],o.filter[3],o.filter[4])
		end
		imageFilter:setFillColor(255, 0, 0)
		imageFilter.alpha = _G["btnAlpha"]
	    imageFilter:addEventListener("touch",function(event)
			if event.phase == "began" then
				image:setFillColor(180)
				timer.performWithDelay( 230,
					function() 
						if pcall(function()
								if image then
									image:setFillColor(255) 
								else 
									display.remove( image )
									image = nil
								end
							end) then
						else
							display.remove( image )
							image = nil
						end
					end
				)

			end
			--return true
	    end)
	else
		imageFilter = display.newRect(group, -10+(o.x or focusW),-10+(o.y or focusH),image.width + 20, image.height + 20)
		imageFilter:setFillColor(255, 0, 0)
		imageFilter.alpha = _G["btnAlpha"]
	    imageFilter:addEventListener("touch",function(event)
			if event.phase == "began" then
				--image.alpha = 0.5
				image:setFillColor( 180 )
				timer.performWithDelay(230,
					function() 
						if pcall(function()
								if image then
									image:setFillColor(255) 
								else 
									display.remove( image )
									image = nil
								end
							end) then
						else
							display.remove( image )
							image = nil
						end
					end
				)
			end
			--return true
	    end)
	end

	imageFilter:addEventListener("tap",
		function()
			image:setFillColor(255)
			if o.action then o.action() end
			-- return true
		end
	)
	--group.x = o.x or 0
	--group.y = o.y or 0
	--[[
	if o.group then 
		o.group:insert(group)
	end
	--]]

	if o.group then
		o.group:insert(group)
	end

	return group
end

-------------------------------------------------------
-- btn.newImage1
--
-- 背景はボタン画像、その上に別画像を載せるパターン
--------------------------------------------------------

function btn.newImage(option)
	----------------------------------
	-- option.group    	   : 
	-- option.x        	   :
	-- option.y        	   :
	-- option.width    	   :
	-- option.height   	   :
	-- option.str      	   :
	-- option.font     	   :
	-- option.fontSize 	   :
	-- option.fontColor	   :
	-- option.color    	   :
	-- option.action       : 
	----------------------------------
	local o = option
	local group = display.newGroup()

	--ボタン背景部分のデザイン
	local normalImage, pushedImage
	if option.type == 1 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 2 then
		normalImage = "Btn/btn2.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 3 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 4 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	else
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	end


	local action = option.action or nil
	local group1 = display.newGroup()
	local btn = createObject(normalImage, nil, pushedImage, nil, 0, 0, group1, nil, action)
	group:insert(group1)

	if option.image then
		onImage = display.newImage(option.image, 0,0)
		onImage.x = btn.x
		onImage.y = btn.y
		group:insert(onImage)
	end

	group.x = o.x or 0
	group.y = o.y or 0

	if o.group then 
		o.group:insert(group)
	end

	return group
end

-------------------------------------------------------
-- btn.newImage1
--
-- 背景はボタン画像、その上に別画像を載せるパターン
--------------------------------------------------------

function btn.newImage1(option)
	----------------------------------
	-- option.group    	   : 
	-- option.x        	   :
	-- option.y        	   :
	-- option.width    	   :
	-- option.height   	   :
	-- option.str      	   :
	-- option.font     	   :
	-- option.fontSize 	   :
	-- option.fontColor	   :
	-- option.color    	   :
	-- option.action       : 
	----------------------------------
	local o = option
	local group = display.newGroup()

	--ボタン背景部分のデザイン
	local normalImage, pushedImage
	if option.type == 1 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 2 then
		normalImage = "Btn/btn2.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 3 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 4 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	else
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	end


	local action = option.action or nil
	local group1 = display.newGroup()
	local btn = createObject2(normalImage, nil, pushedImage, nil, 0, 0, o.width, o.height, group1, nil, action)
	group:insert(group1)

	if option.image then
		onImage = display.newImage(option.image, 0,0)
		onImage.x = btn.x
		onImage.y = btn.y
		group:insert(onImage)
	end

	group.x = o.x or 0
	group.y = o.y or 0

	if o.group then 
		o.group:insert(group)
	end

	return group
end

-------------------------------------------------------
-- btn.newImage2
--
-- 背景はボタン画像、その上に別画像を載せるパターン
--------------------------------------------------------

function btn.newImage2(option)
	----------------------------------
	-- option.group    	   : 
	-- option.x        	   :
	-- option.y        	   :
	-- option.width    	   :
	-- option.height   	   :
	-- option.str      	   :
	-- option.font     	   :
	-- option.fontSize 	   :
	-- option.fontColor	   :
	-- option.color    	   :
	-- option.action       : 
	----------------------------------
	local o = option
	local group = display.newGroup()

	local image  

	local check  = display.newImage(o.image, 0,0)
	local width  = o.width or check.width + 20
	local height = o.height or check.height + 20
	display.remove(check)
	check = nil

	local backRect = display.newRect(0, 0, width, height)
	backRect:setFillColor( 255,0,0, 100 )
	backRect.alpha = _G["btnAlpha"]
	backRect:addEventListener("touch", 
		function(event)
			if event.phase == "began" then
				image.alpha = 1.0
				timer.performWithDelay(230, 
					function() 
						--image.alpha = 0.3 
						image.alpha = 0.01 
					end
				)
			else
				--image.alpha  = 0.3
				image.alpha = 0.01
			end
		end
	)

	backRect:addEventListener("tap",
		function()
			image.alpha = 0.01
			if o.action then o.action() end
		end
	)

	image  = display.newImage(o.image, 0,0)
	--image.alpha = 0.3
	image.alpha = 0.01

	group:insert(backRect)
	group:insert(image)

	group.x = o.x or 0
	group.y = o.y or 0

	backRect.x = image.x
	backRect.y = backRect.y - 10

	if o.group then 
		o.group:insert(group)
	end

	return group
end

-------------------------------------------------------
-- btn.newImage1
--
-- 背景はボタン画像、その上に別画像を載せるパターン
--------------------------------------------------------

function btn.newImage3(option)
	----------------------------------
	-- option.group    	   : 
	-- option.x        	   :
	-- option.y        	   :
	-- option.width    	   :
	-- option.height   	   :
	-- option.str      	   :
	-- option.font     	   :
	-- option.fontSize 	   :
	-- option.fontColor	   :
	-- option.color    	   :
	-- option.action       : 
	----------------------------------
	local o = option
	local group = display.newGroup()

	--ボタン背景部分のデザイン
	local normalImage, pushedImage
	if option.type == 1 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 2 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 3 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	elseif option.type == 4 then
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	else
		normalImage = "Btn/btn1.png"
		pushedImage = "Btn/pushed1.png"
	end


	local action = option.action or nil
	local group1 = display.newGroup()
	local btn = createObject(normalImage, nil, pushedImage, nil, 0, 0, group1, nil, action)
	group:insert(group1)

	local onText
	if option.str then
		
		local fontSize = option.fontFamily or nil
		local textSize = option.textSize or 24

		onText = display.newText(option.str, 0,0, option.fontFamily or nil, option.textSize or 24)
		onText.x = btn.x
		onText.y = btn.y
		if option.fontColor then
			onText:setTextColor(option.fontColor[1],option.fontColor[2],option.fontColor[3],option.fontColor[4] or 255)
		else
			onText:setTextColor(148,208,95)
		end
		group:insert(onText)
	end

	group.x = o.x or 0
	group.y = o.y or 0

	if o.group then 
		o.group:insert(group)
	end

	return group
end

-------------------------------------------------------
-- btn.newRoundedBtn
--
-- 戻るのパターン
-------------------------------------------------------
function btn.newRoundedBtn(option)
	----------------------------------
	-- option.group    	   :
	-- option.image    	   :
	-- option.str          :
	-- option.action       :
	-- option.strokeWidth  :


	local o = option
	local group = display.newGroup()

	local font = o.font or nil

	--テキスト文字
	local text
	if o.text ~= nil then
		text = display.newText(group,o.text["str"], o.text["x"],o.text["y"], font, o.text["size"])
		if o.text["color"] then
			text:setTextColor(o.text["color"][1],o.text["color"][2],o.text["color"][3], o.text["color"][4] or 255)
		else
			text:setTextColor(0)
		end
	end

	--背景
	local rounded = o.button["rounded"] or 12

	-- ボタン
	local mainRect = display.newRoundedRect(group,o.button["x"],o.button["y"], o.button["width"], o.button["height"], rounded)
	
	local rectBg = display.newRect( group, 0, 0, o.button["width"]+20, o.button["height"]+20 )
	rectBg.x = mainRect.x; rectBg.y = mainRect.y
	rectBg:setFillColor(255, 0, 0)
	rectBg.alpha = _G["btnAlpha"]

	if o.button["strokeWidth"] == nil then
	    mainRect.strokeWidth = 1.5
	else
		mainRect.strokeWidth = o.button["strokeWidth"]
	end
    if o.connect == false then
		if o.button["normalColor"] then
			mainRect:setFillColor(o.button["normalColor"][1],o.button["normalColor"][2],o.button["normalColor"][3], o.button["normalColor"][4] or 255)
		else
			mainRect:setFillColor(0)
		end
	else
		if o.button["pushedColor"] then
			mainRect:setFillColor(o.button["pushedColor"][1],o.button["pushedColor"][2],o.button["pushedColor"][3], o.button["pushedColor"][4] or 255)
		else
			mainRect:setFillColor(0)
		end
	end

	if o.button["strokeColor"] then
		mainRect:setStrokeColor(o.button["strokeColor"][1],o.button["strokeColor"][2],o.button["strokeColor"][3], o.button["strokeColor"][4] or 255)
	else
		mainRect:setStrokeColor(180, 180, 180)
	end
    mainRect:addEventListener("touch",function(event)
        if event.phase == "began" then
            mainRect.alpha = 0.5
            timer.performWithDelay(230,function() mainRect.alpha = 1.0 end)
        else
            mainRect.alpha = 1.0
            if event.phase == "ended" then
            end
        end
        return true
    end)
	if o.action then
		mainRect:addEventListener("tap", o.action)
	end
	local btnImage
    if o.connect == false then
    	btnImage = o.icon["image"]
    else
    	btnImage = o.icon["pushed"]
    end
	local btnIcon = display.newImage(group,btnImage,o.icon["x"],o.icon["y"])

	if text ~= nil then
		text:toFront()
	end

	if o.group then
		o.group:insert(group)
	end

    return group
end

-------------------------------------------------------
-- btn.newBackBtn
--
-- 戻るボタンのパターン
-------------------------------------------------------
function btn.newBackBtn(option)
	----------------------------------
	-- option.group    	   :
	-- option.x            :
	-- option.y            :
	-- option.width        :
	-- option.height       :
	-- option.action       :
	----------------------------------

	local o = option
	local group = display.newGroup()

    local backBtn

    if (o.x or o.y or o.width or o.height) then 
	    backBtn = display.newRect( group, o.x or 0, o.y or 0, o.width or 170, o.height or _SH+100 )
    else
	    backBtn = display.newRect( group, 0, 0, 170, _SH+100 )
	end
    backBtn:setFillColor(255, 0, 0)
    backBtn.alpha = _G["btnAlpha"]

    local backArrow = display.newLine( group, 50, _SH+30, 35, _SH+45)
    backArrow:append(50, _SH+60)
    if o.color then
    	backArrow:setColor(o.color[1], o.color[2], o.color[3], o.color[4] or 255)
    else
	    backArrow:setColor(255)
	end
    backArrow.width = 5

    backBtn:addEventListener("touch",
        function(event)
            if ( event.phase == "began" ) then
                display.getCurrentStage():setFocus(event.target)
                backArrow.alpha = 0.5
            elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                display.getCurrentStage():setFocus(nil)
                backArrow.alpha = 1.0
            end
        end)

	if o.action then
		backBtn:addEventListener("tap", o.action)
	end

	if o.group then
		o.group:insert(group)
	end

    return group
end

-------------------------------------------------------
-- btn.newBackBtn
--
-- 戻るボタン＋基本の背景のパターン
-------------------------------------------------------
function btn.newBaseBtn(option)
	----------------------------------
	-- option.group    	    :　
	-- optin.bgColor        :　背景の色　　　　　　｜　指定なしで白(255, 255, 255)　　　　　　
	-- optin.titleColor     :　タイトルバーの色　　｜　指定なしで黄緑(152,210,77)  =  rgbSet.rgbFunction(1)
	-- option.x             :　タップ範囲の指定　　｜　指定なしで0
	-- option.y             :　タップ範囲の指定　　｜　指定なしで0
	-- option.width         :　タップ範囲の幅　　　｜　指定なしで170
	-- option.height        :　タップ範囲の高さ　　｜　指定なしで_SH+100
	-- option.action        :　タップ時のイベント　｜
	-- option.text      (*) :　ページのタイトル　　｜
	-- optin.fontSize       :　タイトルの大きさ　　｜　指定なしで40
	-- option.fontColor     :　タイトルの色　　　　｜　指定なしで白(255, 255, 255)
	--
	-- (*)は必須
	--
	-- 使い方
	-- local basePage = btn.newBaseBtn({ group = group, text = "テスト", })
	--
	----------------------------------

	local o = option
	local group = display.newGroup()

	-- 背景
	local bg = display.newRect( group, 0, 0, _W, _H)
	bg:addEventListener("tap", returnTrue)
	bg:addEventListener("touch", returnTrue)

	if o.bgColor then
		bg:setFillColor( o.bgColor[1], o.bgColor[2], o.bgColor[3], o.bgColor[4] or 255)
	else
		bg:setFillColor(255)
	end

	-- タイトルバー
    local titleBarStatus = display.newRect( group, 0, 0, _W, _SH)
    local titleBar = display.newRect( group, 0, _SH, _W, 90)
    titleBar:addEventListener("touch", returnTrue)
    titleBar:addEventListener("tap", returnTrue)

    if o.titleColor then
    	titleBarStatus:setFillColor( o.titleColor[1], o.titleColor[2], o.titleColor[3], o.titleColor[4] or 255)
		titleBar:setFillColor( o.titleColor[1], o.titleColor[2], o.titleColor[3], o.titleColor[4] or 255)
	else
	    titleBarStatus:setFillColor( rgbSet.rgbFunction(1)[1], rgbSet.rgbFunction(1)[2], rgbSet.rgbFunction(1)[3])
	    titleBar:setFillColor( rgbSet.rgbFunction(1)[1], rgbSet.rgbFunction(1)[2], rgbSet.rgbFunction(1)[3])
    end

    -- タイトルバーテキスト
    local titleText
    if o.text then
    	titleText = display.newText( group, o.text, 0, 0, native.systemFont, 40)
    	titleText.x = _W*0.5; titleText.y = titleBar.y
    	if o.fontSize then
    		titleText.size = o.fontSize
    	end
    	if o.fontColor then
    		titleText:setTextColor( o.fontColor[1], o.fontColor[2], o.fontColor[3], o.fontColor[4] or 255 )
    	else
    		titleText:setTextColor(255)
    	end
    end

    -- 戻るボタンのあたり判定
    local backBtn
    if (o.x or o.y or o.width or o.height) then 
	    backBtn = display.newRect( group, o.x or 0, o.y or 0, o.width or 170, o.height or _SH+100 )
    else
	    backBtn = display.newRect( group, 0, 0, 170, _SH+100 )
	end
    backBtn:setFillColor(255, 0, 0)
    backBtn.alpha = _G["btnAlpha"]

    -- 戻るボタン
    local backArrow = display.newLine( group, 50, _SH+30, 35, _SH+45)
    backArrow:append(50, _SH+60)
    if o.btnColor then
    	backArrow:setColor(o.btnColor[1], o.btnColor[2], o.btnColor[3], o.btnColor[4] or 255)
    else
	    backArrow:setColor(255)
	end
    backArrow.width = 5

    -- タップした際に薄くする
    backBtn:addEventListener("touch",
        function(event)
            if ( event.phase == "began" ) then
                display.getCurrentStage():setFocus(event.target)
                backArrow.alpha = 0.5
            elseif ( event.phase == "ended" or event.phase == "cancelled" ) then
                display.getCurrentStage():setFocus(nil)
                backArrow.alpha = 1.0
            end
        end)

	if o.action then
		backBtn:addEventListener("tap", o.action)
	end

	if o.group then
		o.group:insert(group)
	end

    return group
end


---------------------------------------
-- 文字のみボタン
--
-- option.str       : 表示文字
-- option.fontColor : 文字色(デフォルト：白)
-- option.width     : 幅
-- option.height    : 高さ
-- option.fontSize  : 文字のサイズ
---------------------------------------

function btn.newText(option)
	local group = display.newGroup()

	local o = option

	-- ボタンのテキスト
	local str = display.newText(group,o.str or "文字を設定してね。str", 0,0, o.font or native.systemFont, o.fontSize or 34)
	if o.leftPadding == 1 then
		str:setReferencePoint( display.CenterLeftReferencePoint )
	elseif o.rightPadding == 1 then
		str:setReferencePoint( display.CenterRightReferencePoint )
	end
	str.x , str.y = o.x or 0, o.y or 0

	local width  = o.width or str.width
	local height = o.height or str.height
	
	if o.fontColor then
		str:setTextColor(o.fontColor[1], o.fontColor[2], o.fontColor[3], o.fontColor[4] or 255)
	end

	-- 触れる背景
	local imageFilter = display.newRect(group, 0,0, width + 100, height + 60)
	if o.leftPadding == 1 then
		imageFilter:setReferencePoint( display.CenterLeftReferencePoint )
		imageFilter.x , imageFilter.y = 0 , str.y or 0
	elseif o.rightPadding == 1 then
		imageFilter:setReferencePoint( display.CenterRightReferencePoint )
		imageFilter.x , imageFilter.y = _W , str.y or 0
	else
		imageFilter:setReferencePoint( display.CenterReferencePoint )
		imageFilter.x , imageFilter.y = str.x or 0 , str.y or 0
	end

	if o.filter and o.filter ~= nil then
		display.remove( imageFilter )
		imageFilter = nil
		imageFilter = display.newRect(group,o.filter[1],o.filter[2],o.filter[3],o.filter[4])
	end


	imageFilter:setFillColor( 250 ,0,0 )
	imageFilter.alpha = _G["btnAlpha"]

	imageFilter:addEventListener("touch", 
		function(event)
			if event.phase == "began" then
				transition.to(str, {time=80, alpha = 0.5})
				
				timer.performWithDelay(230, function() str.alpha = 1 end)
			end
		end
	)

	imageFilter:addEventListener("tap", 
		function()
			transition.to(str, {time=80, alpha = 1})
			if o.action then o.action() end
			return true
		end
	)

	if o.group then
		o.group:insert(group)
	end

	return group
end

function btn.newSingleImage(o)
	local group = display.newGroup()

	local image = display.newImage(o.src, 0, 0)
	local rect = display.newRect(0, 0, o.width or image.width + 20, o.height or image.height + 20)

	group:insert(rect)
	group:insert(image)

	rect:setFillColor( 100,0,0 )
	rect.alpha = _G["btnAlpha"]

	image.x, image.y = rect.x, rect.y

	rect:addEventListener( "touch",
		function(event) 
			if event.phase == "began" then 
				image:setFillColor( 180 )
				--timer.performWithDelay( 200, function() if group then image:setFillColor( 255 ) end end)
			end
		end
	)
	rect:addEventListener( "tap", 
		function()
			image:setFillColor( 255 )
			if o.action then
				o.action()
			end
			return true
		end
	)

	return group
end

-------------------------------------------
-- キャンセル or 閉じるボタン
-------------------------------------------
function btn.close(option)
	local o = option
	local group = display.newGroup()

	local xPos,yPos

	local closeBtn
	if o.type == nil then
		xPos,yPos = o.x or 40, o.y or _SH+33
		if o.color == "green" then
			imageName = imageDir.."image/close-green.png"
		else
			imageName = imageDir.."image/close-white.png"
		end
		closeBtn = btn.newPushImage({group=group,image=imageName,x=xPos,y=yPos,
	        fillter={0,0,160,160},
	        action=function( event )
	        	if o.action then o.action() end
	        end})
	else
		if o.type == 1 then
			xPos,yPos = o.x or 18, o.y or _SH+45+5
			closeBtn = btn.newText({
		        str = translations["Cancel"][_isLanguage],
		        x = xPos,
		        y = yPos,
		        leftPadding = 1,
		        fontSize = 30,
		        action=function( event )
		            if o.action then o.action() end
		        end})
		end
	end

	if o.group then
		o.group:insert( group )
	end

	return group
end



return btn