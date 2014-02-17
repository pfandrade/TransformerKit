//
//  TTTSecureCodingTransformers.h
//  Strongbox
//
//  Created by Paulo Andrade on 17/02/14.
//


@interface TTTSecureCodingTransformers : NSValueTransformer

+ (NSValueTransformer *)transformerForClass: (Class<NSSecureCoding>)secureCodingClass;

@end
