//
//  MasterViewController.h
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class IconDocument;

@interface MasterViewController : NSViewController

@property (strong) IconDocument* document;
- (IBAction)Save:(id)sender;

@end
