//
//  Last Updated by Singh
//

#import "FaceBookHelper.h"


/**
 
 FaceBookHelper:-
 
 FaceBookHelper class will allow various possibilities with facebook.
 
 */

@implementation FaceBookHelper

SINGLETON_IMPLEMENTATION_FOR_CLASS(FaceBookHelper, sharedObject)

#pragma mark---
#pragma mark---login via facebook

- (void)login:(operationFinishedBlockFBH)operationFinishedBlock {
    operationFinishedBlockFBH_ = operationFinishedBlock;
    if ([FBSDKAccessToken currentAccessToken]) {
        [self getData];
    }
    else {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithPublishPermissions:@[@"publish_actions"]
                                handler: ^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (error) {
                operationFinishedBlockFBH_(nil);
            }
            else if (result.isCancelled) {
                operationFinishedBlockFBH_(nil);
            }
            else {
                [self getData];
            }
        }];
    }
}

- (void)getData {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"picture,id,birthday,email,name,gender" forKey:@"fields"] HTTPMethod:@"GET"]
     startWithCompletionHandler: ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (error) {
             operationFinishedBlockFBH_(nil); return;
         }
         [self meRequestResult:result WithError:error];
     }];
}

- (void)meRequestResult:(id)result WithError:(NSError *)error {
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = nil;
        if ([result objectForKey:@"data"])
            dictionary = (NSDictionary *)[(NSArray *)[result objectForKey:@"data"] objectAtIndex:0];
        else
            dictionary = (NSDictionary *)result;
        operationFinishedBlockFBH_(dictionary);
    }
}

@end
