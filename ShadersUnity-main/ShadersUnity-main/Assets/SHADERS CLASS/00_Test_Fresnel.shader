Shader"ENTI/00_Test_Fresnel"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _Power ("Power", float) = 0

[Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor ("Src Factor", float) = 5
[Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor ("Dst Factor", float) = 10
[Enum(UnityEngine.Rendering.BlendOp)]
        _Opp ("Operation", float) = 0

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"  = "Transparent"}
Blend [_SrcFactor] [_DstFactor]
ZWrite [_Opp]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                half3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half3 normal : NORMAL;
                half3 viewDir : TEXCOORD0;
            };

            fixed4 _Color;
float _Power;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);        
                o.normal = normalize(UnityObjectToWorldNormal(v.normal));
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                //o.viewDir = normalize(mul((float3x3) unity_CameraToWorld, float3(0, 0, 1)));

    
    
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {              
                fixed4 col;
                //col.xyz = i.viewDir;
    
    
                float fresnel = saturate(dot(i.normal, i.viewDir));
    
    
                fresnel = 1 - fresnel;
                fresnel = pow(fresnel, _Power);
    
                col = _Color;
    col.w = fresnel;
    
                return col;
            }
            ENDCG
        }
    }
}
