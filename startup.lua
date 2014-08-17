--[[
@
@ Project  : SpaceSecretary
@
@ Filename : startup.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 文字設定のライブラリ
@
]]--

module( ..., package.seeall )

local group

--アプリ起動時に表示するもの
function create()
	
	group = display.newGroup()
	if system.getInfo("platformName") == "iPhone OS" then
		openningImg = display.newImage(group, "Default.png", 0, 0, true)
	else
		openningImg = display.newImage(group, "Default.png", 0, _SH, true)
	end
	openningImg:addEventListener("touch", returnTrue)

end

--アプリ起動時に表示したものを削除
function remove()
	timer.performWithDelay( 1,
		function()
			local function removeListener()
				display.remove( group )
				group = nil
			end
			transition.to( group, {time=100, alpha=0, onComplete = removeListener } )
		end
	,1 )
end