//
//  Client.h
//  basic_comms
//
//  Created by null on 11/13/19.
//  Copyright © 2019 Sean McConnell. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject
@property CFSocketNativeHandle clientSocket;
@property CFDataRef address;
@property int state; // 0 new, 1 connected, 2 in progress, 3 dead
@end

NS_ASSUME_NONNULL_END
