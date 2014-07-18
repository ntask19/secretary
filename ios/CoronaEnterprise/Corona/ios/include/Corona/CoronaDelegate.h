// ----------------------------------------------------------------------------
// 
// CoronaDelegate.h
// Copyright (c) 2012 Ansca, Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#ifndef _CoronaDelegate_H__
#define _CoronaDelegate_H__

#import <UIKit/UIApplication.h>

@protocol CoronaRuntime;

// ----------------------------------------------------------------------------

@protocol CoronaDelegate<NSObject, UIApplicationDelegate>

- (void)willLoadMain:(id<CoronaRuntime>)runtime;
- (void)didLoadMain:(id<CoronaRuntime>)runtime;

@end

// ----------------------------------------------------------------------------

#endif // _CoronaDelegate_H__