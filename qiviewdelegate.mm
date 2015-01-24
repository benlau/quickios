#import "qiviewdelegate.h"

@interface QIViewDelegate ()

@end

@implementation QIViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertViewClickedButtonAtIndex)
        alertViewClickedButtonAtIndex(buttonIndex);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertViewDismissWithButtonIndex)
        alertViewDismissWithButtonIndex(buttonIndex);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (actionSheetClickedButtonAtIndex) {
        actionSheetClickedButtonAtIndex(buttonIndex);
    }
}

@end
