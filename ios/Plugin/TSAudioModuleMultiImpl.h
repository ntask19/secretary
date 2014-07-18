//
//  TSAudioModuleMultiImpl.h
//  Talkspace
//
//  Created by 小田謙太郎 on 13/01/04.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#include "CoronaLua.h"

@interface TSAudioModuleMultiImpl : NSObject<AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder* recorder;
    NSMutableDictionary* players;
}

-(id)init;
-(void)dealloc;

// common
+(void)setupAudioSession:(NSString*)session;
-(NSTimeInterval)durationOfFile:(NSString*)filePath;

// session control
-(void)beginSessionRec;
-(void)endSessionRec;
-(void)beginSessionPlay;
-(void)endSessionPlay;

-(NSString*)stringIdOf:(id)object;
-(AVAudioPlayer *)playerOfStrId:(NSString *)stringId;


// recording
-(int)startRecord:(NSString*)filePath quality:(int)quality samplingFreq:(float)samplFreq channels:(int) channels;
-(void)stopRecord;
-(BOOL)isRecording;

// playing
-(int)startPlay:(NSString*)filePath withId:(NSString **)objectId;
-(void)pausePlayFor:(NSString *)playerId;
-(BOOL)resumePlayFor:(NSString *)playerId;
-(void)stopPlayFor:(NSString *)playerId;
-(BOOL)isPlayingFor:(NSString *)playerId;
-(NSTimeInterval)durationOfPlayFor:(NSString *)playerId;
-(NSTimeInterval)currentTimeOfPlayFor:(NSString *)playerId;
-(void)setVolume:(float)volume playFor:(NSString *)playerId;
-(float)volumeOfPlayFor:(NSString *)playerId;
-(void)setLoop:(int)loop playFor:(NSString *)playerId;
-(int)loopOfPlayFor:(NSString *)playerId;

// delegate handling
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)aPlayer error:(NSError *)error;
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag;
-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)aRecorder error:(NSError *)error;

@property (nonatomic, retain) AVAudioRecorder* recorder;
@property (nonatomic, retain) NSMutableDictionary* players;

@end
