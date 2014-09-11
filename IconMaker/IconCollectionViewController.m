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
    NSArray *supportedTypes = [NSArray arrayWithObjects:NSFilenamesPboardType,@"my_drag_type_id", nil];
    [collectionView registerForDraggedTypes:supportedTypes];
    
    //[collectionView registerForDraggedTypes:@[KL_DRAG_TYPE]];
    
    // from external we always add
    [collectionView setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    
    [self.arrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:nil];
    
    IconDocument* doc = [[IconDocument alloc] initWithItems:[NSMutableArray arrayWithObjects:nil]];
    
    self.document = doc;
    
    [self setItems:self.document.imageItems];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if([keyPath isEqualTo:@"selectionIndexes"])
    {
        if([[self.arrayController selectedObjects] count] > 0)
        {
            if ([[self.arrayController selectedObjects] count] == 1)
            {
                ImageFileItem * item = (ImageFileItem *)[[self.arrayController selectedObjects] objectAtIndex:0];
                NSLog(@"Only 1 selected: %@", [item name]);
            }
            else
            {
                // More than one selected - iterate if need be
            }
        }
    }
}

-(BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard {
    NSLog(@"Write Items at indexes : %@", indexes);
    NSData *indexData = [NSKeyedArchiver archivedDataWithRootObject:indexes];
    [pasteboard setData:indexData forType:@"my_drag_type_id"];
    return YES;
}

- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event {
    NSLog(@"Can Drag");
    return YES;
}

- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id<NSDraggingInfo>)draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
{
    if ([draggingInfo draggingSource])
    {
        return NSDragOperationDelete;
    }
    else {
        return NSDragOperationCopy;
    }
}

-(void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
    if (operation == NSDragOperationNone) {
        //delete object, remove from view, etc.
    }
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

- (IBAction)NewIcon:(id)sender {
    [self.document.imageItems removeAllObjects];
    
    // send KVO message so that the array controller updates itself
    [self willChangeValueForKey:@"items"];
    [self setItems:self.document.imageItems];
    [self didChangeValueForKey:@"items"];

}
@end
