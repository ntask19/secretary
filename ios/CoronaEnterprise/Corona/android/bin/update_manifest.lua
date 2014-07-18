----------------------------------------------------------------------------------------------------
-- Creates an "AndroidManifest.xml" using build settings coming from the following files:
-- * A required "build.properties" containing build dialog settings and "build.settings" info.
-- * An optional "output.json" which contains plugin settings.
----------------------------------------------------------------------------------------------------


local json = require("json")


-- Fetch arguments.
local manifestTemplateFilePath = arg[1]
local buildPropertiesFilePath = arg[2]
local appName = arg[3]
local newManifestFilePath = arg[4]
local pluginSettingsFilePath = arg[5]

-- Do not continue if missing required arguments.
if not manifestTemplateFilePath or not buildPropertiesFilePath or not newManifestFilePath then
	print( "USAGE: " .. arg[0] .. " src_manifest build.properties new_manifest" )
	os.exit( -1 )
end

-- Load the "build.properties" file.
local buildPropertiesFileHandle = io.open( buildPropertiesFilePath, "r" )
if not buildPropertiesFileHandle then
	print( "ERROR: The properties file does not exist: ", buildPropertiesFilePath )
	os.exit( -1 )
end
local buildProperties = json.decode(buildPropertiesFileHandle:read("*a"))
buildPropertiesFileHandle:close()

-- Load an array of plugin settings from the given JSON file, if provided.
local pluginSettingsCollection = nil
if pluginSettingsFilePath then
	local pluginSettingsFileHandle = io.open(pluginSettingsFilePath, "r")
	if pluginSettingsFileHandle then
		pluginSettingsCollection = json.decode(pluginSettingsFileHandle:read("*a"))
		pluginSettingsFileHandle:close()
	else
		print( "WARNING: Failed to find plugin settings file: ", pluginSettingsFilePath )
	end
end


----------------------------------------------------------------------------------------------------
-- Initialize Android manifest settings.
----------------------------------------------------------------------------------------------------

local packageName = ""
local defaultOrientation = nil
local supportsOrientationChange = false
local supportsOrientationPortrait = false
local supportsOrientationPortraitUpsideDown = false
local supportsOrientationLandscapeRight = false
local supportsOrientationLandscapeLeft = false
local hasOrientationTable = false
local permissions = {}
local usesPermissions = {}
local supportsScreens = {}
local usesFeatures =
{
	{ glEsVersion = "0x00010001" },
	{ name = "android.hardware.telephony", required = false },
}
local mainIntentFilterCategories =
{
	["android.intent.category.LAUNCHER"] = true,
}
local intentFilters = {}
local usesExpansionFile = false
local largeHeap = false
local installLocation = "auto"
local targetedAppStore = "none"
local applicationChildXmlElements = {}
local googlePlayGamesAppId = false


----------------------------------------------------------------------------------------------------
-- Define functions used to load manifest settings.
----------------------------------------------------------------------------------------------------

-- Fetches the version code from the given argument and copies it to variable "versionCode".
local function fetchVersionCodeFrom(source)
	local numericValue = tonumber(source)
	if "number" == type( numericValue ) then
		versionCode = tostring( math.floor( numericValue ) )
	end
end

-- Fetches a version name from the given argument and copies it to variable "versionName".
local function fetchVersionNameFrom(source)
	if ("string" == type( source )) and (string.len( source ) > 0) then
		versionName = source
	elseif "number" == type( source ) then
		versionName = tostring(source)
	end
end

