//
//  TWAudioHelp.m
//  TimeWorm
//
//  Created by macbook on 16/12/18.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWAudioHelp.h"
#import <AudioToolbox/AudioServices.h>
#import "TWSet.h"

@implementation TWAudioHelp

+ (void)playTimerComplete {
    if (![TWSet currentSet].isVoiceOn) {
        return;
    }
    static SystemSoundID soundID;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        NSString * file_sound = [[NSBundle mainBundle] pathForResource:@"pp" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:file_sound], &soundID);
    });
    AudioServicesPlayAlertSound(soundID);
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}
@end
