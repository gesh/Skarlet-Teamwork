//
//  CoreDataHelper.m
//  ITNews
//
//  Created by Admin on 11/8/14.
//  Copyright (c) 2014 teamwork. All rights reserved.
//

#import "CoreDataHelper.h"
#import <UIKit/UIKit.h>

@implementation CoreDataHelper


NSString *storeFilename = @"CDatabase.sqlite";

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    
    return self;
}

- (NSURL *)storeURL
{
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:storeFilename];
}

- (void)loadStore
{
    if (_store) {
        return;
    } // Don’t load store if it's already loaded
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:nil
                                                error:&error];
    
    if (!_store) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:@"Something gone wrong"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];

        abort();
    } 
}

- (void)setupCoreData
{
    [self loadStore];
}

- (NSString *)applicationDocumentsDirectory
{
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}

- (void)saveContext
{
    
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

- (NSURL *)applicationStoresDirectory
{
    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            NSLog(@"Successfully created Stores directory");
        }

    }
    return storesDirectory;
}

@end