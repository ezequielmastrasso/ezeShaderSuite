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
		float i_rootOpacity
		float i_tipOpacity
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
	
		float i_glint_strength
		float i_glint_softness
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

color exp(color c)
{
	return color( exp(c[0]), exp(c[1]), exp(c[2]) );
}

/* Simple table lookup */
float TableLookup(float i_value; float measured_data[]; )
{
	float len = arraylength(measured_data) - 1;
	float i = 1;

	while( i_value<measured_data[i] && i<len )
	{
		i += 1;
	}

	float min = measured_data[i];
	float max = measured_data[i-1];

	float index = i - (i_value - min)/(max - min);

	return index/len;
}

color TableLookup(color i_value; float measured_data[]; )
{
	return color(
			TableLookup(i_value[0], measured_data),
			TableLookup(i_value[1], measured_data),
			TableLookup(i_value[2], measured_data) );
}

void maya_3DelightHair(
		color i_color;
		float i_rootOpacity;
		float i_tipOpacity;
		float i_samples;

		/* FIXME: This should be the longitudinal roughness. */
		float i_roughness_r;
		float i_roughness_tt;
		float i_roughness_trt;

		/* FIXME: this is not physically correct. */
		float i_weight_r;
		float i_weight_tt;
		float i_weight_trt;

		/* FIXME: which one do we really need. */
		float i_position_r;
		float i_position_tt;
		float i_position_trt;

		float i_glint_strength;
		float i_glint_softness;

		output color o_outColor;
		output color o_outTransparency; )
{
	extern float t;
	extern point P;
	extern float __is_shadow_ray;

	float hair_denormalize = PI;

	/* This data is measured with "hair" bsdf with 0.02 roughness value and 6
	 * lobes in a scene with white background and 20 reflection bounces.
	 * The data is a total radiance with different absorption from 0 to 1.
	 * It is used to restore the absorption value from the color value. */
	uniform float measured_data[] = {
		0.93822449, 0.69060409, 0.53966850, 0.43725812, 0.36537388,
		0.31176218, 0.27037901, 0.23758890, 0.21107984, 0.18979986,
		0.17156327, 0.15614583, 0.14340289, 0.13201463, 0.12211259,
		0.11284425, 0.10523847, 0.09849557, 0.09265823, 0.08724733,
		0.08238390, 0.07783123, 0.07387303, 0.07027616, 0.06674250,
		0.06375086, 0.06100952, 0.05844032, 0.05611800, 0.05397604,
		0.05204895, 0.05021311, 0.04850997, 0.04690897, 0.04543516,
		0.04406185, 0.04282310, 0.04162235, 0.04049886, 0.03955755,
		0.03856574, 0.03763460, 0.03674654, 0.03592037, 0.03514257,
		0.03457187, 0.03387754, 0.03322192, 0.03257031, 0.03198473,
		0.03143068, 0.03092329, 0.03042635, 0.02995514, 0.02966469,
		0.02923608, 0.02882900, 0.02849156, 0.02812242, 0.02777117,
		0.02745434, 0.02713661, 0.02683389, 0.02658062, 0.02630393,
		0.02603995, 0.02587416, 0.02563178, 0.02540026, 0.02521742,
		0.02500628, 0.02480434, 0.02465775, 0.02447199, 0.02429428,
		0.02414984, 0.02398715, 0.02383125, 0.02368090, 0.02353819,
		0.02340132, 0.02335429, 0.02322742, 0.02310568, 0.02301483,
		0.02290259, 0.02279480, 0.02271814, 0.02261816, 0.02252205,
		0.02245865, 0.02236958, 0.02228389, 0.02224615, 0.02216683,
		0.02209048, 0.02204941, 0.02197817, 0.02190954, 0.02185178,
		0.02178815 };

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
	}

	/* Rescale input color to available values. Input color can't be more or
	 * less than a value in the table */
	float physical_color_max = measured_data[0];
	float physical_color_min = measured_data[arraylength(measured_data)-1];
#if 1
	physical_color =
		physical_color_min +
		physical_color * (physical_color_max - physical_color_min);
#else
	physical_color = clamp(physical_color, physical_color_min, physical_color_max);
#endif

	/* Restore the absorption from input color */
	color absorption =
#if 0
		// spline doesn't work
		spline("solvecatmull-rom", i_color, measured_data);
#else
		TableLookup(physical_color, measured_data);
