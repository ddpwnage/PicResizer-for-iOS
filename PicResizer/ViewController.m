//
//  ViewController.m
//  PicResizer
//
//  Created by Danny Dalton on 1/23/15.
//  Copyright (c) 2015 Dannydalton.com. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)checkForStillCapability {
    NSArray *frontCamera = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceFront];
    for (NSObject *frontValue in frontCamera) {
        if (frontValue == UIImagePickerControllerCameraCaptureModePhoto) {
            return TRUE;
        }
    }
    NSArray *backCamera = [UIImagePickerController availableCaptureModesForCameraDevice:UIImagePickerControllerCameraDeviceRear];
    for (NSObject *backValue in backCamera) {
        if (backValue == UIImagePickerControllerCameraCaptureModePhoto) {
            return TRUE;
        }
    }
    NSLog(@"Camera has no ability for stills.");
    return FALSE;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        
        MainViewController *mainViewController;
        [mainViewController setValue:chosenImage forKey:@"imageSentIn"];
        
        [self performSegueWithIdentifier:@"goToMain" sender:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)cameraOrPicker:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Picture source" message:@"Where do you want to choose a picture from?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] && [self checkForStillCapability]) {
        UIAlertAction *takePic = [UIAlertAction actionWithTitle:@"Use the camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            picker.allowsEditing = NO;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
            [alertController addAction:takePic];
        }];
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *choosePic = [UIAlertAction actionWithTitle:@"Use the photo gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }];
        [alertController addAction:choosePic];
    }
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
