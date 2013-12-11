#include <../ezeDelightCommon/ezeDelightCommon.sl>



surface ezeSurface (
    string fullPassName="fullRenderPass";
    string bakePassName="bakeRenderPass";
    #pragma annotation "grouping" "fullPassName;"
    #pragma annotation "grouping" "bakePassName;"

    string ptcFile= "<project>/3delight/<scene>/<scene>_sceneGeom.#.ptc";
    string bakeSpace= "world"; 
    float radiusscale=1.77;
    #pragma annotation "grouping" "bake/ptcFile;"
    #pragma annotation "grouping" "bake/bakeSpace;"
    #pragma annotation "grouping" "bake/radiusscale;"



    float Kd=1;
    float Kid=1;
    
    color KdColor=1;
    string diffuse="";
    string diffuseFilter="gaussian";
    float gamma=0.454;
    float diffuseUseUdim=0;
    float diffuseReverseT=0;
    float diffuseMaxU=2;
    float diffuseFramenumber=2;
    string diffuseTexName="";
    float diffuseUsevariant=2;
    string diffuseVarName="2k";
    float diffuseUseAnimMap=0;
    string diffuseFileExt="tdl";
    float conserveEnergy=1;



    #pragma annotation "grouping" "Diffuse/Kd;"
    #pragma annotation "grouping" "Diffuse/Kid;"
    #pragma annotation "grouping" "Diffuse/conserveEnergy;"
    #pragma annotation "grouping" "Diffuse/lcorenNayarRoughness;"
    #pragma annotation "grouping" "Diffuse/KdColor;"
    #pragma annotation "grouping" "Diffuse/maps/diffuse;"
    #pragma annotation diffuseFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
    #pragma annotation "grouping" "Diffuse/maps/diffuseFilter;"
    #pragma annotation "grouping" "Diffuse/maps/gamma;"
    #pragma annotation "grouping" "Diffuse/maps/diffuseReverseT;"
    #pragma annotation diffuseReverseT "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Diffuse/maps/diffuseUseUdim;"
    #pragma annotation diffuseUseUdim "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseMaxU;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseFramenumber;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseTexName;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseUsevariant;"
    #pragma annotation diffuseUsevariant "gadgettype=checkbox:0:1=custom value;"
    
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseVarName;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseUseAnimMap;"
    #pragma annotation diffuseUseAnimMap "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Diffuse/maps/udim/diffuseFileExt;"
    #pragma annotation diffuseFileExt "gadgettype=optionmenu:tdl:tif:;"



    string bump=""; //bump textureMap
    string bumpFilter="gaussian";

    float bumpDepth=0;

    float bumpUseUdim=0;
    float bumpReverseT=0;
    float bumpMaxU=2;
    float bumpFramenumber=2;
    string bumpTexName="";
    float bumpUsevariant=2;
    string bumpVarName="2k";
    float bumpUseAnimMap=0;
    string bumpFileExt="tdl";

    #pragma annotation "grouping" "bump/bump;"
    #pragma annotation bumpFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
    #pragma annotation "grouping" "bump/bumpFilter;"
    #pragma annotation "grouping" "bump/bumpDepth;"
    #pragma annotation bumpUseUdim "gadgettype=checkbox:0:1=custom value;"
     #pragma annotation "grouping" "bump/bumpReverseT;"
    #pragma annotation bumpReverseT "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "bump/bumpUseUdim;"
   
    #pragma annotation "grouping" "bump/udim/bumpMaxU;"
    #pragma annotation "grouping" "bump/udim/bumpFramenumber;"
    #pragma annotation "grouping" "bump/udim/bumpTexName;"
    #pragma annotation "grouping" "bump/udim/bumpUsevariant;"
    #pragma annotation bumpUsevariant "gadgettype=checkbox:0:1=custom value;"
    
    #pragma annotation "grouping" "bump/udim/bumpVarName;"
    #pragma annotation "grouping" "bump/udim/bumpUseAnimMap;"
    #pragma annotation bumpUseAnimMap "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "bump/udim/bumpFileExt;"
    #pragma annotation bumpFileExt "gadgettype=optionmenu:tdl:tif:;"




    float Ks=1;
    color KsColor=1;

    float primarySpecularModel=0;
    float lcorenNayarRoughness= .5;
    float IOR = 1.3;
    float roughness = .2;
    float gaussConstant = 100;

    #pragma annotation primarySpecularModel "gadgettype=optionmenu:CookTorrance:Wardisotropy;label=specular;"
    #pragma annotation "grouping" "Specular/primarySpecularModel;"
    #pragma annotation "grouping" "Specular/Ks;"
    #pragma annotation "grouping" "Specular/KsColor;"
    #pragma annotation "grouping" "Specular/roughness;"
    #pragma annotation "grouping" "Specular/IOR;"
    
    #pragma annotation "grouping" "Specular/gaussConstant;"
    #pragma annotation "grouping" "Specular/maps/specular;"
    #pragma annotation specularFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
    #pragma annotation "grouping" "Specular/maps/specularFilter;"
    #pragma annotation "grouping" "Specular/maps/specularReverseT;"
    #pragma annotation specularReverseT "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Specular/maps/specularUseUdim;"
    #pragma annotation specularUseUdim   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Specular/maps/udim/specularMaxU;"
    #pragma annotation "grouping" "Specular/maps/udim/specularFramenumber;"
    #pragma annotation "grouping" "Specular/maps/udim/specularTexName;"
    #pragma annotation "grouping" "Specular/maps/udim/specularUsevariant;"
    #pragma annotation specularUsevariant "gadgettype=checkbox:0:1=custom value;"
    
    #pragma annotation "grouping" "Specular/maps/udim/specularVarName;"
    #pragma annotation "grouping" "Specular/maps/udim/specularUseAnimMap;"
    #pragma annotation specularUseAnimMap "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Specular/maps/udim/specularFileExt;"
    #pragma annotation specularFileExt "gadgettype=optionmenu:tdl:tif:;"



    string specular="";
    string specularFilter="gaussian";
    float specularUseUdim=0;
    float specularReverseT=0;
    float specularMaxU=2;
    float specularFramenumber=2;
    string specularTexName="";
    float specularUsevariant=2;
    string specularVarName="2k";
    float specularUseAnimMap=0;
    string specularFileExt="tdl";


    color OiColor=1;
    string OiColorMap="";
    string OiColorMapFilter="gaussian";
    float OiColorMapUseUdim=0;
    float OiColorReverseT=0;
    float OiColorMapMaxU=2;
    float OiColorMapFramenumber=2;
    string OiColorMapTexName="";
    float OiColorMapUsevariant=2;
    string OiColorMapVarName="2k";
    float OiColorMapUseAnimMap=0;
    string OiColorMapFileExt="tdl";
    #pragma annotation "grouping" "Transparency/OiColor;"
    #pragma annotation "grouping" "Transparency/maps/OiColorMap;"
    #pragma annotation OiColorMapFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
    #pragma annotation "grouping" "Transparency/maps/OiColorMapFilter;"
    #pragma annotation "grouping" "Transparency/maps/gamma;"
    #pragma annotation "grouping" "Transparency/maps/OiColorReverseT;"
    #pragma annotation OiColorReverseT "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Transparency/maps/OiColorMapUseUdim;"
    #pragma annotation OiColorMapUseUdim "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapMaxU;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapFramenumber;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapTexName;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapUsevariant;"
    #pragma annotation OiColorMapUsevariant "gadgettype=checkbox:0:1=custom value;"
    
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapVarName;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapUseAnimMap;"
    #pragma annotation OiColorMapUseAnimMap "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "Transparency/maps/udim/OiColorMapFileExt;"
    #pragma annotation OiColorMapFileExt "gadgettype=optionmenu:tdl:tif:;"


    //SSS
    uniform float doSSS = 0;
    uniform float Ksss=1;

    string sss="";
    float sssThreshold=0.08;
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

    uniform string sssGroupname = "";
    color dmfp = color(8.51, 5.57, 3.95);
    color albedo = color(0.830,0.791, 0.753);
    float sssIor = 1.5;
    float sssScale = 1.0;
    uniform string sssCoordsystem = "world";
    uniform float sssSmooth = .5;
    float sssGamma = 1.8;

    #pragma annotation doSSS   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "subsurface/doSSS;"
    #pragma annotation "grouping" "subsurface/Ksss;"
    #pragma annotation "grouping" "subsurface/sssThreshold;"
    #pragma annotation "grouping" "subsurface/maps/sss;"
    #pragma annotation "grouping" "subsurface/maps/sssFilter;"
    #pragma annotation bumpFilter "gadgettype=optionmenu:gaussian:box:triangle:catmull-rom:;"
    #pragma annotation sssUseUdim   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "subsurface/maps/sssReverseT;"
    #pragma annotation sssReverseT "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "subsurface/maps/sssUseUdim;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssMaxU;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssFramenumber;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssTexName;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssUsevariant;"
    #pragma annotation sssUsevariant "gadgettype=checkbox:0:1=custom value;"
    
    #pragma annotation "grouping" "subsurface/maps/udim/sssVarName;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssUseAnimMap;"
    #pragma annotation sssUseAnimMap "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "subsurface/maps/udim/sssFileExt;"
    #pragma annotation sssFileExt "gadgettype=optionmenu:tdl:tif:;"
    #pragma annotation "grouping" "subsurface/sssGroupname;"
    #pragma annotation "grouping" "subsurface/dmfp;"
    #pragma annotation "grouping" "subsurface/albedo;"
    #pragma annotation "grouping" "subsurface/sssIor;"
    #pragma annotation "grouping" "subsurface/sssScale;"
    #pragma annotation "grouping" "subsurface/sssCoordsystem;"
    #pragma annotation "grouping" "subsurface/sssSmooth;"
    #pragma annotation "grouping" "subsurface/sssGamma;"






    float useSpecularMask=0;
    float specularMaskRot = 0,    //Rotates the mapped specular highlight
    specularMaskScaleU = 1, //Scales the mapped specular highlight (can go above 1)
    specularMaskScaleV = 1, //Scales the mapped specular highlight (can go above 1)
    specularMaskSurfaceFalloff = 1; //How steep to apply falloff on the mapped highlight when it approaches a surface edge.
    string specularMaskMap = "";
    float   specularMaskGloss = 0;
    float   specularMaskSamples=16;

    #pragma annotation useSpecularMask   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation maskPrimarySpecular   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation maskSecondarySpecular   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "specularMaskShape/useSpecularMask;"
    #pragma annotation "grouping" "specularMaskShape/maskPrimarySpecular;"
    #pragma annotation "grouping" "specularMaskShape/maskSecondarySpecular;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskRot;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskScaleU;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskScaleV;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskSurfaceFalloff;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskMap;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskGloss;"
    #pragma annotation "grouping" "specularMaskShape/specularMaskSamples;"

    float Kr = 0;
    float samples = 1;
    float cone_angle = 0.0;
    color reflectionColor = 1;
    string traceSet="";

    float maxdist=20;

    float brdf_fresnel = 1;
    float brdf_0_degree_refl = 0.8;
    float brdf_90_degree_refl = 1;
    float brdf_curve = 2;
    float refraction_ior = 1.3;


    #pragma annotation "grouping" "reflection/Kr;"
    #pragma annotation "grouping" "reflection/samples;"
    #pragma annotation "grouping" "reflection/cone_angle;"
    #pragma annotation "grouping" "reflection/maxdist;"
    #pragma annotation "grouping" "reflection/reflectionColor;"
    #pragma annotation "grouping" "reflection/traceSet;"
    #pragma annotation "grouping" "reflection/brdf_fresnel;"
    #pragma annotation brdf_fresnel   "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "reflection/brdf_0_degree_refl;"
    #pragma annotation "grouping" "reflection/brdf_90_degree_refl;"
    #pragma annotation "grouping" "reflection/brdf_curve;"
    #pragma annotation "grouping" "reflection/refraction_ior;"


    float mayaPreview=0;
    #pragma annotation "grouping" "extraParameters/mayaPreview;"

    #pragma annotation aov_specular "hide=true;"
    #pragma annotation aov_specular_shape "hide=true;"
    #pragma annotation aov_diffuse "hide=true;"
    #pragma annotation aov_ambient "hide=true;"
    #pragma annotation aov_surfaceColor "hide=true;"
    #pragma annotation aov_subsurface "hide=true;"
    #pragma annotation aov_indirect "hide=true;"



    output varying color aov_specular=0;
    output varying color aov_specular_shape=0;
    output varying color aov_diffuse=0;
    output varying color aov_ambient=0;
    output varying color aov_surfaceColor=0;
    output varying color aov_subsurface = 0;
    output varying color aov_indirect = 0;

)


