//
//  AppDelegate.h
//  Converter
//
//  Created by Keith Sharp on 08/04/2014.
//  Copyright (c) 2014 Passback IT Consultancy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *latitude;
@property (weak) IBOutlet NSTextField *longitude;
@property (weak) IBOutlet NSTextField *osgbRef;

- (IBAction)convertToOSGB:(id)sender;

@end
