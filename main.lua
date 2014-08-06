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
local background = display.newRect(mainGroup, 0, 0, _W, _H)

local background = display.newRect(mainGroup, 0, 0, _W, _H)
colorScheme.Func( 'tsYellow', background )
background.alpha = 0.5


-- タスクリスト取得
local tasklist_model = require('tasklist_model')
local tasklist_view = require('tasklist_view')
local task_model = require('task_model')
local task_popup = require( viewDir .. 'task_popup')

local tasklist = tasklist_model.new()
local tasklistData = tasklist.getList()
if _isDebug == true then
	-- local jsonData = readText( 'todo.json' )
	-- ssprint( jsonData )
	-- tasklistData = json.decode( jsonData )
end

local tasklistView = tasklist_view.show(tasklistData, {})
mainGroup:insert(tasklistView)


-- タスク追加ボタン
local task = task_model.new()
local addTaskBtn = display.newRect(mainGroup, 40, 100, 80, 80)
colorScheme.Func( 'tsRed', addTaskBtn )
addTaskBtn:addEventListener( "tap", function() task_popup.createTask() end )--task.addTask("テスト", "2014-08-01 02:33:43")  end )
local addTaskText = display.newText( mainGroup, "ADD", 0, 0, nil, 36 )
addTaskText.x, addTaskText.y = addTaskBtn.x, addTaskBtn.y

local taskListBtn = display.newRect(mainGroup, 40, 200, 80, 80)
colorScheme.Func( 'tsBlue', taskListBtn )
taskListBtn:addEventListener( "tap", function() local tasklistData = tasklist.getList(); tasklist_view.showList(tasklistData, {}) end )
local taskListText = display.newText( mainGroup, "List", 0, 0, nil, 36 )
taskListText.x, taskListText.y = taskListBtn.x, taskListBtn.y
