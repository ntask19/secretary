
_W = display.contentWidth
_H = display.contentHeight

json = require('json')
tsutil  = require('tsutil')
library = require('library')
widget = require('widget')

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
local tasklist = tasklist_model.new()

local tasklistData = tasklist.getList()