-- Fetches permissions from argument "sourceArray" and inserts them into the "permissions" table.
local function fetchPermissionsFrom(sourceArray)
	if "table" == type(sourceArray) then
		for sourceIndex = 1, #sourceArray do
			-- Get the next permission, but only accept it if it is a table and it contains a "name" key.
			local sourceEntry = sourceArray[sourceIndex]
			if (("table" == type(sourceEntry)) and ("string" == type(sourceEntry["name"]))) then
				-- If the permission name starts with a period, then prefix the package name to it.
				if string.sub(sourceEntry["name"], 1, 1) == "." then
					sourceEntry["name"] = packageName .. sourceEntry["name"]
				end

				-- Check if the permissions array already contains the indexed element.
				local targetEntry = nil
				for targetIndex = 1, #permissions do
					targetEntry = permissions[targetIndex]
					if sourceEntry["name"] == targetEntry["name"] then
						break
					end
					targetEntry = nil
				end

				-- If an existing entry was not found, then insert a new one.
				if not targetEntry then
					targetEntry = {}
					table.insert(permissions, targetEntry)
				end

				-- Copy the permission settings.
				for key, value in pairs(sourceEntry) do
					targetEntry[key] = value
				end
			end
		end
	end
end

-- Fetches the entries in argument "sourceArray" and inserts them into the "usesPermissions" table.
local function fetchUsesPermissionsFrom(sourceArray)
	if "table" == type(sourceArray) then
		for index = 1, #sourceArray do
			local permissionName = sourceArray[index]
			if ("string" == type(permissionName)) then
				-- If the permission name starts with a period, then prefix the package name to it.
				if string.sub(permissionName, 1, 1) == "." then
					permissionName = packageName .. permissionName
				end

				-- Add the permission name to the given table.
				usesPermissions[permissionName] = true
			end
		end
	end
end

-- Fetches the "uses-features" settings from argument "soruceArray" and inserts them into the "usesFeatures" table.
local function fetchUsesFeaturesFrom(sourceArray)
	if "table" == type(sourceArray) then
		for sourceIndex = 1, #sourceArray do
			-- Get the next feature, but only accept it if it is a table and it contains valid keys and value types.
			-- It is okay if the table is missing the "required" key, because Android allows this attribute to be missing.
			local sourceEntry = sourceArray[sourceIndex]
			if (("table" == type(sourceEntry)) and
			    ("string" == type(sourceEntry["name"])) and
			    ((not sourceEntry["required"]) or ("boolean" == type(sourceEntry["required"])))) then
				
				-- Check if feature array already contains the "build.settings" element.
				local targetEntry = nil
				for targetIndex = 1, #usesFeatures do
					targetEntry = usesFeatures[targetIndex]
					if sourceEntry["name"] == targetEntry["name"] then
						break
					end
					targetEntry = nil
				end
				if targetEntry then
					-- Update the existing array entry, but only if it is setting "required" to true.
					-- Never change a "required=true" setting to "false".
					if ("boolean" == type(sourceEntry["required"])) then
						targetEntry["required"] = targetEntry["required"] or sourceEntry["required"]
					end
				else
					-- Append new feature to the array.
					-- Do not do a direct table copy. Copy only the keys that we support.
					-- For example, ignore the "glEsVersion" since only Corona is allowed to set the min OpenGL requirement.
					-- Also, it is okay for the "required" attribute to be omitted.
					local newEntry = {name = sourceEntry["name"]}
					if ("boolean" == type(sourceEntry["required"])) then
						newEntry["required"] = sourceEntry["required"]
					end
					table.insert(usesFeatures, newEntry)
				end
			end
		end
	end
end

-- Fetches the entries in argument "sourceArray" and inserts them into the "mainIntentFilterCategories" table.
local function fetchMainIntentFilterCategoriesFrom(sourceArray)
	if "table" == type(sourceArray) then
		for index = 1, #sourceArray do
			local categoryName = sourceArray[index]
			if ("string" == type(categoryName)) and (string.len(categoryName) > 0) then
				if string.sub(categoryName, 1, 1) == "." then
					categoryName = packageName .. categoryName
				end
				mainIntentFilterCategories[categoryName] = true
			end
		end
	end
end

