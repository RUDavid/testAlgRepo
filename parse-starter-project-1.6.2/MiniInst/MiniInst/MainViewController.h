//
//  MainViewController.h
//  MiniInst
//
//  Created by David on 2/2/15.
//
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate>

//UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

@end
