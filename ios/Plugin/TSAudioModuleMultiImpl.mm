//
//  TSAudioModuleMultiImpl.m
//  Talkspace
//
//  Created by 小田謙太郎 on 13/01/04.
//
//

#import "TSAudioModuleMulti.h"
#import "TSAudioModuleMultiImpl.h"

@implementation TSAudioModuleMultiImpl
@synthesize recorder;
@synthesize players;


-(id)init
{
    self = [super init];
    if (self != nil) {
        [TSAudioModuleMultiImpl setupAudioSession: AVAudioSessionCategoryPlayback];
        self.players = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

+(void)setupAudioSession:(NSString*)session
{
    //    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    // setup enable background playback
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //[audioSession setCategory:session error:nil];
    //[audioSession setCategory:session withOptions:AVAudioSessionCategoryOptionMixWithOthers || AVAudioSessionCategoryOptionDuckOthers error:nil];
    [audioSession setCategory:session withOptions:nil error:nil];
}

-(void)beginSessionRec
{
//    if (players.count == 0) {
        NSError* error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        [audioSession setCategory:AVAudioSessionCategoryRecord withOptions:nil error:nil];
        [audioSession setMode:AVAudioSessionModeDefault error:&error];
        if (error != nil) {
            NSLog(@"AVAudioSession setMode: error: %@ ", error);
            error = nil;
        }
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (error != nil) {
            NSLog(@"AVAudioSession setActive:YES error:%@ ", error);
        }
//    }
}

-(void)endSessionRec
{
//    if (players.count == 0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError* error = nil;
        [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions:nil error:nil];
        if (error != nil) {
            NSLog(@"AVAudioSession setActive: NO error:%@ ", error);
        }
//    }
}

-(void)beginSessionPlay
{
//    if (players.count == 0) {
        NSError* error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions: AVAudioSessionCategoryOptionMixWithOthers error:nil];
        [audioSession setCategory:AVAudioSessionCategoryPlayback withOptions: nil error:nil];

        [audioSession setMode:AVAudioSessionModeDefault error:&error];
        if (error != nil) {
            NSLog(@"AVAudioSession setMode: error: %@ ", error);
            error = nil;
        }
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (error != nil) {
            NSLog(@"AVAudioSession setActive:YES error:%@ ", error);
        }
//    }
}

-(void)endSessionPlay
{
    if (players.count == 0) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError* error = nil;
        [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        if (error != nil) {
            NSLog(@"AVAudioSession setActive: NO error:%@ ", error);
        }
    }
}


-(NSString*)stringIdOf:(id)object
{
    NSString* strId = [NSString stringWithFormat:@"%@:%p", [[object class] description], object];
    return strId;
}

-(AVAudioPlayer *)playerOfStrId:(NSString *)stringId
{
    id object = [self.players objectForKey:stringId];
    if ([object isKindOfClass:AVAudioPlayer.class]) {
        return (AVAudioPlayer *)object;
    } else {
        return nil;
    }
}

-(NSTimeInterval)durationOfFile:(NSString*)filePath
{
    NSURL* url = [NSURL fileURLWithPath:filePath];
    AVURLAsset* audioAsset = [AVURLAsset URLAssetWithURL:url options:nil];
    CMTime audioDuration = audioAsset.duration;
    float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

-(int)startRecord:(NSString*)filePath quality:(int)quality samplingFreq:(float)samplFreq channels:(int) channels;
{
    NSURL* url = [NSURL fileURLWithPath:filePath];
    
    
    // 48kHz, 16bit, mono, AAC - produces about 63kbps stream
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                              [NSNumber numberWithInt:AVAudioQualityMedium], AVEncoderAudioQualityKey,
                              //                                    [NSNumber numberWithInt:32], AVEncoderBitRateKey,
                              [NSNumber numberWithInt: channels], AVNumberOfChannelsKey,
                              [NSNumber numberWithFloat:samplFreq], AVSampleRateKey,
                              [NSNumber numberWithInt:16], AVEncoderBitDepthHintKey,
                              nil];
    
    // stop & delete object before start
    if (recorder != nil) {
        [recorder stop];
        self.recorder = nil;
    }
    
    // session record
    [self beginSessionRec];

    // インスタンス生成(エラー処理は省略)
    NSError *error = nil;
    self.recorder = [[[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error] autorelease];
    recorder.delegate = self;
    // 録音ファイルの準備(すでにファイルが存在していれば上書きしてくれる)
    [recorder prepareToRecord];
    // 録音中に音量をとるかどうか
    recorder.meteringEnabled = YES;
    
    //録音開始
    [recorder record];
    
    if (error != nil) {
        NSLog(@"AVAudioRecorder start rec file:%@ error: %@ ", url, error);
        [self endSessionRec];
    } else {
    }
    
    return [error code];
}

-(void)stopRecord
{
    [recorder stop];
    // call stop
    // [self audioRecorderDidFinishRecording:self.recorder successfully:YES];
    //NSLog(@"AVAudioRecorder stop recording");
    
    // session for playing
    // [TSAudioModuleMultiImpl setupAudioSession:AVAudioSessionCategoryPlayback];
}

-(BOOL)isRecording
{
    return [self.recorder isRecording];
}

-(int)startPlay:(NSString*)filePath withId:(NSString **)objectId
{
    NSURL* url = [NSURL fileURLWithPath:filePath];

    // begin session play
    [self beginSessionPlay];
    
    // delete object before start
    NSError* error = nil;
    
    AVAudioPlayer* player = [[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] autorelease];
    if (error != nil) {
        NSLog(@"AVAudioPlayer start playing: error: %@,  file: %@ ", error, url);
        [self endSessionPlay];
    } else {
        // success
        player.delegate = self;
        [player play];

        NSString* strId = [self stringIdOf:player];
        [self.players setObject:player forKey:strId];
        if (objectId != nil) {
            *objectId = strId;
        }
    }
    
    return [error code];
}

-(NSTimeInterval)durationOfPlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return [player duration];
}

-(NSTimeInterval)currentTimeOfPlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return [player currentTime];
}

