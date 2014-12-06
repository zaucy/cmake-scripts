set(JSONCPP_VERSION 1.0.0)

set(JSONCPP_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/jsoncpp-${JSONCPP_VERSION}")
set(JSONCPP_SOURCE_DIR "${JSONCPP_INSTALL_PREFIX}.src")
set(JSONCPP_BINARY_DIR "${JSONCPP_INSTALL_PREFIX}.bin")
set(JSONCPP_ARCHIVE "${JSONCPP_INSTALL_PREFIX}.zip")

macro(jsoncpp_DOWNLOAD)
	
	message(STATUS "[${PROJECT_NAME} jsoncpp] Downloading...")
	file(DOWNLOAD
		https://github.com/open-source-parsers/jsoncpp/archive/${JSONCPP_VERSION}.zip
		${JSONCPP_ARCHIVE}
	)
	
endmacro()

macro(jsoncpp_EXTRACT)
	
	message(STATUS "[${PROJECT_NAME} jsoncpp] Extracting...")
	file(MAKE_DIRECTORY ${JSONCPP_SOURCE_DIR}.tmp)
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E tar xzf ${JSONCPP_ARCHIVE} .
		WORKING_DIRECTORY ${JSONCPP_SOURCE_DIR}.tmp
		OUTPUT_QUIET
	)
	
	file(RENAME ${JSONCPP_SOURCE_DIR}.tmp/jsoncpp-${JSONCPP_VERSION} ${JSONCPP_SOURCE_DIR})
	execute_process(
		COMMAND ${CMAKE_COMMAND} -E remove_directory ${JSONCPP_SOURCE_DIR}.tmp
		OUTPUT_QUIET
	)
	
endmacro()

macro(jsoncpp_BUILD)
	message(STATUS "[${PROJECT_NAME} jsoncpp] Configuring...")
	file(MAKE_DIRECTORY ${JSONCPP_BINARY_DIR})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} ${JSONCPP_SOURCE_DIR} -G ${CMAKE_GENERATOR} -Wno-dev -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${JSONCPP_INSTALL_PREFIX}
		WORKING_DIRECTORY ${JSONCPP_BINARY_DIR}
		OUTPUT_QUIET
	)
	
	message(STATUS "[${PROJECT_NAME} jsoncpp] Building...")
	execute_process(
		COMMAND ${CMAKE_COMMAND} --build .
		WORKING_DIRECTORY ${JSONCPP_BINARY_DIR}
		OUTPUT_QUIET
	)
endmacro()

macro(jsoncpp_INSTALL)
	
	message(STATUS "[${PROJECT_NAME} jsoncpp] Installing...")
	file(MAKE_DIRECTORY ${JSONCPP_INSTALL_PREFIX})
	
	execute_process(
		COMMAND ${CMAKE_COMMAND} -P ${JSONCPP_BINARY_DIR}/cmake_install.cmake
		OUTPUT_QUIET
	)
	
endmacro()

if(NOT EXISTS ${JSONCPP_ARCHIVE})
	jsoncpp_DOWNLOAD()
endif()

if(NOT EXISTS ${JSONCPP_SOURCE_DIR})
	jsoncpp_EXTRACT()
endif()

if(NOT EXISTS ${JSONCPP_BUILD_DIR})
	jsoncpp_BUILD()
endif()

if(NOT EXISTS ${JSONCPP_INSTALL_PREFIX})
	jsoncpp_INSTALL()
endif()