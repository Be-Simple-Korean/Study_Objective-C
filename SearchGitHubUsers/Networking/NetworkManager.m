//
//  NetworkManager.m
//  SearchGitHubUsers
//
//  Created by 이정현 on 11/27/24.
//

#import "NetworkManager.h"
#import "Foundation/Foundation.h"
@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.manager = [AFHTTPSessionManager manager];
        sharedInstance.manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [sharedInstance.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return sharedInstance;
}

- (void)requestUsers:(NSString *)keyword
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@",keyword];
    [self.manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}
@end
