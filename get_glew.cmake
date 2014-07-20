set(GLEW_VERSION 1.10.0)

set(GLEW_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/glew-${GLEW_VERSION}")
set(GLEW_SOURCE_DIR "${GLEW_INSTALL_PREFIX}.src")
set(GLEW_BINARY_DIR "${GLEW_INSTALL_PREFIX}.bin")
set(GLEW_ARCHIVE "${GLEW_INSTALL_PREFIX}.tgz")

macro(glew_DOWNLOAD)
	message(STATUS "[${PROJECT_NAME} GLEW] Downloading...")
	file(DOWNLOAD
		http://sourceforge.net/projects/glew/files/glew/${GLEW_VERSION}/glew-${GLEW_VERSION}.tgz/download
		${GLEW_ARCHIVE}
	)
endmacro()

macro(glew_EXTRACT)
	message(STATUS "[${PROJECT_NAME} GLEW] Extracting...")
	file(MAKE_DIRECTORY ${GLEW_SOURCE_DIR}.tmp)
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E tar xzf ${GLEW_ARCHIVE} .
		WORKING_DIRECTORY ${GLEW_SOURCE_DIR}.tmp
		OUTPUT_QUIET
	)
	
	file(RENAME ${GLEW_SOURCE_DIR}.tmp/glew-${GLEW_VERSION} ${GLEW_SOURCE_DIR})
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E remove_directory ${GLEW_SOURCE_DIR}.tmp
		OUTPUT_QUIET
	)
	
	file(WRITE ${GLEW_SOURCE_DIR}/CMakeLists.txt "
cmake_minimum_required(VERSION 2.8)
project(glew C)

set(GLEW_SOURCES
	src/glew.c
)

set(GLEW_HEADERS
	include/GL/glew.h
	include/GL/wglew.h
	include/GL/glxew.h
)

if(GLEW_STATIC)
	add_definitions(-DGLEW_STATIC)
endif()

include_directories(include)

add_library(glew \${GLEW_HEADERS} \${GLEW_SOURCES})

install(
	TARGETS glew
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib
)

install(
	DIRECTORY include
	DESTINATION .
)
")
endmacro()

macro(glew_BUILD)
	message(STATUS "[${PROJECT_NAME} GLEW] Building...")
	file(MAKE_DIRECTORY ${GLEW_BINARY_DIR})
	execute_process(
		COMMAND ${CMAKE_COMMAND}
			${GLEW_SOURCE_DIR}
			"-G${CMAKE_GENERATOR}"
			-DCMAKE_BUILD_TYPE=Release
			-DGLEW_STATIC=True
			-DCMAKE_INSTALL_PREFIX=${GLEW_INSTALL_PREFIX}
			-DCMAKE_SOURCE_DIR=${GLEW_SOURCE_DIR}
			-DCMAKE_BINARY_DIR=${GLEW_BINARY_DIR}
		WORKING_DIRECTORY ${GLEW_BINARY_DIR}
		OUTPUT_QUIET
	)
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build .
		WORKING_DIRECTORY ${GLEW_BINARY_DIR}
		OUTPUT_QUIET
	)
endmacro()

macro(glew_INSTALL)
	message(STATUS "[${PROJECT_NAME} GLEW] Installing...")
	file(MAKE_DIRECTORY ${GLEW_INSTALL_PREFIX})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -P ${GLEW_BINARY_DIR}/cmake_install.cmake
		OUTPUT_QUIET
	)
endmacro()

if(NOT EXISTS ${GLEW_ARCHIVE})
	glew_DOWNLOAD()
endif()

if(NOT EXISTS ${GLEW_SOURCE_DIR})
	glew_EXTRACT()
endif()

if(NOT EXISTS ${GLEW_BINARY_DIR})
	glew_BUILD()
endif()

if(NOT EXISTS ${GLEW_INSTALL_PREFIX})
	glew_INSTALL()
endif()

message(STATUS "[${PROJECT_NAME}] GLEW] Done.")