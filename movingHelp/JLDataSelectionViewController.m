//
//  JLDataSelectionViewController.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLDataSelectionViewController.h"
#import "JLRootViewController.h"

@interface JLDataSelectionViewController ()
@property (nonatomic, retain) NSArray *choices;
@property (nonatomic, retain) NSMutableArray *selected;
@end

@interface JLDataSelectionViewController (action)
- (IBAction)update:(id)sender;

@end
@interface JLDataSelectionViewController (protocol) <UITableViewDataSource, UITableViewDelegate>

@end
@implementation JLDataSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setChoices:@[@"crime", @"neighborhood", @"school", @"meetup"]];
    [self setSelected:[NSMutableArray array]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *selected = [(JLRootViewController *)[self presentingViewController] displayData];
    [self setSelected:[NSMutableArray arrayWithArray:selected]];
}

@end

@implementation JLDataSelectionViewController (protocol)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"toggleCell" forIndexPath:indexPath];
    [[aCell textLabel] setText:[self choices][[indexPath row]]];
    if ([[self selected] containsObject:[[self choices] objectAtIndex:[indexPath row]]]) {
        [aCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    return aCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self choices] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *aSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([aSelectedCell accessoryType] == UITableViewCellAccessoryCheckmark) {
        [aSelectedCell setAccessoryType:UITableViewCellAccessoryNone];
        [[self selected] removeObject:[[self choices] objectAtIndex:[indexPath row]]];
    } else {
        [aSelectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [[self selected] addObject:[[self choices] objectAtIndex:[indexPath row]]];
    }
    return NO;
}
@end

@implementation JLDataSelectionViewController (action)

- (IBAction)update:(id)sender {
    [(JLRootViewController *)[self presentingViewController] setDisplayData:[NSArray arrayWithArray:[self selected]]];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end