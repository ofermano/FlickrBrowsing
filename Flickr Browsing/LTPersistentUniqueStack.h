//
//  LTPersistentUniqueStack.h
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// A class implementing a unique stack over NSUserDefaults persestent memory.
@interface LTPersistentUniqueStack : NSObject

/// Init the memory with key and history size.
- (instancetype) initAppSuit:(NSString *) appSuit andKey:(NSString *)key andSize:(NSUInteger)size;

/// Push an item to the head of the stack.
- (void)push:(id<NSCoding>)item;

/// Getting the stack.
- (NSArray *)stack;

@end

NS_ASSUME_NONNULL_END
