#version 420
uniform mat4 iMVP = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
uniform float iGlobalTime = 1;

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)

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

//layout (early_fragment_tests) in;

in vec3 iVertex;
out vec4 sColor;

void main() {
	sColor = getVertexColor(iVertex,normalize(iVertex));
	gl_Position = iMVP * vec4(iVertex, 1);
}

//! FRAGMENT

in vec4 sColor;
out vec4 oFragColor;

void main() {
	oFragColor = vec4(1-sColor.xyz,0.5);
}