-- Fetches the tables from argument "sourceArray" and inserts them into the "intentFilters" table.
local function fetchIntentFiltersFrom(sourceArray)
	if "table" == type(sourceArray) then
		for key, value in pairs(sourceArray) do
			if "table" == type(value) then
				table.insert(intentFilters, value)
			end
		end
	end
end

-- Fetches the entries in argument "source" and inserts them them into the "applicationChildXmlElements" table.
local function fetchApplicationChildXmlElementsFrom(source)
	-- Fetch the plugin XML tags to be inserted into the AndroidManifest.xml file.
	if "table" == type(source) then
		for index = 1, #source do
			local nextElement = source[index]
			if ("string" == type(nextElement)) and (string.len(nextElement) > 0) then
				applicationChildXmlElements[nextElement] = true
			end
		end
	elseif "string" == type(source) then
		fetchApplicationChildXmlElementsFrom({ source })
	end
end

-- Creates an intent filter "data" XML tag from the given argument.
-- Argument "source" is expected to be a table of the data tag's attributes.
-- Returns the XML tag as a string. Returns nil if given an invalid argument.
local function createIntentFilterDataTagFrom(source)
	-- Create the tag's attributes from the given argument's table entries.
	local attributesString = ""
	if "table" == type(source) then
		for key, value in pairs(source) do
			if ("string" == type(key)) and (string.len(key) > 0) and ("string" == type(value)) then
				attributesString = attributesString .. 'android:' .. key .. '="' .. value .. '" '
			end
		end
	end

	-- Create and return the XML tag string.
	local tagString = nil
	if string.len(attributesString) > 0 then
		tagString = "<data " .. attributesString .. "/>"
	end
	return tagString
end


----------------------------------------------------------------------------------------------------
-- Fetch "build.properties" information.
----------------------------------------------------------------------------------------------------

if buildProperties then
	-- Fetch the package name.
	if "string" == type(buildProperties.packageName) then
		packageName = buildProperties.packageName
	end

	-- Fetch version code and version string.
	fetchVersionCodeFrom(buildProperties.versionCode)
	fetchVersionNameFrom(buildProperties.versionName)

	-- Fetch the targeted app store.
	if ("string" == type(buildProperties.targetedAppStore)) and (string.len(buildProperties.targetedAppStore) > 0) then
		targetedAppStore = buildProperties.targetedAppStore
	end
end


----------------------------------------------------------------------------------------------------
-- Fetch "build.settings" information.
----------------------------------------------------------------------------------------------------

local buildSettings = nil
if buildProperties then
	buildSettings = buildProperties.buildSettings
