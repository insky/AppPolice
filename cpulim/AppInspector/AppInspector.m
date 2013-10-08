//
//  AppInspectorController.m
//  Ishimura
//
//  Created by Maksym on 7/2/13.
//  Copyright (c) 2013 Maksym Stefanchuk. All rights reserved.
//

#import "AppInspector.h"
#import "ChromeMenu.h"
//#import "AppLimitSlider.h"
#import "AppLimitSliderCell.h"
#include <sys/sysctl.h>
#include <unistd.h>


/*
 * Return number of CPUs in computer
 */
static int system_ncpu() {
	static int ncpu = 0;
	if (ncpu)
		return ncpu;
	
#ifdef _SC_NPROCESSORS_ONLN
	ncpu = (int)sysconf(_SC_NPROCESSORS_ONLN);
#else
	int mib[2];
	mib[0] = CTL_HW;
	mig[1] = HW_NCPU;
	size_t len = sizeof(ncpu);
	sysctl(mib, 2, &ncpu, &len, NULL, 0);
#endif
	return ncpu;
}



@implementation AppInspector

@synthesize attachedToItem;

- (id)init {
	self = [super init];
	if (self) {
		[NSBundle loadNibNamed:@"AppInspector" owner:self];
		[NSBundle loadNibNamed:@"PopoverContentView" owner:self];
	}
	return self;
}


- (void)awakeFromNib {
//	NSLog(@"%@ awakeFromNib", [self className]);
//	[_popoverView setTranslatesAutoresizingMaskIntoConstraints:NO];
	[_popoverViewController setView:_popoverView];
	
//	NSLog(@"frame: %@", NSStringFromRect([_slider frame]));
	
//	[NSSlider setCellClass:[AppLimitSliderCell class]];
//	NSSlider *newSlider = [[NSSlider alloc] initWithFrame:NSMakeRect(15, 10, 300, 25)];
//	[NSSlider setCellClass:[NSSliderCell class]];
//	[newSlider setMinValue:0];
//	[newSlider setMaxValue:11];
//	[newSlider setNumberOfTickMarks:11];
//	[newSlider setTickMarkPosition:NSTickMarkBelow];
//	[newSlider setRefusesFirstResponder:YES];
//	[_popoverView addSubview:newSlider];
	
	[_slider setContinuous:YES];	// this is temporary here
	[_slider setTarget:self];
	[_slider setAction:@selector(sliderAction:)];
	[_levelIndicator setWarningValue:5];
	[_levelIndicator setCriticalValue:7.5];
//	[detachedWindow setContentView:popoverView];
	
	
//	int mib[2];
//	size_t len;
//	int ncpu;
//	int res;
//	mib[0] = CTL_HW;
//	mib[1] = HW_NCPU;
//	len = sizeof(ncpu);
//	res = sysctl(mib, 2, &ncpu, &len, NULL, 0);
	NSLog(@"cpu's: %d", system_ncpu());
}


// temp method
- (void)showPopoverRelativeTo:(NSView *)view {
//	if (popoverViewController == nil) {
//		popoverViewController = [[NSViewController alloc] initWithNibName:@"AppInspector" bundle:[NSBundle mainBundle]];
//	}
	
	
//	NSLog(@"called show popover: %@", popoverViewController);
	[_popover showRelativeToRect:[view bounds] ofView:view preferredEdge:NSMaxXEdge];
}


- (NSPopover *)popover {
	return _popover;
}


/*
- (NSWindow *)detachableWindowForPopover:(NSPopover *)thePopover {
	[thePopover setAnimates:NO];
	return detachedWindow;
}
 */

