--[[
@
@ Project  : SpaceSecretary
@
@ Filename : translations.lua
@
@ Author   : Task Nagashige
@
@ Date     : 2014-08-17
@
@ Comment  : 翻訳ライブラリ
@
]]--

module( ..., package.seeall )

local translationsTable = {}

function func( language, translatedStr )
	local translatedStr = nil
	translatedStr = translationsTable[language][str]
	return translatedStr
end

translationsTable = {
	["test"] =
	{
		["en"] = "this is test.",
		["ja"] = "テストです",
	},
}