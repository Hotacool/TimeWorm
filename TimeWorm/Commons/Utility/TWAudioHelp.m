//
//  TWAudioHelp.m
//  TimeWorm
//
//  Created by macbook on 16/12/18.
//  Copyright © 2016年 Hotacool. All rights reserved.
//

#import "TWAudioHelp.h"
#import <AudioToolbox/AudioServices.h>

@implementation TWAudioHelp

+ (void)playTimerComplete {
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
