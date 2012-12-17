//
//  SelectTable.m
//  iTunesSearch
//
//  Created by s_akiba on 12/11/14.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "SelectTable.h"

@implementation SelectTable

@synthesize gridDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[SelectTable alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [gridDelegate performSelector:@selector(pushGridView:) withObject:@"GLAY"];
            break;
        case 1:
            [gridDelegate performSelector:@selector(pushGridView:) withObject:@"ASIAN KUNG-FU GENERATION"];
            break;
        case 2:
            [gridDelegate performSelector:@selector(pushGridView:) withObject:@"チャットモンチー"];
            break;
        default:
            [gridDelegate performSelector:@selector(pushGridView:) withObject:@"androp"];
            break;
    }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIndentifier = @"cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"GLAY";
            break;
        case 1:
            cell.textLabel.text = @"ASIAN KUNG-FU GENERATION";
            break;
        case 2:
            cell.textLabel.text = @"チャットモンチー";
            break;
        default:
            cell.textLabel.text = @"androp";
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end