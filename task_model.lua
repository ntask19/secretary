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
	-- タスク完了、未完了編集
	--
	-- @param id : (int) タスクid
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	local function checkedTask(id, is_checked)

		assert( id "NOT FOUNT id")
		
		if id then
			local result = {result='failure', reason='not_found_title'}
			return result
		else
			db:exec([[UPDATE task SET is_checked = ]] ..is_checked.. [[ WHERE id = ]] id [[;]])	
			local result = {result='success'}
			return result			
		end
	end


	-----------------------------------------------
	-- タスク完了、未完了編集
	--
	-- @param id : (int) タスクid
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	function func.completed(id)
		return checkedTask(id, 0)
	end

	-----------------------------------------------
	-- タスク未完了
	--
	-- @param id : (int) タスクid
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	function func.notYet(id)
		return checkedTask(id, 0)
	end	

	-----------------------------------------------
	-- タスク編集
	--
	-- @param id : (int) タスクid
	-- @param title : (int) タスク名
	-- @param date : (int) タスク日付
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	function func.updateTask(id, title, date)

		assert( id "NOT FOUNT id")
		assert( title "NOT FOUNT title")

		if title then
			local result = {result='failure', reason='not_found_title'}
			return result
		elseif id then
			local result = {result='failure', reason='not_found_title'}
			return result
		else
			db:exec([[UPDATE task SET title = '] ..title.. [[', date=']]..date..[[', WHERE id = ]] id [[;]])	
			local result = {result='success'}
			return result			
		end

		return true

	end

	-----------------------------------------------
	-- タスク追加
	--
	-- @param (int) リスト一覧のid
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	function func.addTask(title, date)

		print(title, date)
		-- (id INTEGER PRIMARY KEY, title, datetime, is_checked)
		--db:exec([[INSERT INTO task VALUES (NULL, ']]..title..[[', NOW() ,']]..detail..[[', 0, NOW()); ]])		
		db:exec([[INSERT INTO task VALUES (NULL, ']] ..title.. [[', ']]..date..[[', 0);]])	

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