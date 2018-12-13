varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D sprite;
uniform lowp vec4 tint;

void main()
{
	
	vec4 color = texture2D(sprite, var_texcoord0.xy);

	if(color.a > 0) {
		color.xyzw = vec4(0.1, 0.1, 0.1, 1.0);
	}

	gl_FragColor = color;
}
