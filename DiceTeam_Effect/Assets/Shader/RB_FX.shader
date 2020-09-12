Shader "RealBright/RB_FX" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EmmitionRange ("Emission", Range(0,3)) = 1.0
	}

		SubShader {
		Tags {"RenderType"="Transparent" "Queue"="Transparent"}
		Cull off

		CGPROGRAM
		#pragma surface surf RealBright alpha:blend noshadow noambient
		#pragma target 3.0

		sampler2D _MainTex;

		float _EmmitionRange;

		struct Input {
		
			float2 uv_MainTex;				
		
		};

		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			o.Emission = c.rgb * _EmmitionRange;
			o.Alpha = saturate(c.a*_EmmitionRange);
		}
	
		float4 LightingRealBright ( SurfaceOutput RB , float3 lightDir , float atten ) {

			float4 FinalAlbedo = float4 (1,1,1,1);
				
					FinalAlbedo.rgb = RB.Emission;
					FinalAlbedo.a = RB.Alpha;

			return FinalAlbedo;

		}	
		
		
		ENDCG
	} 
	FallBack "Emission"
}
