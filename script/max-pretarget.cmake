# Copyright (c) 2016, Cycling '74
# Usage of this file and its contents is governed by the MIT License

string(REGEX REPLACE "(.*)/" "" THIS_FOLDER_NAME "${CMAKE_CURRENT_SOURCE_DIR}")
project(${THIS_FOLDER_NAME})

if (NOT DEFINED C74_MAX_API_DIR)
	set(C74_MAX_API_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../max-api)
endif ()
set(C74_INCLUDES "${C74_MAX_API_DIR}/include")
set(C74_SCRIPTS "${C74_MAX_API_DIR}/script")

set(C74_CXX_STANDARD 0)

if (APPLE)
	set(CMAKE_OSX_ARCHITECTURES x86_64;i386)
endif ()

if (NOT DEFINED C74_BUILD_MAX_EXTENSION)
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../../externals")
else ()
	set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../../../extensions")
endif ()
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

if (WIN32)
	set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/tmp")
	set(CMAKE_PDB_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/tmp")

	if (WIN64)
		SET(MaxAPI_LIB ${C74_MAX_API_DIR}/lib/win64/MaxAPI.lib)
		SET(MaxAudio_LIB ${C74_MAX_API_DIR}/lib/win64/MaxAudio.lib)
		SET(Jitter_LIB ${C74_MAX_API_DIR}/lib/win64/jitlib.lib)	
	else ()
		SET(MaxAPI_LIB ${C74_MAX_API_DIR}/lib/win32/MaxAPI.lib)
		SET(MaxAudio_LIB ${C74_MAX_API_DIR}/lib/win32/MaxAudio.lib)
		SET(Jitter_LIB ${C74_MAX_API_DIR}/lib/win32/jitlib.lib)
	endif ()

	MARK_AS_ADVANCED (MaxAPI_LIB)
	MARK_AS_ADVANCED (MaxAudio_LIB)
	MARK_AS_ADVANCED (Jitter_LIB)

	add_definitions(
		-DMAXAPI_USE_MSCRT
		-DWIN_VERSION
	)
else ()
	file (STRINGS "${C74_MAX_API_DIR}/script/max-linker-flags.txt" C74_SYM_MAX_LINKER_FLAGS)
	file (STRINGS "${C74_MAX_API_DIR}/script/msp-linker-flags.txt" C74_SYM_MSP_LINKER_FLAGS)

	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${C74_SYM_MAX_LINKER_FLAGS} ${C74_SYM_MSP_LINKER_FLAGS}")
	set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${C74_SYM_MAX_LINKER_FLAGS} ${C74_SYM_MSP_LINKER_FLAGS}")
	set(CMAKE_MODULE_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${C74_SYM_MAX_LINKER_FLAGS} ${C74_SYM_MSP_LINKER_FLAGS}")
endif ()
