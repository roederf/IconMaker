//
//  MPCAppDelegate.m
//  IconMaker
//
//  Created by Florian Roeder on 9/5/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "MPCAppDelegate.h"

#import "IconCollectionViewController.h"
#import "PreferencesViewController.h"

@interface MPCAppDelegate()

//@property (nonatomic, strong) IBOutlet MasterViewController *masterViewController;
@property (nonatomic, strong) IBOutlet IconCollectionViewController *iconCollectionViewController;
@property (nonatomic, strong) IBOutlet PreferencesViewController *prefController;

@end

@implementation MPCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
//    self.masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
//    
//    [self.window.contentView addSubview:self.masterViewController.view];
//    self.masterViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    
    self.iconCollectionViewController = [[IconCollectionViewController alloc] initWithNibName:@"IconCollectionViewController" bundle:nil];
    [self.window.contentView addSubview:self.iconCollectionViewController.view];
    self.iconCollectionViewController.view.frame = ((NSView*)self.window.contentView).bounds;
    
    }

- (IBAction)OpenPreferences:(id)sender {
    self.prefController = [[PreferencesViewController alloc] initWithWindowNibName:@"PreferencesViewController"];
    [self.prefController showWindow:NSApp];
}
@end
