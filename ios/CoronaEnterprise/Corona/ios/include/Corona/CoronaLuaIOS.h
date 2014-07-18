// ----------------------------------------------------------------------------
// 
// CoronaLuaIOS.h
// Copyright (c) 2013 Corona Labs Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#ifndef _CoronaLuaIOS_H__
#define _CoronaLuaIOS_H__

#include "CoronaMacros.h"

struct lua_State;

@class NSDictionary;

// ----------------------------------------------------------------------------

CORONA_API NSDictionary *CoronaLuaCreateDictionary( lua_State *L, int index );

// ----------------------------------------------------------------------------

#endif // _CoronaLuaIOS_H__
