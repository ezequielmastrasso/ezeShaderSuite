#pragma annotation colorbleed "gadgettype=checkbox;label=Color Bleeding;hint=If you check this box, shader will compute globall illumination, otherwise result will be Occlusion.;"
#pragma annotation reuse "gadgettype=checkbox;label=Reuse;hint=Turn this option on to reuse previous results form the disk.;"
#pragma annotation intensity "gadgettype=floatslider;label=Intensity;hint=Use this value to control strength of Indirect light.;"
#pragma annotation blackpoint "gadgettype=colorslider;label=Black Point;hint=This applis to the occlusion. When rays will hit geometry they will get the black color and when there is a miss they will get the white color. For example, putting a sky color in white would approximate daylight lighting.;"
#pragma annotation whitepoint "gadgettype=colorslider;label=White Point;hint=This applis to the occlusion. When rays will hit geometry they will get the black color and when there is a miss they will get the white color. For example, putting a sky color in white would approximate daylight lighting.;"
#pragma annotation coneAngle "gadgettype=floatslider;min=0;max=1;label=Cone Angel;hint=Smaller values gives sharper results, value 1 gives the complete smooth result.;"
#pragma annotation maxdist "gadgettype=floatfield;label=Max Distance;hint=controls distance of the effect. Reducing this distance will have a positive impact on speed.;"
#pragma annotation envMap "gadgettype=inputfile;label=Environment File;hint=Use a .tdl environment map made from tdlmake. It will be used if ray doesn't hit a surface.;"
#pragma annotation falloffmode "gadgettype=intslider;min=0;max=1;label=Falloff Mode;hint=0 is exponential. 1 is polynomial."
#pragma annotation falloff "gadgettype=floatslider;min=0;max=10;label=Falloff Exponent;hint=Specifies the rate at which the falloff will take place. Higher exponents will lead to more contrasty effects.;"
#pragma annotation hitsides "gadgettype=optionmenu:front:back:both;label=Hitsides;hint=Specifies which side(s) of the point cloud’s samples will produce the effect.;"
#pragma annotation clamp "gadgettype=checkbox;label=Clamp;hint=If set to 1, attempts to reduce the excessive occlusion caused by the point-based algorithm, at the cost of speed.;"
#pragma annotation sortbleeding "gadgettype=checkbox;label=Sort Bleeding;hint=If set to 1 and clamp is also set to 1, this forces the color bleeding computations to take the ordering of surfaces into account. It is recommanded to set this parameter to 1.;"
#pragma annotation envMapSpace "gadgettype=textfield;label=Env Coordinate System;hint=The coordinate system used by the environment map.;"
#pragma annotation sceneGeomPTC_Space "gadgettype=textfield;label=PTC Coordinate System;hint=The coordinate system where the point cloud data was stored.;"
#pragma annotation sceneGeomPTC "gadgettype=inputfile;label=Scene Radiosity PTC;hint=Specifies the name of a point cloud file to be used to compute the occlusion and color bleeding.;"
#pragma annotation SceneIndirectPTC "gadgettype=inputfile;label=Scene Indirect PTC;hint=Input point cloud used for computing final result. You could choose a brickmap you created out of final point cloud file for reusing.;"
#pragma annotation aoMaxSolidAngle "gadgettype=floatslider;min=0;max=1;label=Max Solid Angle;hint=Larger values gives faster results, smaller values gives more accurate result.;"



