//
//  ImageMisc.m
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import "ImageMisc.h"
#import <Metal/Metal.h>

@interface ImageMisc()

@end

@implementation ImageMisc
{
    id <MTLDevice> _device;
    id <MTLLibrary> _library;
    id <MTLComputePipelineState> _grayPipelineState; //灰度转换
    id <MTLComputePipelineState> _roationPipelineState; //角度旋转
    id <MTLComputePipelineState> _binaryPipelineState; //二值化
    id <MTLCommandQueue> _commandQueue;
}

UIImage* imageByCropToRect(UIImage* in_image, CGRect rect){
    CGImageRef imageRef = CGImageCreateWithImageInRect( in_image.CGImage,  rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale: in_image.scale orientation:in_image.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}

UIImage *imageByResizeToSize( UIImage* in_image, CGSize size) {
    if (size.width <= 0 || size.height <= 0) return nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, in_image.scale);
    [in_image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

UIImage *convertImageToGrayScale(UIImage *image){
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, image.size.width, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

/*UIImage *convertImageToRGBScale(UIImage *image){
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0 , colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}*/

CFDataRef CopyImagePixels(CGImageRef inImage){
    return CGDataProviderCopyData(CGImageGetDataProvider(inImage));
}

unsigned char *getGrayImageData(UIImage* image, size_t & len){
    CGImageRef imageref = [image CGImage];
    
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceGray();
    size_t width=CGImageGetWidth(imageref);
    size_t height=CGImageGetHeight(imageref);
    size_t bytesPerPixel=1;
    size_t bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent = 8;
    len = width*height*bytesPerPixel;
    unsigned char * imagedata=  (unsigned char * )malloc(len);
    
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata, width, height, bitsPerComponent, bytesPerRow,  colorspace,kCGImageAlphaNone);
    //将图像写入一个矩形
    CGRect therect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(cgcnt, therect, imageref);
    
    //释放资源
    CGColorSpaceRelease(colorspace);
    
    CGContextRelease(cgcnt);
    return imagedata;
}

NSData* getGrayImageNSData(UIImage* image){
    size_t len = 0;
    unsigned char* buf = getGrayImageData(image, len);
    NSData* data = [[NSData alloc] initWithBytes:buf length: len];
    free(buf);
    return  data;
}

unsigned char *getImageData(UIImage* image, size_t & len){
    CGImageRef imageref = [image CGImage];
    
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    size_t width=CGImageGetWidth(imageref);
    size_t height=CGImageGetHeight(imageref);
    size_t bytesPerPixel=4;
    size_t bytesPerRow=bytesPerPixel*width;
    int bitsPerComponent = 8;
    len = width*height*bytesPerPixel;
    unsigned char * imagedata=  (unsigned char * )malloc(len);
    
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata, width, height, bitsPerComponent, bytesPerRow,  colorspace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //将图像写入一个矩形
    CGRect therect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(cgcnt, therect, imageref);
    
    //释放资源
    CGColorSpaceRelease(colorspace);
    
    CGContextRelease(cgcnt);
    return imagedata;
}

NSData* getImageNSData(UIImage* image){
    size_t len = 0;
    unsigned char* buf = getImageData(image, len);
    NSData* data = [[NSData alloc] initWithBytes:buf length: len];
    free(buf);
    return  data;
}

+ (instancetype) sharedInstance{
    static ImageMisc *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageMisc alloc] initImageMisc];
    });
    return instance;
}

