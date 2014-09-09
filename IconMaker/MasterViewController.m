//
//  MasterViewController.m
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "MasterViewController.h"
#import "IconDocument.h"
#import "ImageFileItem.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (NSView*)tableView:(NSTableView*)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    
    if ([tableColumn.identifier isEqualToString:@"FileItemColumn"])
    {
        ImageFileItem *item = [self.document.imageItems objectAtIndex:row];
        cellView.imageView.image = item.thumbnail;
        cellView.textField.stringValue = item.name;
        return  cellView;
    }
    return  cellView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.document.imageItems count];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        ImageFileItem* item1 = [[ImageFileItem alloc] initWithName:@"Icon1" Thumbnail:[NSImage imageNamed:@"testIcon32.png"]];
        ImageFileItem* item2 = [[ImageFileItem alloc] initWithName:@"Icon2" Thumbnail:[NSImage imageNamed:@"testIcon64.png"]];
        IconDocument* doc = [[IconDocument alloc] initWithItems:[NSMutableArray arrayWithObjects:item1,item2, nil]];
        
        self.document = doc;
    }
        
    [self.view registerForDraggedTypes:[NSArray arrayWithObject:NSURLPboardType]];
    
    return self;
}

- (IBAction)Save:(id)sender {
    [self.document save:@"/Users/florianroeder/Desktop/test.ico"];

}
@end
