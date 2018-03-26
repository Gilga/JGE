#version 420
uniform mat4 iMVP = mat4(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1);
uniform float iGlobalTime = 1;

#define PI 3.14159265359
#define HALF (0.5 + 1/PI)
#define RADIUS (1 - 0.01/PI)

struct SharedData
{
	vec3 pos;
	vec3 normal;
	vec2 uv;
	vec4 color;
	vec3 world_pos;
	vec3 world_normal;
	bool special;
};

//! VERTEX

in vec3 iVertex;
in vec2 iUV;

layout(location = 0) out SharedData dataV;

vec3 getColorPos(vec3 pos,vec3 normal)
{
	if(true) // pos.z != 0 skip planes
	{
		float len = dot(length(pos),length(normal)); // skip cubes and spheres
		if(len < RADIUS) pos = (pos + normal) * HALF; // model
	}
	
	return (vec3(1) + pos * vec3(1,1,1)) * 0.5;
}

vec2 getUV(vec3 pos)
{
	//return (vec3(1) + pos * vec3(1,-1,1)) * 0.5;
	pos =  pos / (pos.z!=0?pos.z:1);
	return vec2(0.5) +  pos.xy * vec2(0.5,0.5);
}

void main() {
	vec3 vert = iVertex;
	
	//float timeX = 200 * (1 + (1 + sin(iGlobalTime * 0.1)) * 0.5);
	//float timeY = 100 * (1 + (1 + cos(iGlobalTime * 0.1)) * 0.5);
	//float h = -1 + (sin(timeX * cos(-1 + vert.x * 0.01) * 1) + sin(timeY * cos(-1 + vert.y * 0.1) * 1)) * 0.5;
	
	//vert.y += (sin(vert.x + iGlobalTime) + cos(vert.z + iGlobalTime)) * 0.5;
	//vert.x += (sin(vert.z + iGlobalTime) + cos(vert.z + iGlobalTime)) * 0.5;
	//vert.z += (sin(vert.x + iGlobalTime) + cos(vert.x + iGlobalTime)) * 0.5;

	//gl_Position = vec4(iVertex, 1);
	//mvp = projection * view * model;
	vec3 pos = vert;
	vec3 normal = normalize(pos);
	
	vec4 position = vec4(vert, 1);
	gl_Position = vec4(vert, 1);
	vec2 uv = getUV(iVertex); //vec4(fragTexCoord.x,fragTexCoord.y,0,1);
	
	dataV.pos = pos;
	dataV.normal = normal;
	//dataV.uv = uv; //getUV(scale * pos);
	//dataV.color = vec4(getColorPos(pos,normal), 1.0);
	//dataV.world_pos = vec3(0); //(m * Position).xyz;
	//dataV.world_normal = vec3(0); //model * normal;
	//dataV.special = false;
}

//! TESS_CONTROL
layout (vertices = 4) out;

layout(location = 0) in SharedData dataV[];
layout(location = 0) out SharedData dataTC[];

uniform uint iTessLevel = 1;

#define ID gl_InvocationID

void main()
{
  if (ID == 0)
  {
		float p = iTessLevel; //65;		
				
		gl_TessLevelOuter[0] = p;
		gl_TessLevelOuter[1] = p;
		gl_TessLevelOuter[2] = p;
		gl_TessLevelOuter[3] = p;

		gl_TessLevelInner[0] = p;
		gl_TessLevelInner[1] = p;
  }

	gl_out[ID].gl_Position = gl_in[ID].gl_Position;
	
	//for(int i=0; i<gl_in.length(); ++i)
	//{
		dataTC[ID].pos = dataV[ID].pos;
		dataTC[ID].uv = dataV[ID].uv;
	//}
}

//! TESS_EVALUATION
layout (quads, equal_spacing, ccw) in;
//layout (triangles, equal_spacing, ccw) in;

layout(location = 0) in SharedData dataTC[];
layout(location = 0) out SharedData dataTE;

//quad interpol
vec4 interpolate(in vec4 v0, in vec4 v1, in vec4 v2, in vec4 v3)
{
	vec4 a = mix(v0, v1, gl_TessCoord.x);
	vec4 b = mix(v3, v2, gl_TessCoord.x);
	return mix(a, b, gl_TessCoord.y);
}

