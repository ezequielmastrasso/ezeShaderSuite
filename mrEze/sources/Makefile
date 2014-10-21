# -- CONFIG


MAYA_VERSION := 2014
CXXFLAGS :=

# -- PLATFORM DETECTION

UNAME_S := $(shell uname -s)

ifeq (${UNAME_S},Darwin)
	PLATFORM_NAME := macosx
	MR_ROOT := /Applications/Autodesk/mentalrayForMaya${MAYA_VERSION}
	CXXFLAGS += -undefined dynamic_lookup
	LIB_EXT := .dylib
else
	PLATFORM_NAME := linux
	MR_ROOT := /usr/autodesk/mentalrayForMaya${MAYA_VERSION}
	CXXFLAGS += -fPIC
	LIB_EXT := .so
endif


# -- BUILD RULES

BUILD_DIR := build/${PLATFORM_NAME}-${MAYA_VERSION}

MI_SRC := $(wildcard *.mi)
MI_DST := $(MI_SRC:%=${BUILD_DIR}/%)

SHADER_SRC := $(MI_SRC:%.mi=%.cpp)
SHADER_DST := $(SHADER_SRC:%.cpp=${BUILD_DIR}/%${LIB_EXT})

MEL_SRC := $(MI_SRC:%.mi=AE%Template.mel)
MEL_DST := $(MEL_SRC:%=${BUILD_DIR}/%)


.PHONY: default clean

default: ${SHADER_DST} ${MI_DST} ${MEL_DST}

${BUILD_DIR}/%${LIB_EXT}: %.cpp
	@ mkdir -p $(dir $@)
	g++ -shared ${CXXFLAGS} \
		-I${MR_ROOT}/devkit/adskShaderSDK/include \
		-I${MR_ROOT}/devkit/include \
		-o $@ $<

${BUILD_DIR}/%: %
	cp $< $@

clean:
	- rm -rf ${BUILD_DIR}
