
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
