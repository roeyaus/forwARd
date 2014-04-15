//
//  AlertModalViewController.h
//  ForwARd
//
//  Created by Roey Lehman on 18/05/2013.
//  Copyright (c) 2013 Roey Lehman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertModalViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ivBackGround;
@property (weak, nonatomic) IBOutlet UIImageView *ivForeGround;
@property NSString* soundFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

@end
