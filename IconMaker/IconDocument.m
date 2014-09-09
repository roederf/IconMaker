//
//  IconDocument.m
//  IconMaker
//
//  Created by Florian Roeder on 9/8/14.
//  Copyright (c) 2014 amplify. All rights reserved.
//

#import "IconDocument.h"
#import "ImageFileItem.h"


@implementation IconDocument

struct IconHeader {
    short Reserved;  // 0
    short Type;      // 0=Bitmap, 1=Icon
    short Count;     // number of icons
};

struct IconEntry {
    Byte Width;
    Byte Height;
    Byte ColorCount;
    Byte Reserved;
    short Planes;
    short BitCount;
    int32_t BytesInRes;
    int32_t ImageOffset;
};

struct BitmapInfoHeader
{
    int32_t biSize;
    int32_t biWidth;
    int32_t biHeight;
    short biPlanes;
    short biBitCount;
    int32_t biCompression;
    int32_t biSizeImage;
    int32_t biXPelsPerMeter;
    int32_t biYPelsPerMeter;
    int32_t biClrUsed;
    int32_t biClrImportant;
};

typedef struct IconData {
    struct BitmapInfoHeader   icHeader;      // DIB header
    //RGBQuad[]         icColors;   // Color table
    Byte*  icXOR;      // DIB bits for XOR mask
    Byte*   icAND;      // DIB bits for AND mask
    int32_t icXORLength;
    int32_t icANDLength;
} IconData_T;

- (id) initWithItems:(NSMutableArray *)items {
    if ((self = [super init])) {
        self.imageItems = items;
    }
    return self;
}

- (void) addItem:(NSURL *)url WithImage:(NSImage *)image {
    
    ImageFileItem* item = [[ImageFileItem alloc] initWithName:[[url path] lastPathComponent] Size:@"32x32" Thumbnail:image];
    
    [self.imageItems addObject:item];
}

- (void) convertIntoImage:(NSImage*)image IntoIconData:(IconData_T*) iconData {
    NSBitmapImageRep* bitmap = [[NSBitmapImageRep alloc] initWithData:[image TIFFRepresentation]];
    
    iconData->icXORLength =(int32_t)([bitmap pixelsHigh] * [bitmap bytesPerRow]);
    iconData->icXOR = malloc(iconData->icXORLength);
    
    //memcpy(iconData->icXOR, [bitmap bitmapData], iconData->icXORLength);
    for (int i = 0; i < [bitmap pixelsHigh]; i++)
    {
        //Array.Copy(imgData, i*stride, iconImage.icXOR, (bitmap.PixelHeight-i-1)*stride, stride);
        int destIndex =i*(int)[bitmap bytesPerRow];
        int srcIndex =((int)[bitmap pixelsHigh]-i-1)*(int)[bitmap bytesPerRow];
        memcpy(&((iconData->icXOR)[destIndex]),
               &([bitmap bitmapData][srcIndex]),
               [bitmap bytesPerRow]);
    }
    
    iconData->icANDLength =(int32_t)([bitmap pixelsWide] * [bitmap pixelsHigh] / 8);
    iconData->icAND = malloc(iconData->icANDLength);
    
    for(int i=0; i<iconData->icANDLength; i++)
    {
        iconData->icAND[i] = 0;
    }
    
    iconData->icHeader.biSize = 40;
    iconData->icHeader.biWidth = (int32_t)[bitmap pixelsWide];
    iconData->icHeader.biHeight = 2 * (int32_t)[bitmap pixelsHigh];
    iconData->icHeader.biPlanes = 1;
    iconData->icHeader.biBitCount = [bitmap bitsPerPixel];
    iconData->icHeader.biCompression = 0;
    iconData->icHeader.biSizeImage = iconData->icXORLength + iconData->icANDLength;
    iconData->icHeader.biClrImportant = 0;
    iconData->icHeader.biClrUsed = 0;
    iconData->icHeader.biXPelsPerMeter = 0;
    iconData->icHeader.biYPelsPerMeter = 0;
    
    
}

- (void) save:(NSString *)location {
    
    NSMutableData *documentContent = [NSMutableData alloc];
    // add header
    struct IconHeader header;
    header.Reserved =0;
    header.Type = 1;
    header.Count = [self.imageItems count];
    
    int offset = 6 + (int)[self.imageItems count] * 16;
    
    [documentContent appendBytes:&header length:6];
    
    IconData_T** iconDataArray = malloc(sizeof(IconData_T)*[self.imageItems count]);
    
    for (int i=0; i<[self.imageItems count]; i++) {
        
        ImageFileItem *item = self.imageItems[i];
        
        IconData_T* iconData = malloc(sizeof(IconData_T));
        
        [self convertIntoImage:item.thumbnail IntoIconData:iconData];
        
        struct IconEntry entry;
        entry.Width = (Byte)iconData->icHeader.biWidth;
        entry.Height = (Byte)(iconData->icHeader.biHeight / 2);
        entry.ColorCount = 0;
        entry.Reserved = 0;
        entry.Planes = 1;
        entry.BitCount = iconData->icHeader.biBitCount;
        entry.BytesInRes = iconData->icHeader.biSizeImage + iconData->icHeader.biSize;
        entry.ImageOffset = offset;
        
        [documentContent appendBytes:&entry length:16];
        
        iconDataArray[i] = iconData;
        
        
        
        offset += entry.BytesInRes;
    }
    
    for (int i=0; i<[self.imageItems count]; i++) {
        [documentContent appendBytes:&(iconDataArray[i]->icHeader) length:iconDataArray[i]->icHeader.biSize];
        
        [documentContent appendBytes:iconDataArray[i]->icXOR length:iconDataArray[i]->icXORLength];
        
        [documentContent appendBytes:iconDataArray[i]->icAND length:iconDataArray[i]->icANDLength];
        
        free(iconDataArray[i]->icAND);
        free(iconDataArray[i]->icXOR);
    }
    
    free(iconDataArray);
    
    
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString* path = [documentsDirectory stringByAppendingPathComponent:@"test.ico"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *downloadDirectory = [paths objectAtIndex:0];
    NSString* path = [downloadDirectory stringByAppendingPathComponent:@"icon.ico"];
    
    [documentContent writeToFile:path atomically:true];
    
    //NSInteger tag;
    //[[NSWorkspace sharedWorkspace] performFileOperation:NSWorkspaceCopyOperation source:documentsDirectory destination:downloadDirectory files:[[NSArray alloc] initWithObjects:(@"test.ico"), nil] tag:&tag];
}

@end
