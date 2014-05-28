/*
	Copyright (c) 2006 soho vfx inc.
	Copyright (c) 2006 The 3Delight Team.
*/

#ifndef _shading_utils_h
#define _shading_utils_h

#include "utils.h"
#include "global_illumination.h"

#define NEW_BUMP

#define SQR(i) ( (i) * (i) )

#define GET_CL( CL ) { CL = Cl; if( unshadowed != 0 ) \
	lightsource("__3dfm_unshadowed_cl", CL); }

/*
	ShadingNormal

	A wrapper for faceforward which avoids faceforward for single-sided
	primitives or when using double-sided shading. This is to prevent artefacts
	around silhouette edges caused by the way "Sides 2" is usually shaded. Note
	that we don't explicitely check for double-sided shading as it also sets
	Sides to 1.
*/
normal ShadingNormal( normal i_N )
{
	extern vector I;
	normal Nf = i_N;

	uniform float sides = 2;
	attribute("Sides", sides);

	if( sides == 2 )
	{
		Nf = faceforward(Nf, I);
	}
	else
	{
		/* This mess is to flip the normals of polygon meshes with reversed
		   orientation. We only want it when 'N' is attached to the primitive. */
		uniform float geometricnormal = 1;
		attribute( "geometry:geometricnormal", geometricnormal );

		if( geometricnormal == 0 )
		{
			uniform string orientation;
			attribute( "Ri:Orientation", orientation );
			if( orientation == "outside" )
				Nf = -Nf;
		}
	}

	return Nf;
}

/*
	Maya's ambient function
*/
color getAmbient( normal i_N; )
{
	return ambient();
}

color getAmbientUnshadowed( normal i_N )
{
	extern point P;
	color amb = 0;

	illuminance( P )
	{
		if( L == 0 )
		{
			color unshadowed_cl = 0;
			lightsource("__3dfm_unshadowed_cl", unshadowed_cl);
			amb += unshadowed_cl;
		}
	}

	return amb;
}

/*
	Maya's diffuse function
*/
color getDiffuse(
	normal i_N;
	uniform float keyLightsOnly;
	uniform float unshadowed; )
{
	extern point P;
	color C = 0;

	illuminance( P, i_N, PI/2 )
	{
		float isKeyLight = 1;
		
		if( keyLightsOnly != 0 )
		{
			isKeyLight = 0;
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nondiffuse = 0;
			lightsource( "__nondiffuse", nondiffuse );
		
			if( nondiffuse < 1 )
			{
				varying color cur_cl;
				GET_CL(cur_cl);
				C += cur_cl * normalize(L).i_N * (1-nondiffuse);
			}
		}
	}

	if( keyLightsOnly == 0 && unshadowed == 0 )
	{
		float samples = 16;
		option( "user:_3dfm_arealight_samples", samples );

		color clight;
		trace(
			P, i_N,
			"type", "transmission",
			"hitsides", "reversed",
			"samplearealights", 1,
			"samples", samples,
			"arealightcontribution", clight,
			"bsdf", "cosine" );
		C += clight;
	}

	return C;
}

color getTranslucence(
	normal i_N;
	float i_translucence, i_translucenceDepth, i_translucenceFocus;)
{
	extern point P;
	extern vector I;

 	/*
 		A translucence focus of 1 leads to a division by zero and an effective
 		focus of 0. Clamping it like this yields about the same result as maya.
 	*/
 	float focus = min( i_translucenceFocus, 0.99999 );
 
	color C = 0;

	if( i_translucence > 0.0 )
	{
		illuminance( P )
		{
			float nondiffuse = 0;
			lightsource( "__nondiffuse", nondiffuse );

			if( nondiffuse < 1 )
			{
				float costheta = normalize(L).normalize(I);
 				float a = (1 + costheta) * 0.5;

 				float trs = pow( pow(a, focus), 1/(1-focus) );
 
  				C += Cl * trs * (1-nondiffuse);
			}
		}
	}

	return C * i_translucence;
}

