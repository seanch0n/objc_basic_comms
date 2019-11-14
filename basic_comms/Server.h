//
//  Server.h
//  basic_comms
//
//  Created by null on 11/13/19.
//  Copyright © 2019 null. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CFSocket.h>
#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include "Client.h"

NS_ASSUME_NONNULL_BEGIN

@interface Server : NSObject
@property Client *connectedClient;
@property int bob;

void receiveData(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);


void acceptConnection(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info);

- (void) serverStartup:(int)port :(int*)sock;

- (int) handleClient:(int)clientSocket;

@end

NS_ASSUME_NONNULL_END
