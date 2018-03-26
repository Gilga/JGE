#version 420
uniform mat4 iMVP = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
uniform float iGlobalTime = 1;
uniform vec2 iResolution = vec2(1);

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)
#define UVHALF 0.57735

vec2 getUV(vec3 vertex)
{
	bool bag = false;
	bool cube = true;
	
	float dist = bag?0:cube?1:UVHALF;
	
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
	else {
		if (abs(z) >= dist)
		{ 
			uv+=vec2((z>0?1:-1)*x,y);
			found=true;
		}
		if (abs(x) >= dist)
		{ 
			 uv+=vec2((x>0?1:-1)*-z,y);
			 found=true;
		}
		if (abs(y) >= dist)
		{ 
			uv+=vec2(x,-z);
			found=true;
		}
	}

	if(!found) return vec2(-1);
	
	uv = (1+uv)*0.5;
	uv = clamp(uv,0,1);
	
	return uv;
}

//! VERTEX

in vec3 iVertex;
in vec2 iUV;

out vec3 sVertex;
out vec3 sNormal;
out vec2 sUV;

void main() {
	sVertex = iVertex;
	sNormal = normalize(sVertex);
	sUV = iUV;
	
	gl_Position = iMVP * vec4(iVertex, 1);
}

//! FRAGMENT

in vec3 sVertex;
in vec3 sNormal;
in vec2 sUV;

out vec4 oFragColor;

void main() {
	//float ratio = iResolution;
	//vec2 UV = gl_FragCoord.xy / iResolution + vec2(-0.5); // screen UV
	vec2 UV = getUV(sVertex) * 1.02 - vec2(0.01);
	
	float x_width = abs(sin(UV.y*PI*100) / sin(-0.5+UV.x)) * 1;
	float y_width = abs(sin(UV.x*PI*100) / sin(-0.5+UV.y)) * 1;

	float brightness = clamp(x_width,0,1)*clamp(y_width,0,1);

	bool borderX = UV.x > 1 || UV.x < 0;
	bool borderY = UV.y > 1 || UV.y < 0;
	bool border = borderX || borderY;
	
	float r = borderX ? 0 : 1 * UV.x;
	float g = border ? 1 : 0;
	float b = borderY ? 0 : 1 * UV.y;
	
	oFragColor = vec4(vec3(r,g,b)* brightness,1);
}