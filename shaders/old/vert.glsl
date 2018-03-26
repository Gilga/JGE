#version 330
uniform mat4 projection;
uniform mat4 camera;
uniform mat4 model;
//dfdsgu6u7i
in vec3 vert;
in vec2 vertTexCoord;
// sdsfds
out vec2 fragTexCoord;

void main() {
	fragTexCoord = vertTexCoord;
	//gl_Position = vec4(vert, 1);
	gl_Position = projection * camera * model * vec4(vert, 1);
}