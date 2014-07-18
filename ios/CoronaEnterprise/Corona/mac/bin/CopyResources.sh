#!/bin/bash

# $1 is the build config (if it ends in template, all .lu files are removed from dst dir)
# $2 is the src folder
# $3 is the dst folder
# $4 if "--preserve" preserves png's; default is to compress png's using pngcrush, or see $5
# $5 explicit directory where luac is. If not set, will use `dirname $0` 
shopt -s extglob

BUILD_CONFIG=$1
SRC_DIR="$2"
DST_DIR="$3"

#
# Checks exit value for error
# 
checkError() {
	if [ $? -ne 0 ]
	then
		echo "Exiting due to errors (above)"
		exit -1
	fi
}

# Initialize luac directory
# NOTE: luac must be in same dir as this file
LUAC_DIR=`dirname "$0"`
if [[ $4 == "--preserve" ]]; then
	CORONA_COPY_PNG_PRESERVE="--preserve"
	if [[ $5 != "" ]]; then
		# Take the user's luac directory
		LUAC_DIR=$5
	fi
elif [[ $4 != "" ]]; then
	# Take the user's luac directory
	LUAC_DIR=$4
fi

if [[ $BUILD_CONFIG == *-template* ]]; then
	for file in $DST_DIR/*.lu
	do
		filebase=`basename "$file"`
		case "$filebase" in
			'main.lu') echo "Removing $file"; rm $file ;;
		esac
	done
else
	# Warning: Apple has moved these tools before. This is really fragile.
	DEVELOPER_BASE=`xcode-select -print-path`
	COPY_COMMAND="$DEVELOPER_BASE/Library/PrivateFrameworks/DevToolsCore.framework/Resources/pbxcp"
	PATH="$DEVELOPER_BASE/Platforms/iPhoneOS.platform/Developer/usr/bin:/Developer/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin"
	export COPY_COMMAND
	export PATH

	COPYPNG="$DEVELOPER_BASE/Platforms/iPhoneOS.platform/Developer/Library/Xcode/Plug-ins/iPhoneOS Build System Support.xcplugin/Contents/Resources/copypng"
	if ( [ ! -f "$COPYPNG" ] ) then
		# fallback for Xcode 4 (preview 3) moves the location	
		COPYPNG="$DEVELOPER_BASE/Platforms/iPhoneOS.platform/Developer/Library/Xcode/PrivatePlugIns/iPhoneOS Build System Support.xcplugin/Contents/Resources/copypng"
		if ( [ ! -f "$COPYPNG" ] ) then
			# fallback for Xcode 4.5 (preview 4) moves the location	again
			COPYPNG="$DEVELOPER_BASE/Platforms/iPhoneOS.platform/Developer/usr/bin/copypng"
		fi
	fi

	SRC_DIR_ESCAPED=$(echo "$SRC_DIR" | sed -E 's/[$\/\.*()+?^]/\\&/g')

	# for file in "$SRC_DIR"/*
	find -H "$SRC_DIR" -print | while read file;
	do
		if [ "$file" != "$SRC_DIR" ]
		then
			# Create paths relative to $SRC_DIR
			filebase=$(echo "$file" | sed -E "s/$SRC_DIR_ESCAPED\/(.*)/\1/")

			if ( [ -d "$file" ] )
			then
				mkdir -p "$DST_DIR/$filebase"
			else
				case "$filebase" in
					*.lua)
						if [[ $BUILD_CONFIG == @(Debug|DEBUG|debug)* ]]; then
							OPTIONS=
						else
							OPTIONS=-s
						fi

						# Convert directory separator '/' to '.' in $filebase
						filebase=$(echo "$filebase" | sed -E "s/\//\./g")

						file_bytecode=`basename -s lua "$filebase"`lu
						echo "Compiling $file ===> $file_bytecode";
						$LUAC_DIR/luac $OPTIONS -o "$DST_DIR"/"$file_bytecode" "$file"
						checkError
						;;
					build.settings) ;; #echo "Ignoring $file";;
					*.png)
						if [[ $CORONA_COPY_PNG_PRESERVE == "--preserve" ]]; then
							echo "Copying $file to $DST_DIR/$filebase"; 

							# Copy file to dst
							cp -v "$file" "$DST_DIR/$filebase"
							checkError
						else
							echo "Compressing/copying PNG $file to $DST_DIR/$filebase"

							# Compress PNG and copy to dst
							"$COPYPNG" -compress "$file" "$DST_DIR/$filebase"
							checkError
						fi
						;;
					*)
						echo "Copying $file to $DST_DIR/$filebase"

						# Copy file to dst
						cp -v "$file" "$DST_DIR/$filebase"
						checkError
						;;
				esac
			fi
		fi
	done
fi
