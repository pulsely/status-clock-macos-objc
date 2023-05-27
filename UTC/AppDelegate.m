//
//  AppDelegate.m
//  UTC
//
//  Created by Pulsely on 8/12/12.
//  Copyright (c) 2012 Pulsely. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize statusItem, showHideSecondsItem, statusMenu, current_timezone_prefix;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Install status item into the menu bar
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS];
    self.statusItem.title = @"";
    
    [self.statusItem setMenu: self.statusMenu];
    

    /*
    for (NSString *t in [NSTimeZone knownTimeZoneNames]) {
        NSLog(@"t: %@", t);
    }*/
    
    //NSTimeZone timeZoneForSecondsFromGMT
    
    show_seconds = YES;
    
    // set defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //NSLog(@"[defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS]: %@:", [defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS]);
    if ([defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS] != nil) {
        if ( [[defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS] isEqual: @"YES"] ) {
            self.showHideSecondsItem.title = @"Hide seconds";
            show_seconds = YES;
        } else {
            self.showHideSecondsItem.title = @"Show seconds";
            show_seconds = NO;
        }
        
    } else {
        self.showHideSecondsItem.title = @"Hide seconds";
        show_seconds = YES;
    }
    
    [self checkTimezone];
    
    [self updateTime: nil];
    [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];

//    if (show_seconds) {
//        [self.statusItem setLength: STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS];
//    } else {
//        [self.statusItem setLength: STATUS_ITEM_VIEW_WIDTH_NO_SECONDS];
//    }
    
    //[self.statusItem setLength: [self.statusItem.title sizeWithAttributes:nil].width + 40.0];
}



- (IBAction)updateTime:(id)sender {
    
    NSString *timezone_format;
    
    if ( show_seconds ) {
        timezone_format = @"HH:mm:ss";
    } else {
        timezone_format = @"HH:mm";
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: timezone_format];
    [formatter setTimeZone: current_time_zone];
    
    NSString *newClock = [formatter stringFromDate:[NSDate date]];
    
    self.statusItem.title = [NSString stringWithFormat: @"%@%@", self.current_timezone_prefix, newClock];
    [self.statusItem setLength: [self.statusItem.title sizeWithAttributes:nil].width + 40.0];

}

- (void)checkTimezone {
    // check current timezone
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey: DEFAULTS_TIME_ZONE] == nil) {
        [defaults setObject: @"GMT / UTC" forKey: DEFAULTS_TIME_ZONE];
        
        current_time_zone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
        self.current_timezone_prefix = @"UTC ";
    } else {
        NSString *timezone_defaults = [defaults objectForKey: DEFAULTS_TIME_ZONE];
        
        if ([timezone_defaults isEqualToString: @"GMT / UTC"]) {
            //NSLog(@"set to UTC");
            
            current_time_zone = [NSTimeZone timeZoneForSecondsFromGMT: 0];
            self.current_timezone_prefix = @"UTC ";

        } else {
            if ( [timezone_defaults hasPrefix: @"GMT"] ) {
                //NSLog(@"Time zone has prefix GMT");
                self.current_timezone_prefix = [NSString stringWithFormat: @"%@ ", timezone_defaults];
                
                bool has_plus_half = [timezone_defaults containsString: @"½"] && [timezone_defaults containsString: @"+"] ;
                bool has_minus_half = [timezone_defaults containsString: @"½"] && [timezone_defaults containsString: @"-"] ;
                bool has_minus = [timezone_defaults containsString: @"-"] ;

                timezone_defaults = [timezone_defaults stringByReplacingOccurrencesOfString: @"GMT+" withString: @""];
                timezone_defaults = [timezone_defaults stringByReplacingOccurrencesOfString: @"GMT-" withString: @""];
                timezone_defaults = [timezone_defaults stringByReplacingOccurrencesOfString: @"GMT" withString: @""];
                
                //NSLog(@"---> timezone_defaults: %@", timezone_defaults);
                
                int offset;
                offset = [timezone_defaults intValue] * 60 * 60;

                
                if (has_plus_half) {
                    //NSLog(@" --> (has_plus_half)");
                    offset = offset + 30 * 60;
                } else if (has_minus_half) {
                    NSLog(@" --> (has_minus_half)");

                    offset = offset + 30 * 60;
                    offset = offset * -1;
                } else if (has_minus) {
                   // NSLog(@" --> (has_minus)");
                    offset = offset * -1;
                } else {
                    //NSLog(@" --> (has_minus)");
                }
                
                current_time_zone = [NSTimeZone timeZoneForSecondsFromGMT: offset];

            } else {
                NSLog(@"something is really wrong");
            }
        }
    }
}

- (IBAction)updateTimezoneAction:(id)sender {
   // NSLog(@"- (IBAction)updateTimezoneAction:(id)sender");
    
    
   // NSLog(@"sender: %@", [sender title]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [sender title] forKey: DEFAULTS_TIME_ZONE];
    [defaults synchronize];
    
    [self checkTimezone];
}

- (IBAction)showHideSecondsAction:(id)sender {
   // NSLog(@"- (IBAction)showHideSecondsAction:(id)sender");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   // NSLog(@"[defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS]: %@:", [defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS]);

    if ([defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS] != nil) {
        
        if ( [[defaults objectForKey: DEFAULTS_SHOW_HIDE_SECONDS] isEqual: @"YES"] ) {
            [defaults setObject: @"NO" forKey: DEFAULTS_SHOW_HIDE_SECONDS];
            show_seconds = NO;
            
            self.showHideSecondsItem.title = @"Show seconds";
        } else {
            [defaults setObject: @"YES" forKey: DEFAULTS_SHOW_HIDE_SECONDS];
            show_seconds = YES;
            
            self.showHideSecondsItem.title = @"Hide seconds";
        }

    } else {
        [defaults setObject: @"NO" forKey: DEFAULTS_SHOW_HIDE_SECONDS];
        show_seconds = NO;
        
        self.showHideSecondsItem.title = @"Show seconds";
    }
    
//    if (show_seconds) {
//        [self.statusItem setLength: STATUS_ITEM_VIEW_WIDTH_WITH_SECONDS];
//    } else {
//        [self.statusItem setLength: STATUS_ITEM_VIEW_WIDTH_NO_SECONDS];
//    }
    //[self.statusItem setLength: [self.statusItem.title sizeWithAttributes:nil].width + 40.0];

    
    [defaults synchronize];
}

- (IBAction)aboutAction:(id)sender {
    //NSLog(@"- (IBAction)aboutAction:(id)sender");
    
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://pulsely.com/"]];
}

- (IBAction)quitAction:(id)sender {
    //NSLog(@"- (IBAction)quitAction:(id)sender");

    [NSApp terminate:self];
}


- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem: self.statusItem];
}

@end
