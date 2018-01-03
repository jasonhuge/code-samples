//
//  CompassButton.m
//  Compass
//
//

#import "CompassButton.h"

@interface CompassButton ()

@end

@implementation CompassButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //default
        [self setStyle:CompassButtonStylePrimary];
        [self configure];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        //default
        [self setStyle:CompassButtonStylePrimary];
        [self configure];
    }
    return self;
}

-(void)configure
{
    //to use as needed
    if (self.currentTitle != nil && self.currentTitle.length > 0) {
        [self setTitle:self.currentTitle forState:UIControlStateNormal];
    }
}

-(void)setStyle:(CompassButtonStyle)style
{
    _style = style;
    
    //Fonts
    
    //We can't use the styles inherent from UILabel+Compass due to the complexity of
    //buttons having setTitle: and setAttributedTitle: methods
    switch (_style) {
        case CompassButtonStylePrimary:
        {
           // [self.titleLabel setFont:[UIFont compassL1Font]];
            break;
        }
        case CompassButtonStyleSecondary:
        {
           // [self.titleLabel setFont:[UIFont compassL2Font]];
            break;
        }
        case CompassButtonStylePrimarySmall:
        case CompassButtonStylePrimaryTitleSmall:
        {
           // [self.titleLabel setFont:[UIFont compassL3Font]];
            break;
        }
        case CompassButtonStyleSecondarySmall:
        {
           // [self.titleLabel setFont:[UIFont compassL4Font]];
            break;
        }
        case CompassButtonStyleNoBorder:
        {
           // [self.titleLabel setFont:[UIFont compassL3Font]];
            break;
        }
        case CompassButtonStyleAccentLink:
        {
           // [self.titleLabel setFont:[UIFont compassP1Font]];
            break;
        }
        case CompassButtonStyleAccentPressLink:
        {
           // [self.titleLabel setFont:[UIFont compassL7Font]];
            break;
        }
        default:
            break;
    }
    
    //Colors
    
    switch (_style) {
        case CompassButtonStylePrimary:
        case CompassButtonStylePrimarySmall:
        {
            [self setBackgroundColor:[UIColor grayColor]];
            //we can't rely on this for our actual code due to attributed title usage
            #if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
            #endif
            break;
        }
        case CompassButtonStylePrimaryTitleSmall:{
            [self setBackgroundColor:[UIColor clearColor]];
            //we can't rely on this for our actual code due to attributed title usage
            #if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateDisabled];
            #endif
        } break;
        case CompassButtonStyleSecondary:
        case CompassButtonStyleSecondarySmall:
        {
            self.layer.borderColor = [UIColor blackColor].CGColor;
            self.layer.borderWidth = 2.0;
            [self setBackgroundColor:[UIColor clearColor]];
            //we can't rely on this for our actual code due to attributed title usage
            #if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor compassMediumGrayColor] forState:UIControlStateDisabled];
            #endif
            break;
        }
        case CompassButtonStyleNoBorder:
        {
            [self setBackgroundColor:[UIColor clearColor]];
            self.layer.borderWidth = 0;
            self.layer.cornerRadius = 0;
            self.layer.borderColor = nil;
            //we can't rely on this for our actual code due to attributed title usage
            #if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor compassMediumGrayColor] forState:UIControlStateSelected];
            [self setTitleColor:[UIColor compassMediumGrayColor] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor compassMediumGrayColor] forState:UIControlStateDisabled];
            #endif
            break;
        }
        case CompassButtonStyleAccentLink:
        {
            [self setBackgroundColor:[UIColor clearColor]];
            self.layer.borderWidth = 0;
            self.layer.cornerRadius = 0;
            self.layer.borderColor = nil;
            //we can't rely on this for our actual code due to attributed title usage
            #if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor compassAccentColor] forState:UIControlStateNormal];
            #endif
            break;
        }
        case CompassButtonStyleAccentPressLink:
        {
            [self setBackgroundColor:[UIColor clearColor]];
            self.layer.borderWidth = 0;
            self.layer.cornerRadius = 0;
            self.layer.borderColor = nil;
            //we can't rely on this for our actual code due to attributed title usage
#if TARGET_INTERFACE_BUILDER
            [self setTitleColor:[UIColor compassBlueBlackColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor compassAccentColor] forState:UIControlStateHighlighted];
#endif
            break;
        }
        default:
            break;
    }
    [self setNeedsLayout];
}

