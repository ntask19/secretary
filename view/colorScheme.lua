--[[
@
@ Project  : SpaceSecretary
@
@ Filename : colorScheme.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 色設定のライブラリ
@            新Coronaでは1/255を乗じること
@
]]--

local colorScheme = {}
colorScheme.r = nil
colorScheme.g = nil
colorScheme.b = nil

function colorScheme.Func( colorType, obj )
	local rgba = 1
	local colorTable
	if colorType == 'tsGreen' then
		colorTable = { 152/rgba, 210/rgba, 77/rgba }

	elseif colorType == 2 then
		colorTable = { 248, 248, 248 }

	elseif colorType == 3 then
		colorTable = { 230, 230, 230 }

	elseif colorType == 4 then
		colorTable = { 162, 162, 162 }

	elseif colorType == 5 then
		colorTable = { 204, 204, 204 }

	elseif colorType == 'tsBlack' then

		colorTable = { 50/rgba, 50/rgba, 50/rgba }

	elseif colorType == 7 then -- ホームメニュー　灰文字
		colorTable = { 155, 168, 170 }--{197,202,206}

	elseif colorType == 'tsBlue' then -- ランキングの点数が書いてあるバー 青
		colorTable = { 70/rgba, 135/rgba, 205/rgba }

	elseif colorType == 9 then -- タブの文字色 灰色
		colorTable = { 142, 152, 142 }

	elseif colorType == 10 then -- 左メニューの セルを押した状態の色
		colorTable = { 219, 237, 196 }

	elseif colorType == 11 then -- スペースを作成際に表示されるポップアップのフォント色　灰色
		colorTable = { 128, 141, 141 }

	elseif colorType == 12 then -- グレーのボタンを作成するとき 内枠
		colorTable = { 236, 240, 241 }

	elseif colorType == 13 then -- グレーのボタンを作成するとき 外枠
		colorTable = { 186, 194, 197 }

	elseif colorType == 14 then -- popupの閉じるボタン
		colorTable = { 178, 187, 191 }

	elseif colorType == 15 then -- ページ全域の黒色
		colorTable = { 47, 48, 51 }

	elseif colorType == 'tsRed' then
		colorTable = { 216/rgba, 40/rgba, 60/rgba } 

	elseif colorType == 17 then
		colorTable = { 239, 242, 241 }

	elseif colorType == 'tsYellow' then
		colorTable = { 241/rgba, 195/rgba, 64/rgba }

	elseif colorType == 'defalut' or type == nil then
		colorTable = { 255/rgba, 255/rgba, 255/rgba }

	else
		colorTable = { 255/rgba, 255/rgba, 255/rgba }
	end
	-- ssprint("colorTable.r-------"..colorTable[1]..",colorTable.g-------"..colorTable[2]..",colorTable.b-------"..colorTable[3])
	if obj then
		obj:setFillColor( colorTable[1], colorTable[2], colorTable[3] )
	else
		return colorTable
	end
end 

return colorScheme