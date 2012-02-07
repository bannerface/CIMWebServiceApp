//
//  CIMWebServiceAppAppDelegate.h
//  CIMWebServiceApp
//
//  Created by Jian Gao on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CIMWebServiceAppViewController;

@interface CIMWebServiceAppAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CIMWebServiceAppViewController *viewController;

@end