color
getBlinn( 
		normal i_Nf;
		float i_eccentricity;
		float i_specularRollOff;
		uniform float i_keyLightsOnly;
		uniform float unshadowed;
		)
{
	float E;
	color C = 0;
	vector H, Ln, V, Nn;
	float NH, NH2, NHSQR, Dd, Gg, VN, VH, LN, Ff, tmp;
	extern point P;
	extern vector L, I;
	extern color Cl;

	if(i_eccentricity != 1)
		E = 1 / (SQR(i_eccentricity) - 1);
	else
		E = -1e5;

	V = normalize(-I);
	VN = V . i_Nf;

	illuminance( P, i_Nf, PI / 2)
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );

			if( nonspecular < 1 )
			{
				Ln = normalize(L);
				H = normalize(Ln + V);
				NH = i_Nf . H;
				NHSQR = SQR(NH);
				NH2 = NH * 2;
				Dd = (E + 1) / (NHSQR + E);
				Dd *= Dd;
				VH = V . H;
				LN = Ln . i_Nf;
				if(VN < LN)
				{
					if(VN * NH2 < VH)
						Gg = NH2 / VH;
					else
						Gg = 1 / VN;
				}
				else
				{
					if(LN * NH2 < VH)
						Gg = (LN * NH2) / (VH * VN);
					else
						Gg = 1 / VN;
				}
				/* poor man's Fresnel */
				tmp = pow((1 - VH), 3);
				Ff = tmp + (1 - tmp) * i_specularRollOff;

				varying color cur_cl;
				GET_CL(cur_cl);
				C += cur_cl * Dd * Gg * Ff * (1-nonspecular);
			}
		}
	}

	if( i_keyLightsOnly == 0 && unshadowed == 0 )
	{
		float samples = 16;
		option( "user:_3dfm_arealight_samples", samples );

		float eta = 0;
		if( i_specularRollOff < 0.99 )
		{
			float sr = max( 0.0001, i_specularRollOff );
			/* Similar attenuation for highlights seen head-on. */
			eta = -((sr+1+2*sqrt(sr))/(sr-1));
		}

		float e = 1 / pow( i_eccentricity, 2.75 /* guesswork */ );
		float denormalize = 2 * PI / (e + 2);
		/* Do I look like I know what I'm doing? Yes? Awesome! */
		denormalize *= 1.27;

		color clight;
		trace(
			P, i_Nf,
			"type", "transmission",
			"hitsides", "reversed",
			"samplearealights", 1,
			"samples", samples,
			"arealightcontribution", clight,
			"bsdf", "blinn",
			"wo", V,
			"eta", eta,
			"roughness", pow( e + 1, -2/7 ) );
		C += denormalize * clight;
	}

	return C;
}

color getAnisotropic(
		vector i_N, i_I, i_xdir;
		float i_fresnel, i_roughness, i_spreadx, i_spready;
		uniform float i_keyLightsOnly, unshadowed;)
{
	/* Stam's anisotropic BRDF */
	float stam_anisotropy( float u, v, w, rx, ry )
	{
		float w2 = w * w;
		float bt = 4 * PI * w2 * w2 * rx * ry;
		float ex = exp(- u * u / (4 * w2 * rx * rx)) * exp( - v * v / (4 * w2 * ry * ry));

		return ex / bt;
	}

	extern point P;
	vector ydir  = i_N ^ i_xdir;

	float costheta2 = i_I.i_N;

	/*float sintheta2 = sin(acos(costheta2));*/

	float rx = i_roughness / i_spreadx;
	float ry = i_roughness / i_spready;

	float exists, emitspec = 0;
	color ClnoShadow = 0;
	color spec = 0;

	illuminance( P, i_N, PI / 2 )
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );

			if( nonspecular<1 && i_N.L>0 )
			{
				vector Ln = normalize(L);

				float costheta1 = Ln.i_N;
				vector V = Ln + i_I;

				float v = V.i_xdir;
				float u = V.ydir;
				float w = V.i_N;

				float G = (1 + Ln.i_I);
				G = clamp( G * G / (costheta1*costheta2), 0, 1);

				float D = stam_anisotropy( u, v, w, rx, ry );

				float factor =  G * D;
				float HdotI = V.i_I / length(V);
				HdotI = 1.0 - HdotI;
				HdotI = HdotI * HdotI * HdotI;
				factor *= HdotI + (1.0 - HdotI);
				factor = clamp(factor, 0, 1) * i_fresnel;

				varying color cur_cl;
				GET_CL(cur_cl);
				spec += factor * cur_cl * (1-nonspecular);
			}
		}
	}
	return  spec/4;    
}

