#import "qiviewdelegate.h"

@interface QIViewDelegate ()

@end

@implementation QIViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertViewClickedButtonAtIndex)
        alertViewClickedButtonAtIndex(buttonIndex);
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertViewDismissWithButtonIndex)
        alertViewDismissWithButtonIndex(buttonIndex);
    [alertView release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (actionSheetClickedButtonAtIndex) {
        actionSheetClickedButtonAtIndex(buttonIndex);
    }

    [actionSheet release];
}

@end
