Shader "HolyMonkey/Dissolve/Bumped" {

	Properties {
	    _MainColor ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Mask("Mask To Dissolve", 2D) = "white" {}
		_LineTexture("Line Texture", 2D) = "white" {}
		_Range ("Range", Range(0,3)) = 0
		_LineSize ("LineSize", Float) = 0.001
		_Color ("Line Color", Color) = (1,1,1,1)
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}
	
	SubShader {
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		LOD 300
		ZWrite On
		Cull Off
		CGPROGRAM 
		#pragma target 3.0
		#include "UnityCG.cginc"
		#pragma surface surf Lambert alphatest:_Cutoff
        

		sampler2D _MainTex;
		sampler2D _LineTexture;
		sampler2D _BumpMap;
		sampler2D _Mask;
		half4 _Color;
		half4 _MainColor;
		float _Range;
		float _LineSize;
		           
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
            float2 uv_Detail;
		};
            
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 m = tex2D (_Mask, IN.uv_MainTex);
		    half4 lc =  tex2D (_Mask, IN.uv_MainTex - _LineSize);
		    half4 lc2 = tex2D (_Mask, IN.uv_MainTex + _LineSize);
			half4 lc3 = tex2D(_LineTexture, IN.uv_MainTex + _SinTime) * _Color;    
			 
		    o.Albedo = c *  _MainColor;
		    o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
		    o.Alpha = 1;
		    
			float factor = m.rgb.x + m.rgb.y + m.rgb.z;
			if(factor >= _Range)
			{
			   float factor2 = lc.rgb.x + lc.rgb.y + lc.rgb.z;
			   float factor3 = lc2.rgb.x + lc2.rgb.y + lc2.rgb.z;
			   if(factor2 < _Range || factor3 < _Range)
			   {
			      o.Albedo = lc3;
			   }
			   else
			   {
                  o.Alpha = 0.0;
               }
            }
		}
		ENDCG
	} 
	Fallback "Diffuse"
}
