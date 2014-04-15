//
//  AppDelegate.m
//  Converter
//
//  Created by Keith Sharp on 08/04/2014.
//  Copyright (c) 2014 Passback IT Consultancy. All rights reserved.
//

#import "AppDelegate.h"
#include "proj_api.h"

static NSMutableArray *grid = nil;

NSString *gridRefNumToLet(int eastings, int northings, int digits)
{
    // Get the 100K grid indices
    int e100k = floor(eastings/100000);
    int n100k = floor(northings/100000);
    if (e100k < 0 || e100k > 6 || n100k < 0 || n100k > 12) {
        return nil;
    }
    
    // Convert indices to letter pair
    NSString *letters = [NSString stringWithFormat:@"%@", [[grid objectAtIndex:n100k] objectAtIndex:e100k]];
    
    // Strip 100K grid and reduce precision
    int e = floor((eastings%100000)/pow(10, 5-digits/2));
    int n = floor((northings%100000)/pow(10, 5-digits/2));
    
    // Assemble and return the grid reference
    return [NSString stringWithFormat:@"%@%d%d", letters, e, n];
}

@interface AppDelegate ()
{
    projPJ pjWGS84;
    projPJ pjOSGB;
}
@end

@implementation AppDelegate

+(void)initialize
{
    if (!grid) {
        grid = [[NSMutableArray alloc] initWithCapacity:13];
        [grid insertObject:@[@"SV", @"SW", @"SX", @"SY", @"SZ", @"TV", @"Tw"] atIndex:0];
        [grid insertObject:@[@"SQ", @"SR", @"SS", @"ST", @"SU", @"TQ", @"TR"] atIndex:1];
        [grid insertObject:@[@"SL", @"SM", @"SN", @"SO", @"SP", @"TL", @"TM"] atIndex:2];
        [grid insertObject:@[@"SF", @"SG", @"SH", @"SJ", @"SK", @"TF", @"TG"] atIndex:3];
        [grid insertObject:@[@"SA", @"SB", @"SC", @"SD", @"SE", @"TA", @"TB"] atIndex:4];
        [grid insertObject:@[@"NV", @"NW", @"NX", @"NY", @"NZ", @"OV", @"Ow"] atIndex:5];
        [grid insertObject:@[@"NQ", @"NR", @"NS", @"NT", @"NU", @"OQ", @"OR"] atIndex:6];
        [grid insertObject:@[@"NL", @"NM", @"NN", @"NO", @"NP", @"OL", @"OM"] atIndex:7];
        [grid insertObject:@[@"NF", @"NG", @"NH", @"NJ", @"NK", @"OF", @"OG"] atIndex:8];
        [grid insertObject:@[@"NA", @"NB", @"NC", @"ND", @"NE", @"OA", @"OB"] atIndex:9];
        [grid insertObject:@[@"HV", @"HW", @"HX", @"HY", @"HZ", @"JV", @"Jw"] atIndex:10];
        [grid insertObject:@[@"HQ", @"HR", @"HS", @"HT", @"HU", @"JQ", @"JR"] atIndex:11];
        [grid insertObject:@[@"HL", @"HM", @"HN", @"HO", @"HP", @"JL", @"JM"] atIndex:12];
    }
}

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
        [self.osgbRef setStringValue:@"Error"];
    } else {
        [self.osgbRef setStringValue:gridRefNumToLet((int)floor(x), (int)floor(y), 6)];
    }
}

@end
