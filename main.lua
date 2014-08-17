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

-- 開発用（提出前にfalseにする）
_isDebug = true


-- 開発用
_abroadDev = false
if _isDebug == false then
	_abroadDev = false
end


-- include file
ssconfig    = require( 'ssconfig' )
json        = require( 'json' )
tsutil      = require( 'tsutil' )
library     = require( 'library' )
widget      = require( 'widget' )
guiFont     = require( viewDir .. 'guiFont' )
colorScheme = require( viewDir .. 'colorScheme' )
btn         = require( libDir .. 'btn' )
startup     = require( 'startup' )

-- global
_nowPage = 'home'


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



-- メイン画面
local mainGroup = display.newGroup()
local background0 = display.newRect(mainGroup, 0, 0, _W, _H)

local background = display.newRect(mainGroup, 0, 0, _W, _H)
local randomBackground = math.random( 0, 2 )
if randomBackground == 0 then
	colorScheme.Func( 'tsYellow', background )
elseif randomBackground == 1 then
	colorScheme.Func( 'tsBlue', background )
else
	colorScheme.Func( 'tsRed', background )
end
background.alpha = 0.5


-- タスクリスト取得
local tasklist_model = require('tasklist_model')
local tasklist_view = require('tasklist_view')
local task_model = require('task_model')
local task_popup = require( viewDir .. 'task_popup')

local tasklist = tasklist_model.new()
local tasklistData = tasklist.getList()
local tasklistPage = nil
local tasklistView = tasklist_view.show(tasklistData, {})
mainGroup:insert(tasklistView)

function homeReplace( nowPage )
	if tasklistView then
		display.remove( tasklistView )
		tasklistView = nil
	end
	if _nowPage == 'home' or nowPage == 'home' then
		tasklistData = tasklist.getList()
		tasklistView = tasklist_view.show(tasklistData, {})
		mainGroup:insert(tasklistView)
	end
end

function tasklistReplace( nowPage )
	if tasklistPage then
		display.remove( tasklistPage )
		tasklistPage = nil
	end
	if _nowPage == 'list' then
		tasklistData = tasklist.getList()
		tasklistPage = tasklist_view.showList(tasklistData, {})
	end
end

-- Runtime:addEventListener( 'enterFrame', function() print( _nowPage ) end )

-- タスク追加ボタン
local task = task_model.new()
local addTaskBtn = display.newRect(mainGroup, 40, 100, 80, 80)
colorScheme.Func( 'tsRed', addTaskBtn )
addTaskBtn:addEventListener( "tap", function() task_popup.createTask() end )--task.addTask("テスト", "2014-08-01 02:33:43")  end )
local addTaskText = display.newText( mainGroup, "ADD", 0, 0, nil, 36 )
addTaskText.x, addTaskText.y = addTaskBtn.x, addTaskBtn.y

local taskListBtn = display.newRect(mainGroup, 40, 200, 80, 80)
colorScheme.Func( 'tsBlue', taskListBtn )
taskListBtn:addEventListener( "tap", function() _nowPage = 'list'; tasklistReplace(); return true end )
local taskListText = display.newText( mainGroup, "List", 0, 0, nil, 36 )
taskListText.x, taskListText.y = taskListBtn.x, taskListBtn.y

-- ファイルpathを用意する
local voicePath1, voicePath2 = "voice/voice1.mp3", "voice/voice2.mp3"

-- 音声を再生する
local function playVoice( audioPath, listener )
	if system.getInfo( "platformName" ) ~= "iPhone OS" then
		media.playSound( 
			audioPath, 
			system.ResourceDirectory, 
			function()
				media.stopSound( audioPath )
				audioPath = nil
				if listener ~= nil then 
					listener() 
				end 
			end 
		)
	end
end

local function soundVoice()
	local random = math.random( 0, 1 )
	if random == 0 then
		playVoice( voicePath1 )
	else
		playVoice( voicePath2 )
	end
end

startup.create()
timer.performWithDelay( 1000, function() startup.remove(); soundVoice() end )