- (void)sliderAction:(id)sender {
	float value = [_slider floatValue];
//	NSEvent *theEvent = [NSApp currentEvent];
//	NSEventType eventType = [theEvent type];
//	NSPoint mouseLocation = [theEvent locationInWindow];
//	mouseLocation = [_slider convertPoint:mouseLocation fromView:nil];
//	mouseLocation = [theEvent window]
//	NSLog(@"event wind: %@", [theEvent window]);
//	NSLog(@"sliderh action: %f, event: %ld", value, eventType);

	
//	[_slider lockFocus];
//	[[NSColor redColor] set];
//	NSFrameRect(rect);
//	[_slider unlockFocus];
	
//	[_slider cell];
	
//	NSLog(@"sliderh action: %f", value);
//	NSLog(@"last before last rect: %@, mouse loca: %@", NSStringFromRect(rect), NSStringFromPoint(mouseLocation));

	/*
	if (eventType == NSLeftMouseUp) {
	
		if (_sliderMouseTrackingTimer) {
			[_sliderMouseTrackingTimer invalidate];
			_sliderMouseTrackingTimer = nil;
		}
	
	} else {
//	BOOL stopOnTickMarks = [_slider allowsTickMarkValuesOnly];
		NSInteger beforeLastTickMark = [_slider numberOfTickMarks] - 2;
		if (value >= beforeLastTickMark) {
			[_slider setAllowsTickMarkValuesOnly:YES];
			if (! _sliderMouseTrackingTimer) {
				NSRect tickMarkRect = [_slider rectOfTickMarkAtIndex:beforeLastTickMark];
				NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
										  [theEvent window], @"window",
										  [NSValue valueWithRect:tickMarkRect], @"tickMarkRect", nil];
				_sliderMouseTrackingTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(sliderTrackingTimerEvent:) userInfo:userInfo repeats:YES];
				[[NSRunLoop currentRunLoop] addTimer:_sliderMouseTrackingTimer forMode:NSRunLoopCommonModes];
			}
		} else {
			[_slider setAllowsTickMarkValuesOnly:NO];
		}
		
	}
	*/
	[_levelIndicator setFloatValue:value];
	
	if (value < 2) {
		[_applicationNameTextfield setStringValue:@"New app"];
	} else if (value < 4) {
		[_applicationNameTextfield setStringValue:@"New app with some name"];
	} else if (value < 6) {
		[_applicationNameTextfield setStringValue:@"Little Snitch Configuration (1024)"];
	} else {
		[_applicationNameTextfield setStringValue:@"New app with some name longer then previous app."];
	}

	
/*
//	NSLog(@"subviews: %@", [_popoverView subviews]);
//	[[[_popoverView subviews] objectAtIndex:0] invalidateIntrinsicContentSize];
	
	static int showingConstraints = 0;
	if (! showingConstraints) {
		NSEvent *theEvent = [NSApp currentEvent];
		NSWindow *window = [theEvent window];
//		NSArray *constraints = [_popoverView constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal];
		NSMutableArray *constraints = [NSMutableArray new];
		for (NSView *view in [_popoverView subviews]) {
			[constraints addObjectsFromArray:[view constraintsAffectingLayoutForOrientation:NSLayoutConstraintOrientationHorizontal]];
		}
		NSLog(@"all constraints: %@", constraints);
		[window visualizeConstraints:constraints];
		showingConstraints = 1;
	}
 */
	
}

/*
- (void)sliderTrackingTimerEvent:(NSTimer *)timer {
	NSDictionary *userInfo = [timer userInfo];
	NSWindow *window = [userInfo objectForKey:@"window"];
	NSPoint mouseLocation = [NSEvent mouseLocation];
	mouseLocation = [_slider convertPoint:[window convertScreenToBase:mouseLocation] fromView:nil];
//	NSLog(@"timer event, mouseloc: %@", NSStringFromPoint(mouseLocation));
	
	NSRect rect = [(NSValue *)[userInfo objectForKey:@"tickMarkRect"] rectValue];
	
	if (mouseLocation.x < rect.origin.x) {
//		NSLog(@"snapping should be released");
		[_slider setAllowsTickMarkValuesOnly:NO];
		[timer invalidate];
		_sliderMouseTrackingTimer = nil;
	}
	
}
 */


- (void)setPopverDidCloseHandler:(void (^)(void))handler {
	if (_handler != handler)
		_handler = handler;
}

- (void)popoverDidClose:(NSNotification *)notification {
//	[[[self attachedToItem] menu] setSuspendMenus:NO];
	if (_handler)
		_handler();
}


@end