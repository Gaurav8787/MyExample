//
//  MyTableViewCell.h
//  test
//
//  Created by Gaurav on 04/09/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface MyTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel *lblLabel,*lblDesc;
@property(nonatomic,weak)IBOutlet UIView *bgView;
@property(nonatomic,weak)IBOutlet AsyncImageView *imgView;



@end
