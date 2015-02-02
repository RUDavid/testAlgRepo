//
//  FeedViewController.m
//  MiniInst
//
//  Created by David on 2/2/15.
//
//

#import "FeedViewController.h"
#import <Parse/PFQuery.h>
#import "Constats.h"
#import "PAPPhotoCell.h"
#import <Parse/PFFile.h>


@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count * 2 + (self.paginationEnabled ? 1 : 0);
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //TODO: impelemt
//    UITableViewCell * cell ;
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/


#pragma mark - PFQueryTableViewController

- (PFQuery *)queryForTable {
    if (![PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
        [query setLimit:0];
        return query;
    }
    
    PFQuery *userPhotosQuery = [PFQuery queryWithClassName:kPAPPhotoClassKey];
    [userPhotosQuery whereKey:kPAPPhotoUserKey equalTo:[PFUser currentUser]];
    userPhotosQuery.limit = 1000;
    [userPhotosQuery orderByDescending:@"createdAt"];

    
    

    
//    // If no objects are loaded in memory, we look to the cache first to fill the table
//    // and then subsequently do a query against the network.
//    //
//    // If there is no network connection, we will hit the cache first.
//    if (self.objects.count == 0 || ![[UIApplication sharedApplication].delegate performSelector:@selector(isParseReachable)]) {
//        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
//    }
//    
    /*
     This query will result in an error if the schema hasn't been set beforehand. While Parse usually handles this automatically, this is not the case for a compound query such as this one. The error thrown is:
     
     Error: bad special key: __type
     
     To set up your schema, you may post a photo with a caption. This will automatically set up the Photo and Activity classes needed by this query.
     
     You may also use the Data Browser at Parse.com to set up your classes in the following manner.
     
     Create a User class: "User" (if it does not exist)
     
     Create a Custom class: "Activity"
     - Add a column of type pointer to "User", named "fromUser"
     - Add a column of type pointer to "User", named "toUser"
     - Add a string column "type"
     
     Create a Custom class: "Photo"
     - Add a column of type pointer to "User", named "user"
     
     You'll notice that these correspond to each of the fields used by the preceding query.
     */

    return userPhotosQuery;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    if (index < self.objects.count) {
        return self.objects[index];
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    
    if (false /*indexPath.row % 2 == 0*/) {
        // Header
        //return [self detailPhotoCellForRowAtIndexPath:indexPath];
    } else {
        // Photo
        PAPPhotoCell *cell = (PAPPhotoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[PAPPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            //[cell.photoButton addTarget:self action:@selector(didTapOnPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        cell.photoButton.tag = index;
        cell.imageView.image = [UIImage imageNamed:@"PlaceholderPhoto.png"];
        
        if (object) {
            cell.imageView.file = [object objectForKey:kPAPPhotoPictureKey];
            
            // PFQTVC will take care of asynchronously downloading files, but will only load them when the tableview is not moving. If the data is there, let's load it right away.
            if ([cell.imageView.file isDataAvailable]) {
                [cell.imageView loadInBackground];
            }
        }
        
        return cell;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
//    PAPLoadMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
//    if (!cell) {
//        cell = [[PAPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
//        cell.selectionStyle =UITableViewCellSelectionStyleNone;
//        cell.hideSeparatorBottom = YES;
//        cell.mainView.backgroundColor = [UIColor clearColor];
//    }
//    return cell;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ()

- (UITableViewCell *)detailPhotoCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailPhotoCell";
    
    if (self.paginationEnabled && indexPath.row == self.objects.count * 2) {
        // Load More section
        return nil;
    }
    
    NSUInteger index = [self indexForObjectAtIndexPath:indexPath];
    
//    PAPPhotoHeaderView *headerView = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!headerView) {
//        headerView = [[PAPPhotoHeaderView alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, self.view.bounds.size.width, 44.0f) buttons:PAPPhotoHeaderButtonsDefault];
//        headerView.delegate = self;
//        headerView.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    PFObject *object = [self objectAtIndexPath:indexPath];
//    headerView.photo = object;
//    headerView.tag = index;
//    [headerView.likeButton setTag:index];
    
//    NSDictionary *attributesForPhoto = [[PAPCache sharedCache] attributesForPhoto:object];
//    
//    if (attributesForPhoto) {
//        [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
//        [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
//        [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];
//        
//        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
//            [UIView animateWithDuration:0.200f animations:^{
//                headerView.likeButton.alpha = 1.0f;
//                headerView.commentButton.alpha = 1.0f;
//            }];
//        }
//    } else {
//        headerView.likeButton.alpha = 0.0f;
//        headerView.commentButton.alpha = 0.0f;
//        
//        @synchronized(self) {
//            // check if we can update the cache
//            NSNumber *outstandingSectionHeaderQueryStatus = [self.outstandingSectionHeaderQueries objectForKey:@(index)];
//            if (!outstandingSectionHeaderQueryStatus) {
//                PFQuery *query = [PAPUtility queryForActivitiesOnPhoto:object cachePolicy:kPFCachePolicyNetworkOnly];
//                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//                    @synchronized(self) {
//                        [self.outstandingSectionHeaderQueries removeObjectForKey:@(index)];
//                        
//                        if (error) {
//                            return;
//                        }
//                        
//                        NSMutableArray *likers = [NSMutableArray array];
//                        NSMutableArray *commenters = [NSMutableArray array];
//                        
//                        BOOL isLikedByCurrentUser = NO;
//                        
//                        for (PFObject *activity in objects) {
//                            if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike] && [activity objectForKey:kPAPActivityFromUserKey]) {
//                                [likers addObject:[activity objectForKey:kPAPActivityFromUserKey]];
//                            } else if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeComment] && [activity objectForKey:kPAPActivityFromUserKey]) {
//                                [commenters addObject:[activity objectForKey:kPAPActivityFromUserKey]];
//                            }
//                            
//                            if ([[[activity objectForKey:kPAPActivityFromUserKey] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
//                                if ([[activity objectForKey:kPAPActivityTypeKey] isEqualToString:kPAPActivityTypeLike]) {
//                                    isLikedByCurrentUser = YES;
//                                }
//                            }
//                        }
//                        
//                        [[PAPCache sharedCache] setAttributesForPhoto:object likers:likers commenters:commenters likedByCurrentUser:isLikedByCurrentUser];
//                        
//                        if (headerView.tag != index) {
//                            return;
//                        }
//                        
//                        [headerView setLikeStatus:[[PAPCache sharedCache] isPhotoLikedByCurrentUser:object]];
//                        [headerView.likeButton setTitle:[[[PAPCache sharedCache] likeCountForPhoto:object] description] forState:UIControlStateNormal];
//                        [headerView.commentButton setTitle:[[[PAPCache sharedCache] commentCountForPhoto:object] description] forState:UIControlStateNormal];
//                        
//                        if (headerView.likeButton.alpha < 1.0f || headerView.commentButton.alpha < 1.0f) {
//                            [UIView animateWithDuration:0.200f animations:^{
//                                headerView.likeButton.alpha = 1.0f;
//                                headerView.commentButton.alpha = 1.0f;
//                            }];
//                        }
//                    }
//                }];
//            }
//        }
//    }
//    
//    return headerView;
}

- (NSUInteger)indexForObjectAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row / 2;
}

@end
