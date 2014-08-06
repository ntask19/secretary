------------------------------------------------------------ 
-- tsdisplay.lua
--
-- Comment
-- display class をカスタマイズしたもの
--
-- Create
-- RyoTakahashi
--
-- Date: 2014-04-22
------------------------------------------------------------

-- tsdisplay
--
-- @ newImage
-- newText
-- newRect


local tsdisplay = {}


function tsdisplay.newRect( group, x, y, width, height )
	local rect = display.newRect( group, x, y, witdh, height )
	rect.anchorX = 0
	rect.anchorY = 0

	return rect
end


-- image
function tsdisplay.newImage(obj1, obj2, obj3, obj4, obj5)

	local image = {

}
	local group, imageName, dir, x, y

	if type(obj1) == "table" then
		group = obj1
		imageName = obj2
	else
		imageName = obj1
	end



	return image
end


return tsdisplay