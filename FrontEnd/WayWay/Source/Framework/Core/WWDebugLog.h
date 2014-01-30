//
//  WWDebugLog.h
//  WayWay
//
//  Created by Ryan DeVore on 5/17/13.
//  Copyright (c) 2013 Happy Fun Corp. All rights reserved.
//

#ifndef __WWDebugLog_h__
#define __WWDebugLog_h__

#define TRACE 1
#define VERBOSE_LOGGING 1

#define __WW_FILE__ [[NSString stringWithUTF8String:__FILE__] lastPathComponent]

#ifndef WWDebugLog
#ifdef DEBUG
#ifdef VERBOSE_LOGGING
#define WWDebugLog(fmt, ...) NSLog((@"%s [%@:%d] - " fmt), __PRETTY_FUNCTION__, __WW_FILE__, __LINE__, ##__VA_ARGS__)
#else
#define WWDebugLog(fmt, ...) NSLog(fmt, ##__VA_ARGS__)
#endif
#else
#define WWDebugLog( s, ... )
#endif // DEBUG
#endif // WWDebugLog

#endif // __UUDebugLog_h__

