//
//  CompassButton.h
//  Compass
//
//

#import <UIKit/UIKit.h>

/**
 Enum for Compass button styles
 */
typedef enum {
    CompassButtonStylePrimary,
    CompassButtonStyleSecondary,
    CompassButtonStylePrimarySmall,
    CompassButtonStylePrimaryTitleSmall,
    CompassButtonStyleSecondarySmall,
    CompassButtonStyleNoBorder,
    CompassButtonStyleAccentLink,
    CompassButtonStyleAccentPressLink
} CompassButtonStyle;

#define kCompassButtonHeightLarge 60.0
#define kCompassButtonHeightSmall 44.0

/**
 Custom button class for Compass composed initially of two styles and their 'small' variants:
   - Primary      : Accent color background, white text in caps
   - Secondary    : Black border, clear background, black text
 
 @remark Usage of this class from interface builder should be set with button type 'Custom'
 */
@interface CompassButton : UIButton

/** Style of button, default is CompassButtonStylePrimary */
@property (nonatomic) CompassButtonStyle style;
@property (nonatomic, strong) CAShapeLayer *underlineShape;

@end

//Subclasses declared inline for IB usage

/** Primary */
IB_DESIGNABLE
@interface L1Button : CompassButton

@end

/** Secondary */
IB_DESIGNABLE
@interface L2Button : CompassButton

@end

/** Primary Small */
IB_DESIGNABLE
@interface L3Button : CompassButton

@end

/** Primary Title Small */
IB_DESIGNABLE
@interface L3TitleButton : CompassButton

@end

/** Secondary Small */
IB_DESIGNABLE
@interface L4Button : CompassButton

@end

/** No Border */
IB_DESIGNABLE
@interface L5Button : CompassButton

@end

/** No border, accent, underlined */
IB_DESIGNABLE
@interface L6Button : CompassButton

@end

/** No border, accent on press, custom underline */
IB_DESIGNABLE
@interface L7Button : CompassButton

@end
