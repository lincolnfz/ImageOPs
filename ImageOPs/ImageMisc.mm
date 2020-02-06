//
//  ImageMisc.m
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#import "ImageMisc.h"
#import <Metal/Metal.h>
#import "LYShaderTypes.h"
#import "MetalContext/MetalContext.h"
#import "Math/MathUtilities.hpp"

@interface ImageMisc()
@property (nonatomic, strong) id<MTLBuffer> vertices;
@property (nonatomic, assign) NSUInteger numVertices;
@end

@implementation ImageMisc
{
    id <MTLDevice> _device;
    id <MTLLibrary> _library;
    id <MTLComputePipelineState> _grayPipelineState; //灰度转换
    //id <MTLComputePipelineState> _roationPipelineState; //角度旋转
    id <MTLComputePipelineState> _binaryPipelineState; //二值化
    id <MTLRenderPipelineState> _randerPipelineState; //渲染管道
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
    MetalContext* metalCont = [MetalContext shareMetalContext];
    _device = metalCont.device; //MTLCreateSystemDefaultDevice();
    _library = metalCont.library;//[_device newDefaultLibrary];
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
    
    [self setupRenderPipeline];
    [self setupVertex];
    _commandQueue = metalCont.commandQueue;//[_device newCommandQueue];
    
    return self;
}

#define RANDER_PIXEL_FORMAT MTLPixelFormatBGRA8Unorm

// 设置渲染管道
-(void)setupRenderPipeline {
    id<MTLFunction> vertexFunction = [_library newFunctionWithName:@"vertexShader"]; // 顶点shader，vertexShader是函数名
    id<MTLFunction> fragmentFunction = [_library newFunctionWithName:@"samplingShader"]; // 片元shader，samplingShader是函数名
    
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = RANDER_PIXEL_FORMAT;
    _randerPipelineState = [_device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor
                                                                         error:NULL]; // 创建图形渲染管道，耗性能操作不宜频繁调用
}

//设置顶点
- (void)setupVertex {
    static const LYVertex quadVertices[] =
    {   // 顶点坐标，分别是x、y、z、w；    纹理坐标，x、y；
        { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -1.0, -1.0, 0.0, 1.0 },  { 0.f, 1.f } },
        { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
        
        { {  1.0, -1.0, 0.0, 1.0 },  { 1.f, 1.f } },
        { { -1.0,  1.0, 0.0, 1.0 },  { 0.f, 0.f } },
        { {  1.0,  1.0, 0.0, 1.0 },  { 1.f, 0.f } },
    };
    _vertices = [_device newBufferWithBytes:quadVertices
                                                 length:sizeof(quadVertices)
                                                options:MTLResourceStorageModeShared]; // 创建顶点缓存
    _numVertices = sizeof(quadVertices) / sizeof(LYVertex); // 顶点个数
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

- (Byte *)loadImage:(UIImage *)image {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = image.CGImage;
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    Byte * spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    return spriteData;
}

- (UIImage*) roation: (UIImage*) image angle: (float) angle{
    // 纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    textureDescriptor.pixelFormat = RANDER_PIXEL_FORMAT;
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
    id<MTLTexture>  texture = [_device newTextureWithDescriptor:textureDescriptor]; // 创建纹理
    
    MTLRegion region = MTLRegionMake2D(0,0,textureDescriptor.width, textureDescriptor.height); // 纹理上传的范围
    Byte *imageBytes = [self loadImage:image];
    if (imageBytes) {
        [texture replaceRegion:region
                    mipmapLevel:0
                      withBytes:imageBytes
                    bytesPerRow:4 * image.size.width];
        free(imageBytes);
        imageBytes = NULL;
    }
    
    float3 axisZ={0.0,0.0,1.0};
    float3 a0 = {0.,0.,0.};
    float3 a1 = {(float)texture.width,0.,0.};
    float3 a2 = {(float)texture.height, 0.,0.};
    float3 a3 = {(float)texture.width, (float)texture.height,0.};
    float4x3  cord(a0, a1, a2, a3);
    float4x4 rotationPitch=matrix_float4x4_rotation(axisZ,angle/180.0*M_PI);
    
    float4x4 prespecive = matrix_float4x4_perspective(0.1,1.,0.1,100.);
    LYMatrix matrix = {rotationPitch, prespecive};
    
    
    
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    
    if(abs(angle)-90.0<1e-3 || abs(angle)-270.0 < 1e-3){
        textureDescriptor.width = image.size.height;
        textureDescriptor.height = image.size.width;
    }
    
    id<MTLTexture>  colorTexture = [_device newTextureWithDescriptor:textureDescriptor];
    MTLRegion color_region = MTLRegionMake2D(0,0,textureDescriptor.width, textureDescriptor.height); // 纹理上传的范围
    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
    passDescriptor.colorAttachments[0].texture = colorTexture;
    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0, 0.0, 0.0, 1.0);// 设置默认颜色
    passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    
    
    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
    [renderEncoder setRenderPipelineState: _randerPipelineState]; // 设置渲染管道，以保证顶点和片元两个shader会被调用
    
    [renderEncoder setVertexBuffer:self.vertices
                            offset:0
                           atIndex:0]; // 设置顶点缓存
    
    [renderEncoder setVertexBytes:&matrix  length:sizeof(matrix)  atIndex:1]; //设置转换矩阵

    [renderEncoder setFragmentTexture: texture
                              atIndex:0]; // 设置纹理
    
    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                      vertexStart:0
                      vertexCount:self.numVertices]; // 绘制
    
    [renderEncoder endEncoding]; // 结束
    [commandBuffer commit];
    [commandBuffer waitUntilCompleted];
    
    
    NSUInteger bytesPerRow = 4 * colorTexture.width;
    NSInteger img_bytes_len = bytesPerRow * colorTexture.height;
    //NSMutableData* imgdata = [[NSMutableData alloc] initWithLength:img_bytes_len];
    
    unsigned char* dest_data = (unsigned char*)malloc(img_bytes_len);
    [colorTexture getBytes:dest_data bytesPerRow:bytesPerRow fromRegion:color_region mipmapLevel:0];
    //NSData* imgdata = [[NSData alloc] initWithBytes:dest_data length:img_bytes_len];
    UIImage* outimg = [self imageFromBRGABytes:dest_data imageSize:CGSizeMake(colorTexture.width, colorTexture.height)];
    free(dest_data);
    
    return outimg;
}

/*- (matrix_float4x4)getMetalMatrixFromGLKMatrix:(GLKMatrix4)matrix {
    matrix_float4x4 ret = (matrix_float4x4){
        simd_make_float4(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
        simd_make_float4(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
        simd_make_float4(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
        simd_make_float4(matrix.m30, matrix.m31, matrix.m32, matrix.m33),
    };
    return ret;
}

- (void)setupMatrixWithEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    CGSize size = self.view.bounds.size;
    float aspect = fabs(size.width / size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
    static float x = 0.0, y = 0.0, z = M_PI;
    if (self.rotationX.on) {
        x += self.slider.value;
    }
    if (self.rotationY.on) {
        y += self.slider.value;
    }
    if (self.rotationZ.on) {
        z += self.slider.value;
    }
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, x, 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, y, 0, 1, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, z, 0, 0, 1);
    
    LYMatrix matrix = {[self getMetalMatrixFromGLKMatrix:projectionMatrix], [self getMetalMatrixFromGLKMatrix:modelViewMatrix]};
    
    [renderEncoder setVertexBytes:&matrix
                           length:sizeof(matrix)
                          atIndex:LYVertexInputIndexMatrix];
}*/

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 33 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

@end


