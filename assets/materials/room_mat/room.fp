varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D sprite;

uniform lowp vec4 selected;

void main()
{

	vec4 color = texture2D(sprite, var_texcoord0.xy);
	if(selected.x == 1 && color.a == 0) {
		color.rgb = 0.1;
	}
	gl_FragColor = color;
}
