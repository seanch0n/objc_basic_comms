//
//  Server.m
//  basic_comms
//
//  Created by null on 11/13/19.
//  Copyright © 2019 null. All rights reserved.
//

#import "Server.h"

@implementation Server

void receiveData(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    // get the data from the socket
    CFDataRef df = (CFDataRef) data;
    long len = CFDataGetLength(df);
    // can't get to @property from a C function
    //self.connectedClient.state = 1;
    //self.bob = 1;
    //c.state = 0;
    
    if(len <= 0) return;
   
    UInt8 buffer[len];
    CFRange range = CFRangeMake(0,len);
    NSLog(@"Server received %ld bytes from socket %d\n", len, CFSocketGetNative(s));
    CFDataGetBytes(df, range, buffer); // read the data off the socket into the buffer
    NSLog(@"Server received: %s\n", buffer);
    
    // echo our data back over the socket
    CFSocketSendData(s, address, df, 0);
}
 
/*
 handle a connected client that has passed through acceptConnection.
 The idea was to implement this instead of receiveData and do something other than
 an echo server. But I can't call this from CFSocketCreateWithNative
 */
- (int) handleClient:(int)clientSocket
{
    return 0;
}

void acceptConnection(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    // ??? where is *data coming from?
    CFSocketNativeHandle csock = *(CFSocketNativeHandle *)data;
    CFSocketRef sn;
    CFRunLoopSourceRef source;
   
    NSLog(@"Socket %d received connection socket %d\n", CFSocketGetNative(s), csock);
    //int a = [handleClient:csock]; // can't call this from C function
    
    // we've gotten our connection so now we are going to throw the socket into a thread to
    // accept data over the socket
    sn = CFSocketCreateWithNative(
                                  NULL,
                                  csock,
                                  kCFSocketDataCallBack, // chunk read incoming data and call callback
                                  receiveData, // called by kCFSocketDataCallBack
                                  NULL);

    // start the thread
    source = CFSocketCreateRunLoopSource(NULL, sn, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
    CFRelease(sn);
}

/*
 sock param is a pointer so we can get the socket out of this function
 */
-(void) serverStartup:(int)port :(int*)sock
{
     // set up a socket and start listening on it using BSD sockets
     struct sockaddr_in sin;
     int yes = 1;
    
     *sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
     memset(&sin, 0, sizeof(sin));
     sin.sin_family = AF_INET;
     sin.sin_port = htons(port);
     setsockopt(*sock, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof(yes));

     bind(*sock, (struct sockaddr *)&sin, sizeof(sin));
     listen(*sock, 10);
}

@end
