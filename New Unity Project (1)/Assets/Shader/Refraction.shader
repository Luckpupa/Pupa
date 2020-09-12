Shader "Custom/Refraction"
{
    Properties  {        
        _MainTex ("Albedo (RGB)", 2D) = "white" {}        
	}
		SubShader
	{
		Tags { "RenderType" = "Transparent""Opaque" = "Transparent" }
		LOD 200

		GrabPass{}

		CGPROGRAM
		
		#pragma surface surf Lambert

		sampler2D _GrabTexture;
        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
			float4 screenPos;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex + _Time.x);
           // o.Albedo = c.rgb;
            // Metallic and smoothness come from slider variables
			float2 screenUV = IN.screenPos.rgb / IN.screenPos.a;
			screenUV = float2(screenUV.r, 1 - screenUV.g);
			o.Emission = tex2D(_GrabTexture, screenUV + c.r*0.1);
            o.Alpha = c.a;
        }
        ENDCG
    }
		FallBack "Regacy Shaders/Transparent/Diffuse"
}
