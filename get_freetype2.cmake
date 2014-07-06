set(FREETYPE2_VERSION 2.5.3)

set(FREETYPE2_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/freetype-${FREETYPE2_VERSION}")
set(FREETYPE2_SOURCE_DIR "${FREETYPE2_INSTALL_PREFIX}.src")
set(FREETYPE2_BINARY_DIR "${FREETYPE2_INSTALL_PREFIX}.bin")

macro(freetype2_DOWNLOAD)
	message(STATUS "[${PROJECT_NAME} freetype2] Downloading...")
	file(DOWNLOAD
		http://sourceforge.net/projects/freetype/files/freetype2/${FREETYPE2_VERSION}/freetype-${FREETYPE2_VERSION}.tar.gz/download
		${FREETYPE2_INSTALL_PREFIX}.tar.gz)
endmacro()

macro(freetype2_EXTRACT)
	message(STATUS "[${PROJECT_NAME} freetype2] Extracting...")
	file(MAKE_DIRECTORY ${FREETYPE2_INSTALL_PREFIX}.tmp)
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E tar xzf ${FREETYPE2_INSTALL_PREFIX}.tar.gz . 
		WORKING_DIRECTORY ${FREETYPE2_INSTALL_PREFIX}.tmp
	)
	
	file(RENAME "${FREETYPE2_INSTALL_PREFIX}.tmp/freetype-${FREETYPE2_VERSION}" "${FREETYPE2_SOURCE_DIR}")
	execute_process(COMMAND ${CMAKE_COMMAND} -E remove_directory ${FREETYPE2_INSTALL_PREFIX}.tmp)
endmacro()

macro(freetype2_BUILD)
	message(STATUS "[${PROJECT_NAME} freetype2] Configuring...")
	file(MAKE_DIRECTORY ${FREETYPE2_BINARY_DIR})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} ${FREETYPE2_SOURCE_DIR} -G ${CMAKE_GENERATOR} -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${FREETYPE2_INSTALL_PREFIX}
		WORKING_DIRECTORY ${FREETYPE2_BINARY_DIR}
		OUTPUT_QUIET
	)
	
	message(STATUS "[${PROJECT_NAME} freetype2] Building...")
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build .
		WORKING_DIRECTORY ${FREETYPE2_BINARY_DIR}
		OUTPUT_QUIET
	)
endmacro()

macro(freetype2_INSTALL)
	message(STATUS "[${PROJECT_NAME} freetype2] Installing...")
	file(MAKE_DIRECTORY ${FREETYPE2_INSTALL_PREFIX})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -P ${FREETYPE2_BINARY_DIR}/cmake_install.cmake
		OUTPUT_QUIET
	)
endmacro()

if(NOT EXISTS "${FREETYPE2_INSTALL_PREFIX}.tar.gz")
	freetype2_DOWNLOAD()
	freetype2_EXTRACT()
	
else()
	if(NOT EXISTS ${FREETYPE2_SOURCE_DIR})
		freetype2_EXTRACT()
	endif()
endif()

if(NOT EXISTS "${FREETYPE2_BINARY_DIR}")
	freetype2_BUILD()
endif()

if(NOT EXISTS "${FREETYPE2_INSTALL_PREFIX}")
	freetype2_INSTALL()
endif()

message(STATUS "[${PROJECT_NAME} freetype2] DONE.")