void
computeSurfaceTransparency(
	float i_matteOpacityMode;
	float i_matteOpacity;
	color i_transparency;
	output color o_outTransparency )
{
	if(i_matteOpacityMode == 0)
	{
		// This is the "Black Hole" Maya setting
		o_outTransparency = 0;
	}
	else if(i_matteOpacityMode == 1)
	{
		// This is the "Solid Matte" Maya setting
		o_outTransparency = i_matteOpacity;
	}
	else
	{
		// This is the "Opacity Gain" Maya setting (and the default value)
		o_outTransparency = (1 - i_transparency) * i_matteOpacity;
	}

	o_outTransparency = 1.0 - o_outTransparency;
}

void computeSurface(
	color i_surfaceColor;
	color i_transparency;
	float i_matteOpacityMode;
	float i_matteOpacity;
	output color o_outColor;
	output color o_outTransparency;
	)
{
	computeSurfaceTransparency(
		i_matteOpacityMode, i_matteOpacity, i_transparency, o_outTransparency );

	o_outColor = i_surfaceColor * (1 - o_outTransparency);
	o_outColor = clamp(o_outColor, 0, 1e30);
}

float raySpecularDepth()
{
	uniform float depth = 0;
	rayinfo( "speculardepth", depth );
	return depth;
}

color getReflection(
	normal i_N;
	vector i_I;
	color i_specularColor;
	float i_reflectivity;
	color i_reflectedColor;
	uniform float i_maxDistance;
	uniform float i_samples;
	uniform float i_blur;
	uniform float i_noiseAmp;
	uniform float i_noiseFreq;
	uniform float i_reflectionLimit )
{
	extern point P;
	extern uniform float __reflects;
	
#if defined(USE_AOV_aov_env_reflection) || \
    defined(USE_AOV_aov_rt_reflection) || \
    defined(USE_AOV_aov_rt_reflection_alpha) || \
    defined(USE_AOV_aov_reflection) || \
    defined(USE_AOV_aov_env_specular)
	extern color __transparency;
#endif

	color ray_coloration = i_specularColor * i_reflectivity;

	// Color from the "reflectedColor" attr meant for env maps.
	color env_color = i_reflectedColor;

	color reflected = env_color;

	if( ray_coloration != color(0) &&
	    raySpecularDepth() < i_reflectionLimit &&
	    __reflects != 0)
	{
		vector R = reflect( i_I, i_N );

		if( i_noiseAmp != 0 && i_noiseFreq != 0)
		{
			point Pobj = transform("object", P);
			R = mix( R, R * noise( Pobj * i_noiseFreq ), i_noiseAmp );
		}
		
		color trs;
		color rc = trace(
				P, R,
				"subset", "-_3dfm_not_visible_in_reflections",
				"maxdist", i_maxDistance,
				"samplecone", i_blur,
				"samples", i_samples,
				"transmission", trs,
				"weight", ray_coloration );

#ifdef USE_AOV_aov_rt_reflection
		extern color aov_rt_reflection;
		aov_rt_reflection += __transparency * rc * ray_coloration;
#endif
#ifdef USE_AOV_aov_rt_reflection_alpha
		extern float aov_rt_reflection_alpha;
		aov_rt_reflection_alpha += luminance(__transparency * (1 - trs));
#endif

		if( trs != 0 )
		{
			varying color gi_env_color = getGiEnvironmentSpecular(R, i_samples, i_blur);

#ifdef USE_AOV_aov_env_specular
			extern varying color aov_env_specular;
			if( isoutput( aov_env_specular ) )
			{
				aov_env_specular +=	__transparency * gi_env_color * trs * ray_coloration;
			}
#endif

			uniform float add_to_final_mix = getGiAddToFinalMix();
			if( add_to_final_mix > 0 )
			{
				reflected += gi_env_color;
			}

#if !defined(USE_DEPRECATED_SHADING) && defined(USE_AOV_aov_env_reflection)
			env_color += gi_env_color;
#endif
		}

#if !defined(USE_DEPRECATED_SHADING) && defined(USE_AOV_aov_env_reflection)
		env_color *= trs;
#endif
		reflected *= trs;
		reflected += rc;
	}

#ifdef USE_AOV_aov_env_reflection
	extern color aov_env_reflection;
	aov_env_reflection += __transparency * env_color * ray_coloration;
#endif

#ifdef USE_AOV_aov_reflection
	extern color aov_reflection;
	aov_reflection += __transparency * reflected * ray_coloration;
#endif

	return reflected * ray_coloration;
}