end
if "table" == type(buildSettings) then
	-- Fetch the old "androidPermissions" table first for backward compatibility.
	-- Permissions set within the "android" table will be read later.
	fetchUsesPermissionsFrom(buildSettings.androidPermissions)

	-- Fetch orientation settings.
	if "table" == type(buildSettings.orientation) then
		hasOrientationTable = true

		-- Fetch the default orientation.
		-- Note that Android 2.2 only supports "portrait" and "landscape".
		local stringValue = buildSettings.orientation.default
		if ("string" == type(stringValue)) then
			if ("portrait" == stringValue) then
				supportsOrientationPortrait = true
				defaultOrientation = "portrait"
			elseif ("portraitUpsideDown" == stringValue) then
				supportsOrientationPortraitUpsideDown = true
				defaultOrientation = "portrait"
			elseif ("landscapeRight" == stringValue) or ("landscape" == stringValue) then
				supportsOrientationLandscapeRight = true
				defaultOrientation = "landscape"
			elseif ("landscapeLeft" == stringValue) then
				supportsOrientationLandscapeLeft = true
				defaultOrientation = "landscape"
			end
		end

		-- Fetch all supported orientations.
		local supported = buildSettings.orientation.supported
		if "table" == type(supported) then
			for i = 1 , #supported do
				stringValue = supported[i]
				if ("string" == type(stringValue)) then
					if ("portrait" == stringValue) then
						supportsOrientationPortrait = true
					elseif ("portraitUpsideDown" == stringValue) then
						supportsOrientationPortraitUpsideDown = true
					elseif ("landscapeRight" == stringValue) then
						supportsOrientationLandscapeRight = true
					elseif ("landscapeLeft" == stringValue) then
						supportsOrientationLandscapeLeft = true
					elseif ("landscape" == stringValue) then
						supportsOrientationLandscapeRight = true
					end
				end
			end
		end

		-- Determine if this app supports orientation changes.
		if (supportsOrientationPortrait or supportsOrientationPortraitUpsideDown) and
		   (supportsOrientationLandscapeRight or supportsOrientationLandscapeLeft) then
			supportsOrientationChange = true
		end
	end
	
	-- Fetch settings within the Android table.
	if "table" == type(buildSettings.android) then
		-- Fetch the version code.
		fetchVersionCodeFrom(buildSettings.android.versionCode)
		
		-- Fetch version name. This can be either a string or number. (Number is converted to string.)
		fetchVersionNameFrom(buildSettings.android.versionName)

		-- Fetch the "usesExpansionFile" flag.
		if type(buildSettings.android.usesExpansionFile) == "boolean" then
			usesExpansionFile = buildSettings.android.usesExpansionFile
		end

		-- Fetch the large heap flag.
		if type(buildSettings.android.largeHeap) == "boolean" then
			largeHeap = buildSettings.android.largeHeap
		end
		
		-- Fetch install location.
		stringValue = buildSettings.android.installLocation
		if ("string" == type( stringValue )) and (string.len( stringValue ) > 0) then
			installLocation = stringValue
		end

		stringValue = buildSettings.android.googlePlayGamesAppId
		if ("string" == type( stringValue )) and (string.len( stringValue ) > 0) then
			googlePlayGamesAppId = stringValue
		elseif "number" == type( stringValue ) then
			googlePlayGamesAppId = tostring(stringValue)
		end
		
		-- Fetch permissions to be added as <permission> tags to the AndroidManifest.xml file.
		-- These are used to create new permissions, not to use/request permissions.
		fetchPermissionsFrom(buildSettings.android.permissions)

		-- Fetch permissions to be added as <uses-permission> tags to the AndroidManifest.xml file.
		fetchUsesPermissionsFrom(buildSettings.android.usesPermissions)
		
		-- Fetch screen sizes supported.
		if "table" == type(buildSettings.android.supportsScreens) then
			for settingName, settingValue in pairs(buildSettings.android.supportsScreens) do
				supportsScreens[settingName] = tostring(settingValue)
			end
		end
		
		-- Fetch "usesFeatures" settings.
		fetchUsesFeaturesFrom(buildSettings.android.usesFeatures)

		-- Fetch the "mainIntentFilter" settings.
		if "table" == type(buildSettings.android.mainIntentFilter) then
			fetchMainIntentFilterCategoriesFrom(buildSettings.android.mainIntentFilter.categories)
		end

		-- Fetch custom intent filters.
		fetchIntentFiltersFrom(buildSettings.android.intentFilters)
	end
end

-- If a default orientation has not been found, then assign one.
-- Note that Android 2.2 only supports "portrait" and "landscape".
if (not defaultOrientation) then
	if (supportsOrientationPortrait or supportsOrientationPortraitUpsideDown) then
		defaultOrientation = "portrait"
	elseif (supportsOrientationLandscapeRight or supportsOrientationLandscapeLeft) then
		defaultOrientation = "landscape"
	else
		defaultOrientation = "portrait"
		supportsOrientationPortrait = true
	end
end


----------------------------------------------------------------------------------------------------
-- Fetch plugin settings information.
----------------------------------------------------------------------------------------------------

