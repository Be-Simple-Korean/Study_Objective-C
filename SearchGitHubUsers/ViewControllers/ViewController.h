//
//  ViewController.h
//  SearchGitHubUsers
//
//  Created by 이정현 on 11/22/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITextFieldDelegate,UITableViewDelegate>{
    NSMutableArray<NSDictionary *> *rootData;
    NSString *baseUrl;
}
@property (strong, nonatomic) IBOutlet UITextField *keywordTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end

