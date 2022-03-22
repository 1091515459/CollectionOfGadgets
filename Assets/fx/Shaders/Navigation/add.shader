// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wx/add"
{
	Properties
	{
		[Enum(Culloff,0,Frontcull,1,Backcull,2)]_CullMode("CullMode", Int) = 0
		[Enum(Off,0,On,1)]_Zwrite("Zwrite", Int) = 0
		[Enum(UV1,0,UV2,1)]_MainUvChannal("MainUvChannal", Float) = 0
		[Enum(normal,0,polar,1)]_MainUvMode("MainUvMode", Float) = 0
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[Enum(On,0,Off,1)]_MainTexAlphaSwitch("MainTexAlphaSwitch", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexUvSpeed("MainTexUvSpeed", Vector) = (0.5,0,0,0)
		[Enum(UV1,0,UV2,1)]_MaskUvChannal("MaskUvChannal", Float) = 0
		[Enum(noReverse,0,Reverse,1)]_ChannelReverse("ChannelReverse", Float) = 0
		[Enum(normal,0,polar,1)]_MaskUvMode("MaskUvMode", Float) = 0
		[Enum(R,0,A,1)]_MaskChannel("MaskChannel", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTexUvSpeed("MaskTexUvSpeed", Vector) = (0,0,0,0)
		[Enum(R,0,A,1)]_Mask02Channel("Mask02Channel", Float) = 0
		[Enum(noReverse,0,Reverse,1)]_ChannelReverse02("ChannelReverse02", Float) = 0
		_MaskTex02("MaskTex02", 2D) = "white" {}
		[Enum(Normal,0,Vertex,1)]_OffsetDir("OffsetDir", Float) = 0
		[Enum(NoTexAffect,0,TexAffect,1)]_OffsetOption("OffsetOption", Float) = 0
		_offset("offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		Cull [_CullMode]
		ColorMask RGBA
		ZWrite [_Zwrite]
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			};

			uniform int _Zwrite;
			uniform int _CullMode;
			uniform float _OffsetDir;
			uniform float _offset;
			uniform sampler2D _MainTex;
			uniform float2 _MainTexUvSpeed;
			uniform float4 _MainTex_ST;
			uniform half _MainUvChannal;
			uniform half _MainUvMode;
			uniform float _OffsetOption;
			uniform float4 _MainColor;
			uniform float _MainTexAlphaSwitch;
			uniform sampler2D _MaskTex;
			uniform float2 _MaskTexUvSpeed;
			uniform float4 _MaskTex_ST;
			uniform half _MaskUvChannal;
			uniform half _MaskUvMode;
			uniform half _MaskChannel;
			uniform half _ChannelReverse;
			uniform sampler2D _MaskTex02;
			uniform float4 _MaskTex02_ST;
			uniform half _Mask02Channel;
			uniform half _ChannelReverse02;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 lerpResult49 = lerp( v.ase_normal , v.vertex.xyz , _OffsetDir);
				float2 uv0_MainTex = v.ase_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv1_MainTex = v.ase_texcoord1 * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 lerpResult82 = lerp( uv0_MainTex , uv1_MainTex , _MainUvChannal);
				float2 temp_output_24_0 = (lerpResult82*2.0 + -1.0);
				float2 break28 = temp_output_24_0;
				float2 appendResult35 = (float2(length( temp_output_24_0 ) , (( atan2( break28.y , break28.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult37 = lerp( lerpResult82 , appendResult35 , _MainUvMode);
				float2 panner16 = ( 1.0 * _Time.y * _MainTexUvSpeed + lerpResult37);
				float4 tex2DNode2 = tex2Dlod( _MainTex, float4( panner16, 0, 0.0) );
				float MainTexAlpha57 = tex2DNode2.a;
				float lerpResult52 = lerp( 1.0 , MainTexAlpha57 , _OffsetOption);
				float TexAffect55 = lerpResult52;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_texcoord.zw = v.ase_texcoord1.xy;
				o.ase_color = v.color;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( lerpResult49 * _offset * TexAffect55 );
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float2 uv0_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv1_MainTex = i.ase_texcoord.zw * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 lerpResult82 = lerp( uv0_MainTex , uv1_MainTex , _MainUvChannal);
				float2 temp_output_24_0 = (lerpResult82*2.0 + -1.0);
				float2 break28 = temp_output_24_0;
				float2 appendResult35 = (float2(length( temp_output_24_0 ) , (( atan2( break28.y , break28.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult37 = lerp( lerpResult82 , appendResult35 , _MainUvMode);
				float2 panner16 = ( 1.0 * _Time.y * _MainTexUvSpeed + lerpResult37);
				float4 tex2DNode2 = tex2D( _MainTex, panner16 );
				float MainTexAlpha57 = tex2DNode2.a;
				float lerpResult63 = lerp( MainTexAlpha57 , 1.0 , _MainTexAlphaSwitch);
				float FinalTexAlpha66 = lerpResult63;
				float2 uv0_MaskTex = i.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float2 uv1_MaskTex = i.ase_texcoord.zw * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float2 lerpResult84 = lerp( uv0_MaskTex , uv1_MaskTex , _MaskUvChannal);
				float2 temp_output_38_0 = (lerpResult84*2.0 + -1.0);
				float2 break40 = temp_output_38_0;
				float2 appendResult45 = (float2(length( temp_output_38_0 ) , (( atan2( break40.y , break40.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult46 = lerp( lerpResult84 , appendResult45 , _MaskUvMode);
				float2 panner21 = ( 1.0 * _Time.y * _MaskTexUvSpeed + lerpResult46);
				float4 tex2DNode11 = tex2D( _MaskTex, panner21 );
				float lerpResult79 = lerp( tex2DNode11.r , tex2DNode11.a , _MaskChannel);
				float lerpResult87 = lerp( lerpResult79 , ( 1.0 - lerpResult79 ) , _ChannelReverse);
				float2 uv_MaskTex02 = i.ase_texcoord.xy * _MaskTex02_ST.xy + _MaskTex02_ST.zw;
				float4 tex2DNode90 = tex2D( _MaskTex02, uv_MaskTex02 );
				float lerpResult91 = lerp( tex2DNode90.r , tex2DNode90.a , _Mask02Channel);
				float lerpResult93 = lerp( lerpResult91 , ( 1.0 - lerpResult91 ) , _ChannelReverse02);
				
				
				finalColor = float4( ( (tex2DNode2).rgb * (_MainColor).rgb * (i.ase_color).rgb * ( _MainColor.a * i.ase_color.a * FinalTexAlpha66 * lerpResult87 * lerpResult93 ) ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17000
0;0;1920;1139;2561.303;399.6516;1.510221;True;True
Node;AmplifyShaderEditor.RangedFloatNode;80;-4033.792,-168.9446;Half;False;Property;_MainUvChannal;MainUvChannal;2;1;[Enum];Create;True;2;UV1;0;UV2;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-4102.587,-303.3154;Float;False;1;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-4098.852,-446.5663;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;82;-3812.587,-307.3154;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-4235.886,378.0658;Float;False;1;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-4216.748,522.414;Half;False;Property;_MaskUvChannal;MaskUvChannal;8;1;[Enum];Create;True;2;UV1;0;UV2;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-4238.817,246.5152;Float;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;24;-3497.555,-236.6144;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;84;-3911.162,255.1518;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-3219.121,-18.81656;Float;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ATan2OpNode;26;-2967.594,-21.16722;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;30;-2960.924,205.0115;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;38;-3700.334,325.1602;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;40;-3421.9,542.9581;Float;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-2745.048,-21.0173;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;42;-3163.704,752.9822;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;41;-3170.373,540.6074;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;25;-3189.637,-235.4393;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-2525.236,-20.71729;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-2947.827,540.7573;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-2241.862,-238.8077;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1966.918,-59.11402;Half;False;Property;_MainUvMode;MainUvMode;3;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-1581.574,-187.7084;Float;False;Property;_MainTexUvSpeed;MainTexUvSpeed;7;0;Create;True;0;0;False;0;0.5,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;44;-2728.015,541.0574;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;39;-3392.416,326.3352;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;-1760.786,-309.408;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-2444.641,322.9669;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-1351.44,-309.0535;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1969.853,122.6273;Half;False;Property;_MaskUvMode;MaskUvMode;10;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1749.725,261.2718;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1095.012,-516.5847;Float;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;False;0;138df4511c079324cabae1f7f865c1c1;66924d576d2909e43a31bb3fe98087d7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;22;-1835.188,387.9373;Float;False;Property;_MaskTexUvSpeed;MaskTexUvSpeed;13;0;Create;True;0;0;False;0;0,0;0.03,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-440.7264,-516.9232;Float;False;MainTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1552.329,261.9538;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;11;-1379.121,234.6998;Float;True;Property;_MaskTex;MaskTex;12;0;Create;True;0;0;False;0;None;61337b0eed9b5aa4a89d219c2085c03d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;89;-1298.657,685.5913;Half;False;Property;_Mask02Channel;Mask02Channel;14;1;[Enum];Create;True;2;R;0;A;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-1277.244,410.4258;Half;False;Property;_MaskChannel;MaskChannel;11;1;[Enum];Create;True;2;R;0;A;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-280.031,-411.5897;Half;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;90;-1388.452,502.3141;Float;True;Property;_MaskTex02;MaskTex02;16;0;Create;True;0;0;False;0;None;61337b0eed9b5aa4a89d219c2085c03d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;64;-153.191,-449.159;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-364.2824,-336.4412;Float;False;Property;_MainTexAlphaSwitch;MainTexAlphaSwitch;5;1;[Enum];Create;True;2;On;0;Off;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;79;-1086.006,278.1622;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;91;-1071.173,529.1641;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;57.50552,368.0378;Half;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-8.471251,444.5758;Float;False;57;MainTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;-94.93142,-407.6894;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;34.18624,525.4065;Float;False;Property;_OffsetOption;OffsetOption;18;1;[Enum];Create;True;2;NoTexAffect;0;TexAffect;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-979.766,396.2155;Half;False;Property;_ChannelReverse;ChannelReverse;9;1;[Enum];Create;True;2;noReverse;0;Reverse;1;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;-936.6712,333.8947;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;92;-921.8384,584.8967;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;81.90135,-410.9312;Float;False;FinalTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;259.7528,406.3585;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-998.1573,663.8302;Half;False;Property;_ChannelReverse02;ChannelReverse02;15;1;[Enum];Create;True;2;noReverse;0;Reverse;1;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-984.3414,155.6459;Float;False;66;FinalTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;87;-774.4385,279.6868;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;-736.9526,527.6683;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-981.9195,-211.0357;Float;False;Property;_MainColor;MainColor;4;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0.5243137,0.6741176,0.7490196,0.5019608;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;50;-1244.63,1485.35;Float;False;Property;_OffsetDir;OffsetDir;17;1;[Enum];Create;True;2;Normal;0;Vertex;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1279.946,1195.268;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;425.7042,401.6689;Float;False;TexAffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;12;-967.5809,-38.66189;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;51;-1285.271,1340.35;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;49;-929.6304,1307.35;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-829.2144,1547.715;Float;False;55;TexAffect;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;72;-771.5599,-207.2277;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-762.6599,-118.6276;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;71;-792.8776,-506.68;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-558.2026,-17.66168;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-812.0325,1451.041;Float;False;Property;_offset;offset;19;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-524.9461,1305.268;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;47;-2613.172,940.8048;Float;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;3;Culloff;0;Frontcull;1;Backcull;2;0;True;0;0;2;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-387.211,-189.6028;Float;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;48;-2607.677,1050.726;Float;False;Property;_Zwrite;Zwrite;1;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-112.1121,-85.50925;Float;False;True;2;Float;ASEMaterialInspector;0;1;wx/add;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;True;47;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;True;48;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;82;0;15;0
WireConnection;82;1;81;0
WireConnection;82;2;80;0
WireConnection;24;0;82;0
WireConnection;84;0;20;0
WireConnection;84;1;85;0
WireConnection;84;2;83;0
WireConnection;28;0;24;0
WireConnection;26;0;28;1
WireConnection;26;1;28;0
WireConnection;38;0;84;0
WireConnection;40;0;38;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;41;0;40;1
WireConnection;41;1;40;0
WireConnection;25;0;24;0
WireConnection;31;0;29;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;35;0;25;0
WireConnection;35;1;31;0
WireConnection;44;0;43;0
WireConnection;39;0;38;0
WireConnection;37;0;82;0
WireConnection;37;1;35;0
WireConnection;37;2;36;0
WireConnection;45;0;39;0
WireConnection;45;1;44;0
WireConnection;16;0;37;0
WireConnection;16;2;18;0
WireConnection;46;0;84;0
WireConnection;46;1;45;0
WireConnection;46;2;77;0
WireConnection;2;1;16;0
WireConnection;57;0;2;4
WireConnection;21;0;46;0
WireConnection;21;2;22;0
WireConnection;11;1;21;0
WireConnection;64;0;57;0
WireConnection;79;0;11;1
WireConnection;79;1;11;4
WireConnection;79;2;78;0
WireConnection;91;0;90;1
WireConnection;91;1;90;4
WireConnection;91;2;89;0
WireConnection;63;0;64;0
WireConnection;63;1;65;0
WireConnection;63;2;69;0
WireConnection;88;0;79;0
WireConnection;92;0;91;0
WireConnection;66;0;63;0
WireConnection;52;0;54;0
WireConnection;52;1;68;0
WireConnection;52;2;53;0
WireConnection;87;0;79;0
WireConnection;87;1;88;0
WireConnection;87;2;86;0
WireConnection;93;0;91;0
WireConnection;93;1;92;0
WireConnection;93;2;94;0
WireConnection;55;0;52;0
WireConnection;49;0;6;0
WireConnection;49;1;51;0
WireConnection;49;2;50;0
WireConnection;72;0;3;0
WireConnection;73;0;12;0
WireConnection;71;0;2;0
WireConnection;13;0;3;4
WireConnection;13;1;12;4
WireConnection;13;2;67;0
WireConnection;13;3;87;0
WireConnection;13;4;93;0
WireConnection;7;0;49;0
WireConnection;7;1;8;0
WireConnection;7;2;56;0
WireConnection;76;0;71;0
WireConnection;76;1;72;0
WireConnection;76;2;73;0
WireConnection;76;3;13;0
WireConnection;1;0;76;0
WireConnection;1;1;7;0
ASEEND*/
//CHKSM=2D05DC58892DA3704E32A086BA72B0310D5FF0FE