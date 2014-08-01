--[[
@
@ Project  : SpaceSecretary
@
@ Filename : guiFont.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 文字設定のライブラリ
@
]]--

-- フォント
if system.getInfo("platformName") == "Android" then
	_family = "Roboto-Thin"
	_familyNum = "Roboto-Thin"
else
	_family = "HelveticaNeue-UltraLight"
	_familyNum = "HelveticaNeue-UltraLight"
end