{
  if (mayaPreview==1){
                N=-N;
                }
  
  normal Nn = normalize(N);
  vector LN;
  //normal Nf = faceforward(Nn, I);
  vector V = normalize(-I);
  vector In=normalize (I);

  vector Vn = normalize(-I);
  float F;
  float Ktransmit ;
  float m = roughness;
  fresnel( normalize(I), Nn, 1/IOR, F, Ktransmit);
  float NdotV = Nn.Vn;



  uniform string raytype = "unknown";
  rayinfo( "type", raytype );
  string passName = "";
  option ("user:delight_renderpass_name",passName);

  color diffuseColor=getTexture(diffuse,
      diffuseFilter,
      diffuseUseUdim,
      diffuseReverseT,
      diffuseMaxU,
      diffuseFramenumber,
      diffuseTexName,
      diffuseUsevariant,
      diffuseVarName,
      diffuseUseAnimMap,
      diffuseFileExt);
  diffuseColor = gamma(diffuseColor,gamma);
  diffuseColor=diffuseColor*gamma(KdColor,gamma);



  color specularColor=getTexture(specular,
        specularFilter,
        specularUseUdim,
        specularReverseT,
        specularMaxU,
        specularFramenumber,
        specularTexName,
        specularUsevariant,
        specularVarName,
        specularUseAnimMap,
        specularFileExt);
  specularColor = gamma(specularColor,gamma);
  specularColor=specularColor*gamma(KsColor,gamma);


  //-------------------------------------------------------------------------------------------//
  //----------------------------------------BUMP-----------------------------------------------//
  //-------------------------------------------------------------------------------------------//

  normal Nb_diff;

  normal Norig = faceforward(normalize(N),I);
  extern vector dPdu, dPdv;
  normal o_outNormal;
  normal o_outNb_diff;
  normal o_outNb_spec;
  //float bumpValue = texture ( bump, "filter", "gaussian"  );
  float bumpValue=0;

  //SPECULAR COLOR
  if (bumpUseUdim==0){
     //if texture specified, use it
     if( specular != "" ){
       bumpValue=texture( bump, s, t, "filter", bumpFilter);
     }
   }
  else{
     if( bumpTexName != "" ){
         bumpValue=textureFloatUDim(bumpUseUdim,
             bumpReverseT,
             bumpMaxU,
             bumpFramenumber,
             bumpTexName,
             bumpUsevariant,
             bumpVarName,
             bumpUseAnimMap,
             bumpFileExt,
             bumpFilter);
     }
   }


   float depth = abs(bumpDepth);
   float offset = clamp(bumpValue * bumpDepth, -depth, depth);

   float uscale = 1.0 / (length(vtransform("object", dPdu)) * 6.0);
   float vscale = 1.0 / (length(vtransform("object", dPdv)) * 6.0);

   vector gu = vector(1, 0, Du(offset) * uscale);
   vector gv = vector(0, 1, Dv(offset) * vscale);
   normal n = normal(gu ^ gv);
   vector basisz = normalize(N);
   vector basisx = normalize((basisz ^ dPdu) ^ basisz);
   vector basisy = normalize((basisz ^ dPdv) ^ basisz);

   o_outNormal = normal(xcomp(n) * basisx + ycomp(n) * basisy + zcomp(n) * basisz);
   N = normalize(o_outNormal);
   Nb_diff = N;
   o_outNb_diff = mix(normalize(Norig),o_outNormal,1);
   Nb_diff = normalize(o_outNb_diff);


  
  color spec=0;
  color diffuse=0;


  illuminance( P, Nn, PI/2 ){
    
    string category="";
    lightsource ( "__category", category );
    float nondiffuse = 0;
    lightsource("__nondiffuse",nondiffuse);
    float nonspecular = 0;
    lightsource("__nonspecular",nonspecular);
    float nonsubsurface = 0;
    lightsource("__nonsubsurface",nonsubsurface);


    //-------------------------------------------------------------------------------------------//
    //--------------------------------------DIFFUSE----------------------------------------------//
    //-------------------------------------------------------------------------------------------//
        float sigma2 = lcorenNayarRoughness * lcorenNayarRoughness;
        float A = 1 - 0.5 * sigma2 / (sigma2 + 0.33);
        float B = 0.45 * sigma2 / (sigma2 + 0.09);
        vector V = normalize(-I);
        float theta_r = acos (V.Nn); //angle between V and N
        vector V_perp_N = normalize(V-N*(V.Nn)); //part of V perpendicular to N
        vector Ln = normalize(L);
        float cos_theta_i = Ln.Nn;
        float cos_phi_diff = V_perp_N . normalize(Ln - Nn * cos_theta_i);
        float theta_i = acos (cos_theta_i);
        float alpha = max(theta_i, theta_r);
        float beta  = min(theta_i, theta_r);
        //-------------------------------------------------------------------------------------//
        diffuse += Cl * cos_theta_i * (A + B * max(0,cos_phi_diff) * sin(alpha) * tan(beta));
        //-------------------------------------------------------------------------------------//
       

        if( raytype == "subsurface" ){
                    aov_diffuse += (diffuse = (1-nonsubsurface))*(1-nondiffuse);
                  }
        else
          {
            aov_diffuse += (diffuse *= (1-nondiffuse));
          }
        if (category=="envLight"){
        //TODO: aov_diffuse*=envLightOcclusion????;
        }


    //-------------------------------------------------------------------------------------------//
    //--------------------------------------SPECULAR---------------------------------------------//
    //-------------------------------------------------------------------------------------------//

    if(nonspecular < 1){
        //COOK
        vector  up = (0,1,0), //Up in Y
                newup,
                right = (0,0,0);
        float   spec_s = 0,
                        spec_t = 0;
        color   highlightcol = color (1,1,1);
        newup = vector rotate(point up, radians(specularMaskRot), point(0,0,1), point(0,0,0)); //Rotation code for spec highlight
        up = newup;
        
        vector H = normalize (Ln + V); //Specular highlight vector
        right = reflect(up^H,Nn); //vector tangentially right from the surface
        up = reflect(H^right,Nn); //vector tangentially up from the surface
        spec_s = (Ln.right / specularMaskScaleU) + 0.5;
        spec_t = (Ln.up / specularMaskScaleV) + 0.5;

        highlightcol = texture(specularMaskMap,spec_s,spec_t, "blur", specularMaskGloss, "samples", specularMaskSamples) * pow(max(0, Nn.Ln), specularMaskSurfaceFalloff);
        float nonspecularmask = 0;
        lightsource("__nonspecularmask", nonspecularmask); //Turns the specular on/off

        if (primarySpecularModel==0){
                vector H = normalize(Vn+Ln);
                float NdotH = Nn.H;
                float NdotL = Nn.Ln;
                float VdotH = Vn.H;
                alpha = acos(NdotH);
                
                //attenuation by microfacet self-shadowing
                float G = min(1, (2*NdotH*NdotV/VdotH), (2*NdotH*NdotL/VdotH)); 
                
                //Probability microfacets are orientated towards F
                float D = gaussConstant*exp(-(alpha*alpha)/(m*m));  
                
                spec += Cl*(F*D*G)/(PI*NdotV);
                }
        if (primarySpecularModel==1){
            //1 Wardisotropy
          ////////////////////////////////////////////////////////////////////////////////
          // Variation on Greg Ward's isotropic specular /////////////////////////////////
          // Note that you can just pass identical values to x and y anisotropy, in the //
          // Ward anisotropic shader, and get the same results, altough at a slight //////
          // extra expense. //////////////////////////////////////////////////////////////
          ////////////////////////////////////////////////////////////////////////////////
          vector Vf = -In, Ln, Hn;
          float ndotv = N.Vf, ndotl, ndoth, tandelta2;
          float m2 = roughness * roughness;
          Ln = normalize(L);
          ndotl = N.Ln;
          Hn = normalize(Ln + Vf);
          ndoth = N.Hn;
          tandelta2 = SQR( sqrt( max(0, 1 - SQR(ndoth))) / ndoth );

          //-------------------------------------------------------------------------------------//
          spec+=Cl  * ndotl * ( exp(-tandelta2/m2) /(4 * m2 * sqrt( ndotl * ndotv )) );
          //-------------------------------------------------------------------------------------//


        }
        if (useSpecularMask){
          aov_specular+= mix(spec, highlightcol*spec,1-nonspecularmask)*(1-nonspecular);
        }
        else{
          aov_specular+=spec;
        }
    }


  }
  spec = spec/PI;


    //-------------------------------------------------------------------------------------------//
    //----------------------------------------OiColor--------------------------------------------//
    //-------------------------------------------------------------------------------------------//



  aov_surfaceColor=diffuseColor;
  aov_specular=aov_specular*Ks*KsColor*specularColor;

  aov_diffuse=aov_diffuse*Kd;

  //DONT SSS or anything IF SUBSURFACE PASS or not final pass
  if( raytype == "subsurface" || passName==bakePassName)
  {
    Ci=aov_diffuse;
    Ci=Ci*aov_surfaceColor;
    Oi=Oi*OiColor;
    Ci=Ci*Oi;
    if (passName==bakePassName){
      if(ptcFile != "") {
                  bake3d(ptcFile, "", P, N, "_radiosity", Ci, "interpolate", 1, "radiusscale", radiusscale,"coordsystem", bakeSpace);
              }
    }

  }

else {
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

    color sssPTC = 0;
    //TODO: Add sssCutOut If to skip sss with a threshold - sssThreshold
    if ((doSSS == 1)){
    sssPTC = subsurface(P,
                        "groupname", sssGroupname,
                        "coordsystem", sssCoordsystem,
                        "diffusemeanfreepath", dmfp,
                        "albedo", albedo,
                        "scale", sssScale,
                        "ior", sssIor,
                        "smooth", sssSmooth );

                        sssColor = gamma(sssPTC,sssGamma)*sssColor;
                        sssColor = sssColor*sssColor;
                        sssColor = sssColor*Ksss;
    }
    else{
        sssColor=0;
    }

    //-------------------------------------------------------------------------------------------//
    //----------------------------------------REF-----------------------------------------------//
    //-------------------------------------------------------------------------------------------//
    color Cr = 0;
    color Chit = 0;

    vector R = normalize(reflect(I,N));
    float hits = 0;
    float _transm=1;
    color white=1;

    if (Kr>0){
      gather("illuminance", P, R, radians(cone_angle),samples,"surface:Ci",Chit,"maxdist", maxdist){
          Cr+=Chit;
      }
      Cr /= samples > 0 ? samples : 1;

      //-------------------------------------------------------------------------------------//
      Cr*=reflectionColor;
      //-------------------------------------------------------------------------------------//
    }

    if (brdf_fresnel == 1)
            {
              // Automatic mode.
              float eta = (In . Nn < 0.0) ? 1.0 / refraction_ior : refraction_ior;
              float kr, kt;
              fresnel( In, N, eta, kr, kt);
              Cr *= kr;
            }
            else
            {
              // Manual mode.
              Cr *=
              mix(
                      brdf_0_degree_refl,
                      brdf_90_degree_refl,
                      pow(1-abs(V . N), brdf_curve));
            }

    Cr*=Kr;
    aov_subsurface=sssColor;
    aov_indirect=aov_indirect*Kid;

    Oi=Oi*OiColor;
    

    if (conserveEnergy==1){
        diffuse *= 1.0 - min(Ks*KsColor*specularColor*spec, 1.0);
        diffuse *= 1.0 - min(Cr, 1.0);
        diffuse *= 1.0 - min(aov_subsurface, 1.0);
        //add Oi to energy conserving
        //diffuse *= 1.0 - min(Oi, 1.0);
    }

    //-------------------------------------------------------------------------------------//
    Ci=(Kd*diffuseColor*diffuse*Oi) + aov_indirect + (Ks*KsColor*specularColor*spec) + Cr +aov_subsurface; 
    //-------------------------------------------------------------------------------------//
    
    
}

}


