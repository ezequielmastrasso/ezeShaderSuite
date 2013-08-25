#include <../ezeDelightCommon/ezeDelightCommon.sl>




surface ezeHair(
                      //-----------------------------------------------------------------//
                      //LINEAR
                      //-----------------------------------------------------------------//
                        #pragma annotation "grouping" "Linear/linear;"
                        #pragma annotation "grouping" "Linear/gamma;"
                        #pragma annotation linear "gadgettype=checkbox:0:1=custom value;"

                        uniform float linear=1;
                        uniform float gamma=0.454;

                      //-----------------------------------------------------------------//
                      //DIFFUSE
                      //-----------------------------------------------------------------//
                        #pragma annotation "grouping" "Diffuse/Kd;"
                        #pragma annotation "grouping" "Diffuse/Kid;"
                        #pragma annotation "grouping" "Diffuse/illum_wrap_angle;"
                        #pragma annotation "grouping" "Diffuse/tipDiffuseColor;"
                        #pragma annotation "grouping" "Diffuse/tipDiffuseMapColor;"
                        #pragma annotation "grouping" "Diffuse/rootDiffuseColor;"
                        #pragma annotation "grouping" "Diffuse/rootDiffuseMapColor;"
                        #pragma annotation "grouping" "Diffuse/tipPosition;"
                        #pragma annotation "grouping" "Diffuse/rootPosition;"
                        #pragma annotation illum_wrap_angle "gadgettype=floatslider;min=0;max=180;"

                        uniform float Kd=1;
                        float Kid=1;
                        float illum_wrap_angle = 180;

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
                      //AMBIENT
                      //-----------------------------------------------------------------//

                        #pragma annotation "grouping" "Ambient/ambientOccludeEnvLights;"
                        #pragma annotation ambientOccludeEnvLights "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/ambientGamma;"
                        #pragma annotation "grouping" "Ambient/tipAmbientBrightColor;"
                        #pragma annotation "grouping" "Ambient/tipAmbientDarkColor;"
                        #pragma annotation "grouping" "Ambient/tipAmbientMapColor;"
                        #pragma annotation "grouping" "Ambient/tipAmbientUseUdim;"
                        #pragma annotation tipAmbientUseUdim "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientexName;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientTexName;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientFileExt;"
                        #pragma annotation tipAmbientFileExt "gadgettype=optionmenu:tdl:tif:;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientMaxU;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientReverseT;"
                        #pragma annotation tipAmbientReverseT "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientUseAnimMap;"
                        #pragma annotation tipAmbientUseAnimMap "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientFrameNumber;"
                        #pragma annotation tipAmbientFrameNumber "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientUseVariant;"
                        #pragma annotation tipAmbientUseVariant "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/tipUdim/tipAmbientVarName;"
                        #pragma annotation "grouping" "Ambient/rootAmbientBrightColor;"
                        #pragma annotation "grouping" "Ambient/rootAmbientDarkColor;"
                        #pragma annotation "grouping" "Ambient/rootAmbientMapColor;"
                        #pragma annotation "grouping" "Ambient/rootAmbientUseUdim;"
                        #pragma annotation rootAmbientUseUdim "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientexName;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientTexName;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientFileExt;"
                        #pragma annotation rootAmbientFileExt "gadgettype=optionmenu:tdl:tif:;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientMaxU;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientReverseT;"
                        #pragma annotation rootAmbientReverseT "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientUseAnimMap;"
                        #pragma annotation tipAmbientUseAnimMap "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientFrameNumber;"
                        #pragma annotation rootAmbientFrameNumber "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientUseVariant;"
                        #pragma annotation rootAmbientUseVariant "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Ambient/rootUdim/rootAmbientVarName;"

                        float ambientOccludeEnvLights=0;
                        color tipAmbientBrightColor=0;
                        color tipAmbientDarkColor=0;
                        string tipAmbientMapColor="";

                        float tipAmbientUseUdim=0;
                        float tipReverseT=0;
                        string tipAmbientTexName = "";
                        string tipAmbientFileExt = "tdl";
                        float tipAmbientMaxU = 10;
                        float tipAmbientReverseT = 0;
                        float tipAmbientUseAnimMap = 0;
                        float tipAmbientFrameNumber = 0;
                        float tipAmbientUseVariant = 0;
                        string tipAmbientVarName = "";

                        color rootAmbientBrightColor=0;
                        color rootAmbientDarkColor=0;
                        string rootAmbientMapColor="";

                        float rootAmbientUseUdim=0;
                        float rootReverseT=0;
                        string rootAmbientTexName = "";
                        string rootAmbientFileExt = "tdl";
                        float rootAmbientMaxU = 10;
                        float rootAmbientReverseT = 0;
                        float rootAmbientUseAnimMap = 0;
                        float rootAmbientFrameNumber = 0;
                        float rootAmbientUseVariant = 0;
                        string rootAmbientVarName = "";
                        uniform float ambientGamma=0.454;

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
                    //SCATTER
                    //-----------------------------------------------------------------
                        #pragma annotation "grouping" "Scatter/forward_scatter_mult;"
                        #pragma annotation "grouping" "Scatter/scatter_roughness;"
                        #pragma annotation "grouping" "Scatter/back_scatter_mult;"
                        #pragma annotation "grouping" "Scatter/sheen_width;"
                        #pragma annotation "grouping" "Scatter/scatter_color;"
                        #pragma annotation scatter_roughness "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation sheen_width "gadgettype=floatslider;min=0;max=1;"

                        float forward_scatter_mult = 0.2;
                        float scatter_roughness = 0.3;
                        float back_scatter_mult = 0.3;
                        float sheen_width = 0.5;
                        color scatter_color = 1;

                     //-----------------------------------------------------------------
                     //SPECULAR
                     //-----------------------------------------------------------------
                        #pragma annotation "grouping" "Specular/overall_specular;"
                        #pragma annotation "grouping" "Specular/primary_specular;"
                        #pragma annotation "grouping" "Specular/primary_roughness;"
                        #pragma annotation "grouping" "Specular/primary_color;"
                        #pragma annotation "grouping" "Specular/primary_shift;"
                        #pragma annotation "grouping" "Specular/primary_shift_map;"
                        #pragma annotation "grouping" "Specular/secondary_specular;"
                        #pragma annotation "grouping" "Specular/secondary_roughness;"
                        #pragma annotation "grouping" "Specular/secondary_color;"
                        #pragma annotation "grouping" "Specular/secondary_shift;"
                        #pragma annotation "grouping" "Specular/secondary_shift_map;"
                        #pragma annotation "grouping" "Specular/bump_strength;"
                        #pragma annotation "grouping" "Specular/bump_map;"
                        #pragma annotation primary_roughness "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation primary_shift "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation secondary_roughness "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation secondary_shift "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation bump_strength "gadgettype=floatslider;min=0;max=1;"

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

                      #pragma annotation "grouping" "Specular/specularMapColor;"
                      #pragma annotation "grouping" "Specular/specularGamma;"
                      #pragma annotation "grouping" "Specular/specularUseUdim;"
                      #pragma annotation specularUseUdim "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation useUdim "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation "grouping" "Specular/Udim/specularTexName;"
                      #pragma annotation "grouping" "Specular/Udim/specularFileExt;"
                      #pragma annotation specularFileExt "gadgettype=optionmenu:tdl:tif:;"
                      #pragma annotation "grouping" "Specular/Udim/specularMaxU;"
                      #pragma annotation "grouping" "Specular/Udim/specularReverseT;"
                      #pragma annotation specularReverseT "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation "grouping" "Specular/Udim/specularUseAnimMap;"
                      #pragma annotation specularUseAnimMap "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation "grouping" "Specular/Udim/specularFrameNumber;"
                      #pragma annotation specularFrameNumber "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation "grouping" "Specular/Udim/specularUseVariant;"
                      #pragma annotation specularUseVariant "gadgettype=checkbox:0:1=custom value;"
                      #pragma annotation "grouping" "Specular/Udim/specularVarName;"

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

                        float overrrideAlpha=0;
                        float tipAlphaColor=0;
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

                      //-----------------------------------------------------------------
                      /*TRANSLUCENCE*/
                      //-----------------------------------------------------------------
                        #pragma annotation "grouping" "Translucence/TRANSLUCENCE;"
                        #pragma annotation TRANSLUCENCE "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "Translucence/transl_Focus;"
                        #pragma annotation "grouping" "Translucence/i_translucence;"
                        #pragma annotation "grouping" "Translucence/trsl_gamma;"
                        #pragma annotation transl_Focus "gadgettype=floatslider;min=0;max=1;"
                        #pragma annotation bump_strength "gadgettype=floatslider;min=0;max=1;"

                        float TRANSLUCENCE = 0;
                        float transl_Focus = 0.5;
                        float i_translucence = 1;
                        float trsl_gamma = 1.8;

                      //SSS
                        #pragma annotation "grouping" "subsurface/doSSS;"
                        #pragma annotation "grouping" "subsurface/maps/sss;"
                        #pragma annotation sssFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
                        #pragma annotation "grouping" "subsurface/maps/sssFilter;"
                        #pragma annotation sssUseUdim   "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "subsurface/maps/sssUseUdim;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssMaxU;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssFramenumber;"
                        #pragma annotation sssFramenumber "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssTexName;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssUsevariant;"
                        #pragma annotation sssUsevariant "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssVarName;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssUseAnimMap;"
                        #pragma annotation sssUseAnimMap "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation "grouping" "subsurface/maps/udim/sssFileExt;"
                        #pragma annotation sssFileExt "gadgettype=optionmenu:tdl:tif:;"


                        #pragma annotation "grouping" "subsurface/sss_groupname;"
                        #pragma annotation "grouping" "subsurface/dmfp;"
                        #pragma annotation "grouping" "subsurface/albedo;"
                        #pragma annotation "grouping" "subsurface/sss_ior;"
                        #pragma annotation "grouping" "subsurface/sss_scale;"
                        #pragma annotation "grouping" "subsurface/sss_multiplier;"
                        #pragma annotation "grouping" "subsurface/sss_coordsystem;"
                        #pragma annotation "grouping" "subsurface/sss_smooth;"
                        #pragma annotation "grouping" "subsurface/sss_add_lum;"
                        #pragma annotation "grouping" "subsurface/sss_gamma;"
                        #pragma annotation doSSS "gadgettype=checkbox:0:1=custom value;"
                        #pragma annotation sss_ior "gadgettype=floatslider;min=0.5;max=2;"
                        #pragma annotation sss_multiplier "gadgettype=floatslider;min=0;max=10;"
                        #pragma annotation sss_smooth "gadgettype=floatslider;min=0;max=5;"
                        #pragma annotation sss_gamma "gadgettype=floatslider;min=0;max=2.2;"
                        #pragma annotation "grouping" "subsurface/sss_smooth;"

                        float doSSS = 0;

                        string sss="";
                        uniform string sss_groupname = "";

                        color dmfp = color(8.51, 5.57, 3.95);
                        color albedo = color(0.830,0.791, 0.753);

                        float sss_ior = 1.5;
                        float sss_scale = 1.0;
                        float sss_multiplier = 1.0;

                        uniform string sss_coordsystem = "world";
                        uniform float sss_smooth = .5;

                        float sss_add_lum = 0;
                        float sss_gamma = 1.8;

                      string sssFilter="gaussian";
                      uniform float sssUseUdim=0;
                      float sssReverseT=0;
                      uniform float sssMaxU=2;
                      uniform float sssFramenumber=2;
                      uniform string sssTexName="";
                      uniform float sssUsevariant=2;
                      uniform string sssVarName="2k";
                      uniform float sssUseAnimMap=0;
                      uniform string sssFileExt="tdl";




                      #pragma annotation "grouping" "AOVs/exportToStdAOV;"
                      #pragma annotation exportToStdAOV "gadgettype=checkbox:0:1=custom value;"

                      float exportToStdAOV=1;

                      #pragma annotation aov_hair_diffuse "hide=true;"
                      #pragma annotation aov_hair_total_scatter "hide=true;"
                      #pragma annotation aov_hair_front_scatter "hide=true;"
                      #pragma annotation aov_hair_back_scatter "hide=true;"
                      #pragma annotation aov_hair_ambient "hide=true;"
                      #pragma annotation aov_hair_translucence "hide=true;"
                      #pragma annotation aov_hair_surfaceColor "hide=true;"
                      #pragma annotation aov_hair_total_specular "hide=true;"
                      #pragma annotation aov_hair_primary_specular "hide=true;"
                      #pragma annotation aov_hair_secondary_specular "hide=true;"
                      #pragma annotation aov_hair_specularMap "hide=true;"
                      #pragma annotation aov_hair_subsurface "hide=true;"
                      #pragma annotation aov_hair_v "hide=true;"
                      #pragma annotation aov_indirect "hide=true;"
                      #pragma annotation N_Srf "hide=true;"

                      output varying color aov_hair_diffuse=0;
                      output varying color aov_hair_total_scatter = 0;
                      output varying color aov_hair_front_scatter = 0;
                      output varying color aov_hair_back_scatter = 0;
                      output varying color aov_hair_ambient=0;
                      output varying color aov_hair_translucence=0;
                      output varying color aov_hair_surfaceColor=0;
                      output varying color aov_hair_total_specular = 0;
                      output varying color aov_hair_primary_specular = 0;
                      output varying color aov_hair_secondary_specular = 0;
                      output varying color aov_hair_specularMap = 0;
                      output varying color aov_hair_subsurface = 0;
                      output varying color aov_hair_v=0;
                      output varying color aov_indirect = 0;

                      #pragma annotation aov_specular "hide=true;"
                      #pragma annotation aov_diffuse "hide=true;"
                      #pragma annotation aov_ambient "hide=true;"
                      #pragma annotation aov_surfaceColor "hide=true;"
                      #pragma annotation aov_subsurface "hide=true;"

                      output varying color aov_specular=0;
                      output varying color aov_diffuse=0;
                      output varying color aov_ambient=0;
                      output varying color aov_surfaceColor=0;
                      output varying color aov_subsurface = 0;

                      uniform normal N_Srf = normal(0, 1, 0);



                  )
{

normal Nn=normalize(N_Srf);
//TODO:FIXME
//overide the hair surface normal with shave N_Srf for env light purposes
//and use the hair_normal for when the proper hair normal is needed


normal Ns = pxslUtilShadingNormal(Nn);
vector Tangent = normalize(dPdv);
vector Arbitrary = vector(1, 1, 1);
float  TdotA = Arbitrary . Tangent;
vector Major = normalize(Arbitrary - TdotA * Tangent);
vector Minor = Tangent ^ Major;
vector V = -normalize(I);    /* V is the view vector */
vector T = normalize (dPdv); /* tangent along length of hair */
vector nL;
float T_Dot_nL = 0;
float T_Dot_e = 0;
float Alpha = 0;
float Beta = 0;

uniform string raytype = "unknown";
rayinfo( "type", raytype );
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
//------------------------------------------------------------------------------------------AMBIENT------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
//AMBIENT TIP
//if texture present, use the ambient tip bright and dark to remap the texture
//else just use the bright color
color rootAmbient=0,tipAmbient=0;

if( tipAmbientMapColor != "" || tipAmbientUseUdim==1 ){
    color tipAmbientMap;
    tipAmbientMap=getTexture(tipAmbientMapColor,
            "gaussian",
            tipAmbientUseUdim,
            tipAmbientReverseT,
            tipAmbientMaxU,
            tipAmbientFrameNumber,
            tipAmbientTexName,
            tipAmbientUseVariant,
            tipAmbientVarName,
            tipAmbientUseAnimMap,
            tipAmbientFileExt);
    tipAmbientMap=gamma(tipAmbientMap,ambientGamma);
    tipAmbient=mix( tipAmbientDarkColor,
                    tipAmbientBrightColor,
                    tipAmbientMap);
  }
else{
    tipAmbient=gamma(tipAmbientBrightColor,gamma);
}

//AMBIENT ROOT
if( rootAmbientMapColor != "" || rootAmbientUseUdim==1){
    color rootAmbientMap;
    rootAmbientMap=getTexture(rootAmbientMapColor,
                "gaussian",
                rootAmbientUseUdim,
                rootAmbientReverseT,
                rootAmbientMaxU,
                rootAmbientFrameNumber,
                rootAmbientTexName,
                rootAmbientUseVariant,
                rootAmbientVarName,
                rootAmbientUseAnimMap,
                rootAmbientFileExt);
    rootAmbientMap=gamma(rootAmbientMap,ambientGamma);
    rootAmbient=mix(rootAmbientDarkColor,
                    rootAmbientBrightColor,
                    rootAmbientMap);
  }
else{
    rootAmbient=gamma(rootAmbientBrightColor,gamma);
}



aov_hair_ambient=mix(rootAmbient,tipAmbient,v);

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
    aov_hair_ambient= gamma(aov_hair_ambient,gamma);
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

color alpha= 1;
if(overrrideAlpha==1){
    alpha = mix(rootAlphaColor, tipAlphaColor, smoothstep(sdistAlpha-blendAlpha, sdistAlpha+blendAlpha, v));
    Oi = alpha*alphaMap;
}
else{
    Oi = Os*alphaMap;
}


//DIFFUSE LOOP
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

//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------SPECULAR STUFF--------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
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










float focus = min( transl_Focus, 0.99999 );
color Ctranslucence = 0;
aov_hair_translucence=0;


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
        //--------------------------------------------------DIFFUSE AND MARSCHNER-----------------------------------//
        if(nondiffuse < 1 && category!="envLight"){
          //DIFFUSE LOOP
          hair_diffuse += Cl * atten * (1 - nondiffuse) ;
          //if rayType subsurface, check if
          if( (raytype == "subsurface") ){
              if(nonsubsurface < 1 && category!="envLight")
                aov_hair_diffuse = hair_diffuse*(1-nonsubsurface);
          }
          else{
                aov_hair_diffuse = hair_diffuse;
          }
        }
        else{
            aov_hair_diffuse=0;
        }
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
        //----------------------------------------------------------SCATTER-----------------------------------------//
        if(nondiffuse < 1){
                    // Retroreflective lobe
                    cosine = max(Ln.V, 0);
                    if(scatter_roughness != 0){
                        forward_scatter_color += atten * pow(cosine, 1.0/scatter_roughness) * Cl * forward_scatter_mult  * (1 - nonscatter);
                    }
                    // Horizon scattering
                    cosine = max(hair_normal.V, 0);
                    sine = sqrt(1.0 - (cosine * cosine));
                    if(sheen_width != 0){
                        back_scatter_color += atten * (pow(sine, 1.0/sheen_width) * Ln.hair_normal) * Cl * back_scatter_mult * (1 - nonscatter);
                    }
                    hair_scatter +=  (forward_scatter_color + back_scatter_color);
        }
        //----------------------------------------------------------TRANSLUCENCE------------------------------------//
        if( nontranslucence < 1){
            if (TRANSLUCENCE>0){
              float costheta = normalize(L).normalize(I);
              float a = (1 + costheta) * 0.5;
              float trs = pow( pow(a, focus), 1/(1-focus) );
              Ctranslucence += Cl * trs * i_translucence*(1-nontranslucence);
              aov_hair_translucence = color(
                                              pow ( Ctranslucence[0], 1/trsl_gamma ),
                                              pow ( Ctranslucence[1], 1/trsl_gamma ),
                                              pow ( Ctranslucence[2], 1/trsl_gamma )
                                              );
            }
        }
}



