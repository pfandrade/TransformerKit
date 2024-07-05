//
//  TTTSecureCodingTransformers.m
//  Strongbox
//
//  Created by Paulo Andrade on 17/02/14.
//

#import "TTTSecureCodingTransformers.h"
#import "NSValueTransformer+TransformerKit.h"

@implementation TTTSecureCodingTransformers

+ (NSValueTransformer *)transformerForClass: (Class<NSSecureCoding>)secureCodingClass
{
    if ( secureCodingClass == nil ) return nil;
    
    NSString *transformerName = [NSString stringWithFormat:@"TTTSecureCoding%@Transformer", NSStringFromClass(secureCodingClass)];
    
    NSValueTransformer *transformer = [NSValueTransformer valueTransformerForName:transformerName];
    
    if (transformer == nil) {

        id (^transformingBlock)(id) = ^id (NSData *data){
            if (data == nil) return nil;

            id result = nil;
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
            if ([unarchiver respondsToSelector:@selector(setRequiresSecureCoding:)]) {
                // require secure coding is only available on OSX >= 10.8 and iOS >= 6.0
                [unarchiver setRequiresSecureCoding:YES];
            }
            [unarchiver setRequiresSecureCoding:YES];
            result = [unarchiver decodeObjectOfClass:secureCodingClass forKey:@"rootObject"];
            [unarchiver finishDecoding];
            
            return result;
        };

        id (^reverseTransformingBlock)(id) = ^NSData *(id value){
            if (value == nil) return nil;
            
            NSMutableData *data = [NSMutableData data];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            
            if ( [archiver respondsToSelector:@selector(setRequiresSecureCoding:)] ) {
                // require secure coding is only available on OSX >= 10.8 and iOS >= 6.0
                [archiver setRequiresSecureCoding:YES];
            }
            [archiver setOutputFormat:NSPropertyListBinaryFormat_v1_0];
            [archiver encodeObject:value forKey:@"rootObject"];
            [archiver finishEncoding];
            return data;
        };
        
        [NSValueTransformer registerValueTransformerWithName:transformerName
                                       transformedValueClass:secureCodingClass
                          returningTransformedValueWithBlock:transformingBlock
                      allowingReverseTransformationWithBlock:reverseTransformingBlock];
    }

    return [NSValueTransformer valueTransformerForName:transformerName];
}

@end
