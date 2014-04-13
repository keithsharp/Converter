//
//  AppDelegate.m
//  Converter
//
//  Created by Keith Sharp on 08/04/2014.
//  Copyright (c) 2014 Passback IT Consultancy. All rights reserved.
//

#import "AppDelegate.h"
#include "proj_api.h"

// Probably shouldn't have these as globals!
projPJ pjWGS84;
projPJ pjOSGB;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    if (!(pjWGS84 = pj_init_plus("+proj=longlat +ellps=WGS84 +no_defs"))) {
        NSLog(@"Could not initialise WGS84");
        exit(1);
    }
    if (!(pjOSGB = pj_init_plus("+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +datum=OSGB36 +units=m +no_defs"))) {
        NSLog(@"Could not initialise OSGB");
        exit(1);
    }
}

- (IBAction)convertToOSGB:(id)sender {
    double x, y;
    int e;

    x = DEG_TO_RAD * self.longitude.doubleValue;
    y = DEG_TO_RAD * self.latitude.doubleValue;
 
    if ((e = pj_transform(pjWGS84, pjOSGB, 1, 0, &x, &y, NULL)) != 0) {
        [self.osgbRef setStringValue:@"Transform Error"];
    } else {
        [self.osgbRef setStringValue:[NSString stringWithFormat:@"%d %d", @(x).intValue, @(y).intValue]];
    }
}

@end