light ezeIndirect(
    #pragma annotation bakeWorkflow "gadgettype=checkbox;label=bakeWorkflow;"
    #pragma annotation "grouping" "bakeWorkflow;"
    float bakeWorkflow=0;

    #pragma annotation "grouping" "intensity;"
    #pragma annotation "grouping" "saturation;"
    #pragma annotation "grouping" "__category;"
    #pragma annotation "grouping" "envMap;"
    #pragma annotation "grouping" "envMapSpace;"
    float intensity= 1;
    float saturation=1;
    string __category = "envLight";
    string envMapSpace= "world";

    #pragma annotation "grouping" "ptcBased/bakeIndirectPassName;"
    
    string bakeIndirectPassName="bakeIndirectPass";
    

    #pragma annotation "grouping" "samples;"
    #pragma annotation "grouping" "samplebase;"
    #pragma annotation "grouping" "coneAngle;"
    #pragma annotation "grouping" "bias;"
    #pragma annotation "grouping" "maxdist;"
    #pragma annotation "grouping" "falloffmode;"
    #pragma annotation "grouping" "falloff;"
    #pragma annotation "grouping" "hitsides;"

    #pragma annotation "grouping" "ptcBased/clamp;"
    #pragma annotation "grouping" "ptcBased/sortbleeding;"
    #pragma annotation "grouping" "ptcBased/aoMaxSolidAngle;"


    #pragma annotation "grouping" "ptcBased/sceneGeomPTC;"
    #pragma annotation "grouping" "ptcBased/SceneIndirectPTC;"
    #pragma annotation "grouping" "ptcBased/filterScale;"
    #pragma annotation "grouping" "ptcBased/sceneGeomPTC_Space;"

    float samples=128;
    float samplebase=32;
    float coneAngle=.9;
    float bias = 0;
    float maxdist= 20;
    float maxError=.1;

    float falloffmode = 1;
    float falloff = 2;
    string hitsides = "front";
    float clamp = 1;
    float sortbleeding = 1;
    float useOcclusion=1;

    string sceneGeomPTC= "<project>/3delight/<scene>/ptc/<scene>_geometry.#.ptc"; string sceneGeomPTC_Space= "world";
    float aoMaxSolidAngle= .1;
    string SceneIndirectPTC= "<project>/3delight/<scene>/ptc/<scene>_geometryIndirect.#.ptc";
    float filterScale=1.777;

    #pragma annotation useIndirectSpots "gadgettype=checkbox;label=useIndirectSpots;"
    #pragma annotation "grouping" "indirectSpots_notImplementedYet/useIndirectSpots;"
    #pragma annotation "grouping" "indirectSpots_notImplementedYet/indirectSpotsCategory;"

    float useIndirectSpots=0;
    string indirectSpotsCategory="indirectSpots";
    

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

    point Pshad= Ps;
    normal Nshad = normalize(Ns);
    string passName = "";
    option ("user:delight_renderpass_name",passName);
    color bla=1;
    

    uniform string raytype = "unknown";
    rayinfo( "type", raytype );
    illuminate( Ps + Nshad )
    {
        //if bakeWorkflow and in bakeIndirect Pass
        //  raytrace and bake to file
        //else if akeWorkflow==1 and passname not bakeIndirectPassName
        //  ptc raytrace
        //else
        //  full raytrace
        if( raytype != "subsurface" ){
            if (bakeWorkflow==1 && passName == bakeIndirectPassName){
                Cl= indirectdiffuse( Pshad, Nshad, samples, "samplebase", 64,"coneangle", coneAngle*PI/2, "coordsystem",
                    sceneGeomPTC_Space, "filename", sceneGeomPTC, "pointbased", 1, "maxsolidangle", aoMaxSolidAngle,
                    "clamp", clamp, "hitsides", hitsides, "falloffmode", falloffmode,
                    "falloff", falloff, "environmentspace", envMapSpace, "sortbleeding", sortbleeding, "maxdist", maxdist,"bias", bias );
                bake3d(SceneIndirectPTC, "", Pshad, Nshad, "_radiosity", Cl, "interpolate", 1,
                    "coordsystem", sceneGeomPTC_Space);
                Cl *= intensity;
            }
            else if(bakeWorkflow==1 && passName != bakeIndirectPassName){
                color result=0;
                point Pshad= Ps;
                normal Nshad = normalize(Ns);
                texture3d( SceneIndirectPTC, Pshad, Nshad, "_radiosity", result,
                    "coordsystem",  sceneGeomPTC_Space, "filterscale", filterScale);
                Cl = result*intensity;
            }
            else{
                float occlusion=0;
                Cl= indirectdiffuse( Pshad, Nshad, samples, "samplebase", samplebase,"coneangle", coneAngle*PI/2,  
                    "falloffmode", falloffmode, "occlusion", occlusion,
                    "falloff", falloff, "maxdist", maxdist,"bias", bias );
                if (useOcclusion==1){
                    Cl=Cl*(1-occlusion);  
                }

                Cl *= intensity;
            }
          

        }

    }
    //saturation multiply

    Cl=ctransform( "hsv",
                    "rgb",
                    ctransform("rgb", "hsv",Cl)       *(1, saturation, 1)
                );
    outputchannel( "aov_indirect", Cl );

}
