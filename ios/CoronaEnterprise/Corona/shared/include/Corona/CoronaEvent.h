// ----------------------------------------------------------------------------
// 
// CoronaEvent.h
// Copyright (c) 2012 Corona Labs Inc. All rights reserved.
// 
// ----------------------------------------------------------------------------

#ifndef _CoronaEvent_H__
#define _CoronaEvent_H__

#include "CoronaMacros.h"

// Generic property keys
// ----------------------------------------------------------------------------

// String: 'event.name'
CORONA_API const char *CoronaEventNameKey();

// String: 'event.provider'
CORONA_API const char *CoronaEventProviderKey();

// String: 'event.phase'
CORONA_API const char *CoronaEventPhaseKey();

// String: 'event.type'
CORONA_API const char *CoronaEventTypeKey();

// String: 'event.response'
CORONA_API const char *CoronaEventResponseKey();

// Boolean: 'event.isError'
CORONA_API const char *CoronaEventIsErrorKey();

// Number: 'event.errorCode'
CORONA_API const char *CoronaEventErrorCodeKey();


// Event types for library providers
// ----------------------------------------------------------------------------

// For "ads" providers
CORONA_API const char *CoronaEventAdsRequestName();

// For "gameNetwork" providers
CORONA_API const char *CoronaEventGameNetworkName();

// For "native.popup" providers
CORONA_API const char *CoronaEventPopupName();

// ----------------------------------------------------------------------------

#endif // _CoronaEvent_H__
