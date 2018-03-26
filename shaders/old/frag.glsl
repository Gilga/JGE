#version 420
uniform sampler2D tex;
uniform float time;
uniform float programTick;
in vec2 fragTexCoord;
out vec4 outputColor;

/*
void main() {
	vec2 frag = gl_FragCoord.xy;
	vec2 uv = frag / vec2(400,400);
  float p = sin(uv.y); //*cos(frag.x/400);

  vec4 cl = vec4(0,0,0,1); //*vec4(vec3(p),1);
	if (uv.y > p) cl = vec4(1,0,0,1);

	outputColor = cl;
	//vec4((frag.x/800)*sin(time+frag.x),(frag.y/600)*cos(time+frag.y),sin(time)*cos(time),1); //texture(tex, vec2(fragTexCoord) + vec2(sin(time) * 0.125, cos(time) * 0.5));
}
*/

vec3 XCOLOR1 = vec3(0.5, 0.0, 0.0);
vec3 XCOLOR2 = vec3(0.0, 0.5, 0.0);
vec3 YCOLOR1 = vec3(0.0, 0.0, 0.0);
vec3 YCOLOR2 = vec3(0.5, 0.5, 0.0);
float BLOCK_WIDTH = 0.01;

void main() {
vec2 uv = gl_FragCoord.xy / vec2(800,600); //iResolution.xy;

// To create the BG pattern
vec3 final_color = vec3(1.0);
vec3 bg_color = vec3(0.0);
vec3 wave_color = vec3(0.0);

float c1 = mod(uv.x, 1.25 * BLOCK_WIDTH);
c1 = step(BLOCK_WIDTH, c1);

float c2 = mod(uv.y, 1.25 * BLOCK_WIDTH);
c2 = step(BLOCK_WIDTH, c2);

bg_color = mix((1-uv.x) * XCOLOR1 + uv.x * XCOLOR2, (1-uv.y) * YCOLOR1 + uv.y * YCOLOR2, c1 * c2);


// To create the waves
float wave_width = 0.01;
vec2 w_uv  = -1.0 + 3.0 * uv;
w_uv.y += 0.1;
for(float i = 0.0; i < 10.0; i++) {
	w_uv.y += (0.07 * sin(uv.x + i/7.0 + time * 2.5 ));
	wave_width = abs(1.0 / (150.0 * w_uv.y));
	wave_color += vec3(wave_width * 0.5, wave_width * 0.5, wave_width * 0.5);
}

// To create the waves
wave_width = 3;
w_uv  =  uv;
for(float i = 0.0; i < 1.0; i++) {
	w_uv.y += -0.75 + 0.1 * (sin(uv.x * 60 + (programTick/30)) + cos(uv.x*100+ (programTick/30)  ));
	wave_width *= abs(1.0 / (150.0 * w_uv.y));
	wave_color += vec3(wave_width * 1, wave_width * 0.5, wave_width * 0.5);
}

final_color = bg_color + wave_color;

//outputColor = texture(tex, w_uv*0.5 + 0.5);
outputColor = vec4(final_color, 1.0);
}
