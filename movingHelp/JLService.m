//
//  JLService.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLService.h"

@interface JLService ()
@property (nonatomic, retain) NSArray *crimeData;
@end

@implementation JLService
+ (id)sharedService {
    static JLService *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [JLService new];
    });
    return shared;
    
}

- (NSArray *)crimeDataForYear:(NSString *)yearString {
    if (!_crimeData) {
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:yearString ofType:@"json"]];
        NSError *readError = nil;
        NSArray *anArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&readError];
        if (readError) {
            NSLog(@"dang it: %@", readError);
        } else {
            NSLog(@"total entry: %d", [anArray count]);
        }
        _crimeData = anArray;
    }
    return [self crimeData];
}

- (NSArray *)neighborhoodsInRegion:(MKCoordinateRegion)region {
    //not looking at region
    return [NSArray array];
}

@end
