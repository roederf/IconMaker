//
//  IconCollectionViewController.h
//  IconMaker
//
//  Created by Florian Roeder on 9/9/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NSMutableArray;
@class IconDocument;

@interface IconCollectionViewController : NSViewController <NSCollectionViewDelegate>
{
    IBOutlet NSCollectionView *collectionView;
    NSArrayController *_arrayController;
}

@property (strong) NSMutableArray* items;
@property NSInteger selectedIndex;
@property (strong) IconDocument* document;

- (IBAction)CreateIcon:(id)sender;
- (IBAction)NewIcon:(id)sender;

@property (strong) IBOutlet NSArrayController *arrayController;
@end
