Shader "Hidden/recaculateNormalmap"
{
    Properties
    {
		_MainTex("m",2D)="white"{}
       // _MetallicTex ("_MetallicTex", 2D) = "white" {}
		//_OcclusionTex("_OcclusionTex", 2D) = "white" {}
		//_DetailMaskTex("_DetailMaskTex", 2D) = "white" {}
		//_SmoothnessTex("_SmoothnessTex", 2D) = "white" {}
    }
    SubShader
    {
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag


            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
			sampler2D _MainTex;
            sampler2D _MetallicTex;
			sampler2D _OcclusionTex;
			sampler2D _DetailMaskTex;
			sampler2D _SmoothnessTex;
			int isUseRoughness;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex,i.uv);
				col.r = tex2D(_MetallicTex, i.uv).r;
				col.g = tex2D(_OcclusionTex, i.uv).g;
				col.b = tex2D(_DetailMaskTex, i.uv).b;
				if(isUseRoughness==0)
					col.a = tex2D(_SmoothnessTex, i.uv).r;
				else
					col.a = 1-tex2D(_SmoothnessTex, i.uv).r;
				return col;
            }
            ENDCG
        }
    }
}
