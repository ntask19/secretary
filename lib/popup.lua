--[[
@
@ Project  : SpaceSecretary
@
@ Filename : popup.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-08-17
@
@ Comment  : ポップアップの設定
@
]]--

module( ..., package.seeall )

local customOption = {
	width = _W-200,
	height = 240,
	x = 0,
	y = 0,
	background = false
}

function new( option )
	local o = option or customOption
	-----------------
	-- type       :
	-- width      : 
	-- height     :
	-- x          :
	-- y          :
	-----------------

	print(o)

	local width  = o.width or _W-200
	local height = o.height or 240
	local x = o.x or _W*0.5
	local y = o.y or _H*0.5
	local size = o.size or 32
	local icon

	local group = display.newGroup()

	local blackBack = createBlackFilter(0, 0,_W, _H, group,{255,255,255,0})


	local background = display.newRoundedRect( group, 0, 0, 300, 200, 10 )
	colorScheme.Func( 'tsBlack', background )
	background.alpha = 0.8
	background.x, background.y = x,y

	background:addEventListener( "tap", returnTrue )
	background:addEventListener( "touch", returnTrue )

	local messageTemp, messageTempSub, iconTemp, subIconTemp
	local top, center, bottom = nil, nil, nil
	local topMsg, bottomMsg, msg1, msg2 = nil, nil, nil, nil
	if o.top == 1 then
		top = 1
	end
	if o.center == 1 then
		center = 1
	end
	if o.bottom == 1 then
		bottom = 1
	end
	if o.type ~= nil then
		if o.type == 1 then
			messageTemp = o.text
			iconTemp = o.image
		end
		if iconTemp then
			icon = display.newImage(group,iconTemp,0,0)
			icon.x,icon.y = background.x, background.y-30
		end

		if subIconTemp then
			local subIcon = display.newImage(group,subIconTemp,0,0)
			icon.x,icon.y = background.x - 30, background.y-30			
			subIcon.x,subIcon.y = background.x + 30, background.y-30			
		end

		local message = display.newText(group,messageTemp,0,0, native.systemFontBold, size)
		if o.type == 0 then
			-- message = display.newText(group,messageTemp,0,0, width-100, 32*3, native.systemFontBold, 32)
		end
		if o.type == 8 then
			topMsg = display.newText( group, msg1, 0, 0, native.systemFontBold, size )
			topMsg.x, topMsg.y = background.x, background.y-65
			bottomMsg = display.newText( group, msg2, 0, 0, native.systemFontBold, size )
			bottomMsg.x, bottomMsg.y = background.x, background.y + 65
		end
		message.x, message.y = background.x, background.y+55
		if top == 1 then
			message.y = background.y
			icon.alpha = 0
		end
		if center == 1 then
			message.y = background.y
			if icon then
				icon.alpha = 0
			end
		end
		if messageTempSub then
			message.y = background.y - 15
			bottomMsg = display.newText( group, messageTempSub, 0, 0, native.systemFontBold, size )
			bottomMsg.x, bottomMsg.y = background.x, background.y + 35
		end
	end

	group.alpha = 0
	transition.to(group, {time = 200, alpha=1, onComplete=
		function()
			timer.performWithDelay(o.duration or 1000,function()
				_M.close(group)
			end)
		end
	})

	return group
end

-- ポップアップを閉じる
function close( group )
	transition.to( group, 
		{ 
			time = 200, 
			alpha = 0,      
	    	onComplete = function()
				if group ~= nil then
					display.remove( group )
					group = nil
				end
			end
		}
	)
end
