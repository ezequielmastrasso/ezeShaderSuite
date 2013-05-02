
#include <../ezeInclude/ezeCommon.sl>

/******************************************************************************/
/*                                                                            */
/*    Copyright (c)The 3Delight Team.                                         */
/*    All Rights Reserved.                                                    */
/*                                                                            */
/******************************************************************************/

/*
	A light source for image based lighting.

	PARAMETERS
	light_color
              : a multiplier on the light from the envmap.
	Kenv      : intensity multiplier
	Kocc      : if >0, trace transmission rays to take into account occlusion
	            by other objects
	envmap    : the environment map to use
	envspace  : the coordinate system where to place the environment map
	samples   : number of samples to use to compute lighting. Setting samples
	            to 0 will use the SH-based indirectdiffuse approximation
	            without ray-tracing.
	bias      : ray-tracing bias.
*/
light ezeEnvironment(
        #pragma annotation "grouping" "multipliers/light_color;"
        #pragma annotation "grouping" "multipliers/saturation;"
        #pragma annotation "grouping" "multipliers/Kenv;"
        #pragma annotation "grouping" "multipliers/gamma;"

	color light_color = 1;
        float saturation=1;
        float Kenv=1;
        float gamma=1;

        #pragma annotation "grouping" "map/envmap;"
        #pragma annotation "grouping" "map/envspace;"
        #pragma annotation "grouping" "map/samples;"
        #pragma annotation "grouping" "map/maxdist;"
        #pragma annotation "grouping" "map/bias;"
        #pragma annotation "grouping" "map/coordsyst;"

	string envmap = "", envspace = "world";
	float samples = 256;
	float maxdist = 1e10;
	float bias = 0.02;
        string coordsyst = "world";

        #pragma annotation "grouping" "occlusion/Kocc;"
        #pragma annotation "grouping" "occlusion/filename;"
        #pragma annotation "grouping" "occlusion/AO_hitsides;"
        #pragma annotation "grouping" "occlusion/AO_maxdist;"
        #pragma annotation "grouping" "occlusion/AO_maxdist;"
        #pragma annotation "grouping" "occlusion/AO_int;"
        #pragma annotation "grouping" "occlusion/AO_coneangle;"
        #pragma annotation "grouping" "occlusion/AO_falloff;"
        #pragma annotation "grouping" "occlusion/AO_falloffmode;"
        #pragma annotation "grouping" "occlusion/AO_bias;"
        #pragma annotation "grouping" "occlusion/AO_clamp;"
        #pragma annotation "grouping" "occlusion/AO_maxsolidangle;"
        #pragma annotation "grouping" "category/__category;"

        float Kocc = 0.0;
        string filename = "<project>/3delight/<scene>/ptc/<scene>_geometry.#.ptc";
        string AO_hitsides = "front";
        float AO_maxdist = 40;
        float AO_int = 1;
        float AO_coneangle = 180;
        float AO_falloff = 1;
        float AO_falloffmode = 1;
        float AO_bias = 0;
        float AO_clamp = 1;
        float AO_maxsolidangle = 0.1;
        string __category = "envLight";

        #pragma annotation __nonspecular "hide=true;"
        #pragma annotation __nondiffuse "hide=true;"
        #pragma annotation __nonscatter "hide=true;"
        #pragma annotation __nonsubsurface "hide=true;"
        #pragma annotation __nontranslucence "hide=true;"

        uniform float  __nonspecular = 1;
        uniform float  __nondiffuse = 0;
        uniform float  __nonscatter = 1;
        uniform float  __nonsubsurface = 1;
        uniform float  __nontranslucence = 1;

	)
{
  //float Kenv=pow( 2,  exposure );
	uniform string raytype="";
	rayinfo( "type", raytype );
	uniform string gather_cat = concat("environment:", envmap);
	vector envdir = 0;
	color envcolor = 0;
	float solidangle = 0;
        normal shading_normal = faceforward( normalize(Ns), I );
        if( raytype != "subsurface" ){
          if( samples == 0 )
          {
                  /* Use the SH-based approximation. */
                  normal tN = ntransform( envspace, shading_normal );
                  illuminate( Ps + shading_normal ) /* shade all surface points */
                  {
                          Cl = Kenv * light_color / (4*PI);
                  }
          }
          else
          {
                  uniform float t1 = 0.025 * sqrt(samples);
                  uniform float t2 = 0.05 * sqrt(samples);

                  illuminate( Ps + shading_normal ) /* shade all surface points */
                  {
                          Cl = 0;

                          if( Kenv > 0 )
                          {
                                  vector raydir = 0;

                                  gather(
                                          gather_cat, 0, 0, 0, samples,
                                          "environment:color", envcolor,
                                          "ray:direction", raydir,
                                          "environment:direction", envdir,
                                          "environment:solidangle", solidangle )
                                  {
                                          raydir = vtransform( envspace, "current", raydir );
                                          envdir = vtransform( envspace, "current", envdir );

                                          float atten = max( shading_normal . normalize(envdir), 0 );

                                          float kocc = 1 - smoothstep( t1, t2, solidangle );
                                          kocc *= Kocc;

                                          uniform float diffusedepth = 0;
                                          attribute( "diffusedepth", diffusedepth );


                                          color trs = 1;

                                          Cl += envcolor * atten * light_color / (4*PI);
                                  }

                                  Cl *= Kenv;
                          }
                  }
          }
          color occ=1;
          if( Kocc > 0 ){
          occ=occlusion(
                                Ps, shading_normal, 0,
                                "pointbased", 1,
                                "filename", filename,
                                "coordsystem", coordsyst,
                                "coneangle", radians(AO_coneangle),
                                "hitsides", AO_hitsides,
                                "maxdist", AO_maxdist,
                                "falloff", AO_falloff,
                                "falloffmode", AO_falloffmode,
                                "bias", AO_bias,
                                "clamp", AO_clamp,
                                "maxsolidangle", AO_maxsolidangle);
                                occ=occ*Kocc;
                                occ=1-occ;
                                Cl=Cl*gamma(occ,gamma);}}
        //}
        color tmp=ctransform("rgb","hsv",Cl);
        tmp=tmp*(1, saturation, 1);
        tmp=ctransform("hsv","rgb",tmp);
        Cl=tmp;

}


