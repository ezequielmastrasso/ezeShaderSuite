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
    #pragma annotation "grouping" "baked/bakeWorkflow;"
    #pragma annotation "grouping" "baked/bakeIndirectPass;"
#pragma annotation "grouping" "baked/bakeIndirectPassName;"
    float bakeWorkflow=1;
    string bakeIndirectPassName="bakeIndirectPass";

    #pragma annotation "grouping" "main/intensity;"
    #pragma annotation "grouping" "main/saturation;"
    #pragma annotation "grouping" "main/__category;"
    #pragma annotation "grouping" "main/envMap;"
    #pragma annotation "grouping" "main/envMapSpace;"
    float intensity= 1;
    float saturation=1;
    string envMapSpace= "world";

    #pragma annotation "grouping" "quality/samples;"
    #pragma annotation "grouping" "quality/coneAngle;"
    #pragma annotation "grouping" "quality/bias;"
    #pragma annotation "grouping" "quality/maxdist;"
    #pragma annotation "grouping" "quality/falloffmode;"
    #pragma annotation "grouping" "quality/falloff;"
    #pragma annotation "grouping" "quality/hitsides;"
    #pragma annotation "grouping" "quality/clamp;"
    #pragma annotation "grouping" "quality/sortbleeding;"
    #pragma annotation "grouping" "quality/aoMaxSolidAngle;"

    #pragma annotation "grouping" "quality/bakeIndirectPass;"
    #pragma annotation "grouping" "quality/bakeIndirectPass;"

    #pragma annotation "grouping" "ptc/sceneGeomPTC;"
    #pragma annotation "grouping" "ptc/SceneIndirectPTC;"
    #pragma annotation "grouping" "ptc/filterScale;"
#pragma annotation "grouping" "ptc/sceneGeomPTC_Space;"

    float samples=128;
    float coneAngle=.9;
    float bias = 0;
    float maxdist= 20;

    float falloffmode = 1;
    float falloff = 2;
    string hitsides = "front";
    float clamp = 1;
    float sortbleeding = 1;

    string sceneGeomPTC= "<project>/3delight/<scene>/ptc/<scene>_geometry.#.ptc"; string sceneGeomPTC_Space= "world";
    float aoMaxSolidAngle= .1;
    string SceneIndirectPTC= "<project>/3delight/<scene>/ptc/<scene>_geometryIndirect.#.ptc";
    float filterScale=1.777;

    #pragma annotation useIndirectSpots "gadgettype=checkbox;label=useIndirectSpots;"
    #pragma annotation "grouping" "indirectSpots_notImplementedYet/useIndirectSpots;"
    #pragma annotation "grouping" "indirectSpots_notImplementedYet/indirectSpotsCategory;"
    float useIndirectSpots=0;
    string indirectSpotsCategory="indirectSpots";
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

    point Pshad= Ps;
    normal Nshad = normalize(Ns);
    string passName = "";
    option ("user:delight_renderpass_name",passName);


    uniform string raytype = "unknown";
    rayinfo( "type", raytype );
    illuminate( Ps + Nshad )
    {
    if( raytype != "subsurface" ){
      if(passName == bakeIndirectPassName || bakeWorkflow==0)
          {
          //if useIndirectSpots
          //getLight wrapValue else diffuseWrap to 90`
          //ilumminante(){
          //    diffuse calls with Wrap!!!
          //}
          Cl= indirectdiffuse( Pshad, Nshad, samples, "samplebase", 64,"coneangle", coneAngle*PI/2, "coordsystem",
          sceneGeomPTC_Space, "filename", sceneGeomPTC, "pointbased", 1, "maxsolidangle", aoMaxSolidAngle,
              "clamp", clamp, "hitsides", hitsides, "falloffmode", falloffmode,
              "falloff", falloff, "environmentspace", envMapSpace, "sortbleeding", sortbleeding, "maxdist", maxdist,"bias", bias );

          bake3d(SceneIndirectPTC, "", Pshad, Nshad, "_radiosity", Cl, "interpolate", 1,
            "coordsystem", sceneGeomPTC_Space);
          Cl *= intensity;

          }
      else
          {
          color result=0;
          point Pshad= Ps;
          normal Nshad = normalize(Ns);
          texture3d( SceneIndirectPTC, Pshad, Nshad, "_radiosity", result,"coordsystem",  sceneGeomPTC_Space, "filterscale", filterScale);
          Cl = result*intensity;
          
          }
    }
    }
    color tmp=ctransform("rgb","hsv",Cl);
    tmp=tmp*(1, saturation, 1);
    tmp=ctransform("hsv","rgb",tmp);
    Cl=tmp;
    outputchannel( "aov_indirect", Cl );

}
