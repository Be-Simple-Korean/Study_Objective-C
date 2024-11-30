//
//  NetworkManager.h
//  SearchGitHubUsers
//
//  Created by 이정현 on 11/27/24.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;
+ (instancetype)sharedManager;

- (void)requestUsers:(NSString *)keyword
             success:(void (^)(id responseObject))success
             failure:(void (^)(NSError *error))failure;

@end