-(void)pausePlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    [player pause];
}

-(BOOL)resumePlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return [player play];
}

-(void)stopPlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    [player stop];
    // call stop
    [self audioPlayerDidFinishPlaying:player successfully:YES];
}

-(BOOL)isPlayingFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return [player isPlaying];
}

-(void)setVolume:(float)volume playFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    player.volume = volume;
}

-(float)volumeOfPlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return player.volume;
}

-(void)setLoop:(int)loop playFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    player.numberOfLoops = loop;
}

-(int)loopOfPlayFor:(NSString *)playerId
{
    AVAudioPlayer* player = [self playerOfStrId:playerId];
    return player.numberOfLoops;
}


// delegate handling
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)aPlayer error:(NSError *)error
{
    NSLog(@"TSAUDIO-NATIVE: player: %@ error: %@", aPlayer, error);
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)aPlayer successfully:(BOOL)flag
{
    lua_State *L = TSAudioModuleMulti::getLuaState();
    lua_newtable( L );
    {
        // event["name"] = "tsaudiomulti-native-playing-finish"
        const char kNameKey[] = "name";
        const char kValueKey[] = "tsaudiomulti-native-playing-finish";
        lua_pushstring( L, kValueKey );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["phase"] = "finished"
        const char kNameKey[] = "phase";
        const char kValueKey[] = "finished";
        lua_pushstring( L, kValueKey );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["url"] = "file://...../foo/bar.m4a/"
        const char* url = [[aPlayer.url absoluteString] UTF8String];
        url = (url != NULL) ? url : "";
        const char kNameKey[] = "url";
        lua_pushstring( L, url );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["playerId"] = "avaudioplayer:12d4d34af"
        const char* playerId = [[self stringIdOf:aPlayer] UTF8String];
        playerId = (playerId != NULL) ? playerId : "";
        const char kNameKey[] = "playerId";
        lua_pushstring( L, playerId );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["isSuccess"] = false or true
        const char kNameKey[] = "isSuccess";
        const int isSuccessValue = flag;
        lua_pushboolean(L, isSuccessValue );
        lua_setfield( L, -2, kNameKey );
    }
    
    Corona::Lua::RuntimeDispatchEvent( L, -1 );
    lua_pop( L, 1 ); // pop event
    
    // remove from dict
    NSString* strId = [self stringIdOf:aPlayer];
    [self.players removeObjectForKey:strId];
    // NSLog(@"Num of Players: %d", self.players.count);
    
    // finish session
    [self endSessionPlay];

}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)aRecorder error:(NSError *)error
{
    NSLog(@"TSAUDIO-NATIVE: recoder: %@ error: %@", aRecorder, error);
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)aRecorder successfully:(BOOL)flag
{
    lua_State *L = TSAudioModuleMulti::getLuaState();
    lua_newtable( L );
    {
        // event["name"] = "tsaudiomulti-native-recording-finish"
        const char kNameKey[] = "name";
        const char kValueKey[] = "tsaudiomulti-native-recording-finish";
        lua_pushstring( L, kValueKey );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["phase"] = "finished"
        const char kNameKey[] = "phase";
        const char kValueKey[] = "finished";
        lua_pushstring( L, kValueKey );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["url"] = "file://...../foo/bar.m4a/"
        const char* url = [[aRecorder.url absoluteString] UTF8String];
        url = (url) != NULL ? url : "";
        const char kNameKey[] = "url";
        lua_pushstring( L, url );		// All events are Lua tables
        lua_setfield( L, -2, kNameKey );	// that have a 'name' property
    }
    {
        // event["isSuccess"] = false or true
        const char kNameKey[] = "isSuccess";
        const int isSuccessValue = flag;
        lua_pushboolean(L, isSuccessValue );
        lua_setfield( L, -2, kNameKey );
    }
    
    Corona::Lua::RuntimeDispatchEvent( L, -1 );
    lua_pop( L, 1 ); // pop event
    
    // release
    self.recorder = nil;

    // finish recording
    [self endSessionRec];
}

@end
