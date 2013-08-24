#include <../ezeDelightCommon/ezeDelightCommon.sl>

displacement
 ezeDisplacement(

    float layer1Multiplier=1;
    string layer1 = "";
    float layer1Displacement = 0.1;
    float layer1Offset=-0.05;

    float layer1UseUdim=0;
    float layer1MaxU=2;
    float layer1Framenumber=2;
    string layer1TexName="";
    float layer1Usevariant=2;
    string layer1VarName="2k";
    float layer1UseAnimMap=0;
    string layer1FileExt="tdl";

    #pragma annotation "grouping" "layer1/layer1Multiplier;"
    #pragma annotation "grouping" "layer1/layer1Displacement;"
    #pragma annotation "grouping" "layer1/layer1;"
    #pragma annotation "grouping" "layer1/layer1Offset;"
    #pragma annotation "grouping" "layer1/layer1UseUdim;"
    #pragma annotation layer1UseUdim "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "layer1/uDim/layer1MaxU;"
    #pragma annotation "grouping" "layer1/uDim/layer1Framenumber;"
    #pragma annotation "grouping" "layer1/uDim/layer1TexName;"
    #pragma annotation "grouping" "layer1/uDim/layer1FileExt;"
    #pragma annotation layer1FileExt "gadgettype=optionmenu:tdl:tif:;"
    #pragma annotation "grouping" "layer1/uDim/layer1Usevariant;"
    #pragma annotation layer1Usevariant "gadgettype=checkbox:0:1=custom value;"
    #pragma annotation "grouping" "layer1/uDim/layer1VarName;"
    #pragma annotation "grouping" "layer1/uDim/layer1UseAnimMap;"
    #pragma annotation layer1UseAnimMap "gadgettype=checkbox:0:1=custom value;"



    float layer2Displacement = 0.1;
    string layer2 = "";
    float layer2Offset=-0.05;
    float layer2Multiplier=1;

    float layer2UseUdim=0;
    float layer2MaxU=2;
    float layer2Framenumber=2;
    string layer2TexName="";
    float layer2Usevariant=2;
    string layer2VarName="2k";
    float layer2UseAnimMap=0;
    string layer2FileExt="tdl";

   #pragma annotation "grouping" "layer2/layer2Multiplier;"
   #pragma annotation "grouping" "layer2/layer2Displacement;"
   #pragma annotation "grouping" "layer2/layer2;"
   #pragma annotation "grouping" "layer2/layer2Offset;"
   #pragma annotation "grouping" "layer2/layer2UseUdim;"
   #pragma annotation layer2UseUdim "gadgettype=checkbox:0:1=custom value;"
   #pragma annotation "grouping" "layer2/uDim/layer2MaxU;"
   #pragma annotation "grouping" "layer2/uDim/layer2Framenumber;"
   #pragma annotation "grouping" "layer2/uDim/layer2TexName;"
   #pragma annotation "grouping" "layer2/uDim/layer2FileExt;"
   #pragma annotation layer2FileExt "gadgettype=optionmenu:tdl:tif:;"
   #pragma annotation "grouping" "layer2/uDim/layer2Usevariant;"
   #pragma annotation layer2Usevariant "gadgettype=checkbox:0:1=custom value;"
   #pragma annotation "grouping" "layer2/uDim/layer2VarName;"
   #pragma annotation "grouping" "layer2/uDim/layer2UseAnimMap;"
   #pragma annotation layer2UseAnimMap "gadgettype=checkbox:0:1=custom value;"

	)
{


float s2c_scale = length(ntransform("current",N))/length(N);

float bmp1=0;
float bmp2=0;


bmp1=getFloatTexture(layer1,
    "gaussian",
    layer1UseUdim,
    layer1MaxU,
    layer1Framenumber,
    layer1TexName,
    layer1Usevariant,
    layer1VarName,
    layer1UseAnimMap,
    layer1FileExt);


bmp2=getFloatTexture(layer2,
    "gaussian",
    layer2UseUdim,
    layer2MaxU,
    layer2Framenumber,
    layer2TexName,
    layer2Usevariant,
    layer2VarName,
    layer2UseAnimMap,
    layer2FileExt);



bmp1 = layer1Displacement * bmp1;
bmp1=bmp1+layer1Offset;
bmp1=bmp1*layer1Multiplier;


bmp2 = layer2Displacement * bmp2;
bmp2=bmp2+layer2Offset;
bmp2=bmp2*layer2Multiplier;





P = P + (bmp1+bmp2) * normalize (N) * s2c_scale;
N = calculatenormal(P);
}
