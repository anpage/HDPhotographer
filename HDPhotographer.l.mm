//
//  HDPhotographer.l.mm
//  HD Photographer
//
//  Created by Frigid on 10/18/10.
//  Copyright 2010 Alex Page. All rights reserved.
//
//  MobileSubstrate, libsubstrate.dylib, and substrate.h are
//  created and copyrighted by Jay Freeman a.k.a. saurik and 
//  are protected by various means of open source licensing.
//
//  Theos and Logos are created and copyrighted by Dustin Howett
//  a.k.a. DHowett and are protected by various means of open
//  source licensing.
//

#import <PhotoLibrary/PLCameraView.h>
#import <PhotoLibrary/PLCameraController.h>
#import <Celestial/AVCapture.h>
#import "PLCameraHDButton.h"

PLCameraHDButton *HDButton;

%hook PLCameraFlashLabelView
- (id)initWithFrame:(struct CGRect)arg1 { %log; return %orig; }
- (void)dealloc { %log; %orig; }
- (void)_reloadLabelContents { %log; %orig; }
- (void)sizeToFit { %log; %orig; }
- (struct CGImage *)_newLabelImage:(BOOL)arg1 { %log; return %orig; }
- (void)updateLabelContents { %log; %orig; }
- (BOOL)_shouldAnimatePropertyWithKey:(id)arg1 { %log; return %orig; }
%end


%hook PLCameraView

- (void)_updateOverlayControls {
	
	%orig;
    
	//UI-handling stuff
	
    PLCameraController *&cameraController(MSHookIvar<PLCameraController *>(self, "_cameraController"));
    
    UIView *&overlayView(MSHookIvar<UIView *>(self, "_overlayView"));
    
    if ([cameraController cameraMode] == 0 && [cameraController cameraDevice] == 0)
    {
        
        if (HDButton == NULL)
        {
			
            HDButton = [[PLCameraHDButton alloc] initWithFrame:CGRectMake(20,20,122,63)];
            
        }
        
        if (![[HDButton superview] isEqual: overlayView])
        {
            
            [overlayView addSubview:HDButton];
            
        }
        
    } else if (HDButton != NULL && [[HDButton superview] isEqual: overlayView]) {
        
        [HDButton removeFromSuperview];
        
    }
	
}

%end

%hook AVCapture

- (id)optionsForCaptureMode:(NSString *) captureMode qualityPreset:(NSString *) qualityPreset {
	
	BOOL HDEnabled;
	
	if (HDButton != NULL) {
		
		HDEnabled = [HDButton HDEnabled];
		
	} else { //If the HD toggle button hasn't been created yet, use the user defaults
			
		HDEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"HDEnabled"]; 
		
	}

	
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithDictionary:%orig];
	
	if ([captureMode isEqualToString:@"AVCaptureMode_PhotoCapture"])
	{
		
		NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"LiveSourceOptions"]];
        
        NSMutableDictionary *tempCaptureDict = [NSMutableDictionary dictionaryWithDictionary:[tempDict objectForKey:@"Capture"]];
        
        NSMutableDictionary *tempPreviewDict = [NSMutableDictionary dictionaryWithDictionary:[tempDict objectForKey:@"Preview"]];
        
        NSMutableDictionary *tempSensorDict = [NSMutableDictionary dictionaryWithDictionary:[tempDict objectForKey:@"Sensor"]];
        
		if (HDEnabled) { //If HD is enabled, set the capture mode settings accordingly
			
			[tempCaptureDict setValue: [NSNumber numberWithInt:1280] forKey: @"Width"];
        
			[tempSensorDict setValue: [NSNumber numberWithInt:1280] forKey: @"Width"];
        
			[tempPreviewDict setValue: [NSNumber numberWithInt:540] forKey: @"Height"];
			
		} else { //Vise-versa for HD disabled
			
			[tempCaptureDict setValue: [NSNumber numberWithInt:960] forKey: @"Width"];
			
			[tempSensorDict setValue: [NSNumber numberWithInt:960] forKey: @"Width"];
			
			[tempPreviewDict setValue: [NSNumber numberWithInt:720] forKey: @"Height"];
			
		}

		
		[tempDict setValue: tempCaptureDict forKey: @"Capture"];
        
        [tempDict setValue: tempPreviewDict forKey: @"Preview"]; 
        
        [tempDict setValue: tempSensorDict forKey: @"Sensor"]; 
		
		[result setValue: tempDict forKey: @"LiveSourceOptions"];
		
	}
	
	return result;
	
}

%end