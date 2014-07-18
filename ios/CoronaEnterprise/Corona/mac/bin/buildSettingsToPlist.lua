LuaCocoa.import("Foundation")

local srcAssets = arg[1]
local appBundleFile = arg[2]
local deviceType = arg[3] or "iphone" -- iphone or mac

local function escapeString( str )
	return "\"" .. str .. "\""
end

local function fileExists( filename )
	local f = io.open( filename, "r" )
	if ( f ) then
		io.close( f )
	end
	return ( nil ~= f )
end

local customSettingsFile = srcAssets .. "/build.settings"
if ( fileExists( customSettingsFile ) ) then
	local customSettings, msg = loadfile( customSettingsFile )
	if ( customSettings ) then
		local status, msg = pcall( customSettings )
		if status then
			print( "Using additional build settings from: " .. customSettingsFile )
		else
			print( "WARNING: Errors found in build.settings file:" )
			print( "\t".. msg ) 
		end
	else
		print( "WARNING: Could not load build.settings file:" )
		print( "\t".. msg )
	end
end

-- build.settings (if loaded and successfully executed, creates a global settings table)
local settings = _G.settings
if settings then
	-- cross-platform settings
	local orientation = settings.orientation
	if orientation then
		local defaultOrientation = orientation.default
		local supported = {}
		if defaultOrientation then
			local key = "UIInterfaceOrientation"
			local value = "UIInterfaceOrientationPortrait"
			if "landscape" == defaultOrientation or "landscapeRight" == defaultOrientation then
				value = "UIInterfaceOrientationLandscapeRight"
			elseif "landscapeLeft" == defaultOrientation then
				value = "UIInterfaceOrientationLandscapeLeft"
			end

			table.insert( supported, value )
			os.execute( "defaults write "..appBundleFile.."/Info " .. key .. " "..value )
		end

		os.execute( "defaults delete "..appBundleFile.."/Info ContentOrientation" )
		local contentOrientation = orientation.content
		if contentOrientation then
			local value
			if "landscape" == contentOrientation or "landscapeRight" == contentOrientation then
				value = "UIInterfaceOrientationLandscapeRight"
			elseif "landscapeLeft" == contentOrientation then
				value = "UIInterfaceOrientationLandscapeLeft"
			elseif "portrait" == contentOrientation then
				value = "UIInterfaceOrientationPortrait"
			end

			if value then
				os.execute( "defaults write "..appBundleFile.."/Info ContentOrientation "..value )
			end
		end

		os.execute( "defaults delete "..appBundleFile.."/Info UISupportedInterfaceOrientations" )
		local supportedOrientations = orientation.supported
		if supportedOrientations then
			local toUIInterfaceOrientations =
			{
				landscape = "UIInterfaceOrientationLandscapeRight",
				landscapeRight = "UIInterfaceOrientationLandscapeRight",
				landscapeLeft = "UIInterfaceOrientationLandscapeLeft",
				portrait = "UIInterfaceOrientationPortrait",
				portraitUpsideDown = "UIInterfaceOrientationPortraitUpsideDown",
			}

			for _,v in ipairs( supportedOrientations ) do
				local value = toUIInterfaceOrientations[v]
				if value then
					-- Add only unique values
					local found
					for _,elem in ipairs( supported ) do
						if elem == value then
							found = true
							break
						end
					end

					if not found then
						table.insert( supported, value )
					end
				end
			end
		end
		-- insert escape quotes between each element
		local supportedValue = table.concat( supported, "\" \"" )

		-- escape supportedValue on both ends
		os.execute( "defaults write "..appBundleFile.."/Info UISupportedInterfaceOrientations -array ".. escapeString( supportedValue ) )
	end


	-- add'l custom plist settings specific to iPhone
	-- defaults write is inadequate to write nested arrays and dictionaries
	-- Use LuaCocoa instead to access native NSArray/NSDictionary plist serialization/writing
	local plist = nil
	if deviceType == "iphone" then
		plist = settings.iphone and settings.iphone.plist
	elseif deviceType == "mac" then
		plist = settings.mac and settings.mac.plist
	end

	if plist then
		--		print("appBundleFile", appBundleFile)
		local infoPlistFile = appBundleFile ..  "/Info.plist"
		--		print("infoPlistFile", infoPlistFile)
		local orig_dict = NSDictionary:dictionaryWithContentsOfFile_( infoPlistFile );
		--		print("orig_dict", orig_dict)

		local mutable_dict = orig_dict:mutableCopy()

		-- plist is expected to be a table. LuaCocoa can convert this to an NSArray or NSDictionary.
		-- But our call to addEntriesFromDictionary assumes we have a dictionary.
		-- There is a corner case where the user provides an empty table or an array.
		-- So we want to convert now and check the type and avoid calling addEntriesFromDictionary if we have the wrong type.
		-- It seems in an empty table case, LuaCocoa returns back a Lua table. (I might need to fix this.)
		local ns_array_or_dict = LuaCocoa.toCocoa(plist)
		if type(ns_array_or_dict) == "userdata" and ns_array_or_dict:isKindOfClass_(NSDictionary) then
			-- merge Lua table entries with original plist entries
			mutable_dict:addEntriesFromDictionary_(ns_array_or_dict)
		end
		-- write out final plist
		--		print("final dict", mutable_dict)
		ret_flag = mutable_dict:writeToFile_atomically_(infoPlistFile, true)
		if (not ret_flag) or (ret_flag == 0) then
			print( "ERROR: Could not write Info.plist file. You may have invalid settings or syntax in your build.settings." )
		end
	end
end
