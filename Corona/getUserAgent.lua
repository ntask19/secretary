-- ProjectName : Talkspace
--
-- Filename : getUserAgent.lua
--
-- Creater : Ryo Takahashi
--
-- Date : 2013-07-29
--
-- Comment : 
--
-- ユーザーエージェントを取得する関数
----------------------------------------------------------------------------------
local function getUserAgent()                                                        
  local arg = ""
                                                  
  -- Add version
  local version = system.getInfo("platformVersion") --Build.VERSION.RELEASE;
  if version then
    arg = arg .. version
  else
    -- default to "1.0"
    arg = arg .. "1.0"
    version = "1.0"
  end
  arg = arg .. "; "
  
  -- Initialize the mobile user agent with the default locale.
  local language = system.getPreference( "locale", "language" )
  if  language ~= nil  then
    arg = arg .. language:lower()
    local country =  system.getPreference( "locale", "country" )
    if country ~= nil then
      arg = arg .. "-" .. country:lower()
    end
  else
    -- default to "en"
    arg = arg .. "en"
  end
  
  -- Add the device model name and Android build ID.
  model = system.getInfo("model")
  if model then
    arg = arg .. "; " .. model
  end
 
  --local id = (require "UserID").getHashedID();
 
  --if id then
  --        arg = arg .. " Build/" .. version
  --end                                           
  userAgent = "Talkspace/"..version.." Android " .. arg
  return userAgent
  --return escape( userAgent ) 
end

return getUserAgent()