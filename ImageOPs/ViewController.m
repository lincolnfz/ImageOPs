//
//  ViewController.m
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import "ViewController.h"
#import "ImageMisc.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* pic = [mainBundle pathForResource:@"apple" ofType:@"jpeg"];
    //pic = [NSString stringWithFormat:@"%@/apple.jpeg", NSHomeDirectory()];
    UIImage* img = [UIImage imageWithContentsOfFile:pic];
    [self.imgView setImage:img];
    [ImageMisc sharedInstance];
}

- (IBAction)grayTouchUP:(id)sender {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* pic = [mainBundle pathForResource:@"apple" ofType:@"jpeg"];
    //pic = [NSString stringWithFormat:@"%@/apple.jpeg", NSHomeDirectory()];
    UIImage* img = [UIImage imageWithContentsOfFile:pic];
    UIImage* grayimg = [[ImageMisc sharedInstance] grayTrans:img];
    [self.imgView setImage:grayimg];
}

- (IBAction)roationTouchUP:(id)sender {
    NSBundle* mainBundle = [NSBundle mainBundle];
    NSString* pic = [mainBundle pathForResource:@"apple" ofType:@"jpeg"];
    //pic = [NSString stringWithFormat:@"%@/apple.jpeg", NSHomeDirectory()];
    UIImage* img = [UIImage imageWithContentsOfFile:pic];
    UIImage* binImg = [[ImageMisc sharedInstance] binaryTrans:img Threshold:128];
    [self.imgView setImage:binImg];
}

@end
