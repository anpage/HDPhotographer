//
//  PLCameraHDButton.h
//  HD Photographer
//
//  Created by Frigid on 10/19/10.
//  Copyright 2010 Alex Page. All rights reserved.
//

//Subclasses PLCameraHDRButton for a consistent UI

#import <PhotoLibrary/PLCameraHDRButton.h>

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <PhotoLibrary/PLCameraFlashLabelView.h>

#import <PhotoLibrary/PLCameraView.h>

#import <PhotoLibrary/PLCameraController.h>

#import <Celestial/AVCapture.h>

@class PLCameraFlashLabelView, UIImageView;

@interface PLCameraHDButton : PLCameraHDRButton
{
	BOOL HDEnabled;
}

- (void)setButtonState:(BOOL)Enabled;

- (void)reloadCaptureMode;

@property(nonatomic) BOOL HDEnabled;

@end