if "table" == type(pluginSettingsCollection) then
	for index = 1, #pluginSettingsCollection do
		-- Merge the next plugin's settings with the above build settings.
		local pluginSettings = pluginSettingsCollection[index]
		if "table" == type(pluginSettings) then
			fetchPermissionsFrom(pluginSettings.permissions)
			fetchUsesPermissionsFrom(pluginSettings.usesPermissions)
			fetchUsesFeaturesFrom(pluginSettings.usesFeatures)
			if "table" == type(pluginSettings.mainIntentFilter) then
				fetchMainIntentFilterCategoriesFrom(pluginSettings.mainIntentFilter.categories)
			end
			fetchIntentFiltersFrom(pluginSettings.intentFilters)
			fetchApplicationChildXmlElementsFrom(pluginSettings.applicationChildElements)
		end
	end
end


----------------------------------------------------------------------------------------------------
-- Create XML tag and attribute strings from the given build settings.
----------------------------------------------------------------------------------------------------

local stringBuffer
local stringArray
local manifestKeys = {}

-- Store basic app settings.
manifestKeys.USER_APP_NAME = appName
manifestKeys.USER_ACTIVITY_PACKAGE = packageName
manifestKeys.USER_VERSION_CODE = tostring(versionCode)
manifestKeys.USER_VERSION_NAME = versionName
manifestKeys.USER_INSTALL_LOCATION = installLocation

-- Create a meta-data tag for the targeted app store if provided.
stringBuffer = ""
if ("string" == type(targetedAppStore)) and (string.len(targetedAppStore) > 0) then
	stringBuffer = '<meta-data android:name="targetedAppStore" android:value="' .. targetedAppStore .. '" />'
end
manifestKeys.USER_TARGETED_APP_STORE = stringBuffer

-- Create a meta-data tag for the "usesExpansionFile" setting if provided and only if targeting Google Play.
stringBuffer = ""
if usesExpansionFile and (targetedAppStore == "google") then
	stringBuffer = '<meta-data android:name="usesExpansionFile" android:value="true" />'
end
manifestKeys.USER_USES_EXPANSION_FILE = stringBuffer

stringBuffer = ""
if googlePlayGamesAppId then
	stringBuffer = '<meta-data android:name="com.google.android.gms.games.APP_ID" android:value="\\ ' .. googlePlayGamesAppId .. '" />'
end
manifestKeys.USER_USES_GOOGLE_PLAY_GAMES = stringBuffer

-- Create a "largeHeap" application tag attribute if set.
stringBuffer = ""
if largeHeap == true then
	stringBuffer = 'android:largeHeap="true"'
end
manifestKeys.USER_LARGE_HEAP = stringBuffer

-- Only create a "screenOrientation" attribute if the app does NOT support orientation changes.
stringBuffer = ""
if (not supportsOrientationChange) then
	stringBuffer = 'android:screenOrientation="' .. defaultOrientation .. '"'
end
manifestKeys.USER_DEFAULT_ORIENTATION = stringBuffer

-- Create meta-data tags for all supported orientations.
manifestKeys.USER_SUPPORTED_ORIENTATION_PORTRAIT_UPRIGHT =
		'<meta-data android:name="supportsOrientationPortrait" android:value="' ..
		tostring(supportsOrientationPortrait) .. '" />'
manifestKeys.USER_SUPPORTED_ORIENTATION_PORTRAIT_UPSIDE_DOWN =
		'<meta-data android:name="supportsOrientationPortraitUpsideDown" android:value="' ..
		tostring(supportsOrientationPortraitUpsideDown) .. '" />'
manifestKeys.USER_SUPPORTED_ORIENTATION_LANDSCAPE_RIGHT =
		'<meta-data android:name="supportsOrientationLandscapeRight" android:value="' ..
		tostring(supportsOrientationLandscapeRight) .. '" />'
manifestKeys.USER_SUPPORTED_ORIENTATION_LANDSCAPE_LEFT =
		'<meta-data android:name="supportsOrientationLandscapeLeft" android:value="' ..
		tostring(supportsOrientationLandscapeLeft) .. '" />'

