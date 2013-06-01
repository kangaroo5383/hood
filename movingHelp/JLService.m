//
//  JLService.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLService.h"

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
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:yearString ofType:@"json"]];
    NSError *readError = nil;
    NSArray *anArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&readError];
    if (readError) {
        NSLog(@"dang it: %@", readError);
    } else {
        NSLog(@"total entry: %d", [anArray count]);
    }
    return anArray;
}
@end
