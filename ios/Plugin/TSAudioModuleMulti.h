//
//  TSAudio.h
//  CoronaSampleApp
//
//  Created by 小田謙太郎 on 12/12/10.
//
//

#ifndef __CoronaSampleApp__TSAudioMulti__
#define __CoronaSampleApp__TSAudioMulti__

#include "CoronaLua.h"
#import <AVFoundation/AVFoundation.h>
#import "TSAudioModuleMultiImpl.h"

class TSAudioModuleMulti
{
public:
    typedef TSAudioModuleMulti Self;
    
public:
    static const char *Name();
    static int Open( lua_State *L );
    static lua_State* getLuaState();
protected:
    static TSAudioModuleMultiImpl* sImpl;
    static lua_State *sLuaState;

    static int durationOfFile(lua_State* L);

    static int startRecord(lua_State *L);
    static int stopRecord(lua_State *L);
    static int isRecording(lua_State *L);
    
    static int startPlay(lua_State *L);
    static int stopPlay(lua_State *L);
    static int pausePlay(lua_State *L);
    static int resumePlay(lua_State* L);
    static int durationOfPlay(lua_State* L);
    static int currentTimeOfPlay(lua_State* L);
    static int isPlaying(lua_State *L);
    
};


#endif /* defined(__CoronaSampleApp__TSAudioMulti__) */
