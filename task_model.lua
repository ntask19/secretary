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

		assert( id, "NOT FOUNT id")
		print( id, is_checked )
		
		if id == nil then
			local result = {result='failure', reason='not_found_id'}
			return result
		else

			db:exec([[UPDATE task SET is_checked = ]] ..is_checked.. [[ WHERE id = ]]..id.. [[;]])	
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
		local res = checkedTask(id, 1)
		print( res )
		return res
		-- return checkedTask(id, 1)
	end

	-----------------------------------------------
	-- タスク未完了
	--
	-- @param id : (int) タスクid
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	function func.notYet(id)
		local res = checkedTask(id, 0)
		print( res )
		return res
		-- return checkedTask(id, 0)
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

		assert( id, "NOT FOUNT id")
		assert( title, "NOT FOUNT title")

		if title == nil then
			local result = {result='failure', reason='not_found_title'}
			print( result )
			return result
		elseif id == nil then
			local result = {result='failure', reason='not_found_id'}
			print( result )
			return result
		else
			if date == nil then
				db:exec([[UPDATE task SET title = ']] ..title.. [[' WHERE id = ]]..id..[[;]])
			else
				db:exec([[UPDATE task SET title = ']] ..title.. [[' date=']]..date..[[' WHERE id = ]]..id..[[;]])	
			end
			local result = {result='success'}
			print( result )
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
		db:exec([[INSERT INTO task VALUES (NULL, ']] ..title.. [[', ']]..date..[[', 0);]])	

		return true

	end

	-----------------------------------------------
	-- タスク削除
	--
	-- @param id : (int) タスクid
	--
	-- @value (boolean) 成功失敗
	-----------------------------------------------
	function func.deleteTask(id)

		assert( id, "NOT FOUNT id")

		if id == nil then
			local result = {result='failure', reason='not_found_id'}
			print( result )
			return result
		else
			db:exec([[DELETE FROM task WHERE id = ]]..id..[[;]])	
			local result = {result='success'}
			print( result )
			return result			
		end

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