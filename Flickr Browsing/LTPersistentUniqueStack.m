//
//  LTPersistentUniqueStack.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPersistentUniqueStack.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTPersistentUniqueStack()

/// The application identifier.
@property (strong, readonly, nonatomic) NSString *appSuit;

/// The key to store the stack.
@property (strong, readonly, nonatomic) NSString *key;

/// The stack size.
@property (readonly, nonatomic) NSUInteger size;

@end

@implementation LTPersistentUniqueStack

- (instancetype) initAppSuit:(NSString *) appSuit andKey:(NSString *)key andSize:(NSUInteger)size {
  if (self = [super init]) {
    _appSuit = [appSuit copy];
    _key = [key copy];
    _size = size;
  }
  return self;
}

- (void)push:(id<NSCoding>)item {
  // The push item must be synchronized since while one thread updates the stack we don't want
  // another thread to try to add a new item.
  @synchronized(self) {
    NSArray<id<NSCoding>> *stack = [self stackByMovingItemToHead:item];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:stack];
    NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                        initWithSuiteName:self.appSuit];
    [persistentMemory setObject:arrayData forKey:self.key];
  }
}

- (NSArray<id<NSCoding>> *)stackByMovingItemToHead:(id<NSCoding>)item {
  NSArray<id<NSCoding>> *immutableStack = [self stack];
  NSMutableArray<id<NSCoding>> *stack = [immutableStack mutableCopy];
  [stack removeObject:item];
  [stack insertObject:item atIndex:0];
  while ([stack count] > self.size) {
    [stack removeObjectAtIndex:self.size];
  }
  return stack;
}

- (NSArray<id<NSCoding>> *)stack {
  NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                      initWithSuiteName:self.appSuit];
  NSData *arrayData = [persistentMemory objectForKey:self.key];
  return ([arrayData isKindOfClass:NSData.class] ?
          [NSKeyedUnarchiver unarchiveObjectWithData:arrayData] : @[]);
}

@end

NS_ASSUME_NONNULL_END
