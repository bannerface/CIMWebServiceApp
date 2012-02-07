//
//  CIMWebServiceAppViewController.h
//  CIMWebServiceApp
//
//  Created by Jian Gao on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIMWebServiceAppViewController : UIViewController<NSXMLParserDelegate>
{
    NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL recordResults;
}

@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
//
@end
