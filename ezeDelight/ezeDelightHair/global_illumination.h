/*
	Copyright (c) 2006 soho vfx inc.
	Copyright (c) 2006 The 3Delight Team.
*/

#ifndef _global_illumination_h
#define _global_illumination_h

#define NO_EFFECT 0
#define OCCLUSION 1
#define FAST_IBL 2
#define FULL_GI 3

float
getGiEffect()
{
	uniform float effect = 0;
	option( "user:_3dfm_gi_effect", effect );
	
	return effect;
}

float getGiAddToFinalMix()
{
	uniform float add_to_final_mix = 0;
	option( "user:_3dfm_gi_add_to_final_mix", add_to_final_mix );
	
	return add_to_final_mix;
}

#ifndef USE_DEPRECATED_SHADING

// Retrieves all global illumination effect variables

color
getGlobalIlluminationComponents(
	varying normal i_N;
	varying color i_gi_weight;
	output varying color o_visibility;
	output varying color o_env_diffuse;
	output varying color o_color_bleeding;)
{
	extern point P;
	shader gi_shader = getshader( "maya_gi_shader" );
	if( gi_shader != null )
	{
		uniform float effect = 0;
		getvar( gi_shader, "effect", effect );
		if( effect != 0 )
		{
			varying color gi = gi_shader->ComputeGI( P, i_N, i_gi_weight );
			getvar( gi_shader, "out_visibility", o_visibility );
			getvar( gi_shader, "out_environment_diffuse", o_env_diffuse );
			getvar( gi_shader, "out_color_bleeding", o_color_bleeding );
			return gi;
		}
	}

	o_visibility = 1;
	o_env_diffuse = 0;
	o_color_bleeding = 0;
	return color(0);
}

color
computeIndirectDiffuseAndGIAOVs(
	color i_diffuse_factor;
	color i_surface_color;
	color i_surface_transparency;
	normal i_N )
{
	color gi_weight = i_surface_color * i_diffuse_factor;

	color visibility;
	color env_diffuse;
	color color_bleeding;

	color gi = getGlobalIlluminationComponents(
		i_N, gi_weight,
		visibility, env_diffuse, color_bleeding );

#ifdef USE_AOV_aov_gi
	extern varying color aov_gi;
	extern color __transparency;
	aov_gi += __transparency * i_surface_color * i_diffuse_factor * gi;
#endif
#ifdef USE_AOV_aov_occlusion
	extern varying color aov_occlusion;
	extern color __transparency;
	aov_occlusion += __transparency *
		visibility * (1.0 - i_surface_transparency);
#endif
#ifdef USE_AOV_aov_env_diffuse
	extern varying color aov_env_diffuse;
	extern color __transparency;
	aov_env_diffuse += __transparency *
		i_surface_color * i_diffuse_factor * env_diffuse;
#endif
#ifdef USE_AOV_aov_indirect
	extern varying color aov_indirect;
	extern color __transparency;
	aov_indirect +=	__transparency *
		i_surface_color * i_diffuse_factor * color_bleeding;
#endif

	return i_diffuse_factor * gi;
}

#endif

#ifdef USE_DEPRECATED_SHADING

// Retrieves all global illumination effect variables
//
void
getGlobalIlluminationComponents(
	output varying color o_visibility;
	output varying color o_env_diffuse;
	output varying color o_color_bleeding;)
{
	o_visibility = 1;
	o_env_diffuse = 0;
	o_color_bleeding = 0;
	
	shader gi_light_shader = getlight( "maya_gi_light" );
	if( gi_light_shader != null )
	{
		uniform float effect = getGiEffect();
		
		// Visibility (which is 1 - occlusion)
		if( effect == 1 || effect == 3 || effect == 4 )
		{
			getvar( gi_light_shader, "__visibility", o_visibility );
		}
		
		// Environment diffuse
		if( effect >= 2 )
		{
			getvar( gi_light_shader, "__environment_diffuse", o_env_diffuse );
		}
		
		// Color bleeding
		if( effect >= 3 )
		{
			getvar( gi_light_shader, "__color_bleeding", o_color_bleeding );
		}
	}
}

