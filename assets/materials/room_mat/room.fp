varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp sampler2D sprite;

uniform lowp vec4 selected;
uniform lowp vec4 selected_color;

void main()
{

	vec4 color = texture2D(sprite, var_texcoord0.xy);
	if(selected.x == 1 && color.a == 0) {
		color.rgba = selected_color;
	}
	gl_FragColor = color;
}
