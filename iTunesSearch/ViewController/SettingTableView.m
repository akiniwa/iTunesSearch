//
//  SettingTableView.m
//  iTunesSearch
//
//  Created by s_akiba on 12/12/10.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingCell.h"

@implementation SettingTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelegate:(id)self];
        [self setDataSource:(id)self];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell==nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [defaults objectForKey:@"user_id"];
                    break;
                case 1:
                    cell.textLabel.text = [defaults objectForKey:@"name"];
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"利用規約";
                    break;
                case 1:
                    cell.textLabel.text = [defaults objectForKey:@"id"];
                default:
                    break;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [defaults objectForKey:@"FBAccessTokenKey"];
                    break;
                default:
                    break;
            }
        default:
            break;
    }

    return cell;
}

//リストアイテムの数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
        case 2:
            return 1;
        default:
            return 1;
            break;
    }
}

//セクションの数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//セルを選択したとき
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [myPocketDelegate performSelector:@selector(pushToDetailView:) withObject:[tlArray.shared objectAtIndex:indexPath.row]];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end