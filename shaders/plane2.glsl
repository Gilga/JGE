//! FRAGMENT

layout(location = 0) in SharedData dataG;
out vec4 outputColor;

uniform sampler2D tex;
uniform uint key;
uniform vec2 windowsize;
uniform vec2 iResolution;
uniform vec2 cursorpos;

vec3 XCOLOR1 = vec3(1.0, 0.0, 0.0);
vec3 XCOLOR2 = vec3(0.0, 1.0, 0.0);
vec3 XCOLOR3 = vec3(0.0, 0.0, 1.0);

float BLOCK_WIDTH = 1; //0.005;

vec3 rainbowColor(vec2 pos) {
	vec3 xcolormix = mix(XCOLOR1,XCOLOR2,pos.x);
	vec3 ycolormix = mix(xcolormix,XCOLOR3,pos.y);
	vec3 color  = (xcolormix+ycolormix)*0.5;
	//color  = mix(xcolormix,ycolormix,(uv.x+uv.y)*0.5);
	return color;
}

/*
vec2 CalcCameraSpacePosition()
{
		//vec4 ndcPos;
		//ndcPos.xy = ((2.0 * gl_FragCoord.xy) - (2.0 * viewport.xy)) / (viewport.zw) - 1;
		//ndcPos.z = (2.0 * gl_FragCoord.z - gl_DepthRange.near - gl_DepthRange.far) / (gl_DepthRange.far - gl_DepthRange.near);
		//ndcPos.w = 1.0;
 
    vec4 clipPos = vec4((gl_FragCoord.xyz  * 10), 1) / (gl_FragCoord.w); //vec4(gl_FragCoord.xyz, 1)
		vec4 eyePos = (mvp) * clipPos;
    return eyePos.xy / windowsize;
		
		//vec4 eyePos = (mvp) * vec4(gl_FragCoord.xyz, 1);
		//vec3 pos = eyePos.xyz / eyePos.w;
   // return (pos.xy);

		//return (gl_FragCoord.xy / windowsize,0,1); // * vec2(1+curpos.x*0, 1+(1-curpos.y)*0) + vec2(-mvp[3][0]*2,-mvp[3][1]);
		//return UV;
}
*/

