#ifndef SQR
#define SQR(X)  ( (X) * (X) )
#endif

float schlickfresnel(
                        normal Nf;
                        vector Vf;
                        float ior;
        )
{
        float kr = ( ior - 1.0 ) / ( ior + 1.0 );
        kr *= kr;
        return kr + ( 1.0 - kr ) * pow( 1.0 - (Nf.Vf), 5);
}

float sgeoattenuation(float costheta, roughness;)
{
  float g1 = roughness - roughness * costheta + costheta;
  return costheta / g1;
}

float angledependence(float cosbeta, isotropy;)
{
  float i2 = SQR(isotropy);
  float cosbeta2 = SQR(cosbeta);
  return sqrt( isotropy / (i2 - i2 * cosbeta2 + cosbeta2));
}

// Zenith dependence
float zenithdependence(float cosbeta, roughness;)
{
  float cosbeta2 = SQR(cosbeta);
  float zz = 1 - (1 - roughness) * cosbeta2;
  return roughness / SQR(zz) ;
}



//Shift specular highlights along hair length
vector shifttangent(vector Tn; normal Nn; float shift;)
{
    vector shiftedT = Tn + shift * Nn;
    return normalize(shiftedT);
}
//Strand specular lighting//
float strandspecular(vector Tn, Vn, Ln; float exponent;)
{
    vector Hn = normalize(Ln + Vn);
    float dotth = Tn.Hn;
    float sinth = max(0.0, sqrt(1.0 - dotth * dotth));
    float diratten = smoothstep(-1.0, 0.0, dotth);
    return diratten * pow(sinth, exponent);
}

normal pxslUtilShadingNormal(normal n;)
{
    normal Ns = normalize(n);
    extern vector I;
    uniform float sides = 2;
    uniform float raydepth;
    attribute("Sides", sides);
    rayinfo("depth", raydepth);

    if (sides == 2 || raydepth > 0)
    {
        Ns = faceforward(Ns, I, Ns);
    }

    return Ns;
}


/*Author: Charles Trippe
Date: Nov 09, 2009
Description: A surface with blurry reflections and a custom specular shape that can be controlled with a map.*/
color shaped_specular (normal Nn; vector V; float theta; float specscale_s; float specscale_t; float surffalloff; float specmapblur; float specsamples; string highlightshape)
{
        extern point P;
        color C = 1;
        vector  up = (0,1,0), //Up in Y
                        newup,
                        right = (0,0,0);
        float   spec_s = 0,
                        spec_t = 0;

        color   highlightcol = color (1,1,1);

        newup = vector rotate(point up, radians(theta), point(0,0,1), point(0,0,0)); //Rotation code for spec highlight

        illuminance (P, Nn, PI/2) {
                float nonspecularmask = 0;
                lightsource("__nonspecularmask", nonspecularmask); //Turns the specular on/off
                if(nonspecularmask < 1){
                        up = newup;
                        vector Ln = normalize(L); //normalized light vector
                        vector H = normalize (Ln + V); //Specular highlight vector
                        right = reflect(up^H,Nn); //Make a vector pointing tangentially right from the surface
                        up = reflect(H^right,Nn); //Make a vector pointing tangentially up from the surface
                        spec_s = (Ln.right / specscale_s) + 0.5; //S coords
                        spec_t = (Ln.up / specscale_t) + 0.5;   //T coords

                        highlightcol = texture(highlightshape,spec_s,spec_t, "blur", specmapblur, "samples", specsamples) * pow(max(0, Nn.Ln), surffalloff); //place the mapped highlight

                        C *=mix(highlightcol,1,nonspecularmask);
                }
                else{
                    C=C;
                }
        }
        return C;
}

