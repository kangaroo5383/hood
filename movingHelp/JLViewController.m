//
//  JLViewController.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "JLViewController.h"
#import "JLService.h"

@interface JLViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet MKMapView *mainMap;
@property BOOL crimeDrawn;

@end

@interface JLViewController (protocol) <MKMapViewDelegate>
@end

@interface JLViewController (drawing)
- (void)drawCrimeInformation;
- (void)squareForCenterAt:(CLLocationCoordinate2D)center;
- (void)drawCoordinates:(CLLocationCoordinate2D *)drawingCoordinates count:(NSInteger)count forType:(NSInteger)aType onMap:(MKMapView *)mapView;
@end


@implementation JLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //San Francsico
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.7645381907803,  -122.440239784725), MKCoordinateSpanMake(0.136888010555715, 0.134679137168746));
    [[self mainMap] setRegion:defaultRegion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation JLViewController (protocol)
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    [self drawCrimeInformation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"location changed");

}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake([[mapView userLocation] coordinate], MKCoordinateSpanMake(40, 40));
    [mapView setRegion:defaultRegion];
}
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	if([overlay isKindOfClass:[MKPolygon class]]){
		MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
		view.lineWidth=1;
		view.fillColor=[[UIColor redColor] colorWithAlphaComponent:0.1];
        return view;
	}
	return nil;
}
@end

@implementation JLViewController (drawing)
- (void)drawCoordinates:(CLLocationCoordinate2D *)drawingCoordinates count:(NSInteger)count forType:(NSInteger)aType onMap:(MKMapView *)mapView {
    //TODO: type determines color
    MKPolygon *polygon = [MKPolygon polygonWithCoordinates:drawingCoordinates count:count];
    [mapView addOverlay:polygon];
}

- (void)squareForCenterAt:(CLLocationCoordinate2D)center {
    CLLocationDegrees offset = 0.0008;
    CLLocationCoordinate2D coords[5] = {
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude - offset),
        CLLocationCoordinate2DMake(center.latitude + offset, center.longitude - offset),
        CLLocationCoordinate2DMake(center.latitude + offset, center.longitude + offset),
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude + offset),
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude - offset)
    };
    
    [self drawCoordinates:coords count:5 forType:0 onMap:[self mainMap]];
    return;
}

- (void)drawCrimeInformation {
    if (![self crimeDrawn]) {
        NSArray *crimeArray = [[JLService sharedService] crimeDataForYear:@"2012"];
        NSInteger count = 5000;
        NSInteger i = 0 ;
        for (NSDictionary *aCrime in crimeArray) {
            if (i > count) {
                break;
            }
            CLLocationDegrees x = [aCrime[@"X"] doubleValue];
            CLLocationDegrees y = [aCrime[@"Y"] doubleValue];
            
            CLLocationCoordinate2D center = CLLocationCoordinate2DMake(y, x);
            [self squareForCenterAt:center];
            i++;
        }
        [self setCrimeDrawn:YES];
    }
}

@end