//
//  DocumentViewController.h
//  BreastImplantExercises
//
//  Created by Jacky Nguyen on 5/19/13.
//
//

#import <UIKit/UIKit.h>

@interface DocumentViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (copy, nonatomic) NSString *document;
- (IBAction)close_Click:(id)sender;

@end
