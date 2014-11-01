#import "qiviewdelegate.h"

@interface QIViewDelegate ()

@end

@implementation QIViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    __attribute__((alertView));
    if (alertViewDismissWithButtonIndex)
        alertViewDismissWithButtonIndex(buttonIndex);
}

@end