//We have to take over the title set here, and use setAttributedTitle in able to get font
//tracking working. We can't use the styles inherent from UILabel+Compass as then the titleLabel
//doesn't resize its width properly to fit the new wider text.
//
//Additionally, we have to set the attributedTitle foreground colors here.
//
//For some reason this is crashing IB, so I'm only going to have it run in the tracking
//in the real app, hence the conditionals.
-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    //null check so we dont hit errors - crashlytics
    if (title != nil)
    {
        switch (self.style)
        {
            case CompassButtonStylePrimary:
            {
                #if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateDisabled];
                #else
                [super setTitle:[title uppercaseString] forState:state];
                #endif
                break;
            }
            case CompassButtonStyleSecondary:
            {
                #if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor grayColor]}] forState:UIControlStateDisabled];
                #else
                [super setTitle:title forState:state];
                #endif
                break;
            }
            case CompassButtonStylePrimarySmall:
            {
                #if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateDisabled];
                #else
                [super setTitle:[title uppercaseString] forState:state];
                #endif
                break;
            }
            case CompassButtonStylePrimaryTitleSmall:
            {
#if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateDisabled];
#else
                [super setTitle:[title uppercaseString] forState:state];
#endif
                break;
            }
            case CompassButtonStyleSecondarySmall:
            {
                #if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor blackColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor whiteColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor grayColor]}] forState:UIControlStateDisabled];
                #else
                [super setTitle:title forState:state];
                #endif
                break;
            }
            case CompassButtonStyleNoBorder:
            {
                #if !TARGET_INTERFACE_BUILDER
                CGFloat charSpacing = self.titleLabel.font.pointSize*160/1000;
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName: @(charSpacing), NSForegroundColorAttributeName: [UIColor orangeColor]}] forState:UIControlStateNormal];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor grayColor]}] forState:UIControlStateSelected];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor grayColor]}] forState:UIControlStateHighlighted];
                [self setAttributedTitle:[[NSAttributedString alloc] initWithString:[title uppercaseString] attributes:@{NSKernAttributeName : @(charSpacing), NSForegroundColorAttributeName : [UIColor grayColor]}] forState:UIControlStateDisabled];
                #else
                [super setTitle:[title uppercaseString] forState:state];
                #endif
                break;
            }
            case CompassButtonStyleAccentLink:
            {
                
            }
            case CompassButtonStyleAccentPressLink:
            {
               
                break;
            }
            default:
                break;
        }
    }
    else
    {
        [super setTitle:title forState:state];
    }
}




-(void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height/2;
}

-(void)prepareForInterfaceBuilder
{
    
    [super prepareForInterfaceBuilder];
    [self configure];
}

@end

//Subclasses declared inline for IB usage

//Primary
@implementation L1Button

-(void)configure
{
    [self setStyle:CompassButtonStylePrimary];
    [super configure];
}

@end

//Secondary
@implementation L2Button

-(void)configure
{
    [self setStyle:CompassButtonStyleSecondary];
    [super configure];
}

@end

//Primary Small
@implementation L3Button

-(void)configure
{
    [self setStyle:CompassButtonStylePrimarySmall];
    [super configure];
}

-(CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    //add padding
    return CGSizeMake(size.width + 30, size.height);
}

@end

//Primary Title Small
@implementation L3TitleButton

-(void)configure
{
    [self setStyle:CompassButtonStylePrimaryTitleSmall];
    [super configure];
}

-(CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    //add padding
    return CGSizeMake(size.width + 30, size.height);
}

@end

//Secondary Small
@implementation L4Button

-(void)configure
{
    [self setStyle:CompassButtonStyleSecondarySmall];
    [super configure];
}

@end

//Secondary Small
@implementation L5Button

-(void)configure
{
    [self setStyle:CompassButtonStyleNoBorder];
    [super configure];
}
@end

// no border, accent, underlined
@implementation L6Button

-(void)configure
{
    [self setStyle:CompassButtonStyleAccentLink];
    [super configure];
}

@end

// no border, accent, underlined
@implementation L7Button

-(void)configure
{
    [self setStyle:CompassButtonStyleAccentPressLink];
    [super configure];
}

@end
