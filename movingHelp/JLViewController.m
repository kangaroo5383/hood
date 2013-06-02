//
//  JLViewController.m
//  movingHelp
//
//  Created by Jessica Lam on 6/1/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "JLViewController.h"
#import "JLService.h"
#import "JLDataSelectionViewController.h"

@interface JLViewController ()
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet MKMapView *mainMap;
@property (nonatomic, retain) NSArray *crimeOverlays;
@property BOOL crimeDisplayed;

@property (nonatomic, retain) NSArray *rentOverlays;

@property (nonatomic, retain) NSArray *neighborhoodOverlays;
@property BOOL neighborhoodDisplayed;

//TODO
@property (nonatomic, retain) NSArray *schoolOverlays;

//TODO
@property (nonatomic, retain) NSArray *meetupOverlays;
@end

@interface JLViewController (action)
- (IBAction)toggleCrimeData:(id)sender;
- (IBAction)goToAddress:(id)sender;
- (IBAction)toggleNeighborhoods:(id)sender;
- (IBAction)displaySelectionMenu:(id)sender;

@end
@interface JLViewController (protocol) <MKMapViewDelegate>
@end

@interface JLViewController (drawing)
- (void)drawCrimeInformation;
- (MKPolygon *)squareForCenterAt:(CLLocationCoordinate2D)center;
@end

