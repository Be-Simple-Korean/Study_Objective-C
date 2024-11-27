//
//  ViewController.m
//  SearchGitHubUsers
//
//  Created by 이정현 on 11/22/24.
//

#import "ViewController.h"
#import "ProfileCell.h"
#import "AFNetworking.h"
#import <SDWebImage/SDWebImage.h>
#import "NetworkManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.keywordTextField.text= @"be-simple";
    rootData = [[NSMutableArray alloc]init];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"getValue >> %@",textField.text);
    if(textField == self.keywordTextField){
        [self reuqestGithubUsers:textField.text];
        [textField resignFirstResponder];
    }
    return false;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Profile";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ProfileCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSDictionary *item = rootData[indexPath.row];
    NSLog(@"item >> %@",item);
    cell.nameLabel.text=item[@"name"];
    NSURL *imageURL = [NSURL URLWithString:item[@"imgUrl"]];
    [cell.profileImgView sd_setImageWithURL:imageURL];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count >> %li",rootData.count);
    return rootData.count;
}

-(void)reuqestGithubUsers:(NSString *)keyword{
    NetworkManager *manager = [NetworkManager sharedManager];
    [manager requestUsers:keyword success:^(id responseObject) {
        NSLog(@"success request");
        [self->rootData removeAllObjects];
        NSArray *items = responseObject[@"items"];
        for(NSDictionary *item in items){
            NSString *profileName = item[@"login"];
            NSString *profileImgUrl = item[@"avatar_url"];
            NSString *profilePage = item[@"html_url"];
            
            NSLog(@"item name >> %@ , url >> %@",profileName,profileImgUrl);
            [self->rootData addObject:@{
                @"name":profileName,@"imgUrl":profileImgUrl,
                @"profileUrl":profilePage
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }failure:^(NSError *error) {
        NSString *message = error ? error.localizedDescription : @"unknown Error";
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"통신 에러" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [controller dismissViewControllerAnimated:YES completion:nil];
        }];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select Index >> %li",indexPath.row);
    NSString *url = [rootData[indexPath.row] objectForKey:@"profileUrl"];
    NSLog(@"loadUrl >> %@",url);
    [self openWebPage:url];
}

-(void)openWebPage:(NSString *)url{
    NSURL *webUrl = [NSURL URLWithString:url];
    if([[UIApplication sharedApplication] canOpenURL:webUrl]){
        [[UIApplication sharedApplication] openURL:webUrl options:@{} completionHandler:nil];
    }else{
        NSLog(@"can't open url");
    }
}

@end
