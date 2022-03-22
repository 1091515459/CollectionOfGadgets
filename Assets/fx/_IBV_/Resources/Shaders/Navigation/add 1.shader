// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "zyz/add1"
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
		[Enum(normal,0,polar,1)]_MaskUvMode("MaskUvMode", Float) = 0
		[Enum(R,0,A,1)]_MaskChannel("MaskChannel", Float) = 0
		_MaskTex("MaskTex", 2D) = "white" {}
		_MaskTexTiling("MaskTexTiling", Vector) = (0,0,0,0)
		_MaskTexUvSpeed("MaskTexUvSpeed", Vector) = (0,0,0,0)
		[Enum(Normal,0,Vertex,1)]_OffsetDir("OffsetDir", Float) = 0
		[Enum(NoTexAffect,0,TexAffect,1)]_OffsetOption("OffsetOption", Float) = 0
		_offset("offset", Float) = 0
		[Enum(WX,0,jz,1)]_normalmatpoffsetoffset("normalmatpoffset/offset", Float) = 0
		_noiseMap("noiseMap", 2D) = "white" {}
		_NoiseMapTiling("NoiseMapTiling", Vector) = (0.5,0.5,0,0)
		_noise("noise", Float) = 0
		_noiseSpeed("noiseSpeed", Vector) = (0,0,0,0)
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
			uniform sampler2D _noiseMap;
			uniform float2 _noiseSpeed;
			uniform float2 _NoiseMapTiling;
			uniform float2 _MaskTexTiling;
			uniform float _noise;
			uniform half _normalmatpoffsetoffset;
			uniform half _MaskChannel;
			
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
				float3 vertexValue = ( lerpResult49 * _offset * TexAffect55 );
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
				float2 uv0104 = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner108 = ( 1.0 * _Time.y * _noiseSpeed + ( _NoiseMapTiling * uv0104 ));
				float2 temp_cast_0 = (tex2D( _noiseMap, panner108 ).r).xx;
				float2 lerpResult106 = lerp( temp_cast_0 , ( uv0104 * _MaskTexTiling ) , _noise);
				float2 lerpResult90 = lerp( lerpResult46 , lerpResult106 , _normalmatpoffsetoffset);
				float2 panner21 = ( 1.0 * _Time.y * _MaskTexUvSpeed + lerpResult90);
				float4 tex2DNode11 = tex2D( _MaskTex, panner21 );
				float lerpResult79 = lerp( tex2DNode11.r , tex2DNode11.a , _MaskChannel);
				
				
				finalColor = float4( ( (tex2DNode2).rgb * (_MainColor).rgb * (i.ase_color).rgb * ( _MainColor.a * i.ase_color.a * FinalTexAlpha66 * lerpResult79 ) ) , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16800
1920;0;1920;1019;4291.708;1075.412;1.972751;True;True
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-4252.995,-1019.099;Float;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-4256.729,-875.8475;Float;False;1;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;80;-4187.935,-741.4767;Half;False;Property;_MainUvChannal;MainUvChannal;2;1;[Enum];Create;True;2;UV1;0;UV2;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;82;-3966.731,-879.8475;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;24;-3651.699,-809.1465;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;-4235.886,378.0658;Float;False;1;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;83;-4216.748,522.414;Half;False;Property;_MaskUvChannal;MaskUvChannal;8;1;[Enum];Create;True;2;UV1;0;UV2;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;28;-3373.265,-591.3486;Float;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;20;-4265.051,230.207;Float;False;0;11;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PiNode;30;-3126.079,-352.8401;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;26;-3121.738,-593.6993;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;-3911.162,255.1518;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;38;-3700.334,325.1602;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-2899.192,-593.5494;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;31;-2679.38,-593.2494;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;25;-3343.781,-807.9714;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;40;-3421.9,542.9581;Float;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;36;-1999.949,-716.0582;Half;False;Property;_MainUvMode;MainUvMode;3;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;42;-3163.704,752.9822;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;41;-3170.373,540.6074;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;35;-2396.006,-811.3398;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;104;-3198.249,-49.62695;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;119;-2934.306,-278.2979;Float;False;Property;_NoiseMapTiling;NoiseMapTiling;20;0;Create;True;0;0;False;0;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;43;-2947.827,540.7573;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2753.306,-188.2979;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;37;-1764.456,-889.2803;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;109;-2567.811,-246.1238;Float;False;Property;_noiseSpeed;noiseSpeed;22;0;Create;True;0;0;False;0;0,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;18;-1658.646,-683.169;Float;False;Property;_MainTexUvSpeed;MainTexUvSpeed;7;0;Create;True;0;0;False;0;0.5,0;-0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LengthOpNode;39;-3392.416,326.3352;Float;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;44;-2728.015,541.0574;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-1344.1,-738.4525;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;118;-2584.925,90.37019;Float;False;Property;_MaskTexTiling;MaskTexTiling;12;0;Create;True;0;0;False;0;0,0;0.02,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;108;-2338.811,-225.1238;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-1963.853,386.6273;Half;False;Property;_MaskUvMode;MaskUvMode;9;1;[Enum];Create;True;2;normal;0;polar;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1979.373,-4.25375;Float;False;Property;_noise;noise;21;0;Create;True;0;0;False;0;0;1.06;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;-2117.434,-260.3659;Float;True;Property;_noiseMap;noiseMap;19;0;Create;True;0;0;False;0;None;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1095.012,-516.5847;Float;True;Property;_MainTex;MainTex;6;0;Create;True;0;0;False;0;138df4511c079324cabae1f7f865c1c1;6fa0f4eb9cbb13244ac3da13bb64386d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;45;-2444.641,322.9669;Float;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-2328.709,-0.4403076;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-440.7264,-516.9232;Float;False;MainTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;46;-1762.725,233.2718;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;106;-1822.373,-91.25366;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-1983.402,142.5926;Half;False;Property;_normalmatpoffsetoffset;normalmatpoffset/offset;18;1;[Enum];Create;True;2;WX;0;jz;1;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-280.031,-411.5897;Half;False;Constant;_Float1;Float 1;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-364.2824,-336.4412;Float;False;Property;_MainTexAlphaSwitch;MainTexAlphaSwitch;5;1;[Enum];Create;True;2;On;0;Off;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;90;-1598.316,115.1405;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;64;-153.191,-449.159;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;22;-1678.188,356.9373;Float;False;Property;_MaskTexUvSpeed;MaskTexUvSpeed;13;0;Create;True;0;0;False;0;0,0;-0.4,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;53;34.18624,525.4065;Float;False;Property;_OffsetOption;OffsetOption;15;1;[Enum];Create;True;2;NoTexAffect;0;TexAffect;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;63;-94.93142,-407.6894;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-1397.329,288.9538;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;57.50552,368.0378;Half;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-8.471251,444.5758;Float;False;57;MainTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;81.90135,-410.9312;Float;False;FinalTexAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-972.9559,429.2524;Half;False;Property;_MaskChannel;MaskChannel;10;1;[Enum];Create;True;2;R;0;A;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;259.7528,406.3585;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1157.121,239.6998;Float;True;Property;_MaskTex;MaskTex;11;0;Create;True;0;0;False;0;None;529911e9b419af64cb3921bc5aa32e6f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;51;-1208.726,622.537;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;12;-967.5809,-38.66189;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;67;-984.3414,155.6459;Float;False;66;FinalTexAlpha;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1168.085,767.537;Float;False;Property;_OffsetDir;OffsetDir;14;1;[Enum];Create;True;2;Normal;0;Vertex;1;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-981.9195,-211.0357;Float;False;Property;_MainColor;MainColor;4;1;[HDR];Create;True;0;0;False;0;1,1,1,1;2.458025,4.861427,10.43295,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;55;425.7042,401.6689;Float;False;TexAffect;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;79;-745.6618,281.8183;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;6;-1203.401,477.455;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;56;-770.6694,913.9023;Float;False;55;TexAffect;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;-564.8878,55.87287;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;72;-771.5599,-207.2277;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;73;-762.6599,-118.6276;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;49;-871.0854,673.537;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;71;-792.8776,-506.68;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-753.4875,817.2283;Float;False;Property;_offset;offset;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-925.1738,567.1125;Float;False;Property;_Float3;Float 3;23;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-466.401,671.455;Float;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;48;-2607.677,1050.726;Float;False;Property;_Zwrite;Zwrite;1;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-387.211,-189.6028;Float;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.IntNode;47;-2613.172,940.8048;Float;False;Property;_CullMode;CullMode;0;1;[Enum];Create;True;3;Culloff;0;Frontcull;1;Backcull;2;0;True;0;0;0;0;1;INT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-1396.948,447.8257;Float;False;Property;_Float2;Float 2;17;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-112.1121,-85.50925;Float;False;True;2;Float;ASEMaterialInspector;0;1;zyz/add1;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;1;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;True;47;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;True;48;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;True;0;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;82;0;15;0
WireConnection;82;1;81;0
WireConnection;82;2;80;0
WireConnection;24;0;82;0
WireConnection;28;0;24;0
WireConnection;26;0;28;1
WireConnection;26;1;28;0
WireConnection;84;0;20;0
WireConnection;84;1;85;0
WireConnection;84;2;83;0
WireConnection;38;0;84;0
WireConnection;29;0;26;0
WireConnection;29;1;30;0
WireConnection;31;0;29;0
WireConnection;25;0;24;0
WireConnection;40;0;38;0
WireConnection;41;0;40;1
WireConnection;41;1;40;0
WireConnection;35;0;25;0
WireConnection;35;1;31;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;120;0;119;0
WireConnection;120;1;104;0
WireConnection;37;0;82;0
WireConnection;37;1;35;0
WireConnection;37;2;36;0
WireConnection;39;0;38;0
WireConnection;44;0;43;0
WireConnection;16;0;37;0
WireConnection;16;2;18;0
WireConnection;108;0;120;0
WireConnection;108;2;109;0
WireConnection;100;1;108;0
WireConnection;2;1;16;0
WireConnection;45;0;39;0
WireConnection;45;1;44;0
WireConnection;117;0;104;0
WireConnection;117;1;118;0
WireConnection;57;0;2;4
WireConnection;46;0;84;0
WireConnection;46;1;45;0
WireConnection;46;2;77;0
WireConnection;106;0;100;1
WireConnection;106;1;117;0
WireConnection;106;2;107;0
WireConnection;90;0;46;0
WireConnection;90;1;106;0
WireConnection;90;2;91;0
WireConnection;64;0;57;0
WireConnection;63;0;64;0
WireConnection;63;1;65;0
WireConnection;63;2;69;0
WireConnection;21;0;90;0
WireConnection;21;2;22;0
WireConnection;66;0;63;0
WireConnection;52;0;54;0
WireConnection;52;1;68;0
WireConnection;52;2;53;0
WireConnection;11;1;21;0
WireConnection;55;0;52;0
WireConnection;79;0;11;1
WireConnection;79;1;11;4
WireConnection;79;2;78;0
WireConnection;13;0;3;4
WireConnection;13;1;12;4
WireConnection;13;2;67;0
WireConnection;13;3;79;0
WireConnection;72;0;3;0
WireConnection;73;0;12;0
WireConnection;49;0;6;0
WireConnection;49;1;51;0
WireConnection;49;2;50;0
WireConnection;71;0;2;0
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
//CHKSM=F6BE40783948E36F26AFB9666FE64331AAADCFC4