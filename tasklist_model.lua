--[[
@
@ Project  : SpaceSecretary
@
@ Filename : tasklist_model.lua
@
@ Author   : Ryo Takahashi, Task Nagashige
@
@ Date     : 2014-07-31
@
@ Comment  : 文字設定のライブラリ
@
]]--

module(..., package.seeall)


local function Listener()
	local func = {}

	local tasklist = {}

	-- タスク一覧をDBから取得する
	local function getListInDB(id)


		--テーブル名
		local tableName = "task"
		--存在していない場合はテーブルを新規作成
		db:exec([[CREATE TABLE IF NOT EXISTS ]]..tableName..[[ (id INTEGER PRIMARY KEY, title, create_date, datail, is_checked, date)]])

		-- データ取得
		local res = {}
		for row in db:nrows("SELECT * FROM "..tableName) do
			table.insert(res, row)
		end

		return res
	end

	-----------------------------------------------
	-- タスク一覧をキャッシュから取得
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	local function getListInCache(id)
		if tasklist[id] then
			return tasklist[id]
		else
			return getListInDB(id)
		end
	end



	-----------------------------------------------
	-- タスク一覧をキャッシュから取得
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	function func.getList(id)
		return getListInCache(id)
	end


	-----------------------------------------------
	-- タスク一覧を削除する
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------	
	function func.removeList()
		local filename = id..".txt."
		local path = system.pathForFile(filename, system.DocumentsDirectory)
		local file = io.open(path, "r")			

		if file then
			os.remove(path)
			return true
		else
			return false
		end
	end

	return func
end




function new()
	local listener = Listener()

	return listener
end