-- Create "permission" tags.
stringBuffer = ""
for index = 1, #permissions do
	local attributesString = ""
	for settingName, settingValue in pairs(permissions[index]) do
		attributesString = attributesString .. 'android:' .. settingName .. '="' .. tostring(settingValue) .. '" '
	end
	if (string.len(attributesString) > 0) then
		stringBuffer = stringBuffer .. "<permission " .. attributesString .. "/>\n\t"
	end
end
manifestKeys.USER_PERMISSIONS = stringBuffer

-- Create "uses-permission" tags.
stringBuffer = ""
for permissionName, permissionEnabled in pairs(usesPermissions) do
	if permissionEnabled then
		stringBuffer = stringBuffer .. '<uses-permission android:name="' .. permissionName .. '" />\n\t'
	end
end
manifestKeys.USER_USES_PERMISSIONS = stringBuffer

-- Create a "supports-screens" tag if settings were provided.
stringBuffer = ""
for settingName, settingValue in pairs(supportsScreens) do
	stringBuffer = stringBuffer .. 'android:' .. settingName .. '="' .. settingValue .. '" '
end
if (string.len(stringBuffer) > 0) then
	stringBuffer = "<supports-screens " .. stringBuffer .. "/>"
end
manifestKeys.USER_SUPPORTS_SCREENS = stringBuffer

-- Create "uses-feature" tags.

-- If the application is landscape only then we don't want the uses portrait feature since it will remove the landscape only devices
-- which is caused by the CameraActivity's screenOrientation property in the manifest

-- Check for a user setting so it won't be overridden
local hasUseLandScapeFeature = false
local hasUsePortraitFeature = false
for index = 1, #usesFeatures do
	if usesFeatures[index].name == "android.hardware.screen.portrait" then
		hasUsePortraitFeature = true
	end
	if usesFeatures[index].name == "android.hardware.screen.landscape" then
		hasUseLandScapeFeature = true
	end
end

if not hasUsePortraitFeature then
	-- If the app only supports portrait then its required or theres no settings and everything defaults to portrait
	local required = not supportsOrientationLandscapeRight and 
					 not supportsOrientationLandscapeLeft
	table.insert(usesFeatures, {name = "android.hardware.screen.portrait", required = required})
end

if not hasUseLandScapeFeature then
	-- If the app only supports landscape then its required
	local required = (supportsOrientationLandscapeRight or supportsOrientationLandscapeLeft) and 
					 hasOrientationTable and
					 not supportsOrientationPortrait and 
					 not supportsOrientationPortraitUpsideDown
	table.insert(usesFeatures, {name = "android.hardware.screen.landscape", required = required})
end

stringBuffer = ""
for index = 1, #usesFeatures do
	local attributesString = ""
	for settingName, settingValue in pairs(usesFeatures[index]) do
		attributesString = attributesString .. 'android:' .. settingName .. '="' .. tostring(settingValue) .. '" '
	end
	if (string.len(attributesString) > 0) then
		stringBuffer = stringBuffer .. "<uses-feature " .. attributesString .. "/>\n\t"
	end
end
manifestKeys.USER_USES_FEATURES = stringBuffer

-- Create the main intent filter's "category" tags.
stringArray = {}
for categoryName, categoryEnabled in pairs(mainIntentFilterCategories) do
	if categoryEnabled then
		stringBuffer = string.format('<category android:name="%s"/>', categoryName)
		table.insert(stringArray, stringBuffer)
	end
end
manifestKeys.USER_MAIN_INTENT_FILTER_CATEGORIES = table.concat(stringArray, "\n\t\t\t\t")

