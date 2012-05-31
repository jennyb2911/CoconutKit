//
//  HLSLabel.m
//  CoconutKit
//
//  Created by Joris Heuberger on 12.04.12.
//  Copyright (c) 2012 Hortis. All rights reserved.
//

#import "HLSLabel.h"

#import "NSString+HLSExtensions.h"

@interface HLSLabel ()

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;

@end

@implementation HLSLabel

#pragma mark Object creation and destruction

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame])) {
		self.verticalAlignment = HLSLabelVerticalAlignmentMiddle;
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder])) {
		self.verticalAlignment = HLSLabelVerticalAlignmentMiddle;
	}
	return self;
}

#pragma mark Accessors and mutators

@synthesize verticalAlignment = _verticalAlignment;

- (void)setVerticalAlignment:(HLSLabelVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment == verticalAlignment) {
        return;
    }
    
	_verticalAlignment = verticalAlignment;
    
	[self setNeedsDisplay];
}

#pragma mark UILabel drawing override points

/**
 * Vertical alignment
 *
 * Original author: jhoncybpr - http://www.iphonedevsdk.com/forum/iphone-sdk-development/35532-uilabel-vertical-align-top.html 
 */
- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
	CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
	
	switch (self.verticalAlignment) {
		case HLSLabelVerticalAlignmentTop: {
			textRect.origin.y = CGRectGetMinY(bounds);
			break;
        }
            
		case HLSLabelVerticalAlignmentBottom: {
			textRect.origin.y = CGRectGetMaxY(bounds) - textRect.size.height;
			break;
        }
            
		case HLSLabelVerticalAlignmentMiddle: {
		default:
			textRect.origin.y =  CGRectGetMinY(bounds) + (bounds.size.height - textRect.size.height) / 2.f;
        }
	}
    
	return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect
{
    if (self.adjustsFontSizeToFitWidth) {
        CGFloat fontSize = [self.text fontSizeWithFont:self.font 
                                     constrainedToSize:self.bounds.size 
                                           minFontSize:self.minimumFontSize
                                         numberOfLines:self.numberOfLines];
		self.font = [UIFont fontWithName:self.font.fontName size:fontSize];
	}
    
	CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
	[super drawTextInRect:actualRect];
}

@end
