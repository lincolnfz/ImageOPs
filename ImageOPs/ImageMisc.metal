//
//  ImageMisc.metal
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#include <metal_stdlib>
#import "LYShaderTypes.h"

using namespace metal;


// Rec 709 LUMA values for grayscale image conversion
constant half3 kRec709Luma = half3(0.2126, 0.7152, 0.0722);

// Grayscale compute shader
kernel void grayscale(texture2d<half, access::read>  inTexture   [[ texture(0) ]],
                      texture2d<half, access::write> outTexture  [[ texture(1) ]],
                      uint2                          gid         [[ thread_position_in_grid ]])
{
    if((gid.x < outTexture.get_width()) && (gid.y < outTexture.get_height()))
    {
        half4 inColor  = inTexture.read(gid);
        half  gray     = dot(inColor.rgb, kRec709Luma);
        half4 outColor = half4(gray, gray, gray, 1.0);
        
        outTexture.write(outColor, gid);
    }
}

kernel void binaryscale(texture2d<half, access::read>  inTexture   [[ texture(0) ]],
                        const device float* threshold[[buffer(0)]],
                      texture2d<half, access::write> outTexture  [[ texture(1) ]],
                      uint2                          gid         [[ thread_position_in_grid ]])
{
    if((gid.x < outTexture.get_width()) && (gid.y < outTexture.get_height()))
    {
        half4 inColor  = inTexture.read(gid);
        half  gray     = dot(inColor.rgb, kRec709Luma);
        half outval = 0.0;
        if(gray >= threshold[0]){
            outval = 1.0;
        }
        half4 outColor = half4(outval, outval, outval, 1.0);
        
        outTexture.write(outColor, gid);
    }
}


typedef struct
{
    float4 clipSpacePosition [[position]]; // position的修饰符表示这个是顶点
    
    float2 textureCoordinate; // 纹理坐标，会做插值处理
    
} RasterizerData;

vertex RasterizerData // 返回给片元着色器的结构体
vertexShader(uint vertexID [[ vertex_id ]], // vertex_id是顶点shader每次处理的index，用于定位当前的顶点
             constant LYVertex *vertexArray [[ buffer(0) ]],
             constant LYMatrix *matrix [[ buffer(1) ]]) {
    RasterizerData out;
    //out.clipSpacePosition = vertexArray[vertexID].position;
    out.clipSpacePosition = matrix->projectionMatrix * vertexArray[vertexID].position;
    //out.clipSpacePosition = matrix->projectionMatrix * matrix->modelViewMatrix * vertexArray[vertexID].position;
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    return out;
}

fragment float4
samplingShader(RasterizerData input [[stage_in]], // stage_in表示这个数据来自光栅化。（光栅化是顶点处理之后的步骤，业务层无法修改）
               texture2d<half> colorTexture [[ texture(0) ]]) // texture表明是纹理数据，0是索引
{
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear); // sampler是采样器
    
    half4 colorSample = colorTexture.sample(textureSampler, input.textureCoordinate); // 得到纹理对应位置的颜色
    return float4(colorSample.b, colorSample.g, colorSample.r, colorSample.a);
    //return float4(colorSample);
    
    //constexpr sampler textureSampler;
    //half4 baseColor = colorTexture.sample(textureSampler, input.textureCoordinate);
    //return float4(baseColor);
}
