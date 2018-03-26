#version 420
uniform mat4 iMVP = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
uniform float iGlobalTime = 1;
uniform vec2 iResolution = vec2(1);
uniform vec3 iCamAngle = vec3(0);
uniform vec3 iCamPos = vec3(0);

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)

//! VERTEX

in vec3 iVertex;

void main() {
	gl_Position = iMVP * vec4(iVertex, 1);
}

//! FRAGMENT

out vec4 oFragColor;

float snoise(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / iResolution;
	vec4 bgcolor = vec4(0);
	vec4 color = vec4(0);

	float t1 = 0.5+0.5*sin(iGlobalTime);
	float t2 = 0.5+0.5*cos(iGlobalTime*0.5);
	float t3 = 0.5+0.5*sin(iGlobalTime*2);
	
	bgcolor = (vec4(vec3(0.5,0.5,0.75),1)+vec4(0.3,0.75,1,1))*vec4(vec3(sin(uv.y)*cos(uv.x)*t2),1)-vec4(0.01,0.2,0.01,0);
	bgcolor.w=0.9;

	//if((uv.x >= 0.5 && uv.x < 0.501) || (uv.y >= 0.5 && uv.y < 0.501)) color = vec4(0,0,0,1);
	
	color = vec4(0.5+uv.x*0.25,0.5+uv.y*0.25,0.5+(1+sin(iGlobalTime))*0.5,0);
	
	vec2 ori = vec2(0,0);
	float brightness = 0;
	float radius = 0.01;
	float aspect = iResolution.x/iResolution.y;
	vec2 sp = vec2(0,0);
	
	float total = 25;
	float time = iGlobalTime * 0.5;
	vec2 vaspect = vec2(1,1/aspect); vec2 ps; vec2 pos_aspect; float r = 0; float f = 0; float t = 0;

	float s = 0;
	float n = 0;
	float z = 0;
	float m = 0;
	float o = time;
	
	ori += -0.5 + uv + vec2(iCamAngle.x,-iCamAngle.y)*0 + vec2(-iCamPos.x,iCamPos.y)*0;

	for(int i = 0; i < total; i++) {
		s = sin(i * 1.0);
		t = (time/total)*(i+1);	
		n = (-0.5+snoise(vec2(0,i)))*2 + cos(s*t);
					
		z = (1+s)*0.5;
		m = ((1+sin(z*time*8))*0.5);
		
		ps  = ori + vec2(n,sin(n+time*z))*0.314;
		
		sp = vaspect*ps*(z*100+10);
		
		r = dot(sp,sp);
		f = ((2*m-sqrt(abs(1.0-r)))/(r) + brightness * 0.5);
		if(f > 0) {
			color.w+=(f/(i+1))*m;
		}
	}
	
	color = mix(bgcolor,color,color.w);

	oFragColor = color;
}