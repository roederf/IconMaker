//
//  MPCAppDelegate.h
//  IconMaker
//
//  Created by Florian Roeder on 9/5/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MPCAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)OpenPreferences:(id)sender;

@end