void main() {
//vec2 frag = (gl_FragCoord.xy / windowsize) * vec2(1,-1);// * vec2(1-cursorpos.x,1+(1-cursorpos.y)*-1);
vec2 uv = 0.5+(-0.5+dataG.uv)*2; //gl_FragCoord.xy / iResolution; //dataG.uv;
//vec2 uv = CalcCameraSpacePosition();

float x = uv.x;
float y = uv.y;

float areaX = (x>=0 && x<=1?1:0);
float areaY = (y>=0 && y<=1?1:0);
float area = areaX*areaY;

// To create the BG pattern
vec3 final_color = vec3(1.0);
vec3 bg_color = vec3(0.0);
vec3 wave_color = vec3(0.0);
vec3 wave_color2 = vec3(0.0);

float c1 = mod(uv.x, 1.25 * BLOCK_WIDTH);
c1 = step(BLOCK_WIDTH, c1);

float c2 = mod(uv.y, 1.25 * BLOCK_WIDTH);
c2 = step(BLOCK_WIDTH, c2);

bg_color = rainbowColor(uv);

float count = 100;
float dist = 0.01; 
float v = sin(iGlobalTime)*10;
float wave_width = 0.0;
vec2 w_uv  =  uv + vec2(-0.5,-0.5) + (count/2) * vec2(-dist) - vec2(-dist/2);
float wave_bounceX = 0.025 * (sin(uv.x * v - v*0.5));
float wave_bounceY = 0.025 * (sin(uv.y * v - v*0.5));
//for(float i = 0.0; i < count; i++) {
//	wave_color += vec3(1, 0, 0) * abs(1.0/(150.0*(w_uv.y + dist * i + wave_bounceX))) * wave_width;
//	wave_color += vec3(1, 0, 0) * abs(1.0/(150.0*(w_uv.x + dist * i + wave_bounceY))) * wave_width;
//}

vec3 wcolor = vec3(1, 0.5, 0.5);

w_uv  = (-0.5 + uv)*3;
w_uv.y += 0.1;
for(float i = 0.0; i < 10.0; i++) {
	w_uv.y += (0.07 * sin(uv.x + i/5.0 + iGlobalTime * 2.5 )) + 0.01* cos(uv.x* 200 + iGlobalTime*20);
	wave_width = 3 * abs(1.0 / (150.0 * w_uv.y));
	//wave_color += wcolor * wave_width;
}

float ptime = programTime*0.1;
x = uv.x;
y = uv.y;
y += -0.75;
y += clamp(sin(x*6.25),0,1) * sin((sin(x * 60 + iGlobalTime) + cos(x*100 + iGlobalTime + frames)) * 0.5 * frames)*0.25;
y += clamp(sin((1-x)*6.25),0,1) * sin((sin(x * 60 + ptime) + cos(x*100 + ptime)) * 0.5 * (0.0001/programTick))*0.25;
wave_width =  sin(x*6.25) / sin(y);
wave_color +=  wcolor * abs(wave_width) * 0.01 * areaX; 

x = uv.x;
y = uv.y;
y += -0.25;
y += (cursorpos.x>0.5?1:0)*(cursorpos.y>0.5?1:0)*-clamp(sin((1-x)*6.3),0,1)*sin((1-x+cursorpos.x*2)*6.3)*(0.1+-0.85+cursorpos.y);
y += clamp(sin((x)*6.3),0,1)*sin((sin(x * 60 + ptime) + cos(x*100 + ptime)) * (programTime*0.00001))*0.25;
wave_width = sin(x*6.25) / sin(y);
wave_color += wcolor * abs(wave_width) * 0.01 * areaX; 

count = 1;
dist = 0.05; 
wave_width = 0.5;
x = uv.x;
y = uv.y;
w_uv  =  uv + vec2(-0.5,-0.5) + (count/2) * vec2(-dist) - vec2(-dist/2);
wave_bounceX = key*0.025 * (sin(x * v - v*0.5));
wave_bounceY = key*0.025 * (sin(y * v - v*0.5));

for(float i = 0.0; i < count; i++) {
	wave_color2 += wcolor * abs(1.0/(100.0*(w_uv.y + dist * i + wave_bounceX))) * wave_width;
	wave_color2 += wcolor * abs(1.0/(100.0*(w_uv.x + dist * i + wave_bounceY))) * wave_width;
}

float xpower = (-0.5 + cursorpos.x)*10;
float ypower = (-0.5 + cursorpos.y)*10;
float power = abs(xpower*ypower)*0.5*10;

wave_color.x *= 1-wave_color.x;
wave_color.y *= 1-wave_color.y;
wave_color.z *= 1-wave_color.z;

//bg_color *= 1-abs((uv.x-0.5)*(uv.y-0.5))*power;
//wave_color *= abs((uv.x-0.5)*(uv.y-0.5))*power;

bg_color += vec3(1) * 0.000001 * 1/(abs(uv.x-cursorpos.x) * abs(1-uv.y-cursorpos.y)); // * (1-uv.y-cursorpos.y));

if (
	 (cursorpos.x>0.5 && cursorpos.y>0.5 && (uv.x>0.5 && uv.y<0.5))
|| (cursorpos.x<0.5 && cursorpos.y>0.5 && (uv.x<0.5 && uv.y<0.5))
|| (cursorpos.x>0.5 && cursorpos.y<0.5 && (uv.x>0.5 && uv.y>0.5))
|| (cursorpos.x<0.5 && cursorpos.y<0.5 && (uv.x<0.5 && uv.y>0.5))
) {
	wave_color=abs(wave_color);
}

final_color = bg_color + wave_color + wave_color2;

//outputColor = texture(tex, w_uv*0.5 + 0.5);
outputColor = vec4(final_color, 1.0);
}