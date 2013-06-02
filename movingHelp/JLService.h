//
//  JLService.h
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLService : NSObject
+ (id)sharedService;

- (NSArray *)crimeDataForYear:(NSString *)yearString;
- (NSArray *)neighborhoodsInRegion:(MKCoordinateRegion)region;
- (NSArray *)rentData;
- (NSArray *)schoolData;
@end
