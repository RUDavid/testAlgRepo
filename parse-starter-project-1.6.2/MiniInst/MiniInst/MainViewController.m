//
//  MainViewController.m
//  MiniInst
//
//  Created by David on 2/2/15.
//
//

#import "MainViewController.h"
#import <Parse/PFFile.h>
#import <Parse/PFObject.h>
#import <Parse/PFUser.h>
#import "FeedViewController.h"
#import "Constats.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)takePhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    // image picker needs a delegate,
    [imagePickerController setDelegate:self];
    
    // Place image picker on the screen
    [self presentModalViewController:imagePickerController animated:YES];
    
}

-(IBAction)chooseFromLibrary:(id)sender
{
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // image picker needs a delegate so we can respond to its messages
    [imagePickerController setDelegate:self];
    // Place image picker on the screen
    [self presentModalViewController:imagePickerController animated:YES];
    
}

//delegate methode will be called after picking photo either from camera or library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; // Image to be stored
    
    NSData *imageData =  UIImageJPEGRepresentation(image, 0.1); //UIImagePNGRepresentation(image);
    //UIImageJPEGRepresentation(thumbnailImage, 0.1);
    
     PFFile *photoFile = [PFFile fileWithData:imageData];
    
    // Create a Photo object
    PFObject *photo = [PFObject objectWithClassName:kPAPPhotoClassKey];
    [photo setObject:[PFUser currentUser] forKey:kPAPPhotoUserKey];
    [photo setObject:photoFile forKey:kPAPPhotoPictureKey];
    
    [photo saveInBackground];
}


- (IBAction)goToFeedScreen:(id)sender {
    FeedViewController *feedViewController=[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    [self.navigationController pushViewController:feedViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
