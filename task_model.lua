-- tasklist_model
-- 

module(..., package.seeall)


local function Listener()
	local func = {}

	local tasklist = {}

	-- タスク一覧をDBから取得する
	local function getListInDB(id)


		return jsonData
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
	-- タスク追加
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	function func.addTask(title, detail)

		plprint(title, detail)
		-- (id INTEGER PRIMARY KEY, title, create_date, datail, is_checked, date)
		--db:exec([[INSERT INTO task VALUES (NULL, ']]..title..[[', NOW() ,']]..detail..[[', 0, NOW()); ]])		
		db:exec([[INSERT INTO task VALUES (NULL, 'test', datetime('now'), 'detail-detail', 0, datetime('now')); ]])	

		return true

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

	return func
end




function new()
	local listener = Listener()

	return listener
end