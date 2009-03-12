//
//  CercaMapView.h
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark Forward Declarations
@protocol CercaMapViewDelegate;

@interface CercaMapView : UIView
{
@private
	IBOutlet id <CercaMapViewDelegate> delegate;
	int numPoints;
	CGPoint points[2];
}

@end