-- Create all of the custom intent filter tags and concatenate them into one string.
stringBuffer = ""
for index = 1, #intentFilters do
	local nextIntentFilter = intentFilters[index]

	-- Append the start tag.
	stringBuffer = stringBuffer .. "<intent-filter "
	if ("string" == type(nextIntentFilter.label)) and (string.len(nextIntentFilter.label) > 0) then
		stringBuffer = stringBuffer .. 'android:label="' .. nextIntentFilter.label .. '"'
	end
	stringBuffer = stringBuffer .. ">\n"

	-- Append the action tags.
	if "table" == type(nextIntentFilter.actions) then
		for actionIndex = 1, #nextIntentFilter.actions do
			local actionName = nextIntentFilter.actions[actionIndex]
			if ("string" == type(actionName)) and (string.len(actionName) > 0) then
				if string.sub(actionName, 1, 1) == "." then
					actionName = packageName .. actionName
				end
				stringBuffer = stringBuffer .. '\t\t\t\t<action android:name="' .. actionName .. '"/>\n'
			end
		end
	end

	-- Append the category tags.
	if "table" == type(nextIntentFilter.categories) then
		for categoryIndex = 1, #nextIntentFilter.categories do
			local categoryName = nextIntentFilter.categories[categoryIndex]
			if ("string" == type(categoryName)) and (string.len(categoryName) > 0) then
				if string.sub(categoryName, 1, 1) == "." then
					categoryName = packageName .. categoryName
				end
				stringBuffer = stringBuffer .. '\t\t\t\t<category android:name="' .. categoryName .. '"/>\n'
			end
		end
	end

	-- Append the data tags.
	if "table" == type(nextIntentFilter.data) then
		stringArray = {}

		-- Attempt to fetch one data tag at the root level of this table.
		local dataTagString = createIntentFilterDataTagFrom(nextIntentFilter.data)
		if dataTagString then
			table.insert(stringArray, "\t\t\t\t" .. dataTagString)
		end

		-- Attempt to fetch an array of data tags within this table.
		for key, value in pairs(nextIntentFilter.data) do
			dataTagString = createIntentFilterDataTagFrom(value)
			if dataTagString then
				table.insert(stringArray, "\t\t\t\t" .. dataTagString)
			end
		end

		-- Append all of the data tags to the end of the string buffer.
		if #stringArray > 0 then
			stringBuffer = stringBuffer .. table.concat(stringArray, "\n") .. "\n"
		end
	end

	-- Append the end tag.
	stringBuffer = stringBuffer .. "\t\t\t</intent-filter>\n\t\t\t"
end
manifestKeys.USER_INTENT_FILTERS = stringBuffer

-- Create the XML elements to be inserted as children within the "application" block.
stringArray = {}
for elementString, elementEnabled in pairs(applicationChildXmlElements) do
	if elementEnabled then
		table.insert(stringArray, elementString)
	end
end
manifestKeys.USER_APP_CHILD_XML_ELEMENTS = table.concat(stringArray, "\n\t\t")


----------------------------------------------------------------------------------------------------
-- Create a new "AndroidManifest.xml" with the given build settings.
----------------------------------------------------------------------------------------------------

-- Open the "AndroidManifest.xml" template file.
-- This file contains @KEY@ strings where we'll insert the given build settings to.
local manifestTemplateFileHandle = io.open( manifestTemplateFilePath, "r" )
if not manifestTemplateFileHandle then
	print( "ERROR: The manifest file does not exist: ", manifestTemplateFilePath )
	os.exit( -1 )
end

-- Copy the template's contents to a new "AndroidManifest.xml" file containing the given build settings.
-- Note: We currently only support one @KEY@ string substitution per line.
local newManifestFileHandle = io.open( newManifestFilePath, "w" )
for line in manifestTemplateFileHandle:lines() do
	for key, value in pairs(manifestKeys) do
		key = "@" .. key .. "@"
		local wasKeyFound = string.find( line, key, 1, true )
		if wasKeyFound then
			line = string.gsub( line, key, value )
			break
		end
	end
	newManifestFileHandle:write( line, "\n" )
end

-- Close the files.
newManifestFileHandle:close()
manifestTemplateFileHandle:close()

