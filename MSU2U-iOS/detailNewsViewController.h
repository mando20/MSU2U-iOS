//
//  detailNewsViewController.h
//  MSU2U-iOS
//
//  Created by Matthew Farmer on 11/5/12.
//  Copyright (c) 2012 Matthew Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News+Create.h"
//ShareKit
#import "SHK.h"
#import "logPrinter.h"

@interface detailNewsViewController : UITableViewController{
    logPrinter * log;
}

-(void)sendNewsInformation:(News*)news;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *description;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
- (IBAction)sharePressed:(UIBarButtonItem *)sender;
@end
