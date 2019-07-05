//
//  User.h
//  twitter
//
//  Created by drealin on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

// MARK: Properties
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *profilePictureURL;
@property (strong, nonatomic) NSNumber *tweets;
@property (strong, nonatomic) NSNumber *following;
@property (strong, nonatomic) NSNumber *followers;

// Create initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
