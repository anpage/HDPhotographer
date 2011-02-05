//
//  PLCameraHDButton.m
//  HD Photographer
//
//  Created by Frigid on 10/19/10.
//  Copyright 2010 Alex Page. All rights reserved.
//
//  MobileSubstrate, libsubstrate.dylib, and substrate.h are
//  created and copyrighted by Jay Freeman a.k.a. saurik and 
//  are protected by various means of open source licensing.
//

//TODO: Add more comments

#import "PLCameraHDButton.h"

#import <substrate.h>

@implementation PLCameraHDButton

@synthesize HDEnabled;

- (id)initWithFrame:(struct CGRect)arg1
{
	
	[super initWithFrame:arg1];
	
	[_hdrOnLabel setText:@"HD On"];
	
	[_hdrOffLabel setText:@"HD Off"];
	
	//TODO: Find a more dynamic way of positioning the button to account for custom fonts
	//Also, the button doesn't want to reorient when the device is upside-down
    
    CGRect tempFrame = [self frame];
	
    tempFrame.size.width = [_hdrOnLabel contentsSize].width + 64;
    
    [self setFrame: tempFrame];
    
    [self setButtonState: [[NSUserDefaults standardUserDefaults] boolForKey:@"HDEnabled"]];
	
	return self;
}

- (void)_handleSingleTap:(id)arg1
{
    
    [self setButtonState: [[NSNumber numberWithFloat: [_hdrOnLabel alpha]] isEqualToNumber: [NSNumber numberWithFloat: 0]]];
    
	[self reloadCaptureMode];
    
}

- (void)setButtonState:(BOOL)Enabled {
	
	if (Enabled)
    {
        
        [[NSUserDefaults standardUserDefaults]
         
         setObject: @"YES" forKey:@"HDEnabled"];
        
        _hdrEnabled = true;
		HDEnabled = true;
        [_hdrOnLabel setAlpha: 1.0F];
        [_hdrOffLabel setAlpha: 0.0F];
		
        
		if ([[[self superview] superview] superview] != NULL) {
			
			PLCameraView *cameraView = (PLCameraView *)[[[self superview] superview] superview];
			
			PLCameraController *&cameraController(MSHookIvar<PLCameraController *>(cameraView, "_cameraController"));
			
			[cameraController _setPreviewZoomMode:1 force:YES];
			
		}
        
    } else {
		
        [[NSUserDefaults standardUserDefaults]
         
         setObject: @"NO" forKey:@"HDEnabled"];
        
        _hdrEnabled = false;
		HDEnabled = false;
        [_hdrOnLabel setAlpha: 0.0F];
        [_hdrOffLabel setAlpha: 1.0F];
        
    }
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
}

- (void)reloadCaptureMode {
	
	PLCameraView *cameraView = (PLCameraView *)[[[self superview] superview] superview];
    
    PLCameraController *&cameraController(MSHookIvar<PLCameraController *>(cameraView, "_cameraController"));
    
    AVCapture *&avCapture(MSHookIvar<AVCapture *>(cameraController, "_avCapture"));
    
    NSString *&qualityPreset(MSHookIvar<NSString *>(avCapture, "_qualityPreset"));
    
    NSString *&captureMode(MSHookIvar<NSString *>(avCapture, "_captureMode"));
    
    [cameraView disableCamera];
    
    [avCapture setCaptureMode: captureMode qualityPreset: qualityPreset];
    
    [cameraView enableCamera];
	
}

- (void)_setHDREnabled:(BOOL)arg1 notifyDelegate:(BOOL)arg2 animated:(BOOL)arg3
{
}
- (void)setHDREnabled:(BOOL)arg1 notifyDelegate:(BOOL)arg2
{
}

@end
