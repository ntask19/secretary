#!/bin/bash

BIN_DIR=$PROJECT_DIR/CoronaEnterprise/Corona/mac/bin
ASSETS_DIR="$PROJECT_DIR"/../Corona

"$BIN_DIR/LuaCocoa.framework/Versions/Current/Tools/luacocoa" "$BIN_DIR"/buildSettingsToPlist.lua $ASSETS_DIR "$BUILT_PRODUCTS_DIR/$EXECUTABLE_FOLDER_PATH/"
