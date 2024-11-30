//
//  CustomPopupController.m
//  SearchGitHubUsers
//
//  Created by 이정현 on 11/30/24.
//

#import "CustomPopupController.h"
#import "SDWebImage/SDWebImage.h"
@interface CustomPopupController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImgView;
@property (strong, nonatomic) IBOutlet UILabel *nicknameLabel;

- (IBAction)moveProfilePage:(id)sender;

@end

@implementation CustomPopupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.profileImgView.layer.cornerRadius = 50;
    self.profileImgView.layer.masksToBounds = YES;
    NSLog(@"%@",self.profileData);
    NSString *name = [self profileData][@"name"];
    self.nicknameLabel.text=name;
    NSURL *imageURL = [NSURL URLWithString:[self profileData][@"imgUrl"]];
    [self.profileImgView sd_setImageWithURL:imageURL];
}

- (IBAction)moveProfilePage:(id)sender {
    NSString *url = [self profileData][@"profileUrl"];
    NSLog(@"url >> %@",url);
    NSURL *webUrl = [NSURL URLWithString:url];
    if([[UIApplication sharedApplication] canOpenURL:webUrl]){
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] openURL:webUrl options:@{} completionHandler:nil];
    }else{
        NSLog(@"can't open url");
    }
}

@end
