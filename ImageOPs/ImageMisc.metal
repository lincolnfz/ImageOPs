//
//  ImageMisc.metal
//  ImageOPs
//
//  Created by lincoln on 2020/2/3.
//  Copyright © 2020 lincoln. All rights reserved.
//

#include <metal_stdlib>
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


