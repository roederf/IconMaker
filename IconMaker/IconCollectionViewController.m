//
//  IconCollectionViewController.m
//  IconMaker
//
//  Created by Florian Roeder on 9/9/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "IconCollectionViewController.h"
#import "IconDocument.h"
#import "ImageFileItem.h"

@interface IconCollectionViewController ()

@end

@implementation IconCollectionViewController

- (void) awakeFromNib
{
    
    // register types that we accept
    NSArray *supportedTypes = [NSArray arrayWithObjects:NSFilenamesPboardType, nil];
    [collectionView registerForDraggedTypes:supportedTypes];
    
    // from external we always add
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    IconDocument* doc = [[IconDocument alloc] initWithItems:[NSMutableArray arrayWithObjects:nil]];
    
    self.document = doc;
    
    [self setItems:self.document.imageItems];
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
	return NSDragOperationCopy;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id<NSDraggingInfo>)draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
{
    NSPasteboard *pasteboard = [draggingInfo draggingPasteboard];
    
	NSMutableArray *files = [NSMutableArray array];
    
	for (NSPasteboardItem *oneItem in [pasteboard pasteboardItems])
	{
		NSString *urlString = [oneItem stringForType:(id)kUTTypeFileURL];
		NSURL *URL = [NSURL URLWithString:urlString];
        
		if (URL)
		{
			[files addObject:URL];
		}
	}
    
	if ([files count])
	{
		for (NSURL *URL in files)
        {
            if ([NSImage canInitWithPasteboard:pasteboard])
            {
                NSImage *fileImage = [[NSImage alloc] initWithContentsOfURL:URL];
                if ([self.document acceptsImage:fileImage])
                {
                    [self.document addItem:URL WithImage:fileImage];
                }
            }
        }
        
        // send KVO message so that the array controller updates itself
        [self willChangeValueForKey:@"items"];
        [self setItems:self.document.imageItems];
        [self didChangeValueForKey:@"items"];
	}
    
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
    }
    return self;
}

- (IBAction)CreateIcon:(id)sender {
    [self.document save:@"Icon.ico"];
}
@end