- (nonnull instancetype) initImageMisc {
    _device = MTLCreateSystemDefaultDevice();
    _library = [_device newDefaultLibrary];
    //_library = [_device newLibraryWithFile:@"ImageMisc.metal" error: &err];
    
    NSError *error = NULL;
    // Load the kernel function from the library
    id<MTLFunction> kernelFunction = [_library newFunctionWithName:@"grayscale"];
    
    // Create a compute pipeline state
    _grayPipelineState = [_device newComputePipelineStateWithFunction:kernelFunction
                                                                   error:&error];
    if(!_grayPipelineState)
    {
        NSLog(@"Failed to create compute pipeline state, error %@", error);
        return nil;
    }
    
    kernelFunction = [_library newFunctionWithName:@"binaryscale"];
    
    // Create a compute pipeline state
    _binaryPipelineState = [_device newComputePipelineStateWithFunction:kernelFunction
                                                                   error:&error];
    if(!_binaryPipelineState)
    {
        NSLog(@"Failed to create compute pipeline state, error %@", error);
        return nil;
    }
    
    _commandQueue = [_device newCommandQueue];
    
    return self;
}

- (UIImage *)imageFromBRGABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
    CGImageRef imageRef = [self imageRefFromBGRABytes:imageBytes imageSize:imageSize];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (CGImageRef)imageRefFromBGRABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize {
 
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(imageBytes,
                                                imageSize.width,
                                                imageSize.height,
                                                8,
                                                imageSize.width * 4,
                                                colorSpace,
                                                kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return imageRef;
}

- (UIImage*) grayTrans: (UIImage*) srcImg{
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    
    // Indicate we're creating a 2D texture.
    textureDescriptor.textureType = MTLTextureType2D;
    
    // Indicate that each pixel has a Blue, Green, Red, and Alpha channel,
    //    each in an 8 bit unnormalized value (0 maps 0.0 while 255 maps to 1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    textureDescriptor.width =  [srcImg size].width;
    textureDescriptor.height = [srcImg size].height;
    textureDescriptor.usage = MTLTextureUsageShaderRead;
    
    NSData* img_src_data = getImageNSData(srcImg);
    NSUInteger bytesPerRow = 4 * textureDescriptor.width;
    MTLRegion srcregion = MTLRegionMake2D(0,0,textureDescriptor.width, textureDescriptor.height);
    
    id<MTLTexture>  srcTexture = [_device newTextureWithDescriptor:textureDescriptor];
    [srcTexture replaceRegion:srcregion
                  mipmapLevel:0
                    withBytes: [img_src_data bytes]
                  bytesPerRow:bytesPerRow];
    
    textureDescriptor.usage = MTLTextureUsageShaderWrite;
    id<MTLTexture>  destTexture = [_device newTextureWithDescriptor:textureDescriptor];
    [destTexture replaceRegion:srcregion
                  mipmapLevel:0
                    withBytes: [img_src_data bytes]
                  bytesPerRow:bytesPerRow];
    
    NSUInteger wid = _grayPipelineState.threadExecutionWidth;
    NSUInteger hei = _grayPipelineState.maxTotalThreadsPerThreadgroup / wid;
    
    MTLSize threadsPerGrid = {(textureDescriptor.width + wid - 1) / wid, (textureDescriptor.height + hei - 1) / hei,1};
    MTLSize threadsPerGroup = {wid, hei, 1};
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"grayCommand";
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_grayPipelineState];
    //[computeEncoder setLabel:@"filiter encoder"];
    //[computeEncoder pushDebugGroup:@"filter"];
    
    
    [computeEncoder setTexture:srcTexture  atIndex:0];
    [computeEncoder setTexture:destTexture  atIndex:1];
    [computeEncoder dispatchThreadgroups:threadsPerGrid
                   threadsPerThreadgroup:threadsPerGroup];
    
    //[computeEncoder popDebugGroup];
    [computeEncoder endEncoding];
    [commandBuffer commit];
    //[commandBuffer waitUntilScheduled];
    [commandBuffer waitUntilCompleted];
    
    NSInteger img_bytes_len = bytesPerRow * destTexture.height;
    //NSMutableData* imgdata = [[NSMutableData alloc] initWithLength:img_bytes_len];
    
    unsigned char* dest_data = (unsigned char*)malloc(img_bytes_len);
    [destTexture getBytes:dest_data bytesPerRow:bytesPerRow fromRegion:srcregion mipmapLevel:0];
    //NSData* imgdata = [[NSData alloc] initWithBytes:dest_data length:img_bytes_len];
    UIImage* outimg = [self imageFromBRGABytes:dest_data imageSize:CGSizeMake(destTexture.width, destTexture.height)];
    free(dest_data);
    
    return outimg;
}

