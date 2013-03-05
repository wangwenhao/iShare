//
//  SettingViewController.h
//  iShare
//
//  Created by Bryant on 2/21/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UITableViewController

@property (nonatomic, strong) UILabel *awardCount;
@property (nonatomic, strong) UISlider *slider;

-(void)sliderValueChanged:(id)sender;

@end
