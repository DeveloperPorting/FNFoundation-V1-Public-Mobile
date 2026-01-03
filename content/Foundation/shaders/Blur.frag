// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

int iterations = 128;
float radius = 0.00001;

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 uv = fragCoord.xy / iResolution.xy;
	vec3 sum = texture(iChannel0, uv).xyz;
    
    for(int i = 0; i < iterations / 4; i++) {
     
        sum += texture(iChannel0, uv + vec2(float(i) / iResolution.x, 0.) * radius).xyz;
        
    }
    
    for(int i = 0; i < iterations / 4; i++) {
     
        sum += texture(iChannel0, uv - vec2(float(i) / iResolution.x, 0.) * radius).xyz;
        
    }
    
    for(int i = 0; i < iterations / 4; i++) {
     
        sum += texture(iChannel0, uv + vec2(0., float(i) / iResolution.y) * radius).xyz;
        
    }
    
    for(int i = 0; i < iterations / 4; i++) {
     
        sum += texture(iChannel0, uv - vec2(0., float(i) / iResolution.y) * radius).xyz;
        
    }
    
    fragColor = vec4(sum / float(iterations + 1), texture(iChannel0, fragCoord / iResolution.xy).a);
        
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}