- (UIImage*) binaryTrans: (UIImage*) srcImg Threshold: (NSUInteger) threshold{
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    
    float* fthreshold = (float*)malloc(sizeof(float));
    *fthreshold = (float)threshold / 255.0;
    // Indicate we're creating a 2D texture.
    textureDescriptor.textureType = MTLTextureType2D;
    
    // Indicate that each pixel has a Blue, Green, Red, and Alpha channel,
    //    each in an 8 bit unnormalized value (0 maps 0.0 while 255 maps to 1.0)
    textureDescriptor.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    textureDescriptor.width =  [srcImg size].width;
    textureDescriptor.height = [srcImg size].height;
    textureDescriptor.usage = MTLTextureUsageShaderRead;
    
    NSData* img_src_data = getImageNSData(srcImg);
    NSUInteger bytesPerRow = 4 * textureDescriptor.width;
    MTLRegion srcregion = MTLRegionMake2D(0,0,textureDescriptor.width, textureDescriptor.height);
    
    id<MTLTexture>  srcTexture = [_device newTextureWithDescriptor:textureDescriptor];
    [srcTexture replaceRegion:srcregion
                  mipmapLevel:0
                    withBytes: [img_src_data bytes]
                  bytesPerRow:bytesPerRow];
    
    textureDescriptor.usage = MTLTextureUsageShaderWrite;
    id<MTLTexture>  destTexture = [_device newTextureWithDescriptor:textureDescriptor];
    [destTexture replaceRegion:srcregion
                  mipmapLevel:0
                    withBytes: [img_src_data bytes]
                  bytesPerRow:bytesPerRow];
    
    NSUInteger wid = _binaryPipelineState.threadExecutionWidth;
    NSUInteger hei = _binaryPipelineState.maxTotalThreadsPerThreadgroup / wid;
    
    MTLSize threadsPerGrid = {(textureDescriptor.width + wid - 1) / wid, (textureDescriptor.height + hei - 1) / hei,1};
    MTLSize threadsPerGroup = {wid, hei, 1};
    
    id<MTLBuffer> thresholdBuf = [_device newBufferWithBytes:fthreshold length:sizeof(float) options:0];
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"binaryCommand";
    id<MTLComputeCommandEncoder> computeEncoder = [commandBuffer computeCommandEncoder];
    [computeEncoder setComputePipelineState:_binaryPipelineState];
    //[computeEncoder setLabel:@"filiter encoder"];
    //[computeEncoder pushDebugGroup:@"filter"];
    
    
    [computeEncoder setTexture:srcTexture  atIndex:0];
    [computeEncoder setTexture:destTexture  atIndex:1];
    [computeEncoder setBuffer:thresholdBuf offset:0 atIndex: 0];
    [computeEncoder dispatchThreadgroups:threadsPerGrid
                   threadsPerThreadgroup:threadsPerGroup];
    
    //[computeEncoder popDebugGroup];
    [computeEncoder endEncoding];
    [commandBuffer commit];
    //[commandBuffer waitUntilScheduled];
    [commandBuffer waitUntilCompleted];
    
    NSInteger img_bytes_len = bytesPerRow * destTexture.height;
    //NSMutableData* imgdata = [[NSMutableData alloc] initWithLength:img_bytes_len];
    
    unsigned char* dest_data = (unsigned char*)malloc(img_bytes_len);
    [destTexture getBytes:dest_data bytesPerRow:bytesPerRow fromRegion:srcregion mipmapLevel:0];
    //NSData* imgdata = [[NSData alloc] initWithBytes:dest_data length:img_bytes_len];
    UIImage* outimg = [self imageFromBRGABytes:dest_data imageSize:CGSizeMake(destTexture.width, destTexture.height)];
    free(dest_data);
    free(fthreshold);
    
    return outimg;
}

@end


