Shader"ENTI/00_Test_Fragment_Unlit"
{
    Properties
    {
        _Color1 ("Color 1", Color) = (1,1,1,1)
        _Color2 ("Color 2", Color) = (1,1,1,1)

        _Blend ("Blend ", Range(0,1)) = 1

        _MainTex ("Main Texture", 2D) = "white" {}
        _SecondTex ("Secondary Texture", 2D) = "white" {}

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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            sampler _MainTex;
            float4 _MainTex_ST;
            sampler _SecondTex;
            float4 _SecondTex_ST;
            fixed4 _Color1;
            fixed4 _Color2;
            float _Blend;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {              
                fixed4 col;
                //
                //col = _Color1 + _Color2 * _Blend;
    
                //
                //col = _Color1 * (1 - _Blend) + _Color2 * _Blend;
                col = lerp(_Color1, _Color2, _Blend);

                return col;
            }
            ENDCG
        }
    }
}