//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------ENV LIGHTS------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
N=N_Srf;
normal Nn=normalize(N);
float doOcc=1;
if (ambientOccludeEnvLights){
    doOcc=0;
}

illuminance ("envLight",P, Nn, PI,"send:light:Kocc", doOcc) {
          vector Ln = normalize(L);
          float atten;
          float dot = Ln.hair_normal;
          float minDot = cos(radians(90 + illum_wrap_angle));
          float clampedDot = clamp(dot, minDot , 1.0);
          atten = (clampedDot - minDot)/(1.0 - minDot);
          //--------------------------------------------------DIFFUSE AND MARSCHNER-----------------------------------//
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
          if(nondiffuse < 1){
            //DIFFUSE LOOP
                    if (ambientOccludeEnvLights==1){
                        hair_diffuse += Cl * atten * (1 - nondiffuse) * aov_hair_ambient;
                    }
                    else{
                        hair_diffuse += Cl * atten * (1 - nondiffuse);
                    }

            //if rayType subsurface, check if
                    aov_hair_diffuse = hair_diffuse;

          }
          else{
              aov_hair_diffuse=0;
          }
}


//--------------------------------------------------AOV SPECULAR--------------------------------------------//
aov_hair_primary_specular=hair_primary_specular;
aov_hair_secondary_specular=hair_secondary_specular;
aov_hair_total_specular = hair_specular * aov_hair_specularMap;
//--------------------------------------------------AOV DIFFUSE AMBIENT-------------------------------------//