//------------------------------------------------COLOR------------------------------------------------------
color textureUDim(
    float useUdim;
    float maxU;
    float framenumber;
    string texName;
    float usevariant;
    string varName;
    float useAnimMap;
    string fileExt;
    string filter;

){
    extern float s;
    extern float t;
    color pixel_color = color(0,0,0);
    float ss = floor(s);
    float tt = floor(t);
    float abstt = abs(tt);
    uniform string texn;
    uniform string uDim = "1001";
    uniform string frame = "";
    varying float udim = (abstt * maxU + ss + 1001);
    uniform float mapnumber = 1000;
    while( mapnumber < udim )
    {
      mapnumber += 1;
    }
    uDim = format("%04d" , mapnumber);
    frame = format("%04d", framenumber);
    if(texName != "")
    {
      texn = texName;
      if (usevariant > 0)
        texn = concat(texn, "_", varName);
      if (useAnimMap > 0)
        texn = concat(texn, ".", frame);
      texn = concat(texn, ".", uDim, ".", fileExt);
    }
  return texture(texn, s - ss, t - tt,"filter", filter);
}

float textureFloatUDim(
    float useUdim;
    float maxU;
    float framenumber;
    string texName;
    float usevariant;
    string varName;
    float useAnimMap;
    string fileExt;
    string filter;

){
    extern float s;
    extern float t;
    color pixel_color = color(0,0,0);
    float ss = floor(s);
    float tt = floor(t);
    float abstt = abs(tt);
    uniform string texn;
    uniform string uDim = "1001";
    uniform string frame = "";
    varying float udim = (abstt * maxU + ss + 1001);
    uniform float mapnumber = 1000;
    while( mapnumber < udim )
    {
      mapnumber += 1;
    }
    uDim = format("%04d" , mapnumber);
    frame = format("%04d", framenumber);
    if(texName != "")
    {
      texn = texName;
      if (usevariant > 0)
        texn = concat(texn, "_", varName);
      if (useAnimMap > 0)
        texn = concat(texn, ".", frame);
      texn = concat(texn, ".", uDim, ".", fileExt);
    }
  return texture(texn, s - ss, t - tt,"filter", filter);
}

color getTexture(
    string file;
    string filter;
    float useUdim;
    float maxU;
    float framenumber;
    string uDimFile;
    float usevariant;
    string varName;
    float useAnimMap;
    string fileExt;)
{
  extern float s,t;
  if (useUdim==0){
    if( file != "" ){
      return texture ( file, mod(s,1),(mod(t,1)*-1)+1 , "filter", filter);
    }
    else{
          return 1;
    }
  }
  else if (useUdim==1){
    if( uDimFile != "" ){
        return textureUDim(useUdim,
                   maxU,
                   framenumber,
                   uDimFile,
                   usevariant,
                   varName,
                   useAnimMap,
                   fileExt,
                   filter);
    }
    else{
          return 1;
    }
  }

}
float getFloatTexture(
    string file;
    string filter;
    float useUdim;
    float maxU;
    float framenumber;
    string uDimFile;
    float usevariant;
    string varName;
    float useAnimMap;
    string fileExt;)
{
  extern float s,t;
  if (useUdim==0){
    if( file != "" ){
      return texture ( file, mod(s,1),(mod(t,1)*-1)+1, "filter", filter);
    }
    else{
          return 1;
    }
  }
  else if (useUdim==1){
    if( uDimFile != "" ){
        return textureFloatUDim(useUdim,
                   maxU,
                   framenumber,
                   uDimFile,
                   usevariant,
                   varName,
                   useAnimMap,
                   fileExt,
                   filter);
    }
    else{
          return 1;
    }
  }

}

color gamma(color rgb; float gamma;)
{
  return color (pow ( rgb[0], 1/gamma ),
                pow ( rgb[1], 1/gamma ),
                pow ( rgb[2], 1/gamma ));
}
float gamma(float value; float gamma)
{
  return pow ( value, 1/gamma );
}

color screen(color Layer_1; color Layer_2)
{
  return 1-((1-Layer_1)*(1-Layer_2));
}

color strandColor (color rootColor; color tipColor;float v)
{
  return 1;
}

float clampValue (float value; float base; float top)
{
  float clampValue=value;
  if (clampValue>top){
      clampValue=top;
  }
  if (clampValue<base){
      clampValue=base;
  }
  return clampValue;
}


float setRange(float input, oldMin, oldMax, min, max)
{
  return ((max-min)*((input-oldMin)/(oldMax-oldMin)))+min;
}

color strandColor(color rootColor; color middleColor; color tipColor;float v; float middleColorBias)
{
  return 1;
}


