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

#ifndef __ezehair_h
#define __ezehair_h

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
		float i_position_tr
t	
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
#include <global_illumination.h>
#include <fluid_utils.h>
#include <../ezeDelightCommon/ezeDelightCommon.sl>


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

surface ezeHair(
				//-----------------------------------------------------------------//
				//LINEAR
				//-----------------------------------------------------------------//
						#pragma annotation "grouping" "Linear/linear;"
						#pragma annotation "grouping" "Linear/gamma;"
						#pragma annotation linear "gadgettype=checkbox:0:1=custom value;"
				
				uniform float linear=1;
				uniform float gamma=0.454;
				color hair_id=1;
				
				
				//-----------------------------------------------------------------//
				//DIFFUSE
				//-----------------------------------------------------------------//
						#pragma annotation "grouping" "Diffuse/i_color;"
						#pragma annotation "grouping" "Diffuse/i_thickness;"
						#pragma annotation "grouping" "Diffuse/i_tint;"
						#pragma annotation "grouping" "Diffuse/i_samples;"
						
						#pragma annotation "grouping" "Diffuse/i_roughness_r;"
						#pragma annotation "grouping" "Diffuse/i_roughness_tt;"
						#pragma annotation "grouping" "Diffuse/i_roughness_trt;"
						
						#pragma annotation "grouping" "Diffuse/i_weight_r;"
						#pragma annotation "grouping" "Diffuse/i_weight_tt;"
						#pragma annotation "grouping" "Diffuse/i_weight_trt;"
										
						#pragma annotation "grouping" "Diffuse/i_position_r;"
						#pragma annotation "grouping" "Diffuse/i_position_tt;"
						#pragma annotation "grouping" "Diffuse/i_position_trt;"
						
						#pragma annotation "grouping" "Diffuse/Kd;"
						#pragma annotation "grouping" "Diffuse/Kid;"
						
						#pragma annotation "grouping" "Diffuse/tipDiffuseColor;"
						#pragma annotation "grouping" "Diffuse/tipDiffuseMapColor;"
						#pragma annotation "grouping" "Diffuse/rootDiffuseColor;"
						#pragma annotation "grouping" "Diffuse/rootDiffuseMapColor;"
						#pragma annotation "grouping" "Diffuse/tipPosition;"
						#pragma annotation "grouping" "Diffuse/rootPosition;"
				
				color i_color=1;
				float i_thickness=1;
				color i_tint=1;
				float i_samples=64;

				float i_roughness_r=0.02;
				float i_roughness_tt=0.02;
				float i_roughness_trt=0.02;

				float i_weight_r=1;
				float i_weight_tt=1;
				float i_weight_trt=1;

				float i_position_r=0.02;
				float i_position_tt=0.02;
				float i_position_trt=0.02;
				
				float i_glint_strength=1;
				float i_glint_softness=1;

				uniform float Kd=1;
				float Kid=1;
				
				
				color tipDiffuseColor=1;
				string tipDiffuseMapColor="";
				
				color rootDiffuseColor=1;
				string rootDiffuseMapColor="";
				
				uniform float tipPosition=1;
				uniform float rootPosition=0;
				
						#pragma annotation "grouping" "Diffuse/diffuseUseUdim;"
						#pragma annotation diffuseUseUdim "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Diffuse/Udim/rootDiffuseTexName;"
						#pragma annotation "grouping" "Diffuse/Udim/tipDiffuseTexName;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseFileExt;"
						#pragma annotation diffuseFileExt "gadgettype=optionmenu:tdl:tif:;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseMaxU;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseReverseT;"
						#pragma annotation diffuseReverseT "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseUseAnimMap;"
						#pragma annotation diffuseUseAnimMap "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseFrameNumber;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseUseVariant;"
						#pragma annotation diffuseUseVariant "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Diffuse/Udim/diffuseVarName;"
				
				float diffuseUseUdim=0;
				
				string rootDiffuseTexName = "";
				string tipDiffuseTexName = "";
				string diffuseFileExt = "tdl";
				float diffuseMaxU = 10;
				float diffuseReverseT = 0;
				float diffuseUseAnimMap = 0;
				float diffuseFrameNumber = 0;
				float diffuseUseVariant = 0;
				string diffuseVarName = "";
				
				
				//-----------------------------------------------------------------//
				//darkening
				//-----------------------------------------------------------------//
						#pragma annotation "grouping" "darkening/tip/tipDarkeningColor;"
						#pragma annotation "grouping" "darkening/tip/tipDarkeningStart;"
						#pragma annotation "grouping" "darkening/tip/tipDarkeningMapMask;"
						#pragma annotation tipDarkeningStart "gadgettype=floatslider;min=0;max=1;"
				
				
				color tipDarkeningColor=1;
				float tipDarkeningStart=0.8;
				string tipDarkeningMapMask="";
				
						#pragma annotation "grouping" "darkening/tip/tipDarkeningUseUdim;"
						#pragma annotation tipDarkeningUseUdim "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningTexName;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningTexName;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningFileExt;"
						#pragma annotation tipDarkeningFileExt "gadgettype=optionmenu:tdl:tif:;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningMaxU;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningReverseT;"
						#pragma annotation tipDarkeningReverseT "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningUseAnimMap;"
						#pragma annotation tipDarkeningUseAnimMap "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningFrameNumber;"
						#pragma annotation tipDarkeningFrameNumber "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningUseVariant;"
						#pragma annotation tipDarkeningUseVariant "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/tip/Udim/tipDarkeningVarName;"
				
				float tipDarkeningUseUdim=0;
				float tipDarkeningReverseT=0;
				string tipDarkeningTexName = "";
				string tipDarkeningFileExt = "tdl";
				float tipDarkeningMaxU = 10;
				
				float tipDarkeningUseAnimMap = 0;
				float tipDarkeningFrameNumber = 0;
				float tipDarkeningUseVariant = 0;
				string tipDarkeningVarName = "";
				
						#pragma annotation "grouping" "darkening/root/rootDarkeningColor;"
						#pragma annotation "grouping" "darkening/root/rootDarkeningEnd;"
						#pragma annotation "grouping" "darkening/root/rootDarkeningMapMask;"
						#pragma annotation rootDarkeningEnd "gadgettype=floatslider;min=0;max=1;"
				
				color rootDarkeningColor=1;
				float rootDarkeningEnd=.4;
				string rootDarkeningMapMask="";
				
						#pragma annotation "grouping" "darkening/root/rootDarkeningUseUdim;"
						#pragma annotation rootDarkeningUseUdim "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningTexName;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningTexName;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningFileExt;"
						#pragma annotation rootDarkeningFileExt "gadgettype=optionmenu:tdl:tif:;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningMaxU;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningReverseT;"
						#pragma annotation rootDarkeningReverseT "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningUseAnimMap;"
						#pragma annotation rootDarkeningUseAnimMap "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningFrameNumber;"
						#pragma annotation rootDarkeningFrameNumber "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningUseVariant;"
						#pragma annotation rootDarkeningUseVariant "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "darkening/root/Udim/rootDarkeningVarName;"
				
				float rootDarkeningUseUdim=0;
				float rootDarkeningReverseT=0;
				string rootDarkeningTexName = "";
				string rootDarkeningFileExt = "tdl";
				float rootDarkeningMaxU = 10;
				
				float rootDarkeningUseAnimMap = 0;
				float rootDarkeningFrameNumber = 0;
				float rootDarkeningUseVariant = 0;
				string rootDarkeningVarName = "";
				
				//-----------------------------------------------------------------
				//SPECULAR
				//-----------------------------------------------------------------
						#pragma annotation "grouping" "LegacySpecular/overall_specular;"
						#pragma annotation "grouping" "LegacySpecular/illum_wrap_angle;"
						#pragma annotation "grouping" "LegacySpecular/primary_specular;"
						#pragma annotation "grouping" "LegacySpecular/primary_roughness;"
						#pragma annotation "grouping" "LegacySpecular/primary_color;"
						#pragma annotation "grouping" "LegacySpecular/primary_shift;"
						#pragma annotation "grouping" "LegacySpecular/primary_shift_map;"
						#pragma annotation "grouping" "LegacySpecular/secondary_specular;"
						#pragma annotation "grouping" "LegacySpecular/secondary_roughness;"
						#pragma annotation "grouping" "LegacySpecular/secondary_color;"
						#pragma annotation "grouping" "LegacySpecular/secondary_shift;"
						#pragma annotation "grouping" "LegacySpecular/secondary_shift_map;"
						#pragma annotation "grouping" "LegacySpecular/bump_strength;"
						#pragma annotation "grouping" "LegacySpecular/bump_map;"
						#pragma annotation primary_roughness "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation primary_shift "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation secondary_roughness "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation secondary_shift "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation bump_strength "gadgettype=floatslider;min=0;max=1;"
				
				float illum_wrap_angle = 180;
				float overall_specular = 0;
				
				float primary_specular = 0.33;
				float primary_roughness = 0.008;
				color primary_color = 1;
				float primary_shift = 0.5;
				string primary_shift_map = "SET MAP HERE";
				
				float secondary_specular = 0.33;
				float secondary_roughness = 0.02;
				color secondary_color = 1;
				float secondary_shift = 0.5;
				string secondary_shift_map = "SET MAP HERE";
				
				float bump_strength = 0.0;
				string bump_map = "";
				
						#pragma annotation "grouping" "LegacySpecular/specularMapColor;"
						#pragma annotation "grouping" "LegacySpecular/specularGamma;"
						#pragma annotation "grouping" "LegacySpecular/specularUseUdim;"
						#pragma annotation specularUseUdim "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation useUdim "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularTexName;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularFileExt;"
						#pragma annotation specularFileExt "gadgettype=optionmenu:tdl:tif:;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularMaxU;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularReverseT;"
						#pragma annotation specularReverseT "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularUseAnimMap;"
						#pragma annotation specularUseAnimMap "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularFrameNumber;"
						#pragma annotation specularFrameNumber "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularUseVariant;"
						#pragma annotation specularUseVariant "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "LegacySpecular/Udim/specularVarName;"
				
				string specularMapColor="";
				uniform float specularGamma=0.454;
				float specularUseUdim=0;
				float specularReverseT=0;
				string specularTexName = "";
				string specularFileExt = "tdl";
				float specularMaxU = 10;
				
				float specularUseAnimMap = 0;
				float specularFrameNumber = 0;
				float specularUseVariant = 0;
				string specularVarName = "";
				
				
				
				//-----------------------------------------------------------------
				//ALPHA
				//-----------------------------------------------------------------
						#pragma annotation "grouping" "Alpha/overrrideAlpha;"
						#pragma annotation "grouping" "Alpha/tipAlphaColor;"
						#pragma annotation "grouping" "Alpha/rootAlphaColor;"
						#pragma annotation "grouping" "Alpha/blendAlpha;"
						#pragma annotation "grouping" "Alpha/sdistAlpha;"
						#pragma annotation overrrideAlpha "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation tipAlphaColor "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation rootAlphaColor "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation blendAlpha "gadgettype=floatslider;min=0;max=1;"
						#pragma annotation sdistAlpha "gadgettype=floatslider;min=0;max=1;"
				
				float overrrideAlpha=1;
				float tipAlphaColor=1;
				float rootAlphaColor=1;
				float blendAlpha=0.5;
				float sdistAlpha=0.7;
				
				
						#pragma annotation "grouping" "Alpha/maps/alpha;"
						#pragma annotation "grouping" "Alpha/maps/alphaGamma;"
						#pragma annotation alphaFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
						#pragma annotation "grouping" "Alpha/maps/alphaFilter;"
						#pragma annotation alphaUseUdim   "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Alpha/maps/alphaUseUdim;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaMaxU;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaReverseT;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaFrameNumber;"
						#pragma annotation alphaFrameNumber "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaTexName;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaUseVariant;"
						#pragma annotation alphaUseVariant "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaVarName;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaUseAnimMap;"
						#pragma annotation alphaUseAnimMap "gadgettype=checkbox:0:1=custom value;"
						#pragma annotation "grouping" "Alpha/maps/udim/alphaFileExt;"
						#pragma annotation alphaFileExt "gadgettype=optionmenu:tdl:tif:;"
				
				string alpha="";
				
				string alphaFilter="gaussian";
				uniform float alphaGamma=1;
				uniform float alphaUseUdim=0;
				float alphaReverseT=0;
				uniform float alphaMaxU=2;
				uniform float alphaFrameNumber=2;
				uniform string alphaTexName="";
				uniform float alphaUseVariant=2;
				uniform string alphaVarName="2k";
				uniform float alphaUseAnimMap=0;
				uniform string alphaFileExt="tdl";
				
				
				
						output varying color aov_hair_diffuse=0;
						output varying color aov_hair_ambient=0;
						output varying color aov_hair_surfaceColor=0;
						output varying color aov_hair_total_specular = 0;
						output varying color aov_hair_primary_specular = 0;
						output varying color aov_hair_secondary_specular = 0;
						output varying color aov_hair_specularMap = 0;
						output varying color aov_hair_v=0;
						output varying color aov_hair_id = 0;
						output varying color aov_indirect = 0;
						

				
)
{
	//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------DIFFUSE COLOR---------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
color rootDiffuse=1;
color middleDiffuse=1;
color tipDiffuse=1;


rootDiffuse=getTexture(rootDiffuseMapColor,
						"gaussian",
						diffuseUseUdim,
						diffuseReverseT,
						diffuseMaxU,
						diffuseFrameNumber,
						rootDiffuseTexName,
						diffuseUseVariant,
						diffuseVarName,
						diffuseUseAnimMap,
						diffuseFileExt);


tipDiffuse=getTexture(tipDiffuseMapColor,
						"gaussian",
						diffuseUseUdim,
						diffuseReverseT,
						diffuseMaxU,
						diffuseFrameNumber,
						tipDiffuseTexName,
						diffuseUseVariant,
						diffuseVarName,
						diffuseUseAnimMap,
						diffuseFileExt);


rootDiffuse=rootDiffuseColor*rootDiffuse;
tipDiffuse=tipDiffuseColor*tipDiffuse;

//v Range remapping
//TODO: replace by setRange
float vBiased=0;
vBiased=v-rootPosition;
vBiased=vBiased/(tipPosition-rootPosition);


//use or not middle color
aov_hair_surfaceColor=mix(rootDiffuse,tipDiffuse,vBiased);


//-------------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------DARKENING----------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
//----------------------------------------------------------TIPDARKENING


if (tipDarkeningColor!=1){
	color tipDarkeningMap=1;
	tipDarkeningMap=getTexture(tipDarkeningMapMask,
		  "gaussian",
		  tipDarkeningUseUdim,
		  tipDarkeningReverseT,
		  tipDarkeningMaxU,
		  tipDarkeningFrameNumber,
		  tipDarkeningTexName,
		  tipDarkeningUseVariant,
		  tipDarkeningVarName,
		  tipDarkeningUseAnimMap,
		  tipDarkeningFileExt);
	
	float tipDarkeningValue=1;
	tipDarkeningValue=setRange(v,tipDarkeningStart,1,1,0);
	color tipDarkening=mix(tipDarkeningColor,1,tipDarkeningValue);
	tipDarkening=clamp(tipDarkening,0,1);
	tipDarkening=mix(1,tipDarkening,tipDarkeningMap);
	aov_hair_surfaceColor=aov_hair_surfaceColor*tipDarkening;
}
//----------------------------------------------------------ROOTDARKENING
if (rootDarkeningColor!=1){
	color rootDarkeningMap=1;
	rootDarkeningMap=getTexture(rootDarkeningMapMask,
			"gaussian",
			rootDarkeningUseUdim,
			rootDarkeningReverseT,
			rootDarkeningMaxU,
			rootDarkeningFrameNumber,
			rootDarkeningTexName,
			rootDarkeningUseVariant,
			rootDarkeningVarName,
			rootDarkeningUseAnimMap,
			rootDarkeningFileExt);
	
	float rootDarkeningValue=1;
	rootDarkeningValue=setRange(v,rootDarkeningEnd,1,0,1);
	color rootDarkening=mix(rootDarkeningColor,1,rootDarkeningValue);
	rootDarkening=clamp(rootDarkening,0,1);
	rootDarkening=mix(1,rootDarkening,rootDarkeningMap);
	aov_hair_surfaceColor=aov_hair_surfaceColor*rootDarkening;
}

//-------------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------LINEAR-------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
if (linear==1){
	aov_hair_surfaceColor= gamma(aov_hair_surfaceColor,gamma);
	
}

color i_colorGamma=gamma(i_color,gamma);
color i_tintGamma=gamma(i_tint,gamma);

	extern float t;
	extern point P;
	uniform string __raytype = "";
	uniform float __is_shadow_ray = (__raytype == "transmission") ? 1:0;


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
		Ci = 0;
		/* The .9 is a good approximation for the energy lost by the R bounces
		 * at each interaction */
		Oi = 1 - 0.9 * (1 - exp( - 4 * absorption ));
		
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



//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------LEGACY SPECULAR STUFF-------------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//

normal Nn=normalize(N);
float  vt;
vector S = Nn^T; //Derive vector S using cross product between the normalized surface normal Nn and hair tangent T
vector N_hair = T^S; //Hair normal oriented away from the surface
float hair_normal_blend = clamp(Nn.T, 0, 1); //Hair normal blend factor

//Use suface normal when hair is perpendicular to the surface
//Use hair normal when hair is tangent to the surface
//Else blend between the two

vector hair_normal = normalize(mix(N_hair, Nn, hair_normal_blend));

//SCHEUERMANN STUFF
float primary_shift_total = 1;
float secondary_shift_total = 1;
vector T_primary_specular;
vector T_secondary_specular;
vector T_bump, bump_dir;
float bump_scale;
color bump_map_color = color(1);
float secondary_specular_bump;

color hair_diffuse = 0;
color hair_scatter = 0;
color hair_specular = 0;
color hair_primary_specular = 0;
color hair_secondary_specular = 0;
color hair_tertiary_specular = 0;
float cosang, res;

//SCATTER LOOP HAIR SHEEN STUFF
float cosine, sine;
color forward_scatter_color = 0;
color back_scatter_color = 0;
vector V = -normalize(I);    /* V is the view vector */


if(overall_specular != 0){
        if((primary_shift_map != "") && (primary_specular != 0)){
            primary_shift_total = texture(primary_shift_map, s, t, "width", 0.8);
            primary_shift_total *= primary_shift;
            T_primary_specular = shifttangent(T, hair_normal, primary_shift_total - 0.5);
        }
        if((secondary_shift_map != "") && (secondary_specular != 0)){
            secondary_shift_total = texture(secondary_shift_map, s, t, "width", 0.8);
            secondary_shift_total *= secondary_shift;
            T_secondary_specular = shifttangent(T, hair_normal, secondary_shift_total - 0.5);
            //SPECULAR BUMP STUFF
            if(bump_map != ""){
                bump_map_color = texture(bump_map, s, t, "width", 0.8);
            }
            secondary_specular_bump = max(comp(bump_map_color, 0), comp(bump_map_color, 1), comp(bump_map_color, 2));
            if(bump_strength != 0){
                bump_scale = length(vtransform("shader", T_secondary_specular));
                bump_dir = T_secondary_specular * (bump_strength * secondary_specular_bump/bump_scale);
                T_bump = mix(T_secondary_specular, normalize(calculatenormal(P + bump_dir)), bump_strength);
            }
            else{
                T_bump = T_secondary_specular;
            }
        }
    }



//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------SPECULAR COLOR--------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
aov_hair_specularMap=getTexture(specularMapColor,
        "gaussian",
        specularUseUdim,
        specularReverseT,
        specularMaxU,
        specularFrameNumber,
        specularTexName,
        specularUseVariant,
        specularVarName,
        specularUseAnimMap,
        specularFileExt);

if (linear==1){
    aov_hair_specularMap= gamma(aov_hair_specularMap,specularGamma);
}

illuminance ("-envLight",P, hair_normal, PI) {
	string category="";
	lightsource ( "__category", category );
	vector Ln = normalize(L);
	float atten;
	float dot = Ln.hair_normal;
	float minDot = cos(radians(90 + illum_wrap_angle));
	float clampedDot = clamp(dot, minDot , 1.0);
	atten = (clampedDot - minDot)/(1.0 - minDot);
	//--------------------------------------------------LIGHT ATTRS---------------------------------------------//
	float nondiffuse = 0;
	lightsource("__nondiffuse",nondiffuse);
	float nonspecular = 0;
	lightsource("__nonspecular",nonspecular);
	float nonscatter = 0;
	lightsource("__nonscatter",nonscatter);
	float nontranslucence = 0;
	lightsource( "__nontranslucence", nontranslucence );
	float nonsubsurface = 0;
	lightsource("__nonsubsurface",nonsubsurface);
	//---------------------------------------------------------SPECULAR-----------------------------------------//
	//TODO:add if to skip environment lights when diffuse
	//TODO:add enviroment light if, blend linearly between N_Srf and hairNormal?
	if(nonspecular < 1){
				if(overall_specular != 0){
					if(primary_specular != 0){
						hair_primary_specular += atten * primary_color * primary_specular * Cl * strandspecular(T_primary_specular, V, Ln, 1/primary_roughness) * v * (1-nonspecular);
					}
					if(secondary_specular != 0){
						hair_secondary_specular += atten * secondary_color * secondary_specular * Cl * strandspecular(T_bump, V, Ln, 1/secondary_roughness) * v * (1-nonspecular);
					}
					hair_specular += (hair_primary_specular + hair_secondary_specular);
				}
			}
}



//---------------------------------------------------------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------TRANSPARENCY---------------------------------------//
//---------------------------------------------------------------------------------------------------------------------------------------------//
color alphaMap=getTexture(alpha,
	"gaussian",
	alphaUseUdim,
	alphaReverseT,
	alphaMaxU,
	alphaFrameNumber,
	alphaTexName,
	alphaUseVariant,
	alphaVarName,
	alphaUseAnimMap,
	alphaFileExt);

alphaMap=gamma(alphaMap,alphaGamma);

	/* Dont use transparency in this shader. It would be catastrophic in terms
	   of performance. */
color alpha= 1;
if(overrrideAlpha==1){
	alpha = mix(rootAlphaColor, tipAlphaColor, smoothstep(sdistAlpha-blendAlpha, sdistAlpha+blendAlpha, v));
	Oi = alpha*alphaMap;
}
else{
	Oi = Os*alphaMap;
}


aov_hair_diffuse=direct_lighting*Kd;
aov_hair_surfaceColor=aov_hair_surfaceColor;
aov_hair_total_specular = hair_specular*overall_specular;
aov_hair_specularMap = 1;
aov_hair_v=v;
aov_hair_ambient = indirect_lighting*Kid;
aov_indirect = indirect_lighting*Kid;
aov_hair_id=hair_id;



Ci= (
		(
		(direct_lighting*Kd)+
		(indirect_lighting*Kid)
		)*
		aov_hair_surfaceColor
		)+
		(hair_specular*
		overall_specular);
Ci=Ci*Oi;


}








#endif /* __ezehair_h */

