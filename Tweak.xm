%include <UIKit/UIKit.h>
%hook UITableViewCell

- (void)layoutSubviews {
    %orig;

    UIView *content = self.contentView;
    if (!content) return;

    __block BOOL containsMP3 = NO;
    void (^scanSubviews)(UIView *) = ^(UIView *v){
        for (UIView *sub in v.subviews) {
            if ([sub isKindOfClass:UILabel.class]) {
                UILabel *lab = (UILabel*)sub;
                if (lab.text && [lab.text containsString:@".mp3"]) {
                    containsMP3 = YES;
                    break;
                }
            }
            scanSubviews(sub);
            if (containsMP3) break;
        }
    };
    scanSubviews(content);

    if (!containsMP3) return;

    // avoid styling multiple times
    static char styledKey;
    NSNumber *already = objc_getAssociatedObject(self, &styledKey);
    if (already && already.boolValue) return;
    objc_setAssociatedObject(self, &styledKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    // add rounded dark background
    CGRect inset = CGRectInset(content.bounds, 8, 6);
    UIView *bg = [[UIView alloc] initWithFrame:inset];
    bg.backgroundColor = [UIColor colorWithWhite:0.15 alpha:1.0];
    bg.layer.cornerRadius = 16.0;
    bg.clipsToBounds = YES;
    bg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [content insertSubview:bg atIndex:0];

    // hide date-like labels (heuristic: contains " at ")
    void (^updateLabels)(UIView *) = ^(UIView *v){
        for (UIView *sub in v.subviews) {
            if ([sub isKindOfClass:UILabel.class]) {
                UILabel *lab = (UILabel*)sub;
                if (lab.text && [lab.text containsString:@" at "]) {
                    lab.hidden = YES;
                }
                // smaller subtitle: change "Audio ·" to "Audio Recording"
                if (lab.text && [lab.text rangeOfString:@"Audio" options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    lab.text = @"Audio Recording";
                }
                lab.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
            }
            // replace play button appearance
            if ([sub isKindOfClass:UIButton.class]) {
                UIButton *btn = (UIButton*)sub;
                CGFloat side = 52.0;
                btn.bounds = CGRectMake(0,0,side,side);
                btn.layer.cornerRadius = side/2.0;
                btn.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.5 alpha:1.0];
                btn.tintColor = [UIColor whiteColor];
                // create triangle image
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(20,20), NO, 0);
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
                UIBezierPath *p = [UIBezierPath bezierPath];
                [p moveToPoint:CGPointMake(0,0)];
                [p addLineToPoint:CGPointMake(20,10)];
                [p addLineToPoint:CGPointMake(0,20)];
                [p closePath];
                [p fill];
                UIImage *tri = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [btn setImage:tri forState:UIControlStateNormal];
                btn.contentEdgeInsets = UIEdgeInsetsMake(8,8,8,8);
                btn.center = CGPointMake(content.bounds.size.width - side/2 - 12, content.bounds.size.height/2);
                btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            }
            updateLabels(sub);
        }
    };
    updateLabels(content);
}

%end
