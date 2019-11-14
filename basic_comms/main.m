//
//  main.m
//  basic_comms
//
//  Created by null on 11/13/19.
//  Copyright © 2019 null. All rights reserved.
//

#import <CoreFoundation/CFSocket.h>
#import <Foundation/Foundation.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include "Server.h"
 
int main ()
{
    // create our server instance
    Server *serv = [Server alloc];
    serv.connectedClient = [Client alloc]; // not sure if this is necessary but I think so?
    serv.connectedClient.state = 0;
    
    // start the server on port 9999 and pass our socket in to be written out
    int socket = 0;
    [serv serverStartup:9999 :(&socket)];
    
    // convert our BSD socket to a CFSocket type
    CFSocketRef s;
    CFRunLoopSourceRef source;
    s = CFSocketCreateWithNative(
                                  NULL,
                                  socket, // the BSD socket written out to by serverStartup
                                  kCFSocketAcceptCallBack, // when we accept, run callback func
                                  acceptConnection, // this func gets called by kCFSocketAcceptCallBack
                                  NULL);

    //CFRunLoop is basically a thread that handles our connection
    source = CFSocketCreateRunLoopSource(NULL, s, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    // release our objects now that they have been consumed by the thread
    CFRelease(source);
    CFRelease(s);
    CFRunLoopRun();
}
