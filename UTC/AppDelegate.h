//
//  AppDelegate.h
//  UTC
//
//  Created by Pulsely on 8/12/12.
//  Copyright (c) 2012 Pulsely. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenubarController.h"
#import "NSString+ JRStringAdditions.h"

#define DEFAULTS_SHOW_HIDE_SECONDS @"DEFAULTS_SHOW_HIDE_SECONDS"
#define DEFAULTS_TIME_ZONE @"DEFAULTS_TIME_ZONE"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL show_seconds;
    NSTimeZone *current_time_zone;
}


@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, retain) IBOutlet NSMenuItem *showHideSecondsItem;

@property (nonatomic, retain) IBOutlet NSMenu *statusMenu;
@property (nonatomic, retain) NSString *current_timezone_prefix;

- (void)checkTimezone;
- (IBAction)updateTimezoneAction:(id)sender;
- (IBAction)showHideSecondsAction:(id)sender;
- (IBAction)aboutAction:(id)sender;
- (IBAction)quitAction:(id)sender;

@end