#endif

	if( __is_shadow_ray != 0 )
	{
		/* Just return the transmission */
		o_outColor = 0;
		/* The .9 is a good approximation for the energy lost by the R bounces
		 * at each interaction */
		o_outTransparency = 1 - 0.9 * (1 - exp( - 4 * absorption ));
		return;
	}

	/*
		Glint

		Start by finding a random direction for the hair strand. Note this method
		is not correct as we rely (implicitely) on the viewer direction to get a
		fixed 3d frame.

		After finding the eccentricity direction 'ecc', we vary the ecentricity
		of the hair strand between 0.85 and 1. The lower value (high eccentricity)
		will produce more glint.

		The glint 'softness' is applied as the azimutal roughness to the TRT lobe.
	*/
	extern vector dPdu;
	extern vector dPdv;
	extern float u;

	float random_scalar = 0;
	getvar( null, "random_scalar", random_scalar );

    vector ecc = normalize(dPdu);
	ecc = rotate( ecc, random_scalar * 2 * PI, 0, point(dPdv) );

	float strength = 1 - i_glint_strength;
	strength = strength * 0.15 + 0.85;
    ecc *= strength;

	float softness = 1.0 - i_glint_softness;

	float lobeparams[] =
	{
		i_weight_r, -i_position_r, i_roughness_r, i_roughness_r,
		i_weight_tt, -i_position_tt, i_roughness_tt, i_roughness_tt,
		i_weight_trt, -i_position_trt, i_roughness_trt, softness*softness
	};

	extern vector I, dPdv;
	vector wo = normalize( -I );
	vector T = normalize( dPdv );

	varying color direct_lighting_lobes[3] = {0, ...};
	color visibility = 0;

	illuminance( P )
	{
		varying color b[3];
		b = bsdf(
			L, normal(T),
			"distribution", "hair",
			"wo", wo,
			"udir", ecc,
			"lobeparameters", lobeparams,
			"absorption", absorption );

		/* Denormalize light contribution */
		direct_lighting_lobes[0] += Cl * hair_denormalize * b[0];
		direct_lighting_lobes[1] += Cl * hair_denormalize * b[1];
		direct_lighting_lobes[2] += Cl * hair_denormalize * b[2];
	}

	uniform string envmap = "";
	uniform string envspace = "";
	getGiEnvironmentMapParameters( envmap, envspace );

	varying color hair_lobes[3];
	varying color ibl_components[3];
	varying color arealightcontribution[3];

	hair_lobes = trace(
		P, T,
		"distribution", "hair",
		"wo", wo,
		"absorption", absorption,
		"udir", ecc,
		"lobeparameters", lobeparams,
		"raytype", "hair",
		"samples", i_samples,
		"samplearealights", 1,
		"transmission", visibility,
		"arealightcontribution", arealightcontribution,
		"environmentmap", envmap,
		"environmentspace", envspace,
		"environmentcontribution", ibl_components );

	/* Denormalize area light contribution */
	hair_lobes[0] -= arealightcontribution[0];
	hair_lobes[1] -= arealightcontribution[1];
	hair_lobes[2] -= arealightcontribution[2];

	hair_lobes[0] += arealightcontribution[0] * hair_denormalize;
	hair_lobes[1] += arealightcontribution[1] * hair_denormalize;
	hair_lobes[2] += arealightcontribution[2] * hair_denormalize;

	/* Tint all outputs */
	color ibl = ibl_components[0] + ibl_components[1] + ibl_components[2];
	color direct_lighting =
		direct_lighting_lobes[0] +
		direct_lighting_lobes[1] +
		direct_lighting_lobes[2];
	color indirect_lighting =
		hair_lobes[0] + hair_lobes[1] + hair_lobes[2];

	o_outColor = direct_lighting + indirect_lighting;

#ifdef SHADER_TYPE_surface
	if( isoutput( "aov_specular" ) )
	{
		outputchannel( "aov_specular", direct_lighting );
	}

	if( isoutput( "aov_reflection" ) )
	{
		outputchannel( "aov_reflection", indirect_lighting );
	}

	if( isoutput( "aov_rt_reflection") )
	{
		outputchannel( "aov_rt_reflection", indirect_lighting - ibl );
	}

	if( isoutput( "aov_env_reflection") )
	{
		outputchannel( "aov_env_reflection", ibl );
	}

	if( isoutput( "aov_occlusion" ) )
	{
		color occ = 1 - visibility;
		outputchannel( "aov_occlusion", occ );
	}

	if( isoutput( "aov_hair_R" ) )
	{
		outputchannel(
				"aov_hair_R",
				hair_lobes[0] + direct_lighting_lobes[0]);
	}

	if( isoutput( "aov_hair_TT" ) )
	{
		outputchannel(
				"aov_hair_TT",
				hair_lobes[1] + direct_lighting_lobes[1] );
	}

	if( isoutput( "aov_hair_TRT") )
	{
		outputchannel(
				"aov_hair_TRT",
				hair_lobes[2] + direct_lighting_lobes[2] );
	}

	if( isoutput( "aov_motion_vector" ) )
	{
		outputchannel( "aov_motion_vector", motionVector() );
	}
#endif

	/* No transparency in this shader. It would be catastrophic in terms
	   of performance. */
	o_outTransparency = 0;
}

#endif /* __3delighthair_h */

