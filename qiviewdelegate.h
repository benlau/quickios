//
// QIViewDelegate - A universal delegate class for listening event
//

#include <UIKit/UIKit.h>

@interface QIViewDelegate : NSObject<UIAlertViewDelegate> {

    @public

    void ( ^ alertViewClickedButtonAtIndex )( int );
    void ( ^ alertViewDismissWithButtonIndex )( int );

}
@end
