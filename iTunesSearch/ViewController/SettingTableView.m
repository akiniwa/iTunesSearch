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

@synthesize settingTableDelegate;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setDelegate:(id)self];
        [self setDataSource:(id)self];
        self.backgroundColor = [UIColor clearColor];
        self.bounces = NO;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textAlignment = UITextAlignmentRight;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [defaults objectForKey:@"name"];
                    [cell setUserImage];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"プレイリスト数：%@", [defaults objectForKey:@"playlist_number"]];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"登録曲数：%@", [defaults objectForKey:@"music_number"]];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"ユーザーガイド";
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    break;
                default:
                    break;
            }
            
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"ユーザー情報";
            break;
        case 1:
            sectionName = @"登録情報";
            break;
        case 2:
            sectionName = @"About Neiro";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

//リストアイテムの数。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
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
    if (indexPath.section==2) {
        [settingTableDelegate performSelector:@selector(showTutorialView)];
    }
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

//セルの高さ
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end