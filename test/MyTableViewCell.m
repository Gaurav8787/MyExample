//
//  MyTableViewCell.m
//  test
//
//  Created by Gaurav on 04/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell
@synthesize lblLabel,bgView,imgView,lblDesc;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
