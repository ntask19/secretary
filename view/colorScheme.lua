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

function colorScheme.Func( type )
	local colorTable
	if type == 'tsGreen' then
		colorTable = { 152/255, 210/255, 77/255 }

	elseif type == 2 then
		colorTable = { 248, 248, 248 }

	elseif type == 3 then
		colorTable = { 230, 230, 230 }

	elseif type == 4 then
		colorTable = { 162, 162, 162 }

	elseif type == 5 then
		colorTable = { 204, 204, 204 }

	elseif type == 'tsBlack' then

		colorTable = { 50/255, 50/255, 50/255 }

	elseif type == 7 then -- ホームメニュー　灰文字
		colorTable = { 155, 168, 170 }--{197,202,206}

	elseif type == 'tsBlue' then -- ランキングの点数が書いてあるバー 青
		colorTable = { 70/255, 135/255, 205/255 }

	elseif type == 9 then -- タブの文字色 灰色
		colorTable = { 142, 152, 142 }

	elseif type == 10 then -- 左メニューの セルを押した状態の色
		colorTable = { 219, 237, 196 }

	elseif type == 11 then -- スペースを作成際に表示されるポップアップのフォント色　灰色
		colorTable = { 128, 141, 141 }

	elseif type == 12 then -- グレーのボタンを作成するとき 内枠
		colorTable = { 236, 240, 241 }

	elseif type == 13 then -- グレーのボタンを作成するとき 外枠
		colorTable = { 186, 194, 197 }

	elseif type == 14 then -- popupの閉じるボタン
		colorTable = { 178, 187, 191 }

	elseif type == 15 then -- ページ全域の黒色
		colorTable = { 47, 48, 51 }

	elseif type == 'tsRed' then
		colorTable = { 216/255, 40/255, 60/255 } 

	elseif type == 17 then
		colorTable = { 239, 242, 241 }

	elseif type == 'tsYellow' then
		colorTable = { 241/255, 195/255, 64/255 }

	elseif type == 'defalut' or type == nil then
		colorTable = { 255/255, 255/255, 255/255 }

	else
		colorTable = { 255/255, 255/255, 255/255 }
	end
	-- ssprint("colorTable.r-------"..colorTable[1]..",colorTable.g-------"..colorTable[2]..",colorTable.b-------"..colorTable[3])
	return colorTable
end 

return colorScheme