//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------AOV SCATTER-----------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
aov_hair_total_scatter=hair_scatter;
  if( raytype == "subsurface" ){
      //AMBIENT+DIFFUSE
      Ci=aov_hair_diffuse*Kd;
      //STRANDCOLOR
      Ci=Ci*aov_hair_surfaceColor;
      //OPACITY
      Oi=Oi;
  }
//-------------------------------------------------------------------------------------------------------------------------------------------//
//---------------------------------------------------------------------------------------FINALPASS-------------------------------------------//
//-------------------------------------------------------------------------------------------------------------------------------------------//
  else{
      color sssColor=getTexture(sss,
                  sssFilter,
                  sssUseUdim,
                  sssReverseT,
                  sssMaxU,
                  sssFramenumber,
                  sssTexName,
                  sssUsevariant,
                  sssVarName,
                  sssUseAnimMap,
                  sssFileExt);

      color sss_ptc=0;
      if (doSSS == 1){
                  sss_ptc = subsurface(P,
                  "groupname", sss_groupname,
                  "coordsystem", sss_coordsystem,
                  "diffusemeanfreepath", dmfp,
                  "albedo", albedo,
                  "scale", sss_scale,
                  "ior", sss_ior,
                  "smooth", sss_smooth );
                  aov_hair_subsurface = sss_ptc;

                  aov_hair_subsurface = gamma(aov_hair_subsurface,sss_gamma);
                  aov_hair_subsurface = aov_hair_subsurface*sss_multiplier;

                  aov_hair_subsurface=aov_hair_subsurface*sssColor;
                  }

      aov_indirect=aov_indirect*Kid;
      aov_hair_diffuse=aov_hair_diffuse*Kd;

      //MIX AMBIENT+DIFFUSE
      color white=1;
      color black=0;

      //diffuse *= 1.0 - min(Cr, 1.0);

      
      /*

      if (ambientOccludeEnvLights==0){
          Ci=mix(aov_hair_diffuse,aov_hair_ambient,aov_hair_ambient);
          Ci=Ci+aov_hair_diffuse;
      }

      else{
          Ci=aov_hair_diffuse+aov_indirect;
      }
      */
      Ci=   aov_hair_diffuse * aov_hair_surfaceColor;
      
      //MIX AOV SUBSURFACE
      Ci *= 1.0 - min(aov_hair_subsurface, 1.0);
      
      //MIX SPECULAR
      Ci *= 1.0 - min(aov_hair_total_specular*Oi*overall_specular, 1.0);
      
      //MIX TRANSLUCENCE
      Ci *= 1.0 - min(aov_hair_translucence, 1.0);
      //  aov_hair_translucence);

      //MIX SCATTER
      //Ci *= 1.0 - min(aov_hair_total_scatter*aov_hair_surfaceColor, 1.0);
      
      /*Ci+=aov_hair_surfaceColor +
            aov_hair_subsurface +
            (aov_hair_total_specular*Oi*overall_specular) +
            aov_hair_translucence +
            aov_hair_total_scatter*aov_hair_surfaceColor; */

      Ci+=
            aov_hair_subsurface +
            (aov_hair_total_specular*Oi*overall_specular) +
            aov_hair_translucence +
            aov_hair_total_scatter*aov_hair_surfaceColor;

      

      //OPACITY

      Ci=Ci*Oi;
      //AOV OPACITY
      aov_hair_diffuse*=Oi;
      aov_hair_surfaceColor*=Oi;
      aov_hair_ambient*=Oi;
      aov_hair_total_specular*=Oi;
      aov_hair_translucence*=Oi;
      aov_hair_total_scatter*=Oi;
      aov_hair_primary_specular*=Oi;
      aov_hair_secondary_specular*=Oi;
      aov_hair_specularMap*=Oi;
      aov_hair_v=v*Oi;
      aov_indirect=v*Oi;

      //Export to STD AOVs
      if (exportToStdAOV){
        aov_specular=aov_hair_total_specular;
        aov_diffuse=aov_hair_diffuse;
        aov_ambient=aov_hair_ambient;
        aov_surfaceColor=aov_hair_surfaceColor;
        aov_subsurface = aov_hair_subsurface;
        aov_indirect = aov_indirect;
      }
      }

}

