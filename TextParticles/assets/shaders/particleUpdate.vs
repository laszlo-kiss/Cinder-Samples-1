#version 150 core

uniform float uMouseForce;
uniform vec3  uMousePos;

uniform sampler2D	uNoiseTex;
uniform sampler2D	uPerlinTex;
uniform float		uTime = 1.0;
uniform float		uStep = 1.0;

in vec3   iPosition;
in vec3   iPPosition;
in vec3   iHome;
in float  iDamping;
in vec4   iColor;
in vec2	  iTexCoord;
in float  iInvMass;

out vec3  position;
out vec3  pposition;
out vec3  home;
out float damping;
out vec4  color;
out vec2  texcoord;
out float invmass;

const float dt2 = 1.0 / (60.0 * 60.0);

void main()
{
	position =  iPosition;
	pposition =  iPPosition;
	damping =   iDamping;
	home =      iHome;
	color =     iColor;
	texcoord =  iTexCoord;
	invmass =	iInvMass;

//	vec3 vel = (position - pposition) * damping;
	vec3 vel = (position - pposition);
	pposition = position;
	vec3 direction = normalize( vel );
	
	
	damping -= 0.004;
	damping = max( damping, 0 );	// min is 0
	
	vec3 perlin		= ( texture( uPerlinTex, texcoord * vec2( 5.0, 1.0 ) ).rgb * vec3( 2.0 ) ) - vec3(1.0);	// [-1.0,1.0]
	

//	vec3 newV		= texture( uPerlinTex, texcoord * vec2( 5.0, 1.0 ) ).rgb * 2.0 - 1.0;
//	float noiseVal	= texture( uNoiseTex, texcoord ).r;
//	vec3 acc = direction + perlin;
	vec3 acc = direction + ((perlin * invmass) * uStep);
	
	vec3 v1 = vel.xyz + acc;
	v1 *= damping;

	vec3 p1 = position.xyz + v1;
	
	position = p1;
	color.a = clamp( damping * 2.0, 0.0, 1.0 );
}