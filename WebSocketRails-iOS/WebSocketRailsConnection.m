//
//  WebSocketRailsConnection.m
//  WebSocketRails-iOS
//
//  Created by Evgeny Lavrik on 17.12.13.
//  Copyright (c) 2013 Evgeny Lavrik. All rights reserved.
//

#import "WebSocketRailsConnection.h"
#import "SRWebSocket.h"

@interface WebSocketRailsConnection() <SRWebSocketDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, weak) WebSocketRailsDispatcher *dispatcher;
@property (nonatomic, strong) NSMutableArray *message_queue;
@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation WebSocketRailsConnection

- (id)initWithUrl:(NSURL *)url dispatcher:(WebSocketRailsDispatcher *)dispatcher
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    return [self initWithURLRequest:request dispatcher:dispatcher];
}

- (id)initWithURLRequest:(NSURLRequest*)request dispatcher:(WebSocketRailsDispatcher *)dispatcher
{
    self = [super init];
    if (self) {
        _url = request.URL;
        _dispatcher = dispatcher;
        _message_queue = [NSMutableArray array];
        
        _webSocket = [SRWebSocket.alloc initWithURLRequest:request];
        _webSocket.delegate = self;
        [_webSocket open];
    }
    return self;
}

- (void)trigger:(WebSocketRailsEvent *)event
{
    if (![_dispatcher.state isEqualToString:@"connected"])
        [_message_queue addObject:event];
    else
        [_webSocket send:[event serialize]];
}

- (void)flushQueue:(NSNumber *)id
{
    for (WebSocketRailsEvent *event in _message_queue)
    {
        NSString *serializedEvent = [event serialize];
        [_webSocket send:serializedEvent];
    }
}

- (void)disconnect
{
    [_webSocket close];
}

- (void)dealloc
{
    _webSocket.delegate = nil;
}

#pragma mark - SRWebSocketDelegate
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    // data here is an array of WebSocketRails messages (or events)
    id messageData = [message isKindOfClass:[NSData class]] ? message : [message dataUsingEncoding:NSUTF8StringEncoding];
    id data = [NSJSONSerialization JSONObjectWithData:messageData options:NSJSONReadingMutableContainers error:nil];
    [_dispatcher newMessage:data];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    WebSocketRailsEvent *closeEvent = [WebSocketRailsEvent.alloc initWithData:@[@"connection_closed", @{}]];
    _dispatcher.state = @"disconnected";
    [_dispatcher dispatch:closeEvent];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    WebSocketRailsEvent *closeEvent = [WebSocketRailsEvent.alloc initWithData:@[@"connection_error", @{}]];
    _dispatcher.state = @"disconnected";
    [_dispatcher dispatch:closeEvent];
}

@end
