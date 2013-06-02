//
//  JLToggleCell.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLToggleCell.h"

@interface JLToggleCell (action)
- (IBAction)toggle:(id)sender;

@end

@implementation JLToggleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation JLToggleCell (action)


- (IBAction)toggle:(id)sender {
    [self setSelected:YES];
}
@end