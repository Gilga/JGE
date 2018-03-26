#version 420

const mat4 IdealMat = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);

uniform mat4 iMVP = IdealMat;
uniform mat4 iVP = IdealMat;
uniform mat4 iModel = IdealMat;
uniform float iGlobalTime = 1;
uniform vec2 iResolution = vec2(1);
uniform vec3 iPos = vec3(0);
uniform vec3 iCameraPos = vec3(0);

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)
#define UVHALF 0.57735
#define UVFULL (1-0.000001)

vec2 getUV(vec3 vertex)
{
	int i = 1;

	bool bag = i==0;
	bool cube = i==1;
	
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


#define STEPS 20 //64
#define STEP_SIZE 0.1 //0.01
 
#define SCENTRE vec3(0,0,0)
#define SRADIUS 1
 
bool sphereHit (vec3 p)
{
    return distance(p,-iPos+SCENTRE) < SRADIUS;
} 
 
bool raymarchHit(vec3 worldpos, vec3 viewDirection)
{
	for (int i = 0; i < STEPS; i++)
	{
		if (sphereHit(worldpos)) return true;
		worldpos += viewDirection * STEP_SIZE;
	}

 return false;
}

//! VERTEX

in vec3 iVertex;
in vec2 iUV;

out vec3 sVertex;
out vec3 sNormal;
out vec2 sUV;
out vec3 sWorldPos;

void main() {
	sVertex = iVertex;
	sNormal = normalize(sVertex);
	sUV = iUV;
	vec4 vertex = vec4(sVertex, 1);
	sWorldPos = vec3(-iModel*vertex);
	gl_Position = iMVP * vertex;
}

//! FRAGMENT

in vec3 sVertex;
in vec3 sNormal;
in vec2 sUV;
in vec3 sWorldPos;

out vec4 oFragColor;

uniform sampler2D tex;

void main() {
	vec2 UV = getUV(sVertex);
	vec4 color = texture(tex, UV);
	
	oFragColor = color;
}