Shader "RealBright/RB_Rim_Custom" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Main_Intencity ("Main_Intencity" , Range(1,10)) = 1

		_Main_Tex_UVX_Offset ("x Offset Speed" , int) = 0.0
		_Main_Tex_UVY_Offset ("y Offset Speed" , int) = 0.0

		_BumpMap ("Normal" , 2D) = "bump" {}


		_Rim_Color ("Rim Color" , Color) = (0,0,0,0) 
		_Rim_Intencity ("Rim Intencity" , int) = 0.0
		_Rim_Tex ("Rim Texture", 2D) = "white" {}
		_Rim_Power ("Rim Range" , Range(0.1,5)) = 1
		_Rim_Speed ("Rim Speed" , int) = 0.0
		 
		_Tex_UVX_Offset ("x Offset Speed" , int) = 0.0
		_Tex_UVY_Offset ("y Offset Speed" , int) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue" = "Transparent"}

		CGPROGRAM
		#pragma surface surf RealBrightFX alpha:blend noshadow
		#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _BumpMap;
			sampler2D _Rim_Tex;

			fixed4 _Color;
			float _Main_Intencity;
			fixed4 _Rim_Color;
			float _Rim_Intencity;
			float _Rim_Power;
			float _Rim_Speed;


			float _Main_Tex_UVX_Offset;
			float _Main_Tex_UVY_Offset;
			float _Tex_UVX_Offset;
			float _Tex_UVY_Offset;


			struct Input {

				float2 uv_MainTex;
				float2 uv_BumpMap;
				float2 uv_Rim_Tex;

				float3 lightDir;
				float3 viewDir;

		};

		void surf (Input IN, inout SurfaceOutput o) {

			fixed4 c = tex2D (_MainTex, float2(IN.uv_MainTex.x + _Time.y*_Main_Tex_UVX_Offset,
											   IN.uv_MainTex.y+ _Time.y*_Main_Tex_UVY_Offset)) * _Color;

			fixed4 r = tex2D (_Rim_Tex, float2(IN.uv_Rim_Tex.x + _Time.y * _Tex_UVX_Offset,
											   IN.uv_Rim_Tex.y + _Time.y * _Tex_UVY_Offset));


			fixed3 n = UnpackNormal(tex2D (_BumpMap, IN.uv_BumpMap));

//			N . ViewVector 반전 을 통한 림 기본형 생성
			float Rim = 1 - dot(n, IN.viewDir);
			fixed4 RimColor;

//			Pow를 통해 범위조절 및 슬라이더 반전
			Rim = pow(Rim, 5-_Rim_Power);
			RimColor = Rim * _Rim_Color * (sin(_Time.y*_Rim_Speed)*0.5+0.5);


			o.Albedo = c.rgb * _Color * _Main_Intencity;
			o.Emission = RimColor * _Rim_Intencity;
			o.Normal = n;

			o.Alpha = Rim * _Color.a * r.rgba * (sin(_Time.y*_Rim_Speed)*0.5+0.5);

		}

		float4 LightingRealBrightFX ( SurfaceOutput RB , float3 lightDir , float atten) {

			fixed4 FinalAlbedo = float4(1,1,1,1);

					FinalAlbedo.rgb = RB.Albedo;
					FinalAlbedo.a = RB.Alpha;

				return FinalAlbedo;
		}

		ENDCG

	}

	FallBack "Emission"
}
