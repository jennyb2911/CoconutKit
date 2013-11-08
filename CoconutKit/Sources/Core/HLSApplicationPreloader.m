//
//  HLSApplicationPreloader.m
//  CoconutKit
//
//  Created by Samuel Défago on 02.07.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

#import "HLSApplicationPreloader.h"

#import "HLSAssert.h"
#import "HLSLogger.h"

@interface HLSApplicationPreloader ()

@property (nonatomic, assign) UIApplication *application;           // weak ref since retained by the application

@end

@implementation HLSApplicationPreloader

#pragma mark Object creation and destruction

- (id)initWithApplication:(UIApplication *)application
{
    if ((self = [super init])) {
        if (! application) {
            HLSLoggerError(@"Missing application");
            [self release];
            return nil;
        }
        
        self.application = application;
    }
    return self;
}

- (id)init
{
    HLSForbiddenInheritedMethod();
    return nil;
}

- (void)dealloc
{
    self.application = nil;

    [super dealloc];
}

#pragma mark Pre-loading

- (void)preload
{
    // To avoid the delay which occurs when loading a UIWebView for the first time, we display one as soon as possible
    // (out of screen bounds). It seems that loading a large web view (here with the application frame size) is more 
    // effective
    CGRect applicationFrame = [UIScreen mainScreen].applicationFrame;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(applicationFrame), 
                                                                     CGRectGetMaxY(applicationFrame), 
                                                                     CGRectGetWidth(applicationFrame), 
                                                                     CGRectGetHeight(applicationFrame))];
    webView.delegate = self;
    
    UIWindow *keyWindow = self.application.keyWindow;
    if (keyWindow) {
        [keyWindow addSubview:webView];
        
        // We do not need to load anything meaningful
        [webView loadHTMLString:@"" baseURL:nil];
    }
    else {
        HLSLoggerWarn(@"No key window found. Cannot preload UIWebView. To fix this issue, your application delegate must "
                      "implement the -application:didFinishLaunchingWithOptions: method to set the key window, either by "
                      "calling -makeKeyAndVisible or -makeKeyWindow");
    }    
}

#pragma mark UIWebViewDelegate protocol implementation

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // The web view is not needed anymore
    [webView removeFromSuperview];
    [webView release];
}

@end
