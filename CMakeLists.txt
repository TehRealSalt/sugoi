cmake_minimum_required( VERSION 3.18 )

if("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_CURRENT_SOURCE_DIR}")
	message(FATAL_ERROR "In-source builds are blocked. Please build from a separate directory.")
endif()

project(SUGOI)

# PK3 building utilities are from the GZDoom repo @ https://github.com/ZDoom/gzdoom/

set( BZIP2_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libs/bzip2" )
set( LZMA_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libs/lzma/C" )
add_subdirectory(libs)

add_subdirectory(tools)

# Recursive function to place PK3 archive source files into a hierarchy of source file in the IDE
function( assort_pk3_source_folder FOLDER_NAME PK3_DIR )
	# Assort source files into folders in the IDE
	file(GLOB PK3_SRCS ${PK3_DIR}/*) # Create list of all files in this folder

	foreach(PK3_SRC ${PK3_SRCS})
		# If there are subfolders, recurse into them
		if(IS_DIRECTORY ${PK3_SRC})
			get_filename_component(DIRNAME ${PK3_SRC} NAME)

			# Exclude folder from list of source files
			list(REMOVE_ITEM PK3_SRCS ${PK3_SRC})

			# Recurse deeper into the filesystem folder tree
			assort_pk3_source_folder( ${FOLDER_NAME}\\${DIRNAME} ${PK3_SRC} )
		endif()

		# Assign IDE group for current top-level source files
		source_group(${FOLDER_NAME} FILES ${PK3_SRCS})
	endforeach()
endfunction()

option( PK3_QUIET_ZIPDIR "Do not list files processed by zipdir" NO )
if( PK3_QUIET_ZIPDIR )
	set( PK3_ZIPDIR_OPTIONS "-q" )
endif()

function( add_pk3 PK3_NAME_BASE PK3_GAMETYPES PK3_VERSION PK3_DIR )
	# Generate target name
	set(PK3_TARGET "${PK3_NAME_BASE}_pk3")

	list(APPEND PK3_PARTS "${PK3_GAMETYPES}")
	list(APPEND PK3_PARTS "${PK3_NAME_BASE}")

	string(REPLACE "." "-" PK3_VERSION "${PK3_VERSION}")
	string(REPLACE " " "" PK3_VERSION "${PK3_VERSION}")
	string(TOLOWER "${PK3_VERSION}" PK3_VERSION )
	list(APPEND PK3_PARTS "${PK3_VERSION}")

	list(JOIN PK3_PARTS "_" PK3_NAME)
	set(PK3_NAME "${PK3_NAME}.pk3")

	add_custom_command(
		OUTPUT ${SUGOI_OUTPUT_DIR}/${PK3_NAME}
		COMMAND zipdir -udf ${PK3_ZIPDIR_OPTIONS} ${SUGOI_OUTPUT_DIR}/${PK3_NAME} ${PK3_DIR}
		DEPENDS zipdir
	)

	# Create a list of source files for this PK3, for use in the IDE
	# Phase 1: Create a list of all source files for this PK3 archive, except
	#  for a couple of strife image file names that confuse CMake.
	file(GLOB_RECURSE PK3_SRCS ${PK3_DIR}/*)

	# Exclude from the source list some files with brackets in the
	# file names here, because they confuse CMake.
	# This only affects the list of source files shown in the IDE.
	# It does not actually remove the files from the PK3 archive.
	# First replace that toxic bracket character with something we can handle
	string(REPLACE "[" confusing_bracket PK3_SRCS "${PK3_SRCS}")
	string(REPLACE "]" confusing_bracket PK3_SRCS "${PK3_SRCS}")

	foreach(PK3_SRC ${PK3_SRCS}) # All source files at all levels
		# Exclude those quarantined source file source file names that once had a bracket
		if(${PK3_SRC} MATCHES confusing_bracket)
			# message(STATUS "Ignoring PK3 file name containing brackets "${PK3_SRC})
			list(REMOVE_ITEM PK3_SRCS ${PK3_SRC})
		endif()
	endforeach()

	# Phase 2: Create the PK3 build rule, including the source file list for the IDE
	# Touch the zipdir executable here so that the pk3s are forced to
	# rebuild each time since their dependency has "changed."
	add_custom_target(
		${PK3_TARGET} ALL
		COMMAND ${CMAKE_COMMAND} -E touch $<TARGET_FILE:zipdir>
		DEPENDS ${SUGOI_OUTPUT_DIR}/${PK3_NAME}
		SOURCES ${PK3_SRCS}
	)

	# Phase 3: Assign source files to a nice folder structure in the IDE
	assort_pk3_source_folder("Source Files" ${PK3_DIR})

	# Phase 4: Add the resulting PK3 to the install target.
	if( WIN32 )
		set( INSTALL_PK3_PATH . CACHE STRING "Directory where the output PK3 will be placed during install." )
	else()
		set( INSTALL_PK3_PATH share/games/srb2 CACHE STRING "Directory where the output PK3 will be placed during install." )
	endif()

	install(
		FILES "${PROJECT_BINARY_DIR}/${PK3_NAME}"
		DESTINATION ${INSTALL_PK3_PATH}
		COMPONENT "Game resources"
	)
endfunction()

# TODO: make a copy of wadsrc/soc/main.soc and
# modify it to use this value.
file(STRINGS VERSION.md SUGOI_VERSION)

set( SUGOI_OUTPUT_DIR ${CMAKE_BINARY_DIR} CACHE PATH "Directory where the output PK3 will be created." )

add_pk3("sugoi" "sl" "${SUGOI_VERSION}" ${CMAKE_CURRENT_SOURCE_DIR}/wadsrc)
