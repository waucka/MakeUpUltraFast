#version 120
/* MakeUp - gbuffers_skytextured.vsh
Render: sun, moon

Javier Garduño - GNU Lesser General Public License v3.0
*/

#define NO_SHADOWS

#include "/lib/config.glsl"
#include "/lib/color_utils.glsl"

// 'Global' constants from system
uniform int current_hour_floor;
uniform int current_hour_ceil;
uniform float current_hour_fract;

// Varyings (per thread shared variables)
varying vec2 texcoord;
varying vec4 tint_color;
varying float sky_luma_correction;  // Flat

#if AA_TYPE > 0
  #include "/src/taa_offset.glsl"
#endif

void main() {
  texcoord = gl_MultiTexCoord0.xy;
  tint_color = gl_Color;

  sky_luma_correction = mix(
    ambient_exposure[current_hour_floor],
    ambient_exposure[current_hour_ceil],
    current_hour_fract
    );

  #ifdef VOL_LIGHT
    sky_luma_correction = 4.0 / ((sky_luma_correction * -2.5) + 3.5);
  #else
    sky_luma_correction = 1.5 / ((sky_luma_correction * -2.5) + 3.5);
  #endif

  gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
  #if AA_TYPE > 0
    gl_Position.xy += offsets[frame_mod] * gl_Position.w * pixel_size;
  #endif
}
