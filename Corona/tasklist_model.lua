-- tasklist_model
-- 

module(..., package.seeall)


--
-- 日付の分割
-- @param (datetime型) 日付
-- @return (table) {year, month, day, hour, min, sec}
--
local function exploadDateTime(dateTime)
	dateTime = string.gsub(dateTime, " ", "-")
	dateTime = string.gsub(dateTime, ":", "-")
	function split(str, d)
		local s = str
		local t = {}
		local p = "%s*(.-)%s*"..d.."%s*"
		local f = function(v)
			table.insert(t, v)
		end
		if s ~= nill then
			string.gsub(s, p, f)
			f(string.gsub(s, p, ""))
		end
		return t
	end
	
	dateTime = split(dateTime,"-")

	local Year, Month, Day, Hour, Minute, Second= dateTime[1],dateTime[2],dateTime[3],dateTime[4],dateTime[5],dateTime[6]
	local t = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=Second})
 	
 	dateTime = nil
	return t
end


local function Listener()
	local func = {}

	local tasklist = {}

	-- タスク一覧をDBから取得する
	local function getListInDB(startDate)


		--テーブル名
		local tableName = "task"

		--存在していない場合はテーブルを新規作成
		db:exec([[CREATE TABLE IF NOT EXISTS ]]..tableName..[[ (id INTEGER PRIMARY KEY, title, datetime, is_checked)]])

		-- データ取得
		local res = {}


		local query = "SELECT * FROM "..tableName

		-- startDate が指定されているとき
		if startDate then
			query = query .. " WHERE datetime >= '" .. startDate .. "'"
		end
		--query = query .. " ORDER BY date ASC"


		local set_date = nil
		local row_count = 1
		local date_row = {}

		for row in db:nrows(query) do
			if not set_date or string.find(row['datetime'], set_date) then --set_date ~= os.date("%Y-%m-%d", row['datetime']) then

				if #date_row > 0 then
					table.insert(res, date_row)
					date_row = nil
					date_row = {}
				end
				set_date = os.date("%Y-%m-%d", exploadDateTime(row['datetime']))
				date_row["date"] = set_date
				date_row["tasks"] = {}
			end
			table.insert(date_row["tasks"], row)

		end
		table.insert(res, date_row)
		
		print(json.encode(res))
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
	-- @param (date型) date
	-- @value (json) リスト一覧のデータ
	-----------------------------------------------
	function func.getList(startDate)
		--startDate = os.date("%Y-%m-%d")
		return getListInCache(startDate)
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