//
//  ViewController.h
//  opencvtest1
//
//  Created by Yanliang Gu on 9/6/15.
//  Copyright (c) 2015 Yanliang Gu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/highgui_c.h>

@interface ViewController : UIViewController{
    UIImage * newImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UILabel *peakLabel1;
@property (weak, nonatomic) IBOutlet UILabel *peakLabel2;
@property (weak, nonatomic) IBOutlet UILabel *peakLabel3;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callFacetime:(id)sender;

@end

