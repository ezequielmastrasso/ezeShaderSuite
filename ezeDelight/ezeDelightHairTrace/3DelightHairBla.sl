/******************************************************************************/
/*                                                                            */
/*    Copyright (c)The 3Delight Developers. 2010-2014                         */
/*    All Rights Reserved.                                                    */
/*                                                                            */
/******************************************************************************/

/******************************************************************************
 * = LIBRARY
 *     3DFM
 * = AUTHOR(S)
 *     Victor Yudin
 * = VERSION
 *     $Revision$
 * = DATE RELEASED
 *     $Date$
 * = RCSID
 *     $Id$
 ******************************************************************************/

#ifndef __3delighthair_h
#define __3delighthair_h

/*
begin inputs
		color i_color
		float i_thickness
		float i_rootOpacity
		float i_tipOpacity
		color i_tint
		float i_samples

		float i_roughness_r
		float i_roughness_tt
		float i_roughness_trt

		float i_weight_r
		float i_weight_tt
		float i_weight_trt

		float i_position_r
		float i_position_tt
		float i_position_trt
end inputs

begin outputs
	color outColor
	color outTransparency
end outputs

begin shader_extra_parameters aov_occlusion
#ifdef USE_AOV_aov_occlusion
	output varying color aov_occlusion = 0;
#endif
end shader_extra_parameters

begin shader_extra_parameters aov_env_diffuse
#ifdef USE_AOV_aov_env_diffuse
	output varying color aov_env_diffuse = 0;
#endif
end shader_extra_parameters

begin shader_extra_parameters aov_indirect
#ifdef USE_AOV_aov_indirect
	output varying color aov_indirect = 0;
#endif
end shader_extra_parameters

begin shader_extra_parameters aov_gi
#ifdef USE_AOV_aov_gi
	output varying color aov_gi = 0;
#endif
end shader_extra_parameters
*/

#include <shading_utils.h>
#include <utils.h>

float desaturate(color c)
{
	return (c[0]+c[1]+c[2])/3;
}

color pow(color c; color x)
{
	return color( pow(c[0],x[0]), pow(c[1],x[1]), pow(c[2],x[2]) );
}


surface maya_3DelightHair(
		color i_color=1;
		float i_thickness=1;
		float i_rootOpacity=1;
		float i_tipOpacity=1;
		color i_tint=1;
		float i_samples=64;

		float i_roughness_r=1;
		float i_roughness_tt=1;
		float i_roughness_trt=1;

		float i_weight_r=1;
		float i_weight_tt=1;
		float i_weight_trt=1;

		float i_position_r=1;
		float i_position_tt=1;
		float i_position_trt=1;

		output color o_outColor=1;
		output color o_outTransparency=0; )
{
	extern float t;
	extern point P;
	float weight[3] = { i_weight_r, i_weight_tt, i_weight_trt };
	float position[3] = { i_position_r, i_position_tt, i_position_trt };
	float azimuthal_variance[3] = { 0, 0, 0 };

	/* Map color to absorption */
	color physical_color = i_color;
	/* Get the current color from Shave&Haircut */
	color shave_root_color = 1;
	color shave_tip_color = 1;
	color shave_color = 1;
	if( getvar( null, "rootcolor", shave_root_color ) != 0 &&
		getvar( null, "tipcolor", shave_tip_color ) != 0 )
	{
		shave_color = mix(shave_root_color, shave_tip_color, clamp(t, 0, 1));
		physical_color *= shave_color;
		physical_color = pow(physical_color, 0.175);
	}
	color absorption = i_thickness * (1-physical_color);
	absorption = max( absorption, 1e-6 );

	float varmult = 2-desaturate(physical_color);
	float variance[3] =
			{ i_roughness_r * varmult,
			  i_roughness_tt * varmult,
			  i_roughness_trt * varmult };

	extern vector I, dPdv;
	vector wo = normalize( -I );
	vector T = normalize( dPdv );

	color direct_lighting = 0;
	color visibility = 0;

    illuminance( P )
    {
         color b = bsdf(
            L, normal(T),
            "distribution", "hair",
            "wo", wo,
            "absorption", absorption,
            "lobesweight", weight,
            "lobesvariance", variance );

        direct_lighting += Cl * b;
    }

	uniform string envmap = "";
	uniform string envspace = "";
	getGiEnvironmentMapParameters( envmap, envspace );

	varying color hair_lobes[3];
	varying color ibl_components[3];

	hair_lobes = trace(
		P, T, 
		"distribution", "hair",
		"wo", wo,
		"absorption", absorption,
		"weight", i_tint,
		"raytype", "diffuse",
		"samples", i_samples,
		"lobesweight", weight,
		"lobesvariance", variance,
		"transmission", visibility,
		"environmentmap", envmap,
		"environmentspace", envspace,
		"environmentcontribution", ibl_components );

	/* Tint all outputs */
	hair_lobes[0] *= i_tint;
	hair_lobes[1] *= i_tint;
	hair_lobes[2] *= i_tint;
	direct_lighting *= i_tint;
	color ibl = i_tint * (ibl_components[0] + ibl_components[1] + ibl_components[2] );
	color indirect_lighting = hair_lobes[0] + hair_lobes[1] + hair_lobes[2];

#if 0
	o_outColor =
		i_tint *
		deon_hair(
			absorption,
			weight,
			variance,
			position,
			azimuthal_variance,
			i_samples );
	o_outColor += direct_lighting;
#endif

	Ci= direct_lighting + indirect_lighting;

#ifdef SHADER_TYPE_surface
	if( isoutput( "aov_gi" ) )
	{
		outputchannel( "aov_gi", i_tint * indirect_lighting );
	}

	if( isoutput( "aov_occlusion" ) )
	{
		color occ = 1 - visibility;
		outputchannel( "aov_occlusion", occ );
	}

	if( isoutput( "aov_env_diffuse" ) )
	{
		outputchannel( "aov_env_diffuse", ibl );
	}

	if( isoutput( "aov_indirect" ) )
	{
		color color_bleeding = indirect_lighting - ibl;
		outputchannel( "aov_indirect", color_bleeding );
	}

	if( isoutput( "aov_motion_vector" ) )
	{
		outputchannel( "aov_motion_vector", motionVector() );
	}

	if( isoutput( "aov_specular_prm" ) )
	{
		outputchannel( "aov_specular_prm", hair_lobes[0] );
	}

	if( isoutput( "aov_specular_trn" ) )
	{
		outputchannel( "aov_specular_trn", hair_lobes[1] );
	}

	if( isoutput( "aov_specular_sec") )
	{
		outputchannel( "aov_specular_sec", hair_lobes[2] );
	}
#endif

	/* No transparency in this shader. It would be catastrophic in terms
	   of performance. */
	o_outTransparency = 0;
}

#endif /* __3delighthair_h */

