//
//  User.m
//  twitter
//
//  Created by drealin on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePictureURL = dictionary[@"profile_image_url_https"];
        self.tweets = dictionary[@"statuses_count"];
        self.following = dictionary[@"friends_count"];
        self.followers = dictionary[@"followers_count"];
    }
    return self;
}

@end