vec4 interpolate2(in vec4 v0, in vec4 v1, in vec4 v2, in vec4 v3)
{
	return vec4(v0.xyz * gl_TessCoord.x + v1.xyz * gl_TessCoord.y + v2.xyz * gl_TessCoord.z,1.0);
}

void main(void)
{
	vec3 p0 = gl_TessCoord.x * dataTC[0].pos;
	vec3 p1 = gl_TessCoord.y * dataTC[1].pos;
	vec3 p2 = gl_TessCoord.z * dataTC[2].pos;
	//tePatchDistance = gl_TessCoord;
	
	dataTE.pos = normalize(p0 + p1 + p2);
	dataTE.uv = gl_TessCoord.xy;

	//gl_Position = vec4((p0 + p1 + p2),1.0);
	vec4 pos = interpolate(gl_in[0].gl_Position, gl_in[1].gl_Position, gl_in[2].gl_Position, gl_in[3].gl_Position);
	
		
	mat4 model = mat4(
	vec4(1,0,0,0),           //first column
	vec4(0,1,0,0),           //second column
	vec4(0,0,1,0),           //third column
	vec4(0,0,0,1));
	
	float timeX = 200 * (1 + (1 + sin(iGlobalTime * 0.1)) * 0.5);
	float timeY = 100 * (1 + (1 + cos(iGlobalTime * 0.1)) * 0.5);
	float timeC = 1 - (1 + sin(iGlobalTime))*0.5;
	
	float h = 0; //-1 + (sin(timeX * cos(-1 + pos.x * 0.01) * 1) + sin(timeY * cos(-1 + pos.z * 0.1) * 1)) * 0.5;
	h=sin(((1.5+pos.x)*4+iGlobalTime)*PI+iGlobalTime);
	h+=sin(((1.5+pos.y)*4+iGlobalTime)*PI+iGlobalTime);
	//model[3].x += sin(iGlobalTime * cos(iVertex.z));
	model[3].z = (h*0.5)*0.5;
	//model[3].z += sin(iGlobalTime * cos(iVertex.z));
	
	gl_Position = iMVP * model * pos;
}

//! GEOMETRY

layout(triangles) in;
layout(triangle_strip, max_vertices=3) out;

layout(location = 0) in SharedData dataTE[];
layout(location = 0) out SharedData dataG;

void main()
{
	for(int i=0; i<gl_in.length(); ++i)
	{
		dataG.pos = dataTE[i].pos;
		dataG.uv = dataTE[i].uv;
		//dataG.normal = dataTE[i].normal;
		//dataG.color = dataTE[i].color;
		//dataG.world_pos = dataTE[i].world_pos;
		//dataG.world_normal = dataTE[i].world_normal;
		//dataG.color = dataTE[i].color;
		//dataG.special = dataTE[i].special;

		gl_Position = gl_in[i].gl_Position; //(inverse(iMVP)* pos);
		EmitVertex();
		
		//gl_Position = iMVP * vec4(0,0,0,1); //iMVP * ( vec4(v.pos-v.normal*0.1,1));
		//gl_Position = vec4(0,0,0,1);
		//EmitVertex();
	}

	EndPrimitive();
}

//! FRAGMENT

layout(location = 0) in SharedData dataG;
out vec4 oFragColor;

vec3 XCOLOR1 = vec3(1.0, 0.0, 0.0);
vec3 XCOLOR2 = vec3(0.0, 1.0, 0.0);
vec3 XCOLOR3 = vec3(0.0, 0.0, 1.0);

vec3 rainbowColor(vec2 pos) {
	vec3 xcolormix = mix(XCOLOR1,XCOLOR2,pos.x);
	vec3 ycolormix = mix(xcolormix,XCOLOR3,pos.y);
	vec3 color  = (xcolormix+ycolormix)*0.5;
	//color  = mix(xcolormix,ycolormix,(uv.x+uv.y)*0.5);
	return color;
}

void main() {
	vec2 uv = 0.5+(-0.5+dataG.uv)*2;
	vec3 bg_color = rainbowColor(uv);
	vec3 color = bg_color;
	color += bg_color*mix((1-sin((uv.x)*1000)),(1-sin(uv.y*1000)),0.5)*0.25;
	oFragColor = vec4(color, 0.5);
}