
_W = display.contentWidth
_H = display.contentHeight

json = require('json')
tsutil  = require('tsutil')
library = require('library')
widget = require('widget')


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
		print("close")            
		db:close()
	end
end
Runtime:addEventListener( "system", onSystemEvent )

----------------------------------------------------------------------





--local graph = require('graph')
local getUserAgent = require('getUserAgent')
local MultipartFormData = require("class_MultipartFormData")

-- フォント
if system.getInfo("platformName") == "Android" then
	_family = "Roboto-Thin"
	_familyNum = "Roboto-Thin"
else
	_family = "HelveticaNeue-UltraLight"
	_familyNum = "HelveticaNeue-UltraLight"
end

-- メイン画面
local mainGroup = display.newGroup()
local background = display.newRect(mainGroup, 0, 0, _W, _H)



-- タスクリスト取得
local tasklist_model = require('tasklist_model')
local tasklist_view = require('tasklist_view')
local task_model = require('task_model')


local tasklist = tasklist_model.new()

local tasklistData = tasklist.getList()
local tasklistView = tasklist_view.show(tasklistData, {})
mainGroup:insert(tasklistView)
tasklistView.y = _H/2



-- タスク追加ボタン
local task = task_model.new()
local addTaskBtn = display.newRect(mainGroup, _W-150, 50, 140, 80)
addTaskBtn:setFillColor( 0, 90, 90)
addTaskBtn:addEventListener( "tap", function() task.addTask("テスト", "詳細だよ")  end )