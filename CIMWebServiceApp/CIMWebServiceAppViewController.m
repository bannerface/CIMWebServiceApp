//
//  CIMWebServiceAppViewController.m
//  CIMWebServiceApp
//
//  Created by Jian Gao on 12-2-6.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CIMWebServiceAppViewController.h"

@implementation CIMWebServiceAppViewController

@synthesize webData, soapResults, xmlParser;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *urlString = [NSString stringWithFormat:@"http://192.168.1.54/CIMWebService/Service1.asmx"]; 
    
    NSString *soapMessage = nil;
    soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                   "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                   "<soap:Body>\n"
                   "<HelloWorld xmlns=\"http://tempuri.org/\" />\n"
                   "</soap:Body>\n"
                   "</soap:Envelope>\n"];
    
    NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	//以下对请求信息添加属性前四句是必有的，第五句是soap信息。
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/HelloWorld" forHTTPHeaderField:@"SOAPAction"];
	
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
	//请求
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	//如果连接已经建好，则初始化data
	if( theConnection )
	{
		webData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	//[webData setLength: 0];
	NSLog(@"connection: didReceiveResponse:1");
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
	NSLog(@"connection: didReceiveData:2");
    
}

//如果电脑没有连接网络，则出现此信息（不是网络服务器不通）
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"3 DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = nil;
    theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	NSLog(theXML);
	[theXML release];
	
    char *by = [webData mutableBytes];
    //TEST
	//重新加載xmlParser
	if( xmlParser )
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	[connection release];
	//[webData release];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	//NSLog(@"4 parser didStarElemen: namespaceURI: attributes:");
    
    if( [elementName isEqualToString:@"HelloWorldResult"])
	{
		if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
		recordResults = YES;
	}
	
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//NSLog(@"5 parser: foundCharacters:");
    
	if( recordResults )
	{
		[soapResults appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	//NSLog(@"6 parser: didEndElement:");
    
	if( [elementName isEqualToString:@"HelloWorldResult"])
	{
		recordResults = FALSE;
		NSString *strResult = [NSString stringWithFormat:@"Result is: %@", soapResults];
        NSLog(strResult);
        [strResult release];
        
		[soapResults release];
		soapResults = nil;
	}
	
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
	NSLog(@"-------------------start--------------");
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
	NSLog(@"-------------------end--------------");
}

- (void)dealloc 
{
	[xmlParser release];
	
	[super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