float doRefraction(
	normal i_N;
	vector i_I;
	uniform float i_refractions;
	float i_refractiveIndex;
	uniform float i_refractionLimit;
	float i_lightAbsorbance;
	float i_shadowAttenuation;
	output color io_transparency;
	output color o_refraction; )
{
	// Returns a non-zero value if there is a total internal reflection
	// (which should be computed elsewhere)
	//
	extern point P;
	uniform string rayType;
	uniform float isShadowMap;
	extern uniform float __refracts;

	float tir = 0;
	if( io_transparency != color(0) &&
	    __refracts != 0)
	{
		/*
		Check for shadows (either raytraced or shadow maps), in which case
		we compute a straight opacity instead of tracing refraction rays.
		*/
		if( (1 == rayinfo( "type", rayType ) && rayType == "transmission") ||
			(1 == attribute( "user:ShadowMapRendering", isShadowMap ) &&
			 isShadowMap != 0) )
		{
			o_refraction = 0;
			io_transparency *=
				mix( 1, abs( normalize(i_I) . i_N ), i_shadowAttenuation );
		}
		else if( i_refractions != 0 )
		{
			color refractionColor = 0;

			if( raySpecularDepth() < i_refractionLimit )
			{
				float eta;
				normal Nf = i_N;

				if( i_I . i_N < 0 )
				{
					eta = 1.0 / i_refractiveIndex;
					Nf = i_N;
				} 
				else 
				{
					eta = i_refractiveIndex;
					Nf = -i_N;
				}
				
				vector refract = refract(normalize(i_I), Nf, eta);

				if( length( refract ) <= EPSILON )
				{
					o_refraction = 0;
					tir = 1.0;
				}
				else
				{
					color trs = 0;
					vector dir = normalize(refract);
					
					refractionColor = trace(
							P, dir,
							"subset", "-_3dfm_not_visible_in_refractions", 
							"transmission", trs);
					
					uniform float add_to_final_mix = getGiAddToFinalMix();
					if( trs != 0 && add_to_final_mix > 0)
					{
						refractionColor += getGiEnvironmentSpecular(dir, 0, 0) * trs;
					}
				}
			}

			o_refraction = io_transparency * refractionColor;
			io_transparency = 0;
		}
		else
		{
			o_refraction = 0;
		}
	}
	else
	{
		o_refraction = 0;
	}
	
	return tir;
}

float computeShadowValue(normal i_N)
{
	float shadowValue = 0;
	varying float totalLightIntensity = 0;

	extern varying point P;
	illuminance(P)
	{
		/* Do this manually instead of specifying i_N, PI/2 to illuminance so
		   ambient lights are included. */
		if( L.i_N >= 0 )
		{
			float __3dfm_shadowing = 0;
			color __3dfm_unshadowed_cl = 0;

			lightsource("__3dfm_shadowing", __3dfm_shadowing);
			lightsource("__3dfm_unshadowed_cl", __3dfm_unshadowed_cl);
			float unshadowed_intensity = luminance(__3dfm_unshadowed_cl);

			shadowValue += __3dfm_shadowing * unshadowed_intensity;
			totalLightIntensity += unshadowed_intensity;
		}
	}

	shadowValue /= totalLightIntensity;
  return shadowValue;
}

void computeShadowPass(normal i_N)
{
#ifdef USE_AOV_aov_shadow
	extern float aov_shadow;
	aov_shadow = computeShadowValue(i_N);
#endif
}

color computeLuminanceDepth()
{
	uniform float near_far[2] = {0, 1e3};
	option( "Clipping", near_far );

	uniform float near = near_far[0];
	uniform float far = near_far[1];
	
	extern varying vector I;
	float depth = length(I) - near;
	
	far -= near;
	depth = (far - depth) / far;

	return color(depth, depth, depth);
}

color getPhong(
	normal i_N; vector i_V; float i_size; 
	uniform float i_keyLightsOnly, unshadowed)
{
	color C = 0;
	vector R = reflect( -normalize(i_V), normalize(i_N) );
	extern varying point P;
	
	illuminance( P, i_N, PI/2 )
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				vector Ln = normalize(L);
				
				varying color cur_cl;
				GET_CL(cur_cl);
				C += cur_cl * pow(max(0.0,R.Ln), i_size) * (1-nonspecular);
			}
		}
	}
	return C;
}

