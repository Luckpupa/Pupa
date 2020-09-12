Shader "RealBright/RB_Wet_Tile" {

	Properties{

		_Color("Color", Color) = (1,1,1,1)

		_MainTex("Albedo", 2D) = "white" {}
		_Albedo_x_Offset("Albedo x Offset", int ) = 0
		_Albedo_y_Offset("Albedo y Offset", int ) = 0


		_AlphaTex("Alpha Shape", 2D) = "white" {}

		_RGBATex("Metal/Smooth", 2D) = "white" {}

		_BumpMap("Detail Normal", 2D) = "bump" {}
		_Bump_x_Offset("Bump x Offset", int ) = 0
		_Bump_y_Offset("Bump y Offset", int ) = 0

		_MetallicRange("Metallic" , Range(0,1)) = 0.0
		_SmoothnessRange("Smoothness" , Range(0,1)) = 0.0
		_BumpRangeTex("Bump" , Range(0,1)) = 0.0

	}


		SubShader{

		Tags{ "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200
		Cull Off 

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:blend
		#pragma target 3.0

		fixed4 _Color;

		sampler2D _MainTex;
		sampler2D _RGBA_Tex;
		sampler2D _AlphaTex;
		sampler2D _BumpMap;

		float _MetallicRange;
		float _SmoothnessRange;
		float _BumpRangeTex;

		float _Albedo_x_Offset;
		float _Albedo_y_Offset;

		float _Bump_x_Offset;
		float _Bump_y_Offset;




	struct Input {
		float2 uv_MainTex;
		float2 uv_AlphaTex;

		float2 uv_RGBA_Tex;
		float2 uv_BumpMap;

		float4 color:COLOR;

	};


	void surf(Input IN, inout SurfaceOutputStandard o) {


		fixed4 c = tex2D(_MainTex, float2(IN.uv_MainTex.x + _Time.y * _Albedo_x_Offset,
										  IN.uv_MainTex.y + _Time.y * _Albedo_y_Offset));	

		fixed4 d = tex2D(_AlphaTex, IN.uv_AlphaTex);

		fixed3 n = UnpackNormal(tex2D(_BumpMap, float2(IN.uv_BumpMap.x + _Time.y * _Bump_x_Offset,
										  			   IN.uv_BumpMap.y + _Time.y * _Bump_y_Offset)));	

		fixed4 m = tex2D(_RGBA_Tex, IN.uv_RGBA_Tex);



		o.Albedo = _Color * c.rgb * d.rgb;

		//o.Metallic = m.r;
		o.Metallic = d.rgb * m.r * _MetallicRange;

		o.Smoothness = d.rgb * m.a * _SmoothnessRange;

		o.Normal = lerp(float3(0.5,0.5,1),n,d.rgb * _BumpRangeTex);

		o.Alpha = _Color.a * d.rgb;
	}
	ENDCG
	}
		FallBack "Diffuse"
}
