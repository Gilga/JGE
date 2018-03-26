#version 420
uniform mat4 iMVP = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
uniform float iGlobalTime = 1;
uniform vec2 iResolution = vec2(1);

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)
#define UVHALF 0.57735
#define UVFULL (1-0.000001)

vec2 getUV(vec3 vertex)
{
	int i = 1;

	bool bag = i == 0;
	bool cube = i == 1;
	
	float dist = bag?0:cube?UVFULL:UVHALF;
	
	vec3 normal = normalize(vertex);
	normal = clamp(cube?vertex:normal,-1,1);
	
	float x = normal.x;
	float y = normal.y;
	float z = normal.z;
		
	vec2 uv = vec2(0);
	
	bool found = false;
	
	if (bag)
	{
		uv+=vec2(x,y);
		found=true;
	}
	else
	{
		bool fb = abs(z)>=dist;
		bool rl = abs(x)>=dist;
		bool ud = abs(y)>=dist;
		
		float u = x;
		float v = y;
		
		if(fb) u = (z>0?1:-1)*x;
		if(rl) u = (x>0?1:-1)*-z;
		if(ud) {u = x; v = -z;}
		
		uv+=vec2(u,v);
		found=true;
	}

	if(!found) return vec2(-1);
	
	uv = (1+uv)*0.5;
	uv = clamp(uv,0,1);
	
	return uv;
}

vec4 getVertexColor(vec3 pos, vec3 normal)
{
	if(false) // pos.z != 0 skip planes
	{
		float len = dot(length(pos),length(normal)); // skip cubes and spheres
		if(len < RADIUS) pos = (pos + normal) * HALF; // model
	}
	
	vec3 color1 = (1-normal)*0.5;
	vec3 color2 = (1+normal)*0.5;
	vec3 color = mix(color1,color2, sin(iGlobalTime));
	
	return vec4(color,1.0);
}

//! VERTEX

in vec3 iVertex;
in vec2 iUV;

out vec3 sVertex;
out vec3 sNormal;
out vec2 sUV;
out vec4 sColor;

void main() {
	sVertex = iVertex;
	sNormal = normalize(sVertex);
	sUV = iUV;
	sColor = getVertexColor(sVertex,sNormal);
	
	gl_Position = iMVP * vec4(iVertex, 1);
}

//! FRAGMENT

in vec3 sVertex;
in vec3 sNormal;
in vec2 sUV;
in vec4 sColor;

out vec4 oFragColor;

vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
	//float ratio = iResolution;
	//vec2 UV = gl_FragCoord.xy / iResolution + vec2(-0.5); // screen UV
	vec2 UV = (getUV(sVertex))*vec2(1.02)-vec2(0.01);
	
	vec2 z, c;

	float scale = 2;
	vec2 center = vec2(0.5,0);
	
	c = vec2((UV.x-0.5)*2,(UV.y-0.5)* 2) * scale - center;

	z = c;
	float i;
	float max = 10;
	float step = 0;
	
	for(i = 0; i < max; i++) {
		z = vec2(pow(z.x, 2) - pow(z.y, 2), 2 * z.x * z.y) + c;
		step=length(z);
		if(step > 2.0) break;
	}
	
	step = (1+sin(length(z)))*0.5;
	//step = i<0 ? 0 : ((i >= max) ? 0 : step = i / max);
	
	float brightness = 1-step;

	oFragColor = vec4(sColor.xyz*brightness,1); //vec4(sColor.xyz*brightness,1.0);
}