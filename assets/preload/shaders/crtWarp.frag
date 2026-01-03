#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

uniform float warp; // simulate curvature of CRT monitor
uniform float scan; // simulate darkness between scanlines

void mainImage(out vec4 fragColor,in vec2 fragCoord)
	{
    // squared distance from center
    vec2 uv = fragCoord/iResolution.xy;
    vec2 dc = abs(0.5-uv);
    dc *= dc;
    
    // warp the fragment coordinates
    uv.x -= 0.5; uv.x *= 1.0+(dc.y*(0.3*warp)); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0+(dc.x*(0.4*warp)); uv.y += 0.5;

    // sample inside boundaries, otherwise set to black
    if (uv.y > 1.0 || uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0)
        fragColor = vec4(0.0, 0.0, 0.0, texture(iChannel0, fragCoord / iResolution.xy).a);
    else
    	{
        // determine if we are drawing in a scanline
        float apply = abs(sin(fragCoord.y)*0.5*scan);
        // sample the texture
    	fragColor = vec4(mix(texture(iChannel0,uv).rgb,vec3(0.0),apply),1.0);
        }
	}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}