varying mediump vec4 position;
varying mediump vec2 var_texcoord0;

uniform lowp vec4 alarm_color;

void main()
{
	gl_FragColor = alarm_color.xyzw;
}