/* Implementation of specularstd function */
color getPhongS(
	normal i_N; vector i_V; float i_size; 
	uniform float i_keyLightsOnly, unshadowed)
{
	color C = 0;
	extern varying point P;
	
	illuminance( P, i_N, PI/2 )
	{
		vector H = normalize(normalize(L)+i_V);
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				vector Ln = normalize(L);
				
				varying color cur_cl;
				GET_CL(cur_cl);
				C += cur_cl * pow(max(0.0,i_N.H), i_size) * (1-nonspecular);
			}
		}
	}
	return C;
}

color getPhongE(vector i_R; float i_highlight_size, i_roughness;
	uniform float i_keyLightsOnly, unshadowed)
{
	extern point P;
	varying color C = 0;
	
	illuminance( "specular", P, i_R, i_highlight_size * PI/2 )
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				float cos_angle = normalize(L) . i_R;
				float angle = acos(cos_angle);

				float spec = pow( cos(angle / i_highlight_size), pow(i_roughness, -2) );

				varying color cur_cl;
				GET_CL(cur_cl);
				C += spec * cur_cl * (1-nonspecular);
			}
		}
	}
	return C;
}

color getGaussian(vector i_I; vector i_N; float i_roughness;
	uniform float i_keyLightsOnly, unshadowed)
{
	extern point P;
	color C = 0;
	
	illuminance( "specular", P )
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				vector Ln = normalize(L);
				vector Hn = normalize(-i_I + Ln);
				
				float spec = exp( -sq( acos(i_N.Hn) / i_roughness ) );
				
				varying color cur_cl;
				GET_CL(cur_cl);
				
				C += cur_cl * spec * (1-nonspecular);
			}
		}
	}
	return C;
}

color getGaussianG(vector i_I; vector i_N; float i_roughness;
	uniform float i_keyLightsOnly, unshadowed)
{
	extern point P;
	color C = 0;
	
	illuminance( "specular", P )
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				vector Ln = normalize(L);
				vector Hn = normalize(-i_I + Ln);
				
				float spec = exp( -sq( acos(i_N.Hn) / i_roughness ) );
				spec = smoothstep(0, 1/3, spec);
				
				varying color cur_cl;
				GET_CL(cur_cl);
				
				C += cur_cl * spec * (1-nonspecular);
			}
		}
	}
	return C;
}

color getCookTorr(vector i_V; vector i_N; float i_roughness; color i_ior;
	uniform float i_keyLightsOnly, unshadowed)
{
	extern point P;
	
	float etar = 1/i_ior[0];
	float etag = 1/i_ior[1];
	float etab = 1/i_ior[2];
	float Kt, Krr, Krg, Krb;
	fresnel(-i_V, i_N, etar, Krr, Kt);
	fresnel(-i_V, i_N, etag, Krg, Kt);
	fresnel(-i_V, i_N, etab, Krb, Kt);
	
	color F = color(Krr, Krg, Krb);
		
	color C = 0;
	
	illuminance( P, i_N, PI/2)
	{
		float isKeyLight = 1;
		
		if( i_keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );
		
			if( nonspecular < 1 )
			{
				vector Ln = normalize(L);
				vector Hn = normalize(i_V + Ln);
				float NH = i_N.Hn;
				float alpha = acos(NH);
				float NV = i_N.i_V;
				float NL = i_N.Ln;
				float HV = Hn.i_V;
				
				// Geometric attenuation term:
				float G1 = (2 * NH * NV) / HV;
				float G2 = (2 * NH * NL) / HV;         
				float G = min(1, min(G1, G2));
				
				// Beckmann distribution factor:
				float _D = tan(alpha) / i_roughness;
				float D = exp( - (_D*_D) ) / 
					(4.0 * i_roughness * i_roughness * pow(cos(alpha), 4.0));
				
				color spec = D*G*F/NV;
				
				varying color cur_cl;
				GET_CL(cur_cl);
				
				C += cur_cl * spec * (1-nonspecular);
			}
		}
	}
	
	return C;
}