@implementation JLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //San Francsico
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.7645381907803,  -122.440239784725), MKCoordinateSpanMake(0.136888010555715, 0.134679137168746));
    [[self mainMap] setRegion:defaultRegion];
    [self setDisplayData:@[]];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self displayData]) {
        NSArray *onKeys = [self displayData];
        if ([onKeys containsObject:@"crime"]) {
            if (![self crimeDisplayed]) {
                [[self mainMap] addOverlays:[self crimeOverlays]];
                [self setCrimeDisplayed:YES];
            }
        } else {
            [[self mainMap] removeOverlays:[self crimeOverlays]];
            [self setCrimeDisplayed:NO];
        }
        
        if ([onKeys containsObject:@"neighborhood"]) {
            if (![self neighborhoodDisplayed]) {
                [[self mainMap] addOverlays:[self neighborhoodOverlays]];
                [self setNeighborhoodDisplayed:YES];
            }
        } else {
            [[self mainMap] removeOverlays:[self neighborhoodOverlays]];
            [self setNeighborhoodDisplayed:NO];
        }
        
        if ([onKeys containsObject:@"school"]) {
            [[self mainMap] addOverlays:[self schoolOverlays]];
        } else {
            [[self mainMap] removeOverlays:[self schoolOverlays]];
        }
        
        if ([onKeys containsObject:@"meetup"]) {
            [[self mainMap] addOverlays:[self meetupOverlays]];
        } else {
            [[self mainMap] removeOverlays:[self meetupOverlays]];
        }
        
        if ([onKeys containsObject:@"rent"]) {
            [[self mainMap] addOverlays:[self rentOverlays]];
        } else {
            [[self mainMap] removeOverlays:[self rentOverlays]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSArray *)polygonsForDataArray:(NSArray *)dataArray limit:(NSInteger)limit{
    NSMutableArray *overlays = [NSMutableArray array];
    NSInteger i = 0;
    for (NSDictionary *aCrime in dataArray) {
        if (limit > 0) {    //-1 means everything goes
            if (i > limit) {
                break;
            }            
        }
        CLLocationDegrees x = [aCrime[@"X"] doubleValue];
        CLLocationDegrees y = [aCrime[@"Y"] doubleValue];
        
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(y, x);
        MKPolygon *aPolygon = [self squareForCenterAt:center];
//        [aPolygon setAColor:[UIColor redColor]];
        [overlays addObject:aPolygon];
        i++;
    }
    return [NSArray arrayWithArray:overlays];
}

- (NSArray *)crimeOverlays {
    if (!_crimeOverlays) {
        NSArray *crimeArray = [[JLService sharedService] crimeDataForYear:@"2012"];
        _crimeOverlays = [self polygonsForDataArray:crimeArray limit:5000];
    }
    return _crimeOverlays;
}

- (NSArray *)rentOverlays {
    if (!_rentOverlays) {
        NSArray *rentArray = [[JLService sharedService] rentData];
        _rentOverlays = [self polygonsForDataArray:rentArray limit:100];
    }
    return _rentOverlays;
}

- (NSArray *)neighborhoodOverlays {
    if (!_neighborhoodOverlays) {
        NSArray *neighborhood = [[JLService sharedService] neighborhoodsInRegion:[[self mainMap] region]];
        NSMutableArray *polygons = [NSMutableArray array];
        NSInteger limit = -1;
        NSInteger i = 0;
        for (NSDictionary *anEntry in neighborhood) {
            if (limit > 0 ) {
                if (i > limit) {
                    break;
                }
                i++;
            }
            NSArray *coordinates = anEntry[@"geometry"][@"coordinates"][0];
            CLLocationCoordinate2D *points = malloc([coordinates count] * sizeof(CLLocationCoordinate2D));

            NSInteger i = 0;
            for (NSArray *coordinate in coordinates) {
                CLLocationCoordinate2D aPoint = CLLocationCoordinate2DMake([coordinate[1] doubleValue], [coordinate[0] doubleValue]);
                points[i] = aPoint;
                i++;
            }
            [polygons addObject:[MKPolygon polygonWithCoordinates:points count:[coordinates count]]];
            free(points);
        }
        _neighborhoodOverlays = [NSArray arrayWithArray:polygons];
    }
    return _neighborhoodOverlays;
}

- (NSArray *)schoolOverlays {
    if (!_schoolOverlays) {
        
    }
    return _schoolOverlays;
}

@end

@implementation JLViewController (protocol)
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMake([[mapView userLocation] coordinate], MKCoordinateSpanMake(40, 40));
    [mapView setRegion:defaultRegion];
}
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	if([overlay isKindOfClass:[MKPolygon class]]){
		MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
		view.lineWidth=1;
        if ([[self crimeOverlays] containsObject:overlay]) {
            view.fillColor=[[UIColor redColor] colorWithAlphaComponent:0.1];
        }
        if ([[self neighborhoodOverlays] containsObject:overlay]) {
            [view setStrokeColor:[UIColor greenColor]];
            [view setFillColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
        }
        return view;
	}
	return nil;
}
@end

@implementation JLViewController (drawing)

- (MKPolygon *)squareForCenterAt:(CLLocationCoordinate2D)center {
    CLLocationDegrees offset = 0.0008;
    CLLocationCoordinate2D coords[5] = {
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude - offset),
        CLLocationCoordinate2DMake(center.latitude + offset, center.longitude - offset),
        CLLocationCoordinate2DMake(center.latitude + offset, center.longitude + offset),
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude + offset),
        CLLocationCoordinate2DMake(center.latitude - offset, center.longitude - offset)
    };
    
    return [MKPolygon polygonWithCoordinates:coords count:5];
}

- (void)drawCrimeInformation {
    [[self mainMap] addOverlays:[self crimeOverlays]];
}

@end

@implementation JLViewController (action)


- (IBAction)toggleCrimeData:(id)sender {
    if ([self crimeDisplayed]) {
        [[self mainMap] removeOverlays:[self crimeOverlays]];
        [self setCrimeDisplayed:NO];
    } else {
        [[self mainMap] addOverlays:[self crimeOverlays]];
        [self setCrimeDisplayed:YES];
    }
    
}

- (IBAction)goToAddress:(id)sender {
    NSString *addressString = [[self addressField] text];
    
}

- (IBAction)toggleNeighborhoods:(id)sender {
    if ([self neighborhoodDisplayed]) {
        [[self mainMap] removeOverlays:[self neighborhoodOverlays]];
        [self setNeighborhoodDisplayed:NO];
    } else {
        [[self mainMap] addOverlays:[self neighborhoodOverlays]];
        [self setNeighborhoodDisplayed:YES];
    }
}

- (IBAction)displaySelectionMenu:(id)sender {

}
@end