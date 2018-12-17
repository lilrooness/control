varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D original;

uniform float weight[5] = float[] (
	0.227027, 0.1945946, 0.1216216, 0.054054, 0.016216
);

float rand(vec2 co){
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main()
{
	vec2 tex_offset = 1.0 / textureSize(original, 0); // gets size of single texel
	vec3 result = texture(original, var_texcoord0).rgb * weight[0]; // current fragment's contribution
	for(int i = 1; i < 5; ++i)
	{
		result += texture(original, var_texcoord0 + vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
		result += texture(original, var_texcoord0 - vec2(tex_offset.x * i, 0.0)).rgb * weight[i];
	}

	for(int i = 1; i < 5; ++i)
	{
		result += texture(original, var_texcoord0 + vec2(0.0, tex_offset.y * i)).rgb * weight[i];
		result += texture(original, var_texcoord0 - vec2(0.0, tex_offset.y * i)).rgb * weight[i];
	}
	//gl_FragColor = vec4(result, 1.0);
	gl_FragColor = texture2D(original, var_texcoord0.xy);
	
}
