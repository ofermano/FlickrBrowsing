//
//  LTPersistentPhotoHistory.m
//  Flickr Browsing
//
//  Created by Ofer Mano on 15/12/2015.
//  Copyright © 2015 Lightricks. All rights reserved.
//

#import "LTPersistentPhotoHistory.h"

@implementation LTPersistentPhotoHistory

static NSString* const kAppSuit = @"Flickr Browsing";
static NSString* const kHistoryKey = @"history";
static const int kHistoryLength = 20;

+ (void)pushPhotoDescription:(LTPhotoDescription *)description {
  if (!description)
    return;
  NSString *descriptionString = [LTPhotoDescription serialize:description];
  NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                      initWithSuiteName:kAppSuit];
  [LTPersistentPhotoHistory addItem:descriptionString
                             forKey:kHistoryKey
                           toMemory:persistentMemory
                  withMaximalLength:kHistoryLength];
}

+ (NSMutableArray *)getHistory {
  NSUserDefaults *persistentMemory = [[NSUserDefaults standardUserDefaults]
                                      initWithSuiteName:kAppSuit];
  NSArray *descriptionStringArray = [LTPersistentPhotoHistory getArrayForKey:kHistoryKey
                                                                   forMemory:persistentMemory];
  return [LTPersistentPhotoHistory desirializeArray:descriptionStringArray];
}

+ (NSMutableArray *)desirializeArray:(NSArray *)descriptionStringArray {
  if (!descriptionStringArray) {
    return nil;
  }
  NSMutableArray *descriptionArray = [[NSMutableArray alloc] init];
  for (NSString *descriptionString in descriptionStringArray) {
    [descriptionArray addObject:[LTPhotoDescription desirialize:descriptionString]];
  }
  return descriptionArray;
}

/// \c addItem will add the item to the head of the array.
/// If the item is already in the array it will move it to the head of the array.
+ (void)addItem:(NSString *)item forKey:(NSString *)key
                               toMemory:(NSUserDefaults *)persistentMemory
                      withMaximalLength:(NSUInteger)maximalLength {
  NSMutableArray *history = [LTPersistentPhotoHistory getArrayForKey:key
                                                           forMemory:persistentMemory];
  if (!history) {
    return;
  }
  // In this case we will move it to the head of the array.
  [history removeObject:item];
  [history insertObject:item atIndex:0];
  while ([history count] > kHistoryLength) {
    [history removeObjectAtIndex:kHistoryLength];
  }
  [persistentMemory setObject:history forKey:key];
}

/// If the array is not in the \c NSUserDefaults we will create one.
/// If it does - we need to convert it to mutable array as \c NSUserDefaults does not store
/// mutable elements.
+ (NSMutableArray *)getArrayForKey:(NSString *)key forMemory:(NSUserDefaults *)persistentMemory {
  id arrayID = [persistentMemory objectForKey:key];
  NSMutableArray *array = nil;
  if (!arrayID) {
    array = [[NSMutableArray alloc]init];
  }
  else if ([arrayID isKindOfClass:[NSArray class]]) {
    NSMutableArray *immutableArray = (NSMutableArray *)arrayID;
    array = [immutableArray mutableCopy];
  }
  return array;
}


@end

