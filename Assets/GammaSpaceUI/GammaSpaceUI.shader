Shader "Hidden/GammaSpaceUI"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _UITex ("Texture", 2D) = "black" {}
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

        #if defined(SHADER_API_METAL) || defined(SHADER_API_GLES3)
            #define MOBILE_USE_POST_CORRECTION 1
        #endif

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex, _UITex;

            half3 LinearToGammaSpace3(half3 col)
            {
                col.r = LinearToGammaSpaceExact(col.r);
                col.g = LinearToGammaSpaceExact(col.g);
                col.b = LinearToGammaSpaceExact(col.b);
                return col;
            }

            half3 GammaToLinearSpace3(half3 col)
            {
                col.r = GammaToLinearSpaceExact(col.r);
                col.g = GammaToLinearSpaceExact(col.g);
                col.b = GammaToLinearSpaceExact(col.b);
                return col;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb = LinearToGammaSpace3(col.rgb);
                fixed4 ui = tex2D(_UITex, i.uv);

                col.rgb = col.rgb * (1.0 - ui.a) + ui.rgb;

                // need conversion back to linear space if GL.sRGBWrite doesn't work on your platform (mobile)
            #if defined(MOBILE_USE_POST_CORRECTION)
                col.rgb = GammaToLinearSpace3(col.rgb);
            #endif
                return col;
            }
            ENDCG
        }
    }
}
