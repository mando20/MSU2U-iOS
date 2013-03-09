//
//  MYDocumentHandler.m
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/16/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import "MYDocumentHandler.h"

@interface MYDocumentHandler ()
- (void)objectsDidChange:(NSNotification *)notification;
- (void)contextDidSave:(NSNotification *)notification;
@end;

@implementation MYDocumentHandler

@synthesize document = _document;

static MYDocumentHandler *_sharedInstance;

+ (MYDocumentHandler *)sharedDocumentHandler
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        log = [[logPrinter alloc]init];
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"MyDocument.md"];
        
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        
        // Set our document up for automatic migrations
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        self.document.persistentStoreOptions = options;
        
        // Register for notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(objectsDidChange:)
                                                     name:NSManagedObjectContextObjectsDidChangeNotification
                                                   object:self.document.managedObjectContext];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSave:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.document.managedObjectContext];
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    [log functionEnteredClass:[self class] Function:_cmd];

    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document);
    };
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]]) {
        [self.document saveToURL:self.document.fileURL
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
    
    [log functionExitedClass:[self class] Function:_cmd];
}

- (void)objectsDidChange:(NSNotification *)notification
{
    [log functionEnteredClass:[self class] Function:_cmd];
#ifdef DEBUG
    [log outputClass:[self class] Function:_cmd Message:@"NSManagedDocument did change"];
#endif
    [log functionExitedClass:[self class] Function:_cmd];
}

- (void)contextDidSave:(NSNotification *)notification
{
    [log functionEnteredClass:[self class] Function:_cmd];
#ifdef DEBUG
    [log outputClass:[self class] Function:_cmd Message:@"NSManagedDocument did save"];
#endif
    [log functionExitedClass:[self class] Function:_cmd];
}

@end