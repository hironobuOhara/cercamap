//
//  CercaMapView.m
//  Cerca
//
//  Created by Peter Zion on 10/03/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CercaMapView.h"
#import "CercaMapViewDelegate.h"

@implementation CercaMapView

-(void) awakeFromNib
{
	mode = M_NONE;
}

+(CGFloat) distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
	return sqrt( (point2.x - point1.x) * (point2.x - point1.x) + (point2.y - point1.y) * (point2.y - point1.y) );
}

-(void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *allTouches = [event allTouches];
    
    switch ( [allTouches count] )
	{
        case 1:
		{
			mode = M_PANNING;
			panStartPoint = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
        }
		break;
		
        case 2:
		{
			mode = M_ZOOMING;
            CGPoint point1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
            CGPoint point2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];
            zoomStartDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
        }
		break;
		
        default:
            mode = M_NONE;
            break;
    }
}

-(void) touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSSet *allTouches = [event allTouches];
    
    switch ( [allTouches count] )
	{
        case 1:
		{
            if ( mode == M_PANNING )
			{
				CGPoint panEndPoint = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
				CGPoint delta = CGPointMake( panEndPoint.x-panStartPoint.x, panEndPoint.y-panStartPoint.y );
				[delegate cercaMapView:self didPanByDelta:delta];
				panStartPoint = panEndPoint;
			}
			else
				mode = M_NONE;
        }
		break;
        
       case 2:
	   {
			if ( mode == M_ZOOMING )
			{
				CGPoint point1 = [[[allTouches allObjects] objectAtIndex:0] locationInView:self];
				CGPoint point2 = [[[allTouches allObjects] objectAtIndex:1] locationInView:self];
				CGFloat zoomEndDistance = [CercaMapView distanceFromPoint:point1 toPoint:point2];
				if ( zoomEndDistance > 1.5 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomIn:self];
					zoomStartDistance = zoomEndDistance;
				}
				else if ( zoomEndDistance < .67 * zoomStartDistance )
				{
					[delegate cercaMapViewDidZoomOut:self];
					zoomStartDistance = zoomEndDistance;
				}
			}
			else
				mode = M_NONE;
        }
		break;
		
        default:
            mode = M_NONE;
            break;
    }
}

-(void) touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    mode = M_NONE;
}

-(void) touchesCanceled
{
    mode = M_NONE;
}

@end
