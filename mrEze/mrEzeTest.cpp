#include "adskShader.h"

// Parameters struct
struct mrEzeTestParameters {
	ADSK_BASE_SHADER_PARAMETERS
	miColor ambient;
	miColor diffuse;
	miColor specular;
	miScalar exponent;
	miColor transparency;
};

const unsigned int mrEzeTest_VERSION = 3;
typedef ShaderHelper<mrEzeTestParameters> BaseShaderHelperType;


class mrEzeTestClass : public Material<mrEzeTestParameters, BaseShaderHelperType, mrEzeTest_VERSION>
{
public:

	static void init(miState *state, mrEzeTestParameters *params) {}
	static void exit(miState *state, mrEzeTestParameters *params) {}

	mrEzeTestClass(miState *state, mrEzeTestParameters *params) :
		Material<mrEzeTestParameters, BaseShaderHelperType, mrEzeTest_VERSION>(state, params)
		{}
	~mrEzeTestClass() {}

	miBoolean operator()(miColor *result, miState *state, mrEzeTestParameters *params);

private:

	// short cut definition for base class
	typedef Material<mrEzeTestParameters, BaseShaderHelperType, mrEzeTest_VERSION> MaterialBase;

};


#define IF_PASSES if (numberOfFrameBuffers && MaterialBase::mFrameBufferWriteOperation)
#define WRITE_PASS(pass, value) MaterialBase::writeToFrameBuffers(state, frameBufferInfo, passTypeInfo, (value), pass, false)

miBoolean mrEzeTestClass::operator()(miColor *result, miState *state, mrEzeTestParameters *params)
{


	// Initialize "mayabase state" into a MBS variable.
	MBS_SETUP(state)

	// Setup framebuffers.
    PassTypeInfo* passTypeInfo;
    FrameBufferInfo* frameBufferInfo;
    unsigned int numberOfFrameBuffers = getFrameBufferInfo(state, passTypeInfo, frameBufferInfo);

 	// Fetch parameters.
	miColor Ka = opaqueColor(*mi_eval_color(&params->ambient));
	miColor Kd = opaqueColor(*mi_eval_color(&params->diffuse));
	miColor Ks = opaqueColor(*mi_eval_color(&params->specular));
	miScalar exponent = *mi_eval_scalar(&params->exponent);
	miColor Kt = opaqueColor(*mi_eval_color(&params->transparency));

	result->r = result->g = result->b = 1.0;

    IF_PASSES {
		WRITE_PASS(AMBIENT_MATERIAL_COLOR, Ka);
        WRITE_PASS(DIFFUSE_MATERIAL_COLOR, Kd);
    }

    
    result->r = state->tex_list[0].x;
    result->g = state->tex_list[0].y;
    result->b = 1.0;

	return(miTRUE);
}

// Use the EXPOSE macro to create Mental Ray compliant shader functions
//----------------------------------------------------------------------
EXPOSE(mrEzeTest, miColor, );