void do_bump_map(
	float i_bumpValue;
	float i_bumpDepth;
	normal i_normalCamera;
	output normal o_outNormal )
{
	extern vector dPdu, dPdv;

	float depth = abs(i_bumpDepth);
	float offset = clamp(i_bumpValue * i_bumpDepth, -depth, depth);

#ifndef NEW_BUMP /* old bump implementation */
	/*
		These scale factors are a bit experimental. The constant is to roughly
		match maya's bump mapping. The part about dPdu/dPdv ensures that the
		bump's scale does not depend on the underlying parametrization of the
		patch (the use of Du and Dv below introduce that) and that it happens
		in object space. Note that maya's handling of object space appears to
		be slightly broken since an enlarged sphere will have the same bump as
		a sphere with its control points moved outwards by a scale, somehow.
	*/
	float uscale = 1.0 / (length(vtransform("object", dPdu)) * 6.0);
	float vscale = 1.0 / (length(vtransform("object", dPdv)) * 6.0);

	vector gu = vector(1, 0, Du(offset) * uscale);
	vector gv = vector(0, 1, Dv(offset) * vscale);
	normal n = normal(gu ^ gv);
	
	vector basisz = normalize(i_normalCamera);
	vector basisx = normalize((basisz ^ dPdu) ^ basisz);
	vector basisy = normalize((basisz ^ dPdv) ^ basisz);

	o_outNormal = normal(
		xcomp(n) * basisx + ycomp(n) * basisy + zcomp(n) * basisz);

	o_outNormal = normalize(o_outNormal);
#else

	extern point P;
	extern normal Ng;
	
	normal Nn = normalize(i_normalCamera);
	normal Ngn = normalize(Ng);
	normal Noffset = Nn - Ngn;
	
	float scale = 0.25;
	
	point Pp =
		transform("world", P) +
		normalize(ntransform("world", Ngn)) * offset * scale;
	Nn = -ntransform("world", "current", calculatenormal(Pp));
	Nn = normalize(Nn);
	o_outNormal = normalize(Nn + Noffset);

#endif
}

/* Macros to implement a special case for photons in the surface shaders. */

