//
//  CTPNOcr.h
//  ImageOPs
//
//  Created by lincoln on 2020/2/7.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CTPNOcr : NSObject
+ (NSString*) RunInferenceOnImage: (UIImage*) img;
@end

NS_ASSUME_NONNULL_END
