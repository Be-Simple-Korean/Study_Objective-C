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
    NSString *url = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@",keyword];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success request");
        [self->rootData removeAllObjects];
        NSArray *items = responseObject[@"items"];
        for(NSDictionary *item in items){
            NSString *profileName = item[@"login"];
            NSString *profileImgUrl = item[@"avatar_url"];
            NSLog(@"item name >> %@ , url >> %@",profileName,profileImgUrl);
            [self->rootData addObject:@{@"name":profileName,@"imgUrl":profileImgUrl}];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure request");
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130.0;
}

@end