// Outputs the variables related to the global illumination options.
// This function should be called only once per shader.
//
void
outputGlobalIlluminationAOVs(
	varying color i_transparency;
	varying color i_visibility;
	varying color i_env_diffuse;
	varying color i_color_bleeding;)
{
	uniform float outputOcclusion = 0;
	uniform float outputEnvDiffuse = 0;
	uniform float outputColorBleeding = 0;
	uniform float outputGi = 0;
	uniform float addToFinalMix = getGiAddToFinalMix();

#ifdef USE_AOV_aov_occlusion
	extern varying color aov_occlusion;
	outputOcclusion = isoutput(aov_occlusion);
#endif
#ifdef USE_AOV_aov_env_diffuse
	extern varying color aov_env_diffuse;
	outputEnvDiffuse = isoutput(aov_env_diffuse);
#endif
#ifdef USE_AOV_aov_indirect
	extern varying color aov_indirect;
	outputColorBleeding = isoutput(aov_indirect);
#endif
#ifdef USE_AOV_aov_gi
	extern varying color aov_gi;
	outputGi = isoutput(aov_gi);
#endif
	
	if ( outputOcclusion != 0 ||
		outputEnvDiffuse != 0 ||
		outputColorBleeding != 0 ||
		outputGi != 0)
	{
		extern color __transparency;

#ifdef USE_AOV_aov_occlusion
		if( outputOcclusion )
		{
			aov_occlusion += __transparency * i_visibility * (1.0 - i_transparency);
		}
#endif
#ifdef USE_AOV_aov_env_diffuse
		if( outputEnvDiffuse != 0 )
		{
			aov_env_diffuse += 
				__transparency * i_env_diffuse * (1.0 - i_transparency);
		}
#endif
#ifdef USE_AOV_aov_indirect
		if( outputColorBleeding != 0 )
		{
			aov_indirect += 
				__transparency * i_color_bleeding * (1.0 - i_transparency);
		}
#endif
#ifdef USE_AOV_aov_gi
		if( outputGi != 0 )
		{
			varying color gi_color;
      
			if( getGiEffect() > 3 )
				gi_color = i_env_diffuse + i_color_bleeding;
			else
				gi_color = i_env_diffuse * i_visibility + i_color_bleeding;
        
			aov_gi += __transparency * gi_color * (1.0 - i_transparency);
		}
#endif
	}
}

// Apply the render pass' global illumination diffuse effects on the
// received color & transparency, and output the global illumation AOVs.
// This function must be called only once per shader.
//
color 
getGlobalIllumination(
	varying color i_diffuse_color;
	varying color i_transparency; )
{
	// Get GI variables values
	color visibility;
	color env_diffuse;
	color color_bleeding;
	getGlobalIlluminationComponents(
		visibility,
		env_diffuse,
		color_bleeding );
		
	// Output the GI AOVs
	outputGlobalIlluminationAOVs( 
		i_transparency, 
		visibility, 
		env_diffuse, 
		color_bleeding );

	// Modify the received diffuse color so it includes the diffuse GI effects
	varying color out_color = i_diffuse_color;
	uniform float addToFinalMix = getGiAddToFinalMix();

	if( addToFinalMix != 0 )
	{
		if( getGiEffect() > 2 )
			out_color = i_diffuse_color + color_bleeding;
		else
			out_color = i_diffuse_color * visibility + color_bleeding;
	}

	return out_color;
}
#endif

float
getGiEnvironmentMapParameters(
	output uniform string envmap;
	output uniform string envspace;)
{
	envmap = "";
	envspace = "";
	
	uniform float envmap_found = 
		option( "user:_3dfm_gi_environment_map", envmap );
	option( "user:_3dfm_gi_environment_space", envspace );
	
	return envmap_found;
}

float
getGiEnvironmentParameters(
	output uniform string envmap;
	output uniform string envspace;
	output uniform float env_intensity;
	output uniform color env_color_gain;
	output uniform color env_color_offset;
	output uniform float env_specularity; )
{
	envmap = "";
	envspace = "";
	env_intensity = 1.0;
	env_color_gain = 1.0;
	env_color_offset = 0.0;
	env_specularity = 0;

	uniform float envmap_found = getGiEnvironmentMapParameters( envmap, envspace );

	if( envmap_found )
	{
		option( "user:_3dfm_gi_environment_intensity", env_intensity );
		option( "user:_3dfm_gi_environment_color_gain", env_color_gain );
		option( "user:_3dfm_gi_environment_color_offset", env_color_offset );
		option( "user:_3dfm_gi_environment_specularity", env_specularity );
	}
	
	return envmap_found;
}

// Computes the reflections caused by the IBL options of the
// Global Illumination options of the render pass.
//
color getGiEnvironmentSpecular(
	vector i_dir;
	float i_samples;
	float i_blur)
{
	color env_color = 0;
	
	uniform string envmap = "";
	uniform string envspace = "";
	uniform float env_intensity = 1.0;
	uniform color env_color_gain = 1.0;
	uniform color env_color_offset = 0.0;
	uniform float env_specularity = 0;
	uniform float envmap_found = getGiEnvironmentParameters( envmap, envspace, 
		env_intensity, env_color_gain, env_color_offset, env_specularity );

	if( envmap_found != 0 && env_specularity > 0 )
	{
		vector dir = i_dir;
		
		if( envspace != "" )
			dir = transform( envspace, i_dir );
		
		env_color = environment(
			envmap, dir, dir, dir, dir, 
			"samples", i_samples, "blur", i_blur);

		env_color = env_color * env_color_gain + env_color_offset;
		env_color *= env_intensity * env_specularity;
	}

	return env_color;
}


#endif
