//
//  ImageMisc.h
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NSData* getImageNSData(UIImage* image);

@interface ImageMisc : NSObject
+ (instancetype) sharedInstance;
- (nonnull instancetype) initImageMisc;
- (UIImage*) grayTrans: (UIImage*) srcImg;
- (UIImage*) binaryTrans: (UIImage*) srcImg Threshold: (NSUInteger) threshold;
@end

NS_ASSUME_NONNULL_END
