//
//  MissionLogCell.h
//  ForwARd
//
//  Created by Roey Lehman on 19/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ivCellImage;
@property (weak, nonatomic) IBOutlet UILabel *lblMissionTitle;
@end
