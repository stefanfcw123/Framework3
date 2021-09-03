/*
	The process of bloom effect is follow:
	1. blur high level mip
	2. add image with blur image

	Paraments:
	_BlurDistance:  sample distance of Gaussian blur
	_BlurSampleLevel: mip level for blur image
	_BlurBlendFactor: bloom intensity

	Note: Bloom image must have mip feature
*/

Shader "UI/UIImageBloom" 
{
	Properties 
	{
		[PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
		_BlurDistance("Blur Distance", Range(0.001, 0.2)) = 0.01
		_BlurSampleLevel("Blur Sample Level", Range(0, 8)) = 0
		_BlurBlendFactor("Blur Level", Range(0, 2)) = 0
		_AdaptedLum("Adapted Lum", Range(0, 5)) = 1

		[HideInInspector] _StencilComp("Stencil Comparison", Float) = 8
		[HideInInspector] _Stencil("Stencil ID", Float) = 0
		[HideInInspector] _StencilOp("Stencil Operation", Float) = 0
		[HideInInspector] _StencilWriteMask("Stencil Write Mask", Float) = 255
		[HideInInspector] _StencilReadMask("Stencil Read Mask", Float) = 255

		[HideInInspector] _ColorMask("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "True"
		}

		Stencil 
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]

		Pass 
		{
			Name "UIImage_Static_Bloom_Blur"

			CGPROGRAM
	        #pragma vertex vert
	        #pragma fragment frag
	        #pragma target 2.0

	        #include "UnityCG.cginc"
	        #include "UnityUI.cginc"
            #include "Assets/QFramework/Framework/5.ShaderLib/CGInclude/UI.cginc"
            #include "Assets/QFramework/Framework/5.ShaderLib/CGInclude/GaussianBlur.cginc"

			uniform float _BlurDistance;
			uniform float _BlurSampleLevel;
			
            fixed4 ProcessColor(float2 uv,float4 inColor)
            {
                return  GaussianBlur(_MainTex,uv,inColor,_BlurDistance,_BlurSampleLevel);
            }
            
			ENDCG
		}
		
		GrabPass
		{
			"_BlurTexture"
		}

		Pass 
		{
			Name "UIImage_Static_Bloom_Add"

			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"
            #include "Assets/QFramework/Framework/5.ShaderLib/CGInclude/UIGrabPass.cginc"
            
			uniform sampler2D _BlurTexture;

			uniform float _BlurBlendFactor;
			uniform float _AdaptedLum;

			float4 ACESToneMapping(float4 color, float adapted_lum) 
			{
				const float A = 2.51f;
				const float B = 0.03f;
				const float C = 2.43f;
				const float D = 0.59f;
				const float E = 0.14f;

				color *= adapted_lum;
				return (color * (A * color + B)) / (color * (C * color + D) + E);
			}
            
            fixed4 ProcessColor(float2 uv,float4 inColor,float4 worldPosition,float4 grabPosition)
            {
                float4 colMain = tex2D(_MainTex, uv);
                float4 colBlend = tex2Dproj(_BlurTexture, grabPosition);
                float4 color = colMain + colBlend * _BlurBlendFactor;

                color = ACESToneMapping(color, _AdaptedLum);

                color.a *= UnityGet2DClipping(worldPosition.xy, _ClipRect);

                #ifdef UNITY_UI_ALPHACLIP
                clip(color.a - 0.001);
                #endif

                return color;
            }
			ENDCG
		}
	}
}
