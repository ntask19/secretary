--[[
@
@ Project  : SpaceSecretary
@
@ Filename : main.lua
@
@ Author   : Ryo Takahashi, Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 
@
]]--

-- include file
ssconfig    = require( 'ssconfig' )
json        = require( 'json' )
tsutil      = require( 'tsutil' )
library     = require( 'library' )
widget      = require( 'widget' )
guiFont     = require( viewDir .. 'guiFont' )
colorScheme = require( viewDir .. 'colorScheme' )

-- 開発用
_isDebug = true


----------------------------------------------------------------------
-- DBを触る
----------------------------------------------------------------------
--SQLiteを利用する
require "sqlite3"
--data.dbという名前のDBを作成し接続する。該当DBが未作成の場合は新規作成する
local path = system.pathForFile("data.db", system.DocumentsDirectory)
db = sqlite3.open(path)


--アプリ終了時はDB接続をクローズするようにする。
local function onSystemEvent( event )
	if( event.type == "applicationExit" ) then
		ssprint("close")            
		db:close()
	end
end
Runtime:addEventListener( "system", onSystemEvent )

----------------------------------------------------------------------


--local graph = require('graph')
local getUserAgent = require('getUserAgent')
local MultipartFormData = require("class_MultipartFormData")


-- メイン画面
local mainGroup = display.newGroup()
local background = display.newRect(mainGroup, _W*0.5, _H*0.5, _W, _H)
background:setFillColor( colorScheme.Func(0)[1], colorScheme.Func(0)[2], colorScheme.Func(0)[3] )

local background = display.newRect(mainGroup, _W*0.5, _H*0.5, _W, _H)
background:setFillColor( colorScheme.Func('tsYellow')[1], colorScheme.Func('tsYellow')[2], colorScheme.Func('tsYellow')[3] )
background.alpha = 0.5


-- タスクリスト取得
local tasklist_model = require('tasklist_model')
local tasklist_view = require('tasklist_view')
local task_model = require('task_model')

local tasklist = tasklist_model.new()
local tasklistData = tasklist.getList()
if _isDebug == true then
	local jsonData = readText( 'todo.json' )
	ssprint( jsonData )
	tasklistData = json.decode( jsonData )
end

local tasklistView = tasklist_view.show(tasklistData, {})
mainGroup:insert(tasklistView)
tasklistView.y = _H*0.5


-- タスク追加ボタン
local task = task_model.new()
local addTaskBtn = display.newRect(mainGroup, 100, 150, 80, 80)
addTaskBtn:setFillColor( colorScheme.Func('tsRed')[1], colorScheme.Func('tsRed')[2], colorScheme.Func('tsRed')[3] )
addTaskBtn:addEventListener( "tap", function() task.addTask("テスト", "詳細だよ")  end )

local taskListBtn = display.newRect(mainGroup, 100, 250, 80, 80)
taskListBtn:setFillColor( colorScheme.Func('tsBlue')[1], colorScheme.Func('tsBlue')[2], colorScheme.Func('tsBlue')[3] )
taskListBtn:addEventListener( "tap", function() tasklist_view.showList(tasklistData, {}) end )
