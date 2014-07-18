//
//  TSAudio.cpp
//  CoronaSampleApp
//
//  Created by 小田謙太郎 on 12/12/10.
//
//

#include "TSAudioModuleMulti.h"

#import "CoronaRuntime.h"
#import "CoronaLua.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TSAudioModuleMultiImpl.h"


// ----------------------------------------------------------------------------

// static class member initialization
TSAudioModuleMultiImpl* TSAudioModuleMulti::sImpl = nil;
lua_State* TSAudioModuleMulti::sLuaState = NULL;

int
TSAudioModuleMulti::durationOfFile(lua_State* L)
{
    lua_Number result = 0.0f;
    @autoreleasepool {
		const char *filePathC = lua_tostring( L, 1 );
		NSString *filePath = [NSString stringWithUTF8String:filePathC];
        
        // start record
        result = [sImpl durationOfFile :filePath];
    }
    
    lua_pushnumber(L, result);
    return 1;
}

int
TSAudioModuleMulti::startRecord(lua_State *L)
{
    int result = -1;
    @autoreleasepool {
        
        // First argument contains the message
		const char *filePathC = lua_tostring( L, 1 );
		NSString *filePath = [NSString stringWithUTF8String:filePathC];
        
        // sampling freq
		float samplFreq = (float)lua_tonumber(L, 2);
        // default sampl freq 16kHz
        samplFreq = (samplFreq == 0.0f) ? 16000.0f : samplFreq;
        if (samplFreq < 0.0f) {
            NSLog(@"startRecord: assumes samplFreq > 0.0");
            goto error;
        }
        
        // num of channels
		int channels = lua_tointeger(L, 3);
        // default channels 1
        channels = (channels == 0) ? 1 : channels;
        if (channels < 0) {
            NSLog(@"startRecord: assumes channels > 0");
            goto error;
        }
        
        // start record
        result = [sImpl startRecord:filePath quality:0 samplingFreq:samplFreq channels:channels];
    }
    
error:
    lua_pushinteger(L, result);
    return 1;
}

int
TSAudioModuleMulti::stopRecord(lua_State *L)
{
    @autoreleasepool {
        // stop record
        [sImpl stopRecord];
    }
    return 0;
}

int
TSAudioModuleMulti::isRecording(lua_State *L)
{

    @autoreleasepool {
        if ([sImpl isRecording]) {
            lua_pushboolean(L, 1);
        } else {
            lua_pushboolean(L, 0);
        }
    }
    return 1; // num of results
}

int
TSAudioModuleMulti::startPlay(lua_State *L)
{

    int result = -1;
    @autoreleasepool {
        
        // First argument contains the message
		const char *filePathC = lua_tostring( L, 1 );
		NSString *filePath = [NSString stringWithUTF8String:filePathC];
        
        // Second argument contains the string id of a player
        NSString *playerStrID = nil;
        
        // start play
        result = [sImpl startPlay: filePath withId: &playerStrID ];
        
        // return result
        lua_pushinteger(L, result);
        // return playerId
        const char* strIdC = (playerStrID != nil) ? [playerStrID UTF8String] : "";
        lua_pushstring(L, strIdC);
    }
    
    return 2;
}

int
TSAudioModuleMulti::pausePlay(lua_State *L)
{
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];
        //pause play
        [sImpl pausePlayFor:playerID];
    }
    return 0;
}

int
TSAudioModuleMulti::resumePlay(lua_State* L)
{
    BOOL result = YES;
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];
        //resume play
        result = [sImpl resumePlayFor:playerID];
    }
    lua_pushboolean(L, result);
    return 1;
}

int
TSAudioModuleMulti::stopPlay(lua_State *L)
{
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];
        // stop play
        [sImpl stopPlayFor:playerID];
    }
    return 0;
}

int
TSAudioModuleMulti::isPlaying(lua_State *L)
{
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];

        
        if ([sImpl isPlayingFor: playerID ]) {
            lua_pushboolean(L, 1);
        } else {
            lua_pushboolean(L, 0);
        }
    }
    return 1; // number of results
}

int
TSAudioModuleMulti::durationOfPlay(lua_State* L)
{
    lua_Number result = 0.0f;
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];
        result = [sImpl durationOfPlayFor: playerID];
    }

    lua_pushnumber(L, result);
    return 1;
}

int
TSAudioModuleMulti::currentTimeOfPlay(lua_State* L)
{
    lua_Number result = 0.0f;
    @autoreleasepool {
        // First argument contains the string id of a player
		const char *playerIDC = lua_tostring( L, 1 );
		NSString *playerID = [NSString stringWithUTF8String:playerIDC];
        result = [sImpl currentTimeOfPlayFor:playerID];
    }
    lua_pushnumber(L, result);
    return 1;
}

// ----------------------------------------------------------------------------

const char *
TSAudioModuleMulti::Name()
{
	static const char sName[] = "tsaudiomulti-native";
	return sName;
}

int
TSAudioModuleMulti::Open( lua_State *L )
{
	const luaL_Reg kVTable[] =
	{
		{ "startRecord", TSAudioModuleMulti::startRecord },
		{ "stopRecord", TSAudioModuleMulti::stopRecord },
		{ "isRecording", TSAudioModuleMulti::isRecording },
        
		{ "startPlay", TSAudioModuleMulti::startPlay },
		{ "stopPlay", TSAudioModuleMulti::stopPlay },
		{ "pausePlay", TSAudioModuleMulti::pausePlay },
		{ "resumePlay", TSAudioModuleMulti::resumePlay },
		{ "isPlaying", TSAudioModuleMulti::isPlaying },
        { "durationOfPlay", TSAudioModuleMulti::durationOfPlay },
        { "currentTimeOfPlay", TSAudioModuleMulti::currentTimeOfPlay },
        
        { "durationOfFile", TSAudioModuleMulti::durationOfFile },
        
		{ NULL, NULL }
	};
    
	// Ensure upvalue is available to library
	void *context = lua_touserdata( L, lua_upvalueindex( 1 ) );
	lua_pushlightuserdata( L, context );
    
	luaL_openlib( L, Name(), kVTable, 1 ); // leave "mylibrary" on top of stack
    
    // init TSAudioImpl
    if (sImpl == nil) {
        sImpl = [[TSAudioModuleMultiImpl alloc] init];
    }
    
    // set lua state
    sLuaState = L;

	return 1;
}

lua_State*
TSAudioModuleMulti::getLuaState()
{
    assert(sLuaState != NULL);
    return sLuaState;
}
