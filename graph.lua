local graph = {}


local function listener(group)
	local func = {}
	local data = {}
	local color = {90, 90, 90}
	
	function func.setData(option)
		data = option
	end

	function func.setColor(option)
		color = option 
	end

	function func.createGraph()

		local maxValue = 0
		local minValue = nil		

		for k, v in pairs(data) do
			if maxValue < v.num then
				maxValue = v.num
			end
			if minValue == nil or minValue > v.num then
				minValue = v.num
			end			
		end

		-- view
		local leftMargin = 90
		local minLength = 30
		local maxLength = 400
		local rowY = 220

		local line = display.newLine(group, leftMargin, 0, leftMargin, _H)
		line:setColor(color[1],color[2],color[3])

		for k, v in pairs(data) do
			local length = minLength + maxLength * ((v.num - minValue) / (maxValue - minValue))
			
			local row = display.newRect(group, leftMargin, rowY, length, 8)
			row:setFillColor(color[1],color[2],color[3])

			-- local dataDot = display.newCircle(group, 0, 0, 8)
			-- dataDot:setFillColor(color[1],color[2],color[3])
			-- dataDot.x, dataDot.y = row.x + row.width*0.5, row.y

			local data = display.newText(group, v.num, 0, 0, _family, 27)
			data:setFillColor(color[1],color[2],color[3])
			data.x, data.y = _W - data.width*0.5 - 20, row.y

			local Year, Month, Day, Hour, Minute, Second = dateFormat(v.date)
			local date = display.newText(group, Day, 10, 0, _family, 32)
			date:setFillColor(80)
			date.y = row.y

			rowY = rowY + 60
		end
	end

	return func
end


function graph.new()
	local group = display.newGroup()
	local func = listener(group)

	return group, func
end


return graph