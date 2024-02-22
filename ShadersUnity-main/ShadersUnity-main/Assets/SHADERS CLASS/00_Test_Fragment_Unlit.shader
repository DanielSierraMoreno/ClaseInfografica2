Shader"ENTI/00_Test_Fragment_Unlit"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1,1,1,1)
        _Color2 ("Color 2", Color) = (1,1,1,1)

        _Blend ("Blend ", Range(0,1)) = 1

        _MainTex ("Main Texture", 2D) = "white" {}
        _SecondTex ("Secondary Texture", 2D) = "white" {}
        _ThirdTex ("Secondary Texture", 2D) = "white" {}

        _BlendTex ("Blend Texture", 2D) = "white" {}


    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"  = "Transparent"}
        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

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
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;

            };

            sampler _MainTex;
            float4 _MainTex_ST;

            sampler _SecondTex;
            float4 _SecondTex_ST;

sampler _ThirdTex;
float4 _ThirdTex_ST;

            sampler _BlendTex;
            float4 _BlendTex_ST;

            fixed4 _Color1;
            fixed4 _Color2;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);    
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {              
                fixed4 col;
                //
                //col = _Color1 + _Color2 * _Blend;
    
                //
                //col = _Color1 * (1 - _Blend) + _Color2 * _Blend;

                float2 main_uv = TRANSFORM_TEX(i.uv, _MainTex);
                float2 second_uv = TRANSFORM_TEX(i.uv, _SecondTex);
                float2 third_uv = TRANSFORM_TEX(i.uv, _ThirdTex);

                fixed4 main_color = tex2D(_MainTex, main_uv);
                fixed4 secondary_color = tex2D(_SecondTex, second_uv);
                fixed4 third_color = tex2D(_ThirdTex, third_uv);

                float2 blend_uv = TRANSFORM_TEX(i.uv, _BlendTex);
                fixed4 blend_color = tex2D(_BlendTex, blend_uv);
    
    col = _Color1;

    col = lerp(col, main_color, blend_color.r);
    col = lerp(col, secondary_color, blend_color.g);
    col = lerp(col, third_color, blend_color.b);
    
    float sin_value = sin(_Time.y);
    sin_value = saturate(sin_value);
    col = lerp(_Color1, _Color2, sin_value);

    
                return col;
            }
            ENDCG
        }
    }
}
