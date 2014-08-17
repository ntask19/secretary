--[[
@
@ Project  : SpaceSecretary
@
@ Filename : ssconfig.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 設定
@
]]--


_W = display.contentWidth
_H = display.contentHeight
viewDir = 'view.'
libDir  = 'lib.'

-- 国識別
_isLanguage = "ja"
_isCountry = "JP"

if system.getInfo("platformName") == "Android" then
    _isLanguage = system.getPreference( "locale", "language" )
else
    _isLanguage = system.getPreference( "ui", "language" )
end
_isCountry = system.getPreference( "locale", "country" )

-- 開発用に言語情報を強制変換
if _isDebug == true then
	if _abroadDev == true then
		_isLanguage = "en"
		_isCountry = "US"
	end
end