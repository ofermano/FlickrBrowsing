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
@property (strong, nonatomic, readonly) NSString *appSuit;
@property (strong, nonatomic, readonly) NSString *key;
@property (nonatomic, readonly) NSUInteger size;
@end

@implementation LTPersistentUniqueStack


- (instancetype) initAppSuit:(NSString *) appSuit andKey:(NSString *)key andSize:(NSUInteger)size;
{
  if (self = [super init]) {
    _appSuit = appSuit;
    _key = key;
    _size = size;
  }
  return self;
}

- (void)push:(id<NSCoding>)item {
  // The push item must be synchronized since while one thread updates the stack we don't want
  // another thread will try to add a new item.
  @synchronized(self) {
    NSArray<id<NSCoding> >*stack = [self updateStack:item];
    NSData *arrayData = [NSKeyedArchiver archivedDataWithRootObject:stack];
    NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                        initWithSuiteName:self.appSuit];
    [persistentMemory setObject:arrayData forKey:self.key];
  }
}

- (NSArray<id<NSCoding>> *)updateStack:(id<NSCoding>)item {
  NSArray<id<NSCoding> >*imutableStack = [self stack];
  NSMutableArray<id<NSCoding> >*stack = [imutableStack mutableCopy];
  [stack removeObject:item];
  [stack insertObject:item atIndex:0];
  while ([stack count] > self.size) {
    [stack removeObjectAtIndex:self.size];
  }
  return stack;
}

- (NSArray<id<NSCoding> > *)stack {
  NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                      initWithSuiteName:self.appSuit];
  NSData *arrayData = [persistentMemory objectForKey:self.key];
  NSArray<id<NSCoding> > *array = nil;
  if (!arrayData) {
    array = [[NSArray<id<NSCoding> > alloc]init];
  }
  else if ([arrayData isKindOfClass:[NSData class]]) {
    array = [NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
  }
  return array;
}

@end

NS_ASSUME_NONNULL_END

