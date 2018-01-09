//
//  JDStatusBarView.m
//  JDStatusBarNotificationExample
//
//  Created by Markus on 04.12.13.
//  Copyright (c) 2013 Markus. All rights reserved.
//

#import "JDStatusBarView.h"
#import "JDStatusBarLayoutMarginHelper.h"

@interface JDStatusBarView ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@end

@implementation JDStatusBarView

#pragma mark dynamic getter

- (UILabel *)textLabel;
{
  if (_textLabel == nil) {
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.adjustsFontSizeToFitWidth = YES;
    _textLabel.clipsToBounds = YES;
    [self addSubview:_textLabel];
  }
  return _textLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView;
{
  if (_activityIndicatorView == nil) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _activityIndicatorView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self addSubview:_activityIndicatorView];
  }
  return _activityIndicatorView;
}

- (UIImageView *)backgroundView
{
  if (_backgroundView == nil) {
    _backgroundView = [UIImageView new];
    [self insertSubview:_backgroundView atIndex:0];
  }
  return _backgroundView;
}

#pragma mark setter

- (void)setTextVerticalPositionAdjustment:(CGFloat)textVerticalPositionAdjustment;
{
  _textVerticalPositionAdjustment = textVerticalPositionAdjustment;
  [self setNeedsLayout];
}

#pragma mark layout

- (void)layoutSubviews;
{
  [super layoutSubviews];

  // label
  CGFloat topLayoutMargin = JDStatusBarRootVCLayoutMargin().top;
  self.textLabel.frame = CGRectMake(0,
                                    self.textVerticalPositionAdjustment + topLayoutMargin + 1,
                                    self.bounds.size.width,
                                    self.bounds.size.height - topLayoutMargin - 1);

  // background view, use ivar to prevent lazy creation
  if (_backgroundView)
  {
    [self sendSubviewToBack:_backgroundView];
    _backgroundView.frame = CGRectMake(0,
                                       0,
                                       CGRectGetWidth(self.bounds),
                                       CGRectGetHeight(self.bounds));
  }
  
  // activity indicator
  if (_activityIndicatorView ) {
    CGSize textSize = [self currentTextSize];
    CGRect indicatorFrame = _activityIndicatorView.frame;
    indicatorFrame.origin.x = round((self.bounds.size.width - textSize.width)/2.0) - indicatorFrame.size.width - 8.0;
    indicatorFrame.origin.y = ceil(1+(self.bounds.size.height - indicatorFrame.size.height + topLayoutMargin)/2.0);
    _activityIndicatorView.frame = indicatorFrame;
  }
}

- (CGSize)currentTextSize;
{
  CGSize textSize = CGSizeZero;

  // use new sizeWithAttributes: if possible
  SEL selector = NSSelectorFromString(@"sizeWithAttributes:");
  if ([self.textLabel.text respondsToSelector:selector]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSDictionary *attributes = @{NSFontAttributeName:self.textLabel.font};
    textSize = [self.textLabel.text sizeWithAttributes:attributes];
#endif
  }

  // otherwise use old sizeWithFont:
  else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000 // only when deployment target is < ios7
    textSize = [self.textLabel.text sizeWithFont:self.textLabel.font];
#endif
  }

  return textSize;
}

@end
