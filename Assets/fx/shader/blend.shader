// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "wx/blend"
{
	Properties
	{
		[Enum(Culloff,0,Frontcull,1,Backcull,2)]_CullMode("CullMode", Int) = 0
		[Enum(Off,0,On,1)]_Zwrite("Zwrite", Int) = 0
		[Enum(normal,0,polar,1)]_MainUvMode("MainUvMode", Float) = 0
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
		[Enum(On,0,Off,1)]_MainTexAlphaSwitch("MainTexAlphaSwitch", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexUvSpeed("MainTexUvSpeed", Vector) = (0,0,0,0)
		[Enum(normal,0,polar,1)]_MaskUvMode("MaskUvMode", Float) = 0
		[Enum(R,0,A,1)]_MaskChannel("MaskChannel", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTexUvSpeed("MaskTexUvSpeed", Vector) = (0,0,0,0)
		[Enum(R,0,A,1)]_MaskChannel02("MaskChannel02", Float) = 0
		_MaskTex02("MaskTex02", 2D) = "white" {}
		[Enum(Normal,0,Vertex,1)]_OffsetDir("OffsetDir", Float) = 0
		[Enum(NoTexAffect,0,TexAffect,1)]_OffsetOption("OffsetOption", Float) = 0
		_offset("offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
	LOD 0

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
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
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
			};

			uniform int _CullMode;
			uniform int _Zwrite;
			uniform float _OffsetDir;
			uniform float _offset;
			uniform sampler2D _MainTex;
			uniform float2 _MainTexUvSpeed;
			uniform float4 _MainTex_ST;
			uniform float _MainUvMode;
			uniform float _OffsetOption;
			uniform float4 _MainColor;
			uniform float _MainTexAlphaSwitch;
			uniform sampler2D _MaskTex;
			uniform float2 _MaskTexUvSpeed;
			uniform float4 _MaskTex_ST;
			uniform float _MaskUvMode;
			uniform half _MaskChannel;
			uniform sampler2D _MaskTex02;
			uniform float4 _MaskTex02_ST;
			uniform half _MaskChannel02;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 lerpResult49 = lerp( v.ase_normal , v.vertex.xyz , _OffsetDir);
				float2 uv0_MainTex = v.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 temp_output_24_0 = (uv0_MainTex*2.0 + -1.0);
				float2 break28 = temp_output_24_0;
				float2 appendResult35 = (float2(length( temp_output_24_0 ) , (( atan2( break28.y , break28.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult37 = lerp( uv0_MainTex , appendResult35 , _MainUvMode);
				float2 panner16 = ( 1.0 * _Time.y * _MainTexUvSpeed + lerpResult37);
				float4 tex2DNode2 = tex2Dlod( _MainTex, float4( panner16, 0, 0.0) );
				float MainTexAlpha57 = tex2DNode2.a;
				float lerpResult52 = lerp( 1.0 , MainTexAlpha57 , _OffsetOption);
				float TexAffect55 = lerpResult52;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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

#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
#endif
				float2 uv0_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 temp_output_24_0 = (uv0_MainTex*2.0 + -1.0);
				float2 break28 = temp_output_24_0;
				float2 appendResult35 = (float2(length( temp_output_24_0 ) , (( atan2( break28.y , break28.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult37 = lerp( uv0_MainTex , appendResult35 , _MainUvMode);
				float2 panner16 = ( 1.0 * _Time.y * _MainTexUvSpeed + lerpResult37);
				float4 tex2DNode2 = tex2D( _MainTex, panner16 );
				float MainTexAlpha57 = tex2DNode2.a;
				float lerpResult63 = lerp( MainTexAlpha57 , 1.0 , _MainTexAlphaSwitch);
				float FinalTexAlpha66 = lerpResult63;
				float2 uv0_MaskTex = i.ase_texcoord1.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float2 temp_output_38_0 = (uv0_MaskTex*2.0 + -1.0);
				float2 break40 = temp_output_38_0;
				float2 appendResult45 = (float2(length( temp_output_38_0 ) , (( atan2( break40.y , break40.x ) / UNITY_PI )*0.5 + 0.5)));
				float2 lerpResult46 = lerp( uv0_MaskTex , appendResult45 , _MaskUvMode);
				float2 panner21 = ( 1.0 * _Time.y * _MaskTexUvSpeed + lerpResult46);
				float4 tex2DNode11 = tex2D( _MaskTex, panner21 );
				float lerpResult71 = lerp( tex2DNode11.r , tex2DNode11.a , _MaskChannel);
				float2 uv_MaskTex02 = i.ase_texcoord1.xy * _MaskTex02_ST.xy + _MaskTex02_ST.zw;
				float4 tex2DNode73 = tex2D( _MaskTex02, uv_MaskTex02 );
				float lerpResult75 = lerp( tex2DNode73.r , tex2DNode73.a , _MaskChannel02);
				float4 appendResult14 = (float4(( tex2DNode2 * _MainColor * i.ase_color ).rgb , ( FinalTexAlpha66 * _MainColor.a * i.ase_color.a * lerpResult71 * lerpResult75 )));
				
				
				finalColor = appendResult14;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18000
8;295;1435;724;2165.011;-36.40864;1.375401;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-3753.852,-307.5663;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;24;-3497.555,-236.6144;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-3219.121,-18.81656;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ATan2OpNode;26;-2967.594,-21.16722;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;30;-2960.924,205.0115;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-4003.211,246.5152;Inherit;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-2745.048,-21.0173;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;38;-3700.334,325.1602;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;25;-3189.637,-235.4393;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-2525.236,-20.71729;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;40;-3421.9,542.9581;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;35;-2241.862,-238.8077;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2030.16,-12.54104;Float;False;Property;_MainUvMode;MainUvMode;2;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;41;-3170.373,540.6074;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;37;-1760.786,-309.408;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PiNode;42;-3163.704,752.9822;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;18;-1581.574,-187.7084;Float;False;Property;_MainTexUvSpeed;MainTexUvSpeed;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-2947.827,540.7573;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-1351.44,-309.0535;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1095.012,-516.5847;Inherit;True;Property;_MainTex;MainTex;5;0;Create;True;0;0;False;0;-1;None;82b5f42db62b61e42b995ff14348f7c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;39;-3392.416,326.3352;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;44;-2728.015,541.0574;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;45;-2444.641,322.9669;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-740.4335,-574.0831;Float;False;MainTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2028.753,135.2045;Float;False;Property;_MaskUvMode;MaskUvMode;7;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-663.9895,-393.6024;Float;False;Property;_MainTexAlphaSwitch;MainTexAlphaSwitch;4;1;[Enum];Create;True;2;On;0;Off;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-579.7378,-468.7503;Half;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1749.725,261.2718;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;64;-452.8976,-506.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;22;-1517.188,332.9373;Float;False;Property;_MaskTexUvSpeed;MaskTexUvSpeed;10;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;63;-394.6381,-464.8502;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1236.329,264.9538;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-8.471251,444.5758;Inherit;False;57;MainTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;57.50552,368.0378;Half;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;34.18624,525.4065;Float;False;Property;_OffsetOption;OffsetOption;14;1;[Enum];Create;True;2;NoTexAffect;0;TexAffect;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-947.9498,847.1005;Half;False;Property;_MaskChannel02;MaskChannel02;11;1;[Enum];Create;True;2;R;0;A;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-928.0504,503.9668;Half;False;Property;_MaskChannel;MaskChannel;8;1;[Enum];Create;True;2;R;0;A;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-1039.052,638.825;Inherit;True;Property;_MaskTex02;MaskTex02;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-217.8051,-468.0919;Float;False;FinalTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;259.7528,406.3585;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1011.121,305.6998;Inherit;True;Property;_MaskTex;MaskTex;9;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;67;-983.4412,-182.5541;Inherit;False;66;FinalTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;71;-715.4021,379.6321;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;75;-714.5778,691.725;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1191.528,1343.196;Float;False;Property;_OffsetDir;OffsetDir;13;1;[Enum];Create;True;2;Normal;0;Vertex;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;51;-1232.169,1198.196;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1226.844,1053.114;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;425.7042,401.6689;Float;False;TexAffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-979.3195,-103.1356;Float;False;Property;_MainColor;MainColor;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;12;-945.481,64.03809;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-603,-252;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;49;-894.5286,1249.196;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-776.9307,1392.887;Float;False;Property;_offset;offset;15;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;56;-794.1125,1489.561;Inherit;False;55;TexAffect;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-479.4153,13.01833;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;48;-2607.677,1050.726;Float;False;Property;_Zwrite;Zwrite;1;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.IntNode;47;-2613.172,940.8048;Float;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;3;Culloff;0;Frontcull;1;Backcull;2;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-489.8442,1247.114;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;14;-348.4796,-84.85426;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-112.1121,-85.50925;Float;False;True;-1;2;ASEMaterialInspector;0;1;wx/blend;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;True;47;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;True;48;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Opaque=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;24;0;15;0
WireConnection;28;0;24;0
WireConnection;26;0;28;1
WireConnection;26;1;28;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;38;0;20;0
WireConnection;25;0;24;0
WireConnection;31;0;29;0
WireConnection;40;0;38;0
WireConnection;35;0;25;0
WireConnection;35;1;31;0
WireConnection;41;0;40;1
WireConnection;41;1;40;0
WireConnection;37;0;15;0
WireConnection;37;1;35;0
WireConnection;37;2;36;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;16;0;37;0
WireConnection;16;2;18;0
WireConnection;2;1;16;0
WireConnection;39;0;38;0
WireConnection;44;0;43;0
WireConnection;45;0;39;0
WireConnection;45;1;44;0
WireConnection;57;0;2;4
WireConnection;46;0;20;0
WireConnection;46;1;45;0
WireConnection;46;2;72;0
WireConnection;64;0;57;0
WireConnection;63;0;64;0
WireConnection;63;1;65;0
WireConnection;63;2;69;0
WireConnection;21;0;46;0
WireConnection;21;2;22;0
WireConnection;66;0;63;0
WireConnection;52;0;54;0
WireConnection;52;1;68;0
WireConnection;52;2;53;0
WireConnection;11;1;21;0
WireConnection;71;0;11;1
WireConnection;71;1;11;4
WireConnection;71;2;70;0
WireConnection;75;0;73;1
WireConnection;75;1;73;4
WireConnection;75;2;74;0
WireConnection;55;0;52;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;4;2;12;0
WireConnection;49;0;6;0
WireConnection;49;1;51;0
WireConnection;49;2;50;0
WireConnection;13;0;67;0
WireConnection;13;1;3;4
WireConnection;13;2;12;4
WireConnection;13;3;71;0
WireConnection;13;4;75;0
WireConnection;7;0;49;0
WireConnection;7;1;8;0
WireConnection;7;2;56;0
WireConnection;14;0;4;0
WireConnection;14;3;13;0
WireConnection;1;0;14;0
WireConnection;1;1;7;0
ASEEND*/
//CHKSM=8A5E9A4B5E51A8699929118C1DB9CECED83C875C