#define BEGIN_PHOTON_CASE( diffuseColor, specularColor, transparency ) \
	string rayType; \
	if( 1 == rayinfo( "type", rayType ) && rayType == "light" ) \
	{ \
		string shadingmodel; \
		if( 1 == attribute( "photon:shadingmodel", shadingmodel ) && \
		    shadingmodel == "matte" ) \
		{ \
			o_outColor = diffuseColor; \
		} \
		else \
		{ \
			o_outColor = specularColor; \
		} \
		o_outTransparency = transparency; \
	} \
	else \
	{ /* This encloses the shader body. */

/* Macros to implement a special case for photons in the surface shaders
   without o_outTransparency parameter */

#define BEGIN_PHOTON_CASE_OI( diffuseColor, specularColor, transparency ) \
	extern color Oi; \
	string rayType; \
	if( 1 == rayinfo( "type", rayType ) && rayType == "light" ) \
	{ \
		string shadingmodel; \
		if( 1 == attribute( "photon:shadingmodel", shadingmodel ) && \
		    shadingmodel == "matte" ) \
		{ \
			o_outColor = diffuseColor * (1.0 - transparency); \
		} \
		else \
		{ \
			o_outColor = specularColor; \
		} \
		Oi = 1.0 - transparency; \
	} \
	else \
	{ /* This encloses the shader body. */

#define END_PHOTON_CASE } /* This closes the brace above. */

// Compute the roughness corresponding to a given glossiness value.
float roughness(float gloss)
{
	return pow(2.0, 8.0 * gloss);
}

/*
 * Oren and Nayar's generalization of Lambert's reflection model.
 * The roughness parameter gives the standard deviation of angle
 * orientations of the presumed surface grooves.  When roughness=0,
 * the model is identical to Lambertian reflection.
 * Taken from Arman so credits go to Larry Gritz.
 */
color
LocIllumOrenNayar (
	normal N;
	vector V;
	float roughness;
	uniform float keyLightsOnly; 
	uniform float unshadowed;)
{
	/* Surface roughness coefficients for Oren/Nayar's formula */
	float sigma2 = roughness * roughness;
	float A = 1 - 0.5 * sigma2 / (sigma2 + 0.33);
	float B = 0.45 * sigma2 / (sigma2 + 0.09);
	/* Useful precomputed quantities */
	float  theta_r = acos (V . N);        /* Angle between V and N */
	vector V_perp_N = normalize(V-N*(V.N)); /* Part of V perpendicular to N */

	/* Accumulate incoming radiance from lights in C */
	color  C = 0;
	extern point P;
	illuminance (P, N, PI/2)
	{
		float isKeyLight = 1;
		
		if( keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			/* Must declare extern L & Cl because we're in a function */
			extern vector L;
			uniform float nondiff = 0;
			lightsource ("__nondiffuse", nondiff);
			if (nondiff == 0)
			{
				vector LN = normalize(L);
				float cos_theta_i = LN . N;
				float cos_phi_diff = V_perp_N . normalize(LN - N*cos_theta_i);
				float theta_i = acos (cos_theta_i);
				float alpha = max (theta_i, theta_r);
				float beta = min (theta_i, theta_r);
				varying color cur_cl;
				GET_CL(cur_cl);
				C += cur_cl * cos_theta_i * 
				(A + B * max(0,cos_phi_diff) * sin(alpha) * tan(beta));
			}
		}
	}
	return C;
}

// Compute sampling parameters.
float compute_sampling_angle( float glossiness; )
{
	if( glossiness >= 1.0 )
		return 0.0;
	else
    return (1.0 - pow(clamp(glossiness, 0.0, 1.0), 0.2)) * PI / 2.0;
}

color trace_reflection(
	vector In;
	normal Nf;
	vector V;
	float i_refl_gloss;
	float i_refl_gloss_samples;
	float i_use_max_dist;
	float i_max_dist;
	uniform float i_do_refl_falloff;
	varying color i_refl_falloff_color;
	varying color i_weight )
{
	extern point P;
	extern uniform float __reflects;
	
	if( __reflects == 0 )
	{
		return color(0);
	}

	// Compute the sampling parameters.
	float sample_angle = compute_sampling_angle( i_refl_gloss );
	float sample_count = (i_refl_gloss == 0) ?
		min(4, i_refl_gloss_samples) : i_refl_gloss_samples;

	// Compute reflected direction.
	vector refl_dir = reflect(In, Nf);

	uniform float max_dist = i_use_max_dist > EPSILON ? i_max_dist : 1e38;
	
	color trs = 0;
	float dist = 0;

	float fade = 1.0;
	if( i_use_max_dist != 0 )
	{
		fade = pow( ( clamp( 1 - dist / max_dist, 0, 1 ) ), 2 );
	}

	color reflection = trace( 
		P, refl_dir, dist, 
		"samplecone", sample_angle,
		"samples", sample_count, 
		"transmission", trs, 
		"subset", "-_3dfm_not_visible_in_reflections",
		"maxdist", max_dist,
		"weight", i_weight*fade );

	reflection *= fade;
	
	extern color __transparency;	
#ifdef USE_AOV_aov_rt_reflection
	extern varying color aov_rt_reflection;
	if( isoutput( aov_rt_reflection ) )
	{
		aov_rt_reflection += __transparency * reflection;
	}
#endif

#ifdef USE_AOV_aov_rt_reflection_alpha
	extern varying float aov_rt_reflection_alpha;
	if( isoutput( aov_rt_reflection_alpha ) )
	{
		aov_rt_reflection_alpha += CIEluminance( __transparency * (1-trs) );
	}
#endif

	if( trs != 0 )
	{
		color env_color = 0;
		
		if( i_do_refl_falloff != 0 )
		{
			env_color = i_refl_falloff_color;
		}
		else
		{
			env_color = getGiEnvironmentSpecular(refl_dir, sample_count, sample_angle);
		}

		if( i_use_max_dist != 0 )
		{
			env_color *= (1 - fade);
		}
		
		env_color *= trs;
#ifdef USE_AOV_aov_env_specular
		extern varying color aov_env_specular;
		if( isoutput( aov_env_specular ) )
		{
			aov_env_specular +=	__transparency * env_color;
		}
#endif
#ifdef USE_AOV_aov_env_reflection
		extern color aov_env_reflection;
		aov_env_reflection += __transparency * env_color;
#endif
		reflection += env_color;
	}
	
	return reflection;
}

color trace_refraction(
	normal Nn;
	vector In;
	normal Nf;
	vector V;
	float i_refr_ior;
	float i_refr_gloss;
	float i_refr_gloss_samples;
	output float o_total_internal_refl;
	varying color i_weight )
{
	extern point P;
	extern uniform float __refracts;
	
	if( __refracts == 0 )
	{
		o_total_internal_refl = 0;
		return color(0);
	}

	// Compute the sampling parameters.
	float sample_angle = compute_sampling_angle( i_refr_gloss );
	float sample_count = (i_refr_gloss == 0) ?
		min(4, i_refr_gloss_samples) : i_refr_gloss_samples;

	// Compute refracted direction.
	float eta = (In . Nn < 0.0) ? 1.0 / i_refr_ior : i_refr_ior;
	vector refr_dir = refract(In, Nf, eta);
	color refraction = 0;

	if( length( refr_dir ) <= EPSILON )
	{
		o_total_internal_refl = 1;
		refraction = 0;
	}
	else
	{
		color trs = 0;
		refraction = trace( 
			P, refr_dir, 
			"samplecone", sample_angle,
			"samples", sample_count,
			"subset", "-_3dfm_not_visible_in_refractions", 
			"transmission", trs,
			"weight", i_weight );

		if( trs != 0 )
		{
			color env_color = getGiEnvironmentSpecular(refr_dir, sample_count, sample_angle);
			refraction += env_color * trs;
		}

		o_total_internal_refl = 0;
	}

	return refraction;
}

/*
	Compute specular highlights.

	NOTES
	- We use the ward anisotropic model. But we sum 3 highlights with decreasing
	roughness and increasing contribution.
*/
color specular_highlight(
	vector In;
	normal Nf;
	vector V;
	float  refl_roughness_u, refl_roughness_v;
	uniform float keyLightsOnly; 
	uniform float unshadowed;)
{
	extern color Cl;
	extern vector dPdu, dPdv;
	extern point P;

	vector xdir = normalize( dPdu );
	vector ydir = normalize( dPdv );
	
	xdir = normalize(Nf^xdir^Nf);
 	ydir = normalize(Nf^ydir^Nf);

	color highlights = 0;

	/* We have three specular higlihgts of diminushing roughness but increasing
	   brightness */
	uniform float component_coefs[3] = {0.5, 1.0, 1.5}; 

	illuminance( P, Nf, PI * 0.5 )
	{
		float isKeyLight = 1;
		
		if( keyLightsOnly != 0 )
		{
			lightsource( "iskeylight", isKeyLight );
		}
		
		if( isKeyLight != 0 )
		{
			uniform float nonspecular = 0;
			lightsource( "__nonspecular", nonspecular );

			if( nonspecular == 0 )
			{
				vector Ln = normalize(L);

				float dot_ln = Ln . Nf;
				float dot_vn = V . Nf;

				if( dot_vn*dot_ln>0.0 )
				{
					vector Hn = normalize(V + Ln);
					float dot_hn2 = min(sq(Hn . Nf), 1.0);

					if( dot_hn2>0.0 )
					{
						/* precompute this to get it out of the loop below */
						float k1_devider = 1 / (sqrt(dot_vn * dot_ln) * 4.0 * PI);  
						float smooth_step_ln = smoothstep( 0, 0.25, dot_ln );

						uniform float i=0;
						uniform float roughness_coef = 1;

						for( i=0; i<3; i+=1.0 )
						{
							// Compute the highlight due to this light source.
							float k1 =
								(refl_roughness_u * refl_roughness_v * roughness_coef * roughness_coef )
								* k1_devider;
							float k2 =
								sq(Hn . xdir * refl_roughness_u * roughness_coef)
								+ sq(Hn . ydir * refl_roughness_v * roughness_coef);
							color c =
								k1 * exp(-k2 / dot_hn2)
								* dot_ln
								* smooth_step_ln;
							
							varying color cur_cl;
							GET_CL(cur_cl);
							// Accumulate highlights.
							highlights += cur_cl * c * component_coefs[i];

							roughness_coef *= 0.5;
						}
					}
				}
			}
		}
	}

	return highlights;
}

/*
	Compute motion vector.
*/
vector motionVector()
{
	extern point P;
	extern vector dPdtime;

	vector motion = dPdtime;

	point P0 = transform( "screen", P );
	point P1 = transform( "screen", P + motion );

	return P0 - P1;
}


#endif /* _shading_utils_h */

