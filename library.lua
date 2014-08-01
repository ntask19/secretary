-- ssprint関数
_print = print

function printTable(table, prefix)
	if not prefix then
		prefix = "### "
	end
	if _isDebug == true then 
		if type(table) == "table" then
			for key, value in pairs(table) do
				if type(value) == "table" then
					_print(prefix .. tostring(key))
					_print(prefix .. "{")
					printTable(value, prefix .. "   ")
					_print(prefix .. "}")
				else
					_print(prefix .. tostring(key) .. ": " .. tostring(value))
				end
			end
		end
	end
end

function ssprint( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
	if _isDebug == true then
		if type(str1) == "table" then
			printTable(str1)
		else
			if str2 == nil then str2 = "" end 
			if str3 == nil then str3 = "" end 
			if str4 == nil then str4 = "" end 
			if str5 == nil then str5 = "" end 
			if str6 == nil then str6 = "" end 
			if str7 == nil then str7 = "" end 
			if str8 == nil then str8 = "" end 
			if str9 == nil then str9 = "" end 
			if str10 == nil then str10 = "" end 
			_print( tostring(str1), tostring(str2), tostring(str3), tostring(str4), tostring(str5), tostring(str6), tostring(str7), tostring(str8), tostring(str9), tostring(str10))
		end
	end
end

function print( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
	ssprint( str1, str2, str3, str4, str5, str6, str7, str8, str9, str10)
end


--時間の表示を〇〇分前等にかえる
function dateFormat(dateTime)
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

	dateTime = split(dateTime, "-")
	local Year, Month, Day, Hour, Minute, Second= dateTime[1],dateTime[2],dateTime[3],dateTime[4],dateTime[5],dateTime[6]
	local t1 = os.time({year=Year, month=Month, day=Day, hour=Hour, min=Minute, sec=Second})
	local date = os.date( '*t' )
	local t2 = os.time({year=date.year, month=date.month, day=date.day, hour=date.hour, min=date.min, sec=date.sec})
	now=os.difftime( t2, t1 )
	niti = math.floor(now/86400)
	jikan = math.floor(now/3600)
	hun = math.floor(now/60)
	byou = math.floor(now)

	return Year, Month, Day, Hour, Minute, Second
end


-- 色
function colorPalette(name, obj)
	local color = {}

	if name == 'blue' then
		color = {101, 163, 190}
	elseif name == 'green' then
		color = {65, 178, 122}
	elseif name == 'purple' then
		color = {134, 106, 157}
	elseif name == 'red' then
		color = {191, 75, 76}
	elseif name == 'orange' then
		color = {208, 144, 84}
	elseif name == 'black' then
		color = {39, 40, 34}
	elseif name == 'emerald' then
		color = {101, 209, 173}
	elseif name == 'dark' then
		color = {86, 90, 93}		
	elseif name == 'pink' then
		color = {255, 61, 111}				
	elseif name == 'white' then
		color = {240, 240, 240}
	else
		color = {171, 169, 171}
	end

	if obj then
		obj:setFillColor( color[1], color[2], color[3] )
	else
		return color
	end
end


-- ダウンロードする関数
-- 既に持っているか、http:// or local://　かをチェックして画像を準備する
function checkDownload(url, action, dir, root)
	local directory = dir or system.TemporaryDirectory
	local filePath = root or ""
	if startsWith(url,"http://") then
		local path = system.pathForFile(basename(url), directory)
		local file = io.open(path, "r")
		if file then
			io.close(file)
			if action then
				action()
			end
		else
			local function listener(event)
				if event.isError then
				else
					if event.status ~= 200 then
						os.remove(system.pathForFile( basename(url), directory))
					end          
					if action then
						action()
					end
				end
			end
			
			local headers = {}
			headers["User-Agent"] = userAgent
			local params = {}
			params.headers = headers
			network.download(url, "GET", listener, filePath..basename(url), directory)
		end
	else
		if action then
			action()
		end   
	end
end

-- 日付のXXXX-XX-XX XX:XX:XX表記をXX:XX表記に変換する
function datetime_cast( datetime )
	local time 
	if datetime ~= nil and datetime ~= 'NULL' then
		time = string.sub( datetime, 12, 16 )
	else
		time = '-' 
	end
	return time
end

-- 日付のXXXX-XX-XX XX:XX:XX表記をXX-XX表記に変換する
function date_cast( datetime )
	local date = string.sub( datetime, 6, 10 )
	return date
end

--read text
function readText(name, dir)
	local directory = dir or system.DocumentsDirectory
	local path = system.pathForFile(name, system.DocumentsDirectory)
	local file = io.open(path, "r")
	if file then
		local contents = file:read("*a")
		return contents
	else
		return nil
	end
end
