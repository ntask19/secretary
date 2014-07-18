// ----------------------------------------------------------------------------
// 
// CoronaRuntime.h
// Copyright (c) 2012 Ansca, Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#ifndef _CoronaRuntime_H__
#define _CoronaRuntime_H__

#include <CoreGraphics/CGGeometry.h>

@class UIViewController;
@class UIWindow;

struct lua_State;

// ----------------------------------------------------------------------------

@protocol CoronaRuntime

@property (nonatomic, readonly, assign) UIWindow *appWindow;
@property (nonatomic, readonly, assign) UIViewController *appViewController;
@property (nonatomic, readonly, assign) lua_State *L;

- (CGPoint)coronaPointToUIKitPoint:(CGPoint)coronaPoint;
- (void)suspend;
- (void)resume;

@end

// ----------------------------------------------------------------------------

#endif // _CoronaRuntime_H__
