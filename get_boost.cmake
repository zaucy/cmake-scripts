set(BOOST_VERSION 1.55.0)
string(REPLACE "." "_" BOOST_VERSION_WITH_UNDERSCORES ${BOOST_VERSION})
set(BOOST_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/boost")
set(BOOST_BINARY_DIR "${BOOST_INSTALL_PREFIX}.bin")
set(BOOST_SOURCE_DIR "${BOOST_INSTALL_PREFIX}.src")

if(WIN32)
	if(MINGW)
		set(boost_toolset gcc)
	else()
		set(boost_toolset msvc)
	endif()
else()
	message(SEND_FATAL "non-win32 not supported, yet.")
endif()


if(NOT EXISTS ${BOOST_SOURCE_DIR})
	
	message(STATUS "[${PROJECT_NAME} boost] Downloading...")
	
	execute_process(
		COMMAND git clone --recursive https://github.com/boostorg/boost boost.src
		WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
		OUTPUT_QUIET
	)
	
	if(MINGW)
	
		execute_process(
			COMMAND bootstrap mingw
			WORKING_DIRECTORY ${BOOST_SOURCE_DIR}
			OUTPUT_QUIET
		)
	
	else()
		
		execute_process(
			COMMAND bootstrap
			WORKING_DIRECTORY ${BOOST_SOURCE_DIR}
			OUTPUT_QUIET
		)
		
	endif()
	
else()
	
endif()

if(NOT EXISTS ${BOOST_BINARY_DIR})
	message(STATUS "[${PROJECT_NAME} boost] Building...")
	
	file(MAKE_DIRECTORY ${BOOST_BINARY_DIR})
	
	execute_process(
		COMMAND b2 link=static variant=release threading=multi toolset=${boost_toolset} --build-dir=${BOOST_BINARY_DIR} --prefix=${BOOST_INSTALL_PREFIX} --layout=system
		WORKING_DIRECTORY ${BOOST_SOURCE_DIR}
		OUTPUT_QUIET
	)
endif()

if(NOT EXISTS ${BOOST_INSTALL_PREFIX})
	message(STATUS "[${PROJECT_NAME} boost] Installing...")
	execute_process(
		COMMAND b2 install link=static variant=release threading=multi toolset=${boost_toolset} --build-dir=${BOOST_BINARY_DIR} --prefix=${BOOST_INSTALL_PREFIX} --layout=system
		WORKING_DIRECTORY ${BOOST_SOURCE_DIR}
		OUTPUT_QUIET
	)
endif()

message(STATUS "[${PROJECT_NAME} boost] DONE.")
