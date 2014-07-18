-- tasklist_model
-- 

module(..., package.seeall)


local function Listener()
	local func = {}

	local tasklist = {}

	-- タスク一覧をDBから取得する
	function func.getListInDB(id)

		return jsonData
	end

	-----------------------------------------------
	-- タスク一覧をキャッシュから取得
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	function func.getListInCache(id)
		local filename = id..".txt."
		local path = system.pathForFile(filename, system.DocumentsDirectory)
		local file = io.open(path, "r")	
		if file then
			local contents = file:read( "*a" )
			io.close(file)
			return contents
		else 
			